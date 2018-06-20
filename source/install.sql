set define off

prompt INSTALLING BASIC TYPES AND UTILITIES...

@@as_xlsx.pck
@@as_zip.pck
@@at_env.spc
@@at_exc.pck
@@at_type_create.sql
@@at_type.pck
@@at_util.pck

prompt INSTALLING FILE AND OUTPUT UTILITIES...

@@at_file_create.sql
@@at_file.pck
@@at_out.pck

prompt INSTALLING JOURNAL UTILITIES...

@@at_jour.pck

prompt INSTALLING LDAP UTILITIES...

@@at_ldap.pck

prompt INSTALLING LOGGING UTILITIES...

@@at_log_create.sql
@@at_log.pck
@@at_log_create_job.sql

prompt INSTALLING DELTA UTILITIES...

-- as sys: grant select on v_$database to &user;

@@at_delta_create.sql
@@at_delta.pck
@@at_delta2.pck
@@at_delta_create_job.sql

prompt INSTALLING CONFIG UTILITIES...

@@at_conf_create.sql
@@at_conf.pck

prompt INSTALLING TASK SCHEDULER...

@@at_task_create.sql
@@at_task.pck
@@at_task_create_job.sql

prompt INSTALLING MAIL UTILITIES...

@@at_smtp.pck
@@at_mail.pck

prompt DONE

set define on
