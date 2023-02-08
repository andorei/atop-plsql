create or replace package at_delta is
/*******************************************************************************
    Delta streams management API

Changelog
    2016-08-30 Andrei Trofimov Create package
    2018-04-06 Andrei Trofimov Redesign API
    2023-01-23 Andrei Trofimov Add seqn capture type

********************************************************************************
Copyright (C) 2016-2023 by Andrei Trofimov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

********************************************************************************
*/

    c_type_deltascn constant varchar2(10) := 'deltascn';
    c_type_orarowscn constant varchar2(10) := 'orarowscn';
    c_type_seqn constant varchar2(10) := 'seqn';

    -- Create CDC table and register it.
    procedure create_capture(
        p_capture at_cdc_.capture%type,
        p_type    at_cdc_.cdc_type%type,
        p_descr   at_cdc_.descr%type
    );

    -- Unregister and drop CDC table.
    procedure delete_capture(
        p_capture at_cdc_.capture%type
    );

    -- Create CDC client's view and trigger.
    procedure create_client(
        p_client at_svs_.client%type
    );

    -- Drop CDC client's view and trigger.
    procedure delete_client(
        p_client at_svs_.client%type
    );

    -- Register client's service p_service based on capture.
    procedure create_service(
        p_client at_svs_.client%type,
        p_service at_svs_.service%type,
        p_capture at_svs_.capture%type,
        p_descr  at_svs_.descr%type
    );

    -- Unregister client's service p_service.
    procedure delete_service(
        p_client at_svs_.client%type,
        p_service at_svs_.service%type
    );

    -- Current change number for the capture.
    function current_scn(
        p_capture at_cdc_.capture%type,
        p_cdc_type at_cdc_.cdc_type%type
    ) return number;

    -- Delete utilized rows from CDC tables.
    -- (Create job to run at_delta.purge_cdc daily.)
    procedure purge_cdc;

