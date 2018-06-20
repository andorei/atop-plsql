create or replace package at_ldap is
/*******************************************************************************
    Provide support for LDAP query and update.

    You can only extract LDAP attributes that implicitly get converted into 
    varchar2. You can not extract binary attributes.

Changelog
    2007-06-09 Andrei Trofimov create package.
    ...
    2018-02-28 Andrei Trofimov use at_cfg and at_ types.

********************************************************************************
Copyright (C) 2007-2018 by Andrei Trofimov

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

    function open_session(
        p_ldap_host in varchar2 default at_env.c_ldap_host,
        p_ldap_port in varchar2 default at_env.c_ldap_port,
        p_ldap_user in varchar2 default at_env.c_ldap_user,
        p_ldap_pswd in varchar2 default at_env.c_ldap_pswd
    ) return dbms_ldap.session;

    procedure close_session(
        p_session in out dbms_ldap.session
    );
    
    -- Search LDAP server and return at_table where
    --   c1 is entry DN,
    --   c2 is attribute name,
    --   c3 is attribute value.
    --
    --   p_attrs     comma separated list of attributes to return
    --   p_filter    search filter
    --   p_base      base distinguished name
    --   p_scope     search scope, one of dbms_ldap.scope_[subtree|onelevel|base]
    --   p_session   ldap session, if open ldap session exists
    
    function search(
        p_attrs     in varchar2,
        p_filter    in varchar2,
        p_base      in varchar2 default at_env.c_ldap_base,
        p_scope     in binary_integer default dbms_ldap.scope_subtree,
        p_session   in dbms_ldap.session default null
    ) return at_table10;

    -- Search LDAP server and print the data found.
    --
    --   p_attrs     comma separated list of attributes to return
    --   p_filter    search filter
    --   p_base      base distinguished name
    --   p_scope     search scope, one of dbms_ldap.scope_[subtree|onelevel|base]
    --   p_session   ldap session, if open ldap session exists
    
    procedure search_and_print(
        p_attrs     in varchar2,
        p_filter    in varchar2,
        p_base      in varchar2 default at_env.c_ldap_base,
        p_scope     in binary_integer default dbms_ldap.scope_subtree,
        p_session   in dbms_ldap.session default null
    );
    /*
    Usage of search_and_print:
    
    set serveroutput on
    begin
        at_ldap.search_and_print(
            p_base => 'OU=ќфис,OU=associates,DC=md,DC=int',
            p_attrs => 'givenName, mail, homePhone',
            p_filter => 'objectClass=user'
        );
    end;
   */


    -- Search LDAP server and pipeline data found.
    --
    --    p_base      base distinguished name
    --    p_scope     search scope, one of dbms_ldap.scope_[subtree|onelevel|base]
    --    p_filter    serach filter
    --    p_attrs     comma separated list of attributes to return
    
    function search_and_yield(
        p_attrs     in varchar2,
        p_filter    in varchar2,
        p_base      in varchar2 default at_env.c_ldap_base,
        p_scope     in binary_integer default dbms_ldap.scope_subtree,
        p_session   in dbms_ldap.session default null
    ) return at_table10 pipelined;
    /*
    Usage of search_and_yield:
    
    select *
    from table(
        at_ldap.search_and_yield(
            p_attrs => 'givenName, mail, homePhone',
            p_filter => 'objectClass=user',
            p_base => 'OU=ќперационный департамент,OU=ќфис,OU=Associates,DC=md,DC=int'
        ))
    order by 1;

    with q as (
        select c1 dn, c2 attr, c3 val
        from table(
            at_ldap.search_and_yield(
                p_attrs => 'displayName, mail',
                p_filter => 'objectClass=user',
                p_base => 'OU=ќперационный департамент,OU=ќфис,OU=Associates,DC=md,DC=int'
            ))
    )
    select q1.dn, q1.val displayName, q2.val mail
    from q q1, q q2
    where q1.dn = q2.dn
        and q1.attr = 'displayName'
        and q2.attr = 'mail'
    order by 2;
    */

    -- Search LDAP server and return attribute values.
    --
    --    p_attr      attribute to return
    --    p_filter    serach filter
    --    p_base      base distinguished name
    --    p_scope     search scope, one of dbms_ldap.scope_[subtree|onelevel|base]
    --    p_session   ldap session, if open session exists
    --    p_single    1 - only one entry expected, 0 - no limit

    function attribute_values(
        p_attr      in varchar2,
        p_filter    in varchar2,
        p_base      in varchar2 default at_env.c_ldap_base,
        p_scope     in binary_integer default dbms_ldap.scope_subtree,
        p_session   in dbms_ldap.session default null,
        p_single    in pls_integer default 1
    ) return at_varchars;

    -- Return user's email address from mail attribute.
    --
    --   p_user_name   user's name (that matches dislpayName attribute)
    --   p_single      1 - only one entry expected, 0 - no limit
    --   p_expand      1 - replace '.' with '*' and add '*' at the end of user name
    --                 0 - leave user name as it is
    
    function user_mail(
        p_user_name in varchar2,
        p_single in pls_integer default 0,
        p_expand in pls_integer default 1
    ) return varchar2;

    -- Return users' email addresses from mail attribute.
    --
    --   p_user_name   users' names (that match dislpayName attribute)
    --   p_expand      1 - replace '.' with '*' and add '*' at the end of user name
    --                 0 - leave user name as it is
    
    function users_mails(
        p_users_names in at_varchars,
        p_expand in pls_integer default 1
    ) return varchar2;

