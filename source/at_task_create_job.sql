-- Create job to run at_task.run minutely.
begin
    dbms_scheduler.create_job(
        job_name        => 'AT_TASK_RUN',
        job_type        => 'STORED_PROCEDURE',
        job_action      => 'at_task.run',
        start_date      => sysdate,
        --every minute
        repeat_interval => 'Freq=Minutely;Interval=1',
        --every 10 minutes
        --repeat_interval => 'Freq=Minutely;ByMinute=3,13,23,33,43,53',
        end_date        => to_date(null),
        job_class       => 'DEFAULT_JOB_CLASS',
        enabled         => true,
        auto_drop       => true,
        comments        => 'Job to run tasks on schedule'
    );
end;
/
