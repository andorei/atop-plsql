create or replace package at_util is
/*******************************************************************************
    Provide useful utilities.

Changelog
    2017-12-27 Andrei Trofimov create package.
    2018-01-31 Andrei Trofimov add to_nls_lang and to_russian_1251.
    2019-08-05 Andrei Trofimov overload joined for dates and numbers

********************************************************************************
Copyright (C) 2017-2019 by Andrei Trofimov

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

    -- Returns string of p_parts elements connected with p_con.
    -- The resulting string begins with p_start_with and end with p_end_with.
    function joined(
        p_parts in at_varchars,
        p_con in varchar2,
        p_start_with varchar2 default null,
        p_end_with varchar2 default null
    ) return varchar2;

    function joined(
        p_parts in at_dates,
        p_con in varchar2,
        p_start_with varchar2 default null,
        p_end_with varchar2 default null
    ) return varchar2;

    function joined(
        p_parts in at_numbers,
        p_con in varchar2,
        p_start_with varchar2 default null,
        p_end_with varchar2 default null
    ) return varchar2;

    function joined(
        p_parts in at_type.varchars,
        p_con in varchar2,
        p_start_with varchar2 default null,
        p_end_with varchar2 default null
    ) return varchar2;

    function joined(
        p_parts in at_type.dates,
        p_con in varchar2,
        p_start_with varchar2 default null,
        p_end_with varchar2 default null
    ) return varchar2;

    function joined(
        p_parts in at_type.numbers,
        p_con in varchar2,
        p_start_with varchar2 default null,
        p_end_with varchar2 default null
    ) return varchar2;

    -- Returns nested table populated with elements of p_list.
    -- Elements in a string p_list are separated with p_sep.
    -- The elements in a resulting table are optionally trimmed.
    function splitted(
        p_list in varchar2,
        p_sep in varchar2,
        p_trim_spaces pls_integer default 0
    ) return at_varchars;

    -- Convert p_text into p_nls_lang charset/encoding specified in nls_lang format.
    -- Example:
    --     select at_util.to_nls_lang('привет', 'RUSSIAN_CIS.CL8MSWIN1251') from dual;
    function to_nls_lang(
        p_text varchar2,
        p_nls_lang varchar2 default at_env.c_nls_lang
    ) return varchar2;

    -- Zipped blob from p_content blob.
    function zipped(
        p_content blob,
        p_file_name varchar2
    ) return blob;

    -- Zipped blob from p_content of type at_type.lvarchars.
    function zipped(
        p_content at_type.lvarchars,
        p_file_name varchar2
    ) return blob;

    -- Zipped blob from external file.
    function zipped(
        p_dir varchar2,
        p_file_name varchar2
    ) return blob;

    -- Return true if named interval p_name has expired or never started.
    -- Othewise returns false.
    function expired_interval(
        p_name varchar2,
        p_interval interval day to second default interval '0 1:00:00' day to second
    ) return boolean;

    -- true if launched from anonymous block.
    function is_anon return boolean;

    -- Run PL/SQL block as scheduler job.
    procedure run_job(
        p_plsql varchar2,
        p_name varchar2 default null,
        p_comments varchar2 default null
    );

end at_util;
/
create or replace package body at_util is

    -- Returns string of p_parts elements connected with p_con.
    -- The resulting string begins with p_start_with and end with p_end_with.
    function joined(
        p_parts in at_varchars,
        p_con in varchar2,
        p_start_with varchar2 default null,
        p_end_with varchar2 default null
    ) return varchar2
    is
        i pls_integer;
        l_line varchar2(32767) := '';
    begin
        if p_parts is null or p_con is null then
            return null;
        end if;

        i := p_parts.first;
        while i is not null loop
            l_line := l_line || p_con || p_parts(i);
            i := p_parts.next(i);
        end loop;

        return
            case
            when l_line is not null then
                p_start_with || substr(l_line, length(p_con) + 1) || p_end_with
            else
                l_line
            end;
    end joined;

    function joined(
        p_parts in at_dates,
        p_con in varchar2,
        p_start_with varchar2 default null,
        p_end_with varchar2 default null
    ) return varchar2
    is
        i pls_integer;
        l_line varchar2(32767) := '';
    begin
        if p_parts is null or p_con is null then
            return null;
        end if;

        i := p_parts.first;
        while i is not null loop
            l_line := l_line || p_con || to_char(p_parts(i), at_env.c_date_format);
            i := p_parts.next(i);
        end loop;

        return
            case
            when l_line is not null then
                p_start_with || substr(l_line, length(p_con) + 1) || p_end_with
            else
                l_line
            end;
    end joined;

    function joined(
        p_parts in at_numbers,
        p_con in varchar2,
        p_start_with varchar2 default null,
        p_end_with varchar2 default null
    ) return varchar2
    is
        i pls_integer;
        l_line varchar2(32767) := '';
    begin
        if p_parts is null or p_con is null then
            return null;
        end if;

        i := p_parts.first;
        while i is not null loop
            l_line := l_line || p_con || p_parts(i);
            i := p_parts.next(i);
        end loop;

        return
            case
            when l_line is not null then
                p_start_with || substr(l_line, length(p_con) + 1) || p_end_with
            else
                l_line
            end;
    end joined;

    function joined(
        p_parts in at_type.varchars,
        p_con in varchar2,
        p_start_with varchar2 default null,
        p_end_with varchar2 default null
    ) return varchar2
    is
        i pls_integer;
        l_line varchar2(32767) := '';
    begin
        if p_parts is null or p_con is null then
            return null;
        end if;

        i := p_parts.first;
        while i is not null loop
            l_line := l_line || p_con || p_parts(i);
            i := p_parts.next(i);
        end loop;

        return
            case
            when l_line is not null then
                p_start_with || substr(l_line, length(p_con) + 1) || p_end_with
            else
                l_line
            end;
    end joined;

    function joined(
        p_parts in at_type.dates,
        p_con in varchar2,
        p_start_with varchar2 default null,
        p_end_with varchar2 default null
    ) return varchar2
    is
        i pls_integer;
        l_line varchar2(32767) := '';
    begin
        if p_parts is null or p_con is null then
            return null;
        end if;

        i := p_parts.first;
        while i is not null loop
            l_line := l_line || p_con || to_char(p_parts(i), at_env.c_date_format);
            i := p_parts.next(i);
        end loop;

        return
            case
            when l_line is not null then
                p_start_with || substr(l_line, length(p_con) + 1) || p_end_with
            else
                l_line
            end;
    end joined;

    function joined(
        p_parts in at_type.numbers,
        p_con in varchar2,
        p_start_with varchar2 default null,
        p_end_with varchar2 default null
    ) return varchar2
    is
        i pls_integer;
        l_line varchar2(32767) := '';
    begin
        if p_parts is null or p_con is null then
            return null;
        end if;

        i := p_parts.first;
        while i is not null loop
            l_line := l_line || p_con || p_parts(i);
            i := p_parts.next(i);
        end loop;

        return
            case
            when l_line is not null then
                p_start_with || substr(l_line, length(p_con) + 1) || p_end_with
            else
                l_line
            end;
    end joined;

    -- Returns nested table populated with elements of p_list.
    -- Elements in a string p_list are separated with p_sep.
    -- The elements in a resulting table are optionally trimmed.
    function splitted(
        p_list in varchar2,
        p_sep in varchar2,
        p_trim_spaces pls_integer default 0
    ) return at_varchars
    is
        l_beg pls_integer := 1;
        l_fin pls_integer := 0;
        l_parts at_varchars := at_varchars();
    begin
        if p_list is null or p_sep is null then
            return l_parts;
        end if;

        l_fin := instr(p_list, p_sep, l_beg);
        while l_fin > 0 loop
            l_parts.extend;
            l_parts(l_parts.count) := substr(p_list, l_beg, l_fin - l_beg);
            l_beg := l_fin + length(p_sep);
            l_fin := instr(p_list, p_sep, l_beg);
        end loop;
        l_parts.extend;
        l_parts(l_parts.count) := substr(p_list, l_beg);

        if p_trim_spaces = 1 then
            for i in l_parts.first .. l_parts.last loop
                l_parts(i) := trim(l_parts(i));
            end loop;
        end if;

        return l_parts;
    end splitted;

    -- Convert p_text into p_nls_lang charset/encoding specified in nls_lang format.
    -- Example:
    --     select at_util.to_nls_lang('привет', 'RUSSIAN_CIS.CL8MSWIN1251') from dual;
    function to_nls_lang(
        p_text varchar2,
        p_nls_lang varchar2 default at_env.c_nls_lang
    ) return varchar2
    is
    begin
        return utl_raw.cast_to_varchar2(utl_raw.convert(utl_raw.cast_to_raw(p_text), p_nls_lang, userenv('language')));
    end to_nls_lang;

    -- Zipped blob from p_content blob.
    function zipped(
        p_content blob,
        p_file_name varchar2
    ) return blob
    is
        l_zipped_blob blob;
    begin
        as_zip.add1file(
            p_zipped_blob => l_zipped_blob,
            p_name => p_file_name,
            p_content => zipped.p_content
        );
        as_zip.finish_zip(l_zipped_blob);
        return l_zipped_blob;
    end zipped;

    -- Zipped blob from p_content of type at_type.lvarchars.
    function zipped(
        p_content at_type.lvarchars,
        p_file_name varchar2
    ) return blob
    is
    begin
        return zipped(at_type.lvarchars_to_blob(p_content), p_file_name);
    end zipped;

    -- Zipped blob from external file.
    function zipped(
        p_dir varchar2,
        p_file_name varchar2
    ) return blob
    is
    begin
        return zipped(as_zip.file2blob(p_dir, p_file_name), p_file_name);
    end zipped;

    -- Return true if named interval p_name has expired or never started.
    -- Othewise returns false.
    function expired_interval(
        p_name varchar2,
        p_interval interval day to second default interval '0 1:00:00' day to second)
    return boolean
    is
        l_started timestamp := to_timestamp_tz(at_conf.param($$PLSQL_UNIT, 'expire-' || p_name), 'yyyy-mm-dd hh24:mi:ss TZH:TZM');
    begin
        if l_started is null or systimestamp - l_started >= p_interval then
            at_conf.set_param($$PLSQL_UNIT, 'expire-' || p_name, to_char(systimestamp, 'yyyy-mm-dd hh24:mi:ss TZH:TZM'));
            return true;
        else
            return false;
        end if;
    end expired_interval;

    -- true if launched from anonymous block.
    function is_anon return boolean
    is
    begin
        return regexp_like(dbms_utility.format_call_stack, 'anonymous block\s+$', 'm');
    end is_anon;

    -- Run PL/SQL block as scheduler job.
    procedure run_job(
        p_plsql varchar2,
        p_name varchar2 default null,
        p_comments varchar2 default null
    ) is
    begin
        dbms_scheduler.create_job(
            job_name => nvl(p_name, dbms_scheduler.generate_job_name),
            job_type => 'PLSQL_BLOCK',
            job_action => 'begin '||rtrim(p_plsql, ';'||at_env.whitespace)||'; end;',
            enabled => TRUE,
            comments => p_comments
        );
    end run_job;

end at_util;
/