end at_delta;
/
create or replace package body at_delta is

    c_capture_prefix constant varchar2(7) := 'AT_CDC_';
    c_view_prefix constant varchar2(7) := 'AT_SVS_';
    c_trigger_postfix constant varchar2(3) := '_AK';

    -- Set by %_exists procedures and by other procedures.
    g_capture at_svs_.capture%type;
    g_capture_table varchar2(30);
    g_client at_svs_.client%type;
    g_client_view varchar2(30);
    g_client_trigger varchar2(30);
    g_service at_svs_.service%type;

    -- Set global vars for the capture and check that capture table exists.
    function capture_exists(
        p_capture at_cdc_.capture%type
    ) return boolean
    is
        l_cdc_type at_cdc_.cdc_type%type;
        l_dummy pls_integer;
    begin
        g_capture := upper(p_capture);
        g_capture_table := c_capture_prefix||g_capture;
        select 1 into l_cdc_type from at_cdc_ where capture = g_capture;
        if l_cdc_type = c_type_deltascn then
            select 1 into l_dummy from user_tables where table_name = g_capture_table;
        end if;
        return true;
    exception
        when no_data_found then
            return false;
    end capture_exists;

    -- Set global vars for the client and check that client's objects exist.
    function client_exists(
        p_client at_svs_.client%type
    ) return boolean
    is
        l_dummy pls_integer;
    begin
        g_client         := upper(p_client);
        g_client_view    := c_view_prefix||g_client;
        g_client_trigger := g_client_view||c_trigger_postfix;

        select 1 into l_dummy from user_views where view_name = g_client_view;
        select 1 into l_dummy from user_triggers where trigger_name = g_client_trigger;

        return true;
    exception
        when no_data_found then
            return false;
    end client_exists;

    -- Set global vars for the client's service and check that service exists.
    function service_exists(
        p_client at_svs_.client%type,
        p_service at_svs_.service%type
    ) return boolean
    is
        l_dummy pls_integer;
    begin
        g_service := upper(p_service);
        if not client_exists(p_client) then
            return false;
        end if;
        select 1 into l_dummy from at_svs_ where client = upper(p_client) and service = g_service;
        return true;
    exception
        when no_data_found then
            return false;
    end service_exists;

    -- Create CDC table and register it.
    procedure create_capture(
        p_capture at_cdc_.capture%type,
        p_type    at_cdc_.cdc_type%type,
        p_descr   at_cdc_.descr%type
    ) is
    begin
        if capture_exists(p_capture) then
            raise_application_error(
                at_exc.c_already_exists_code,
                'Capture "'||g_capture||'" already exists.'
            );
        end if;
        insert into at_cdc_ (capture, cdc_type, descr)
        values (g_capture, p_type, p_descr)
        ;
        --dbms_output.put_line(''''||g_capture_table||'''');
        if p_type = c_type_deltascn then
            execute immediate
                'create table '||g_capture_table||' (
                    oper char not null,
                    when timestamp with time zone default systimestamp not null
                ) rowdependencies'
            ;
        elsif p_type = c_type_seqn then
            execute immediate
                'create table '||g_capture_table||' (
                    oper char not null,
                    when timestamp with time zone default systimestamp not null,
                    seqn number not null,
                    fixn number
                )'
            ;
            execute immediate
                'create sequence '||g_capture_table||'_seq'
            ;
        end if;
    end create_capture;

    -- Unregister and drop CDC table.
    procedure delete_capture(
        p_capture at_cdc_.capture%type
    ) is
        l_cdc_type at_cdc_.cdc_type%type;
        l_count pls_integer;
    begin
        if not capture_exists(p_capture) then
            raise_application_error(
                at_exc.c_does_not_exist_code,
                'Capture "'||g_capture||'" does not exist.'
            );
        end if;
        -- Services may share the same capture.
        select count(*)
        into l_count
        from at_svs_
        where capture = upper(p_capture)
        ;
        if l_count > 0 then
            raise_application_error(
                at_exc.c_general_error_code,
                'Capture "'||g_capture||'" is used by client''s services.'
            );
        end if;
        delete from at_cdc_
        where capture = upper(g_capture)
        returning cdc_type into l_cdc_type
        ;
        if sql%rowcount = 0 then
            raise_application_error(
                at_exc.c_general_error_code,
                'Failed to delete capture "'||g_capture||'".'
            );
        end if;
        if l_cdc_type = c_type_deltascn then
            execute immediate 'drop table '||g_capture_table;
        elsif l_cdc_type = c_type_seqn then
            execute immediate 'drop table '||g_capture_table;
            execute immediate 'drop sequence '||g_capture_table||'_seq';
        end if;
    end delete_capture;

    -- Create CDC client's view and trigger.
    procedure create_client(
        p_client at_svs_.client%type
    ) is
    begin
        if client_exists(p_client) then
            raise_application_error(
                at_exc.c_already_exists_code,
                'Client "'||g_client||'" already exists.'
            );
        end if;
        execute immediate
            'create or replace view '||g_client_view||' as
            select service, svs.capture, cdc_type, last_when, last_scn, at_delta.current_scn(svs.capture, cdc_type) curr_scn
            from at_svs_ svs, at_cdc_ cdc
            where svs.client = '''||g_client||'''
                and svs.capture = cdc.capture'
        ;
        execute immediate
            'create or replace trigger '||g_client_trigger||'
            instead of update on '||g_client_view||'
            for each row
            call at_delta2.acknowledge('''||g_client||''', :new.service, :new.last_scn)'
        ;
        execute immediate
            'comment on table '||g_client_view||' is ''Service view for '||g_client||' client'''
        ;
    end create_client;

    -- Drop CDC client's view and trigger.
    procedure delete_client(
        p_client at_svs_.client%type
    ) is
        l_count pls_integer;
    begin
        if not client_exists(p_client) then
            raise_application_error(
                at_exc.c_does_not_exist_code,
                'Client "'||g_client||'" does not exist.'
            );
        end if;
        -- The client may still have services.
        select count(*)
        into l_count
        from at_svs_
        where client = g_client
        ;
        if l_count > 0 then
            raise_application_error(
                at_exc.c_general_error_code,
                'Services exist for client "'||g_client||'".'
            );
        end if;
        execute immediate 'drop view ' || g_client_view;
    end delete_client;

    -- Register client's service p_service based on capture.
    procedure create_service(
        p_client at_svs_.client%type,
        p_service at_svs_.service%type,
        p_capture at_svs_.capture%type,
        p_descr  at_svs_.descr%type
    ) is
    begin
        if not client_exists(p_client) then
            raise_application_error(
                at_exc.c_does_not_exist_code,
                'Client "'||g_client||'" does not exist.'
            );
        end if;
        if not capture_exists(p_capture) then
            raise_application_error(
                at_exc.c_does_not_exist_code,
                'Capture "'||g_capture||'" does not exist.'
            );
        end if;
        if service_exists(g_client, p_service) then
            raise_application_error(
                at_exc.c_already_exists_code,
                'Service "'||g_service||'" for client "'||g_client||'" already exists.'
            );
        end if;
        insert into at_svs_ (service, client, capture, descr)
        values (g_service, g_client, g_capture, p_descr)
        ;
    end create_service;

    -- Unregister client's service p_service.
    procedure delete_service(
        p_client at_svs_.client%type,
        p_service at_svs_.service%type
    ) is
    begin
        if not service_exists(p_client, p_service) then
            raise_application_error(
                at_exc.c_does_not_exist_code,
                'Service "'||g_service||'" for client "'||g_client||'" does not exist.'
            );
        end if;
        delete from at_svs_
        where client = g_client
            and service = g_service
        ;
    end delete_service;

    -- Current change number for the capture.
    function current_scn(
        p_capture at_cdc_.capture%type,
        p_cdc_type at_cdc_.cdc_type%type
    ) return number
    is
        l_curr_cn number;
    begin
        case p_cdc_type
            when c_type_deltascn then
                execute immediate
                    'select nvl(max(ora_rowscn), 0) from '||c_capture_prefix||p_capture
                    into l_curr_cn;
            when c_type_orarowscn then
                select current_scn into l_curr_cn from v$database;
            when c_type_seqn then
                execute immediate
                    'select '||c_capture_prefix||p_capture||'_seq.nextval from dual'
                    into l_curr_cn;
            else
                l_curr_cn := null;
        end case;
        return l_curr_cn;
    end current_scn;

    -- Delete utilized rows from CDC tables.
    procedure purge_cdc
    is
    begin
        -- Clients may share the same capture.
        for r in (
            select svs.capture, min(last_scn) last_scn
            from at_svs_ svs, at_cdc_ cdc
            where cdc_type = 'deltascn'
                and svs.capture = cdc.capture
            group by svs.capture
        ) loop
            if capture_exists(r.capture) then
                execute immediate
                    'delete from ' || g_capture_table ||
                    ' where ora_rowscn <= :last_scn'
                using r.last_scn
                ;
                commit;
            end if;
        end loop;
    end purge_cdc;

end at_delta;
/