end at_ldap;
/
create or replace package body at_ldap is

    function open_session(
        p_ldap_host in varchar2 default at_env.c_ldap_host,
        p_ldap_port in varchar2 default at_env.c_ldap_port,
        p_ldap_user in varchar2 default at_env.c_ldap_user,
        p_ldap_pswd in varchar2 default at_env.c_ldap_pswd
    ) return dbms_ldap.session
    is
        l_dummy pls_integer;
        l_session dbms_ldap.session;
    begin
        -- Choose to raise exceptions if not authenticated.
        dbms_ldap.use_exception := true;
        l_session := dbms_ldap.init(p_ldap_host, p_ldap_port);
        l_dummy := dbms_ldap.simple_bind_s(
            ld      => l_session,
            dn      => p_ldap_user,
            passwd  => p_ldap_pswd
        );
        return l_session;
    end open_session;


    procedure close_session(
        p_session in out dbms_ldap.session
    ) is
        l_dummy pls_integer;
    begin
        -- Disconnect from the ldap server.
        l_dummy := dbms_ldap.unbind_s(ld => p_session);
    end close_session;


    -- Returns dbms_ldap.string_collection populated with elements of p_list.
    -- Elements in a string p_list are separated with p_sep.
    -- The elements in a resulting table are optionally trimmed.
    
    function splitted(
        p_list in varchar2,
        p_sep in varchar2,
        p_trim_spaces pls_integer default 0
    ) return dbms_ldap.string_collection
    is
        l_beg pls_integer := 1;
        l_fin pls_integer := 0;
        l_parts dbms_ldap.string_collection;
    begin
        if p_list is null or p_sep is null then
            return l_parts;
        end if;
        
        l_fin := instr(p_list, p_sep, l_beg);
        while l_fin > 0 loop
            l_parts(l_parts.count) := substr(p_list, l_beg, l_fin - l_beg);
            l_beg := l_fin + length(p_sep);
            l_fin := instr(p_list, p_sep, l_beg);
        end loop;
        l_parts(l_parts.count) := substr(p_list, l_beg);
        
        if p_trim_spaces = 1 then
            for i in l_parts.first .. l_parts.last loop
                l_parts(i) := trim(l_parts(i));
            end loop;
        end if;

        return l_parts;
    end splitted;


    function search(
        p_attrs     in dbms_ldap.string_collection,
        p_filter    in varchar2,
        p_base      in varchar2 default at_env.c_ldap_base,
        p_scope     in binary_integer default dbms_ldap.scope_subtree,
        p_session   in dbms_ldap.session default null
    ) return at_table10
    is
        l_session   dbms_ldap.session;
        l_dummy     pls_integer;
        l_message   dbms_ldap.message;
        l_entry     dbms_ldap.message;
        l_attr      varchar2(256);
        l_berelem   dbms_ldap.ber_element;
        l_values    dbms_ldap.string_collection;
        l_result    at_table10 := at_table10();
        l_dn        varchar2(4000);
        
        i pls_integer;
    begin
        if p_session is null then
            l_session := open_session;
        else
            l_session := p_session;
        end if;
        
        l_dummy := dbms_ldap.search_s(
            l_session,
            p_base,
            p_scope,
            p_filter,
            p_attrs,
            0,
            l_message
        );

        l_entry := dbms_ldap.first_entry(l_session, l_message);
        while l_entry is not null loop
            l_dn := dbms_ldap.get_dn(l_session, l_entry);
            l_attr := dbms_ldap.first_attribute(l_session, l_entry, l_berelem);
            while l_attr is not null loop
                l_values := dbms_ldap.get_values(l_session, l_entry, l_attr);
                i := l_values.first;
                while i is not null loop
                    l_result.extend;
                    l_result(l_result.count) := at_row10(l_dn, l_attr, l_values(i));
                    i := l_values.next(i);
                end loop;
                l_attr := dbms_ldap.next_attribute(l_session, l_entry, l_berelem);
            end loop;
            l_entry := dbms_ldap.next_entry(l_session, l_entry);
        end loop;

        if p_session is null then
            close_session(l_session);
        end if;

        return l_result;
    end search;


    function search(
        p_attrs     in varchar2,
        p_filter    in varchar2,
        p_base      in varchar2 default at_env.c_ldap_base,
        p_scope     in binary_integer default dbms_ldap.scope_subtree,
        p_session   in dbms_ldap.session default null
    ) return at_table10
    is
    begin
        return
            search(
                p_attrs   => splitted(p_attrs, ',', 1),
                p_filter  => p_filter,
                p_base    => p_base,
                p_scope   => p_scope,
                p_session => p_session
            );
    end search;        

    
    procedure search_and_print(
        p_attrs     in varchar2,
        p_filter    in varchar2,
        p_base      in varchar2 default at_env.c_ldap_base,
        p_scope     in binary_integer default dbms_ldap.scope_subtree,
        p_session   in dbms_ldap.session default null
    )
    is
        l_result at_table10;
        l_dn varchar2(4000) := '---';
    begin
        l_result := search(
            p_attrs   => p_attrs,
            p_filter  => p_filter,
            p_base    => p_base,
            p_scope   => p_scope,
            p_session => p_session
        );
        
        if l_result.count > 0 then
            for i in l_result.first .. l_result.last loop
                if l_result(i).c1 != l_dn then
                    l_dn := l_result(i).c1;
                    at_out.p(l_dn);
                end if;
                at_out.p(rpad(l_result(i).c2, 20) || ' : ' || l_result(i).c3);
            end loop;
        end if;
    end search_and_print;


    function search_and_yield(
        p_attrs     in varchar2,
        p_filter    in varchar2,
        p_base      in varchar2 default at_env.c_ldap_base,
        p_scope     in binary_integer default dbms_ldap.scope_subtree,
        p_session   in dbms_ldap.session default null
    ) return at_table10 pipelined
    is
        l_data at_table10;
    begin
        l_data := search(
            p_attrs   => p_attrs,
            p_filter  => p_filter,
            p_base    => p_base,
            p_scope   => p_scope,
            p_session => p_session
        );
        
        if l_data.count > 0 then
            for i in l_data.first .. l_data.last loop
                pipe row(l_data(i));
            end loop;
        end if;
    end search_and_yield;


    function attribute_values(
        p_attr      in varchar2,
        p_filter    in varchar2,
        p_base      in varchar2 default at_env.c_ldap_base,
        p_scope     in binary_integer default dbms_ldap.scope_subtree,
        p_session   in dbms_ldap.session default null,
        p_single    in pls_integer default 1
    ) return at_varchars
    is
        l_session   dbms_ldap.session;
        l_attrs     dbms_ldap.string_collection;
        l_dummy     pls_integer;
        l_data      dbms_ldap.message;
        l_entry     dbms_ldap.message;
        l_attr      varchar2(256);
        l_berelem   dbms_ldap.ber_element;
        l_values    dbms_ldap.string_collection;
        l_result    at_varchars := at_varchars();
        
        i pls_integer;
    begin
        if p_session is null then
            l_session := open_session;
        else
            l_session := p_session;
        end if;
        
        l_attrs(1) := p_attr;
        l_dummy := dbms_ldap.search_s(
            l_session,
            p_base,
            p_scope,
            p_filter,
            l_attrs,
            0,
            l_data
        );

        if p_single = 1 and dbms_ldap.count_entries(l_session, l_data) > 1 then
            raise too_many_rows;
        end if;
        
        l_entry := dbms_ldap.first_entry(l_session, l_data);
        while l_entry is not null loop
            l_attr := dbms_ldap.first_attribute(l_session, l_entry, l_berelem);
            if l_attr is not null then
                l_values := dbms_ldap.get_values(l_session, l_entry, l_attr);
                i := l_values.first;
                while i is not null loop
                    l_result.extend;
                    l_result(l_result.count) := l_values(i);
                    i := l_values.next(i);
                end loop;
            end if;
            l_entry := dbms_ldap.next_entry(l_session, l_entry);
        end loop;
        
        if p_session is null then
            close_session(l_session);
        end if;
        
        return l_result;
    end attribute_values;


    function user_mail(
        p_user_name in varchar2,
        p_single in pls_integer default 0,
        p_expand in pls_integer default 1
    ) return varchar2
    is
        l_values    at_varchars;
    begin
        l_values := 
            attribute_values(
                p_attr   => 'mail',
                p_filter => 
                    '(&(objectClass=user)(displayName=' || 
                    case 
                        when p_expand = 1 then 
                            rtrim(replace(p_user_name, '.', '*'), '*') || '*'
                        else
                            p_user_name
                    end || '))',
                p_single => p_single
            );
        return at_util.joined(l_values, ',');
    end user_mail;


    function users_mails(
        p_users_names in at_varchars,
        p_expand in pls_integer default 1
    ) return varchar2
    is
        l_values at_varchars;
        l_filter varchar2(32767);
    begin
        for i in p_users_names.first .. p_users_names.last loop
            l_filter :=
                l_filter ||
                case 
                    when p_expand = 1 then 
                        rtrim(replace(p_users_names(i), '.', '*'), '*') || '*'
                    else
                        p_users_names(i)
                end || 
                case
                    when i < p_users_names.last then
                        ')(displayName='
                    else
                        ''
               end;
        end loop;
        l_filter := '(&(objectClass=user)(|(displayName=' || l_filter || ')))';
        l_values := 
            attribute_values(
                p_attr   => 'mail',
                p_filter => l_filter,
                p_single => 0
            );
        return at_util.joined(l_values, ',');
    end users_mails;

end at_ldap;
/
