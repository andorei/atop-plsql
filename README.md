# atop-plsql

PL/SQL utilities that make it easier to develop routine solutions in Oracle DBMS.

***atop-plsql*** is a collection of types, tables, PL/SQL packages and some other schema objects that has been used as a basis for developing custom solutions on Oracle 11g databases.

***atop-plsql*** provides:

* `at_env` package specification (there is no package body) to set configuration parameters used by other atop-plsql utilities. You are expected to modify constants in `at_env` specification to suit your needs.
* Few types used by atop-plsql itself, including (nested) table of varchar2(4000), table of number, table of date and PL/SQL associative arrays in `at_type` package, as well as functions to convert between these types.
* Few exceptions used by atop-plsql itself, including `assertion_error`, `invalid_argument` and some others defined in `at_exc` package, as well as procedures to test a given condition that raise exceptions when failed.
* Utility routines to split varchar2 strings into elements, to join elements into varchar2 string, to zip blob, associative array of varchar2's or external file (available through Oracle directory object); see package `at_util`.
* File utilities to create, write to, read from and rename external files using default character set and encoding as defined in `at_env` package specification; see package `at_file`.
* Pipeline functions that read .csv file (either external or blob/clob) and return its lines row by row; see `csv_table` functions in package `at_file`.
* Procedures to load `.csv` file (either external or blob/clob) into database table where rows represent lines, and columns contain individual values; see `load_csv` procedures in package `at_file`.
* Procedures to fetch rows from dynamic cursor and put the data formatted as csv, html table or json into dbms_output buffer, owa buffer, associative array of varchar2's, or external file; see package `at_out`.
* Utilities to create, manage and delete audit journal tables that capture changes made to the specified database along with session related meta information; see package `at_jour`.
* Logging utilities to put info, warning, error and debug messages into database table; old messages are purged automatically; see package `at_log` and table `at_log_`.
* Utilities to query and get data from LDAP server. Retrieved data may be returned either as nested table or via a pipeline function. Function 'user_mail' returns email address of a user specified in the argument. See package `at_ldap`.
* Storage for configuration parameters set and accessed by owners. Parameter values, depending on parameter nature, may be either retrieved as is, or dynamically evaluated; see package `at_conf`.
* Utility routines to schedule execution of PL/SQL procedures using crontab-like regular expression as a schedule. Scheduled tasks are executed by `dbms_scheduler` jobs. See package `at_task`.
* Utilities in `at_smtp` package to prepare and send email messages, either text or html, including ones with multiple file  attachments.
* Utilities in `at_mail` package to send email messages using default greeting, signature and sender set in `at_env` package specification.
* Utility routines in `at_mail` package to send data retrieved from dynamic cursor by email either as attached file (optionally compressed as zip) or html table in message body; recipients, subject, message text and priority specified as well.
* Package `at_delta` to create change data capture logs on specified tables, and create services providing data changes (deltas) to the clients; useful to implement interfaces with external systems as well as internal solutions to process data changes over period of time.


### atop-plsql installation

To successfully install all schema objects and PL/SQL packages, Oracle user must be granted the following additional privileges (provided it already has `connect` and `resource` roles):

`
grant create view, drop view to <user>;
grant create job, drop job to <user>;
grant select on sys.v_$database to <user>;
grant select on sys.v_$session to <user>;
`

To install atop-plsql utilities
1. make `source` the current directory,
2. run sqlplus and connect to the user that will own atop-plsql utilities,
3. run `@install.sql`


### atop-plsql uninstallation

To uninstall atop-plsql utilities
1. make `source` the current directory,
2. run sqlplus and connect to the user that owns atop-plsql utilities,
3. run `@uninstall.sql`
