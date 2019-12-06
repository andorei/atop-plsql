create or replace package at_env is
/*******************************************************************************
Changelog
    2017-12-27 Andrei Trofimov create package

********************************************************************************
Copyright (C) 2017-2018 by Andrei Trofimov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

********************************************************************************
*/
  
    ht constant char(1) := chr(9);
    lf constant char(1) := chr(10);
    vt constant char(1) := chr(11);
    ff constant char(1) := chr(12);
    cr constant char(1) := chr(13);
    crlf constant char(2) := cr||lf;
    nl constant varchar2(2) := cr||lf;
    whitespace constant varchar2(10) := ' '||ht||lf||cr||vt||ff;

    c_date_format         constant varchar2(50) := 'DD.MM.YYYY';
    c_datetime_format     constant varchar2(50) := 'DD.MM.YYYY HH24:MI:SS';
    c_timestamp_format    constant varchar2(50) := 'DD.MM.YYYY HH24:MI:SS.FF';
    c_timestamp_tz_format constant varchar2(50) := 'DD.MM.YYYY HH24:MI:SS.FF TZH:TZM';
    c_timezone            constant varchar2(50) := '+10:00';

    -- General purpose statuses
    c_status_on   constant varchar2(5) := 'on';
    c_status_off  constant varchar2(5) := 'off';
    c_status_test constant varchar2(5) := 'test';
    c_status_eyed constant varchar2(5) := 'eyed';

    -- System name.
    c_sysname constant varchar2(50) := 
        lower(sys_context('USERENV', 'SERVER_HOST')||':'||sys_context('USERENV', 'DB_NAME'));
    -- Are we in a test environment?
    c_is_test constant boolean := regexp_like(c_sysname, 'test');

    -- at_file and at_out default configuration
    c_in_dir  constant varchar2(255) := 'IN_DIR';
    c_out_dir constant varchar2(255) := 'OUT_DIR';
    c_file_name_prefix varchar2(20) := case when c_is_test then 'test_' else '' end;
    c_charset constant varchar2(50)  := 'CL8MSWIN1251';
    c_nls_lang constant varchar2(50) := 'RUSSIAN_CIS.CL8MSWIN1251';
    c_lang    constant varchar2(50)  := 'RU';

    -- at_jour package default configuration
    c_jour_jr_prefix constant varchar2(5) := '';
    c_jour_jr_suffix constant varchar2(5) := '_JR';
    c_jour_jr_col_prefix constant varchar2(5) := 'JR_';
    c_jour_jr_owner constant varchar2(30) := user;
    c_jour_tab_owner constant varchar2(30) := user;

    -- at_ldap package default configuration
    c_ldap_host   constant varchar2(30) := '192.168.0.1';
    c_ldap_port   constant varchar2(30) := dbms_ldap.port;
    c_ldap_user   constant varchar2(30) := 'username';
    c_ldap_pswd   constant varchar2(30) := 'password';
    c_ldap_base   constant varchar2(4000) := 'OU=organization,DC=company,DC=com';
    
    -- at_smtp package default configuration
    c_smtp_server constant varchar2(30) := 'localhost';
    c_smtp_port   constant pls_integer  := 25;
    c_smtp_user   constant varchar2(50) := 'username';
    c_smtp_pswd   constant varchar2(50) := 'password';

    -- email configuration
    c_email_from  constant varchar2(255) := 'oradbms@company.com';
    c_email_test  constant varchar2(255) := 'developer@company.com';
    c_email_admin constant varchar2(255) := 'admin@company.com';
    c_email_subj_prefix varchar2(20) := '{' || c_sysname || '}';

    c_email_text_greeting constant varchar2(4000) := 
        'Dear user!' || crlf || crlf;
    c_email_text_signature constant varchar2(4000) :=
        crlf ||
        crlf ||
        'Best regards,' || crlf ||
        'Your Oracle DBMS' || crlf;

    c_email_html_greeting constant varchar2(4000) :=
'<p style="margin-bottom:20px;">
Dear user!
</p>';
    c_email_html_signature constant varchar2(4000) :=
'<p style="margin-top:20px;">
Best regards,<br />
Your Oracle DBMS
</p>';

    c_email_html_opening constant varchar2(4000) :=
'<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <style type="text/css">
        th {background:lightblue; padding: 1px 5px 1px 5px;}
        td {background:lightgrey; padding: 1px 5px 1px 5px; text-align: left;}
    </style>
</head>
<body>';
    c_email_html_closing constant varchar2(4000) :=
'</body>
</html>';

end at_env;
/
