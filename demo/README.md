# atop-plsql demo

Package `at_rep` provides 3 procedures that send reports by email:

* Report on failed atop-tasks,
* Report on errors recently logged in atop-log,
* Report on logins onto the database from unexpected user hosts.

Procedures of `at_rep` package are run as atop-tasks.

Parameters required by the reports, including email addressees, are set using atop-conf.

To get reports by email you should set parameters related to `at_smtp` and `at_mail` packages in package `at_env` and recompile it.

For report on logins to work properly
* select privilege on `dba_audit_session` view must be granted to the package owner and
* `audit session` must be turned on in the database.

To install atop-plsql demo
1. make `demo` the current directory,
2. run sqlplus and connect to the user that owns atop-plsql utilities,
3. run `@@install.sql`

To uninstall atop-plsql demo
1. make `demo` the current directory,
2. run sqlplus and connect to the user that owns atop-plsql demo,
3. run `@@uninstall.sql`
