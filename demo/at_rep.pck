create or replace package at_rep is
/*******************************************************************************
    Reports for administator.

Changelog
    2018-07-05 Andrei Trofimov create package

********************************************************************************
Copyright (C) 2018 by Andrei Trofimov

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

    -- Notify on failed tasks.
    procedure send_failed_tasks(p_task_name at_task_.task_name%type);
    
    -- Notify on errors in log.
    procedure send_logged_errors(p_task_name at_task_.task_name%type);
    
    -- Notify on weird logins to the database.
    procedure send_weird_logins(
        p_task_name at_task_.task_name%type,
        p_since date default trunc(sysdate-1)
    );

    -- Stop jobs that run too long.
    procedure stop_weird_jobs(p_task_name at_task_.task_name%type);
    
end at_rep;
/
create or replace package body at_rep is

    -- Notify on failed tasks.
    procedure send_failed_tasks(p_task_name at_task_.task_name%type)
    is
        l_cursor sys_refcursor;
    begin
        open l_cursor for
        select task_name, job_name, last_when, '<pre>'||additional_info||'</pre>'
        from user_scheduler_job_run_details d, at_task_ r
        where job_name = last_job
            and r.status = at_task.c_task_status_on
            and last_when >= sysdate - 3/24
            and d.status = 'FAILED'
        ;
        at_mail.send_html_table(
            p_owner => p_task_name, 
            p_subject => 'Failed tasks within 3 hours', 
            p_message => null, 
            p_cursor => l_cursor, 
            p_colnames => at_varchars('TASK_NAME','JOB_NAME','LAST_RUN','ADDITIONAL_INFO'), 
            p_status => at_env.c_status_on 
        );
        close l_cursor;
    end send_failed_tasks;

    -- Notify on errors in log.
    procedure send_logged_errors(p_task_name at_task_.task_name%type)
    is
        l_cursor sys_refcursor;
        l_previous_id number := at_conf.param(p_task_name, 'previous_id');
        l_latest_id number;
    begin
        select nvl(max(id), 0) into l_latest_id from at_log_;
        
        open l_cursor for
        select when, progname, message, '<pre>'||addinfo||'</pre>'
        from at_log_ atl
        where atl.id between l_previous_id+1 and l_latest_id
            and kind = 'e'
        order by when;

        at_mail.send_html_table(
            p_owner => p_task_name,
            p_subject => 'Errors in log',
            p_message => null,
            p_cursor => l_cursor,
            p_colnames => at_varchars('WHEN','PROGNAME','MESSAGE','ADDITIONAL_INFO')
        );
        close l_cursor;

        at_conf.set_param(p_task_name, 'previous_id', l_latest_id);
        commit;
    end send_logged_errors;

    -- Notify on weird logins to the database.
    procedure send_weird_logins(
        p_task_name at_task_.task_name%type,
        p_since date default trunc(sysdate-1)
    ) is
        l_cursor sys_refcursor;
        l_allowed_userhosts varchar2(4000) := at_conf.param(p_task_name, 'userhosts_re');
    begin
        open l_cursor for
        'select username, os_username, userhost, trunc(timestamp), count(*)
        from dba_audit_session s
        where (not regexp_like(userhost, :1) or username = ''SYS'')
            and s.timestamp >= :2
        group by username, os_username, userhost, trunc(timestamp)
        order by trunc(timestamp)'
        using l_allowed_userhosts, p_since
        ;
        at_mail.send_html_table(
            p_owner => p_task_name,
            p_subject => 'Weird logins since ' || to_char(p_since, 'yyyy-mm-dd hh24:mi:ss'),
            p_message => null,
            p_cursor => l_cursor,
            p_colnames => at_varchars('DB User','OS User','User Host','Date','Login Count'),
            p_status => at_env.c_status_on
        );
        close l_cursor;
    end send_weird_logins;

    -- Stop jobs that run too long.
    procedure stop_weird_jobs(p_task_name at_task_.task_name%type)
    is
        l_job_run_limit interval day to second := to_dsinterval(at_conf.param(p_task_name, 'job_run_limit'));
        l_longrun_jobs_re varchar2(4000) := at_conf.param(p_task_name, 'longrun_jobs_re');
    begin
        for r in (
            -- create job with LONGRUN in the name to prevent it from being killed
            select r.job_name, j.comments, r.elapsed_time
            from dba_scheduler_running_jobs r, dba_scheduler_jobs j
            where r.elapsed_time > l_job_run_limit
                and r.owner = user
                and r.owner = j.owner
                and r.job_name = j.job_name
                and not regexp_like(r.job_name, l_longrun_jobs_re)
                and not regexp_like(nvl(j.comments, ' '), l_longrun_jobs_re)
        ) loop
            begin
                sys.dbms_scheduler.stop_job(r.job_name, force => true);
                at_log.error($$PLSQL_UNIT, 'Stopped job '||r.job_name||' (' || r.comments ||') running for '||r.elapsed_time);
            exception
                when others then
                    at_log.error($$PLSQL_UNIT, 'Failed to stop job '||r.job_name||' (' || r.comments ||') running for '||r.elapsed_time);
            end;
        end loop;
    end stop_weird_jobs;

end at_rep;
/
