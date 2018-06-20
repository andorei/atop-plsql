create or replace package at_log is
/*******************************************************************************
    Provide support for logging.

Changelog
    2016-09-05 Andrei Trofimov create package

********************************************************************************
Copyright (C) 2016 by Andrei Trofimov

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

    -- Log debug data using autonomous transaction.
    procedure debug(
        p_progname at_log_.progname%type,
        p_message  at_log_.message%type,
        p_addinfo  at_log_.addinfo%type default null,
        p_username at_log_.username%type default null,
        p_tag      at_log_.tag%type default null
    );

    -- Log error data using autonomous transaction.
    procedure error(
        p_progname at_log_.progname%type,
        p_message  at_log_.message%type,
        p_addinfo  at_log_.addinfo%type default null,
        p_username at_log_.username%type default null,
        p_tag      at_log_.tag%type default null
    );

    -- Log warning within current transaction.
    procedure warn(
        p_progname at_log_.progname%type,
        p_message  at_log_.message%type,
        p_addinfo  at_log_.addinfo%type default null,
        p_username at_log_.username%type default null,
        p_tag      at_log_.tag%type default null
    );

    -- Log information within current transaction.
    procedure info(
        p_progname at_log_.progname%type,
        p_message  at_log_.message%type,
        p_addinfo  at_log_.addinfo%type default null,
        p_username at_log_.username%type default null,
        p_tag      at_log_.tag%type default null
    );

    -- Log information within current transaction to keep for a long time.
    procedure keep(
        p_progname at_log_.progname%type,
        p_message  at_log_.message%type,
        p_addinfo  at_log_.addinfo%type default null,
        p_username at_log_.username%type default null,
        p_tag      at_log_.tag%type default null
    );

    -- Delete rows logged earlier than (sysdate - p_keep_days).
    -- Rows created by keep procedure are only deleted if p_purge_all is true.
    -- To purge rows up to the last minute set p_keep_days = -1.
    procedure purge(
        p_keep_days number default 30,
        p_purge_all boolean default false
    );

end at_log;
/
create or replace package body at_log is

    c_info  constant at_log_.kind%type := 'i';
    c_debug constant at_log_.kind%type := 'd';
    c_error constant at_log_.kind%type := 'e';
    c_warn  constant at_log_.kind%type := 'w';
    c_keep  constant at_log_.kind%type := 'p';
    
    -- Internal log procedure
    procedure log_(
        p_kind     at_log_.kind%type,
        p_progname at_log_.progname%type,
        p_message  at_log_.message%type,
        p_addinfo  at_log_.addinfo%type,
        p_username at_log_.username%type,
        p_tag      at_log_.tag%type
    ) is
    begin
        insert into at_log_ (
            id, when, kind, message, addinfo, progname, username, tag)
        values (
            at_log_seq.nextval, 
            systimestamp, 
            p_kind, 
            p_message,
            p_addinfo,
            p_progname,
            nvl(p_username, user),
            p_tag
        );
    end log_;

    -- Log debug data using autonomous transaction.
    procedure debug(
        p_progname at_log_.progname%type,
        p_message  at_log_.message%type,
        p_addinfo  at_log_.addinfo%type default null,
        p_username at_log_.username%type default null,
        p_tag      at_log_.tag%type default null
    ) is
        pragma autonomous_transaction;
    begin
        log_(
            p_kind     => c_debug,
            p_progname => p_progname,
            p_message  => p_message,
            p_addinfo  =>
                case
                    when p_addinfo is null then
                        -- beautiful is better than ugly :)
                        rpad('----- Error Stack -', 29, '-') || at_env.nl ||
                        dbms_utility.format_error_stack || 
                        rpad('----- Error Backtrace -', 29, '-') || at_env.nl ||
                        dbms_utility.format_error_backtrace ||
                        --'----- PL/SQL Call Stack -----' || at_env.nl ||
                        dbms_utility.format_call_stack
                    else
                        p_addinfo
                end,
            p_username => p_username,
            p_tag      => p_tag
        );        
        commit; -- autonomous transaction
    end debug;
    
    -- Log error data using autonomous transaction.
    procedure error(
        p_progname at_log_.progname%type,
        p_message  at_log_.message%type,
        p_addinfo  at_log_.addinfo%type default null,
        p_username at_log_.username%type default null,
        p_tag      at_log_.tag%type default null
    ) is
        pragma autonomous_transaction;
    begin
        log_(
            p_kind     => c_error,
            p_progname => p_progname,
            p_message  => p_message,
            p_addinfo  =>
                case
                    when p_addinfo is null then
                        -- beautiful is better than ugly :)
                        rpad('----- Error Stack -', 29, '-') || at_env.nl ||
                        dbms_utility.format_error_stack || 
                        rpad('----- Error Backtrace -', 29, '-') || at_env.nl ||
                        dbms_utility.format_error_backtrace ||
                        --'----- PL/SQL Call Stack -----' || at_env.nl ||
                        dbms_utility.format_call_stack
                    else
                        p_addinfo
                end,
            p_username => p_username,
            p_tag      => p_tag
        );        
        commit; -- autonomous transaction
    end error;

    -- Log warning within current transaction.
    procedure warn(
        p_progname at_log_.progname%type,
        p_message  at_log_.message%type,
        p_addinfo  at_log_.addinfo%type default null,
        p_username at_log_.username%type default null,
        p_tag      at_log_.tag%type default null
    ) is
    begin
        log_(
            p_kind     => c_warn,
            p_progname => p_progname,
            p_message  => p_message,
            p_addinfo  =>
                case
                    when p_addinfo is null then
                        -- beautiful is better than ugly :)
                        rpad('----- Error Stack -', 29, '-') || at_env.nl ||
                        dbms_utility.format_error_stack || 
                        rpad('----- Error Backtrace -', 29, '-') || at_env.nl ||
                        dbms_utility.format_error_backtrace ||
                        --'----- PL/SQL Call Stack -----' || at_env.nl ||
                        dbms_utility.format_call_stack
                    else
                        p_addinfo
                end,
            p_username => p_username,
            p_tag      => p_tag
        );        
    end warn;

    -- Log information within current transaction.
    procedure info(
        p_progname at_log_.progname%type,
        p_message  at_log_.message%type,
        p_addinfo  at_log_.addinfo%type default null,
        p_username at_log_.username%type default null,
        p_tag      at_log_.tag%type default null
    ) is
    begin
        log_(c_info, p_progname, p_message, p_addinfo, p_username, p_tag);
    end info;
    
    -- Log information within current transaction to keep for a long time.
    procedure keep(
        p_progname at_log_.progname%type,
        p_message  at_log_.message%type,
        p_addinfo  at_log_.addinfo%type default null,
        p_username at_log_.username%type default null,
        p_tag      at_log_.tag%type default null
    ) is
    begin
        log_(c_keep, p_progname, p_message, p_addinfo, p_username, p_tag);
    end keep;

    -- Delete rows logged earlier than (sysdate - p_keep_days).
    -- Rows created by keep procedure are only deleted if p_purge_all is true.
    -- To purge rows up to the last minute set p_keep_days = -1.
    procedure purge(
        p_keep_days number default 30,
        p_purge_all boolean default false
    ) is
        l_rows_per_commit pls_integer := 10000;
    begin
        loop
            if p_purge_all then
                delete from at_log_ 
                where when < trunc(sysdate - p_keep_days)
                    and rownum <= l_rows_per_commit;
            else
                delete from at_log_ 
                where when < trunc(sysdate - p_keep_days)
                    and kind != c_keep
                    and rownum <= l_rows_per_commit;
            end if;
            exit when sql%rowcount = 0;
            commit;
        end loop;
    end purge;

end at_log;
/
