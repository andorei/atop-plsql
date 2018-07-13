begin
    at_conf.set_email(
        p_owner => 'R#SEND_FAILED_TASKS',
        p_to => 'at_env.c_email_admin',
        p_cc => null,
        p_bcc => null,
        p_descr => 'Notification on failed tasks.'
    );
    at_task.define_task(
        p_task_name => 'R#SEND_FAILED_TASKS', 
        p_what => 'at_rep.send_failed_tasks(:1)', 
        p_schedule => '05 .. .. .. .', -- hourly at 5 minutes
        p_status => 'on', 
        p_descr => 'Notification on failed tasks.'
    );
end;
/

begin
    at_conf.set_email(
        p_owner => 'R#SEND_LOGGED_ERRORS',
        p_to => 'at_env.c_email_admin',
        p_cc => null,
        p_bcc => null,
        p_descr => 'Notification on logged errors.'
    );
    at_task.define_task(
        p_task_name => 'R#SEND_LOGGED_ERRORS', 
        p_what => 'at_rep.send_logged_errors(:1)', 
        p_schedule => '.. .. .. .. .', -- minutely
        p_status => 'on', 
        p_descr => 'Notification on logged errors.'
    );
end;
/

begin
    at_conf.set_param(
        p_owner => 'R#SEND_WIERD_LOGINS',
        p_name => 'userhosts_re',
        p_param => '^(company.com|company.ru)',
        p_descr => 'Regular expression that defines allowed users'' hosts.'
    );
    at_conf.set_email(
        p_owner => 'R#SEND_WIERD_LOGINS',
        p_to => 'at_env.c_email_admin',
        p_cc => null,
        p_bcc => null,
        p_descr => 'Notification on weird logins to DB.'
    );
    at_task.define_task(
        p_task_name => 'R#SEND_WIERD_LOGINS', 
        p_what => 'at_rep.send_wierd_logins(:1)', 
        p_schedule => '10 08 .. .. .',
        p_status => 'on', 
        p_descr => 'Notification on weird logins to DB.'
    );
end;
/

commit;
