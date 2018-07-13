set define off

prompt UNINSTALLING DEMO...

@@at_rep_delete_tasks.sql
drop package at_rep;

prompt DONE

set define on
