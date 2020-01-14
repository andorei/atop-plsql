create or replace package at_task is
/*******************************************************************************
    Task scheduling and running API

Changelog
    2016-08-17 Andrei Trofimov create package
    2017-08-07 Andrei Trofimov add schedule start and stop timestamps

********************************************************************************
Copyright (C) 2016-2018 by Andrei Trofimov

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

    c_task_status_on constant at_task_.status%type := 'on';
    c_task_status_off constant at_task_.status%type := 'off';
    c_task_status_test constant at_task_.status%type := 'test';
    c_task_status_eyed constant at_task_.status%type := 'eyed';

    procedure define_task(
        p_task_name     at_task_.task_name%type,
        p_what          at_task_.what%type,
        p_schedule      at_task_.schedule%type,
        p_status        at_task_.status%type default at_task.c_task_status_test,
        p_descr         at_task_.descr%type,
        p_start         at_task_.schedule_start%type default null,
        p_stop          at_task_.schedule_stop%type default null
    );

    -- Change task status.
    procedure set_task_off(p_task_name at_task_.task_name%type);
    procedure set_task_on(p_task_name at_task_.task_name%type);
    procedure set_task_test(p_task_name at_task_.task_name%type);
    procedure set_task_eyed(p_task_name at_task_.task_name%type);

    procedure delete_task(p_task_name at_task_.task_name%type);

    -- Run tasks as scheduled.
    -- Should be run periodically (e.g. minutely, or every 10 minutes).
    procedure run;

    -- Run task now.
    procedure run_task(
        p_task_name at_task_.task_name%type,
        p_status at_task_.status%type default null
    );

end at_task;
/
create or replace package body at_task is

    procedure define_task(
        p_task_name     at_task_.task_name%type,
        p_what          at_task_.what%type,
        p_schedule      at_task_.schedule%type,
        p_status        at_task_.status%type default at_task.c_task_status_test,
        p_descr         at_task_.descr%type,
        p_start         at_task_.schedule_start%type default null,
        p_stop          at_task_.schedule_stop%type default null
    ) is
    begin
        insert into at_task_ (
            task_name, descr, status, what, schedule, schedule_start, schedule_stop)
        values (
            p_task_name, p_descr, p_status, p_what, p_schedule, p_start, p_stop)
        ;
    end define_task;

    -- change task status
    procedure set_task_status(
        p_task_name at_task_.task_name%type,
        p_status   at_task_.status%type
    ) is
    begin
        update at_task_
        set status = p_status
        where task_name = p_task_name
        ;
    end set_task_status;

    procedure set_task_off(p_task_name at_task_.task_name%type)
    is
    begin
        set_task_status(p_task_name, c_task_status_off);
    end set_task_off;

    procedure set_task_on(p_task_name at_task_.task_name%type)
    is
    begin
        set_task_status(p_task_name, c_task_status_on);
    end set_task_on;

    procedure set_task_test(p_task_name at_task_.task_name%type)
    is
    begin
        set_task_status(p_task_name, c_task_status_test);
    end set_task_test;

    procedure set_task_eyed(p_task_name at_task_.task_name%type)
    is
    begin
        set_task_status(p_task_name, c_task_status_eyed);
    end set_task_eyed;

    procedure delete_task(p_task_name at_task_.task_name%type)
    is
    begin
        delete from at_task_ where task_name = p_task_name;
    end delete_task;

    -- run tasks as scheduled
    -- should be run periodically (e.g. minutely, or every 10 minutes)
    procedure run
    is
        now varchar2(100) := to_char(sysdate, 'mi hh24 dd mm d');
        l_job_name varchar2(100);
        l_plsql varchar2(4000);
    begin
        for r in (
            select task_name, what, status
            from at_task_
            where regexp_like(now, schedule)
                and status != c_task_status_off
                and systimestamp >= nvl(schedule_start, sysdate - 1)
                and systimestamp < nvl(schedule_stop, sysdate + 1)
        ) loop
            -- provide task name and status arguments if expected
            l_plsql := replace(r.what, ':1', ''''||r.task_name||'''');
            l_plsql := replace(l_plsql, ':2', ''''||r.status||'''');
            -- run task as a scheduler job
            l_job_name := dbms_scheduler.generate_job_name;
            dbms_scheduler.create_job(
                job_name => l_job_name,
                job_type => 'PLSQL_BLOCK',
                job_action => 'begin '||rtrim(l_plsql, ';'||at_env.whitespace)||'; end;',
                enabled => TRUE,
                comments => r.task_name
            );
            -- remember the job name and start time
            update at_task_
            set last_when = systimestamp,
                last_job = l_job_name
            where task_name = r.task_name
            ;
        end loop;
    end run;

    -- run task now
    procedure run_task(
        p_task_name at_task_.task_name%type,
        p_status at_task_.status%type default null
    ) is
        l_job_name varchar2(100);
        l_plsql varchar2(4000);
    begin
        for r in (
            select task_name, what, status
            from at_task_
            where task_name = p_task_name
                and status != c_task_status_off
                and systimestamp >= nvl(schedule_start, sysdate - 1)
                and systimestamp < nvl(schedule_stop, sysdate + 1)
        ) loop
            -- provide task name and status arguments if expected
            l_plsql := replace(r.what, ':1', ''''||r.task_name||'''');
            l_plsql := replace(l_plsql, ':2', ''''||nvl(p_status, r.status)||'''');
            -- run task as a scheduler job
            l_job_name := dbms_scheduler.generate_job_name;
            dbms_scheduler.create_job(
                job_name => l_job_name,
                job_type => 'PLSQL_BLOCK',
                job_action => 'begin '||rtrim(l_plsql, ';'||at_env.whitespace)||'; end;',
                enabled => TRUE,
                comments => r.task_name
            );
            -- remember the job name and start time
            update at_task_
            set last_when = systimestamp,
                last_job = l_job_name
            where task_name = r.task_name
            ;
        end loop;
    end run_task;

end at_task;
/
