-- create job to run at_delta.purge_cdc daily
begin
    dbms_scheduler.create_job(
        job_name        => 'AT_DELTA_PURGE',
        job_type        => 'STORED_PROCEDURE',
        job_action      => 'at_delta.purge_cdc',
        start_date      => sysdate,
        repeat_interval => 'Freq=Daily;ByHour=0,12;ByMinute=12',
        end_date        => to_date(null),
        job_class       => 'DEFAULT_JOB_CLASS',
        enabled         => true,
        auto_drop       => true,
        comments        => 'Delete utilized rows from CDC tables.'
    );
end;
/
