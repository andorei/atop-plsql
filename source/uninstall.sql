set define off

prompt UNINSTALLING MAIL UTILITIES...

drop package at_mail;
drop package at_smtp;

prompt UNINSTALLING TASK SCHEDULER...

@@at_task_drop_job.sql
drop package at_task;
@@at_task_drop.sql

prompt UNINSTALLING CONFIG UTILITIES...

drop package at_conf;
@@at_conf_drop.sql

prompt UNINSTALLING DELTA UTILITIES...

-- XXX as sys: grant select on v_$database to &user;
@@at_delta_drop_job.sql
drop package at_delta;
drop package at_delta2;
@@at_delta_drop.sql

prompt UNINSTALLING LOGGING UTILITIES...

@@at_log_drop_job.sql
drop package at_log;
@@at_log_drop.sql

prompt UNINSTALLING LDAP UTILITIES...

drop package at_ldap;

prompt UNINSTALLING JOURNAL UTILITIES...

drop package at_jour;

prompt UNINSTALLING FILE AND OUTPUT UTILITIES...

drop package at_out;
drop package at_file;
@@at_file_drop.sql

prompt UNINSTALLING BASIC TYPES AND UTILITIES...

drop package at_util;
drop package at_type;
drop package at_exc;
drop package at_env;
@@at_type_drop.sql
drop package as_xlsx;
drop package as_zip;

prompt DONE

set define on
