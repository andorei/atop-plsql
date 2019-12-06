create table at_task_ (
    task_name   varchar2(30) primary key,
    descr      varchar2(4000),
    status     varchar2(5) default 'test' not null,
    what       varchar2(4000) not null,
    schedule   varchar2(100) not null,
    schedule_start timestamp with time zone,
    schedule_stop  timestamp with time zone,
    last_when  timestamp,
    last_job   varchar2(30),
    constraint at_task_ck check (status in ('on', 'off', 'test', 'eyed'))
);

comment on table at_task_ is 'Task definitions';
comment on column at_task_.task_name is 'Task name';
comment on column at_task_.descr is 'Description';
comment on column at_task_.status is 'Task status, one of: on, off, test';
comment on column at_task_.what is 'PL/SQL code to run';
comment on column at_task_.schedule is 'Regular expression defining schedule';
comment on column at_task_.schedule_start is 'When schedule starts';
comment on column at_task_.schedule_stop is 'When schedule stops';
comment on column at_task_.last_when is 'When last run';
comment on column at_task_.last_job is 'Name of the scheduler job last run';

-- Details of tasks' last run.
create or replace view at_task_jobs as
select t.*, d.status job_status, d.run_duration, d.cpu_used, d.additional_info 
from user_scheduler_job_run_details d, at_task_ t
where d.job_name(+) = t.last_job
order by last_when desc;
