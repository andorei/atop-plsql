begin
    at_task.delete_task(
        p_task_name => 'R#SEND_FAILED_TASKS'
    );
    at_conf.delete_email(
        p_owner => 'R#SEND_FAILED_TASKS'
    );
end;
/

begin
    at_task.delete_task(
        p_task_name => 'R#SEND_LOGGED_ERRORS'
    );
    at_conf.delete_email(
        p_owner => 'R#SEND_LOGGED_ERRORS'
    );
end;
/

begin
    at_task.delete_task(
        p_task_name => 'R#SEND_WEIRD_LOGINS'
    );
    at_conf.delete_email(
        p_owner => 'R#SEND_WEIRD_LOGINS'
    );
    at_conf.delete_param(
        p_owner => 'R#SEND_WEIRD_LOGINS',
        p_name => 'userhosts_re'
    );
end;
/

commit;
