-- create job to run evl.purge daily
begin
    dbms_scheduler.create_job(
        job_name        => 'AT_LOG_PURGE',
        job_type        => 'STORED_PROCEDURE',
        job_action      => 'at_log.purge',
        start_date      => sysdate,
        repeat_interval => 'Freq=Daily;ByHour=20;ByMinute=20',
        end_date        => to_date(null),
        job_class       => 'DEFAULT_JOB_CLASS',
        enabled         => true,
        auto_drop       => true,
        comments        => 'Job to purge log table.'
    );
end;
/
