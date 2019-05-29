create or replace package at_mail is
/*******************************************************************************
    Send email with optional attachments.

Changelog
    2016-02-09 Andrei Trofimov create package
    2017-04-09 Andrei Trofimov add procedures with p_owner

********************************************************************************
Copyright (C) 2016-2018 by Andrei Trofimov

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

    -- Send email message p_message in html format
    -- with prepended p_greeting and appended p_signature.
    procedure send_html(
        p_to varchar2,
        p_subject varchar2,
        p_message in out nocopy at_type.lvarchars,
        p_cc varchar2 default null,
        p_bcc varchar2 default null,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    );

    -- Send email message p_message in html format
    -- with prepended p_greeting and appended p_signature.
    -- Get addressees with at_conf.get_email(p_owner, ...).
    procedure send_html(
        p_owner varchar2,
        p_subject varchar2,
        p_message in out nocopy at_type.lvarchars,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    );

    -- Send email message p_message in html format
    -- with prepended p_greeting and appended p_signature.
    procedure send_html(
        p_to varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_cc varchar2 default null,
        p_bcc varchar2 default null,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    );

    -- Send email message p_message in html format
    -- with prepended p_greeting and appended p_signature.
    -- Get addressees with at_conf.get_email(p_owner, ...).
    procedure send_html(
        p_owner varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    );

    -- Send email message p_message in plain text
    -- with prepended p_greeting and appended p_signature.
    procedure send_text(
        p_to varchar2,
        p_subject varchar2,
        p_message in out nocopy at_type.lvarchars,
        p_cc varchar2 default null,
        p_bcc varchar2 default null,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    );

    -- Send email message p_message in plain text
    -- with prepended p_greeting and appended p_signature.
    -- Get addressees with at_conf.get_email(p_owner, ...).
    procedure send_text(
        p_owner varchar2,
        p_subject varchar2,
        p_message in out nocopy at_type.lvarchars,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    );

    -- Send email message p_message in plain text
    -- with prepended p_greeting and appended p_signature.
    procedure send_text(
        p_to varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_cc varchar2 default null,
        p_bcc varchar2 default null,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    );

    -- Send email message p_message in plain text
    -- with prepended p_greeting and appended p_signature.
    -- Get addressees with at_conf.get_email(p_owner, ...).
    procedure send_text(
        p_owner varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    );

    -- Send email message p_message in html format
    -- with prepended p_greeting and appended p_signature
    -- and with data returned by p_cursor formatted as html table.
    procedure send_html_table(
        p_to varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_cc varchar2 default null,
        p_bcc varchar2 default null,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    );

    -- Send email message p_message in html format
    -- with prepended p_greeting and appended p_signature
    -- and with data returned by p_cursor formatted as html table.
    -- Get addressees with at_conf.get_email(p_owner, ...).
    procedure send_html_table(
        p_owner varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    );

    -- Send email message p_message in html format
    -- with prepended p_greeting and appended p_signature
    -- and with data returned by p_cursor attached as csv file.
    procedure send_html_file(
        p_to varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_filename varchar2,
        p_compress pls_integer default 0,
        p_cc varchar2 default null,
        p_bcc varchar2 default null,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    );

    -- Send email message p_message in html format
    -- with prepended p_greeting and appended p_signature
    -- and with data returned by p_cursor attached as csv file.
    -- Get addressees with at_conf.get_email(p_owner, ...).
    procedure send_html_file(
        p_owner varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_filename varchar2,
        p_compress pls_integer default 0,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    );

end at_mail;
/
create or replace package body at_mail is

    procedure send_html(
        p_to varchar2,
        p_subject varchar2,
        p_message in out nocopy at_type.lvarchars,
        p_cc varchar2 default null,
        p_bcc varchar2 default null,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    )
    is
        NL varchar2(10) := '<br />';
    begin
        p_message(0) :=
            at_env.c_email_html_opening ||
            nvl(p_greeting, at_env.c_email_html_greeting) ||
            case p_status
                when at_env.c_status_test then
                    '>>>' || NL ||
                    'To: ' || at_out.safe_html(p_to) || NL ||
                    'Cc: ' || at_out.safe_html(p_cc) || NL ||
                    'Bcc: ' || at_out.safe_html(p_bcc) || NL ||
                    '>>>' || NL
                else
                    ''
            end ||
            case
                when p_message.exists(0) then
                    p_message(0)
                else
                    ''
            end
        ;
        p_message(p_message.count) :=
            nvl(p_signature, at_env.c_email_html_signature) ||
            at_env.c_email_html_closing
        ;
        at_smtp.send(
            p_from => p_from,
            p_to   => case p_status when at_env.c_status_test then at_env.c_email_test else p_to end,
            p_cc   => case p_status when at_env.c_status_test then '' else p_cc end,
            p_bcc  => case p_status when at_env.c_status_test then '' else p_bcc end,
            p_subject  => at_env.c_email_subj_prefix || ' ' || p_subject,
            p_message  => p_message,
            p_mime_type => 'text/html',
            p_priority => p_priority
        );
    end send_html;

    procedure send_html(
        p_owner varchar2,
        p_subject varchar2,
        p_message in out nocopy at_type.lvarchars,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    )
    is
        l_to varchar2(4000);
        l_cc varchar2(4000);
        l_bcc varchar2(4000);
    begin
        at_conf.get_email(p_owner, l_to, l_cc, l_bcc);
        send_html(l_to, p_subject, p_message, l_cc, l_bcc, p_status, p_priority, p_from, p_greeting, p_signature);
    end send_html;

    procedure send_html(
        p_to varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_cc varchar2 default null,
        p_bcc varchar2 default null,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    )
    is
        l_message at_type.lvarchars;
    BEGIN
        l_message(1) := p_message;
        send_html(p_to, p_subject, l_message, p_cc, p_bcc, p_status, p_priority, p_from, p_greeting, p_signature);
    end send_html;

    procedure send_html(
        p_owner varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    )
    is
        l_to varchar2(4000);
        l_cc varchar2(4000);
        l_bcc varchar2(4000);
    begin
        at_conf.get_email(p_owner, l_to, l_cc, l_bcc);
        send_html(l_to, p_subject, p_message, l_cc, l_bcc, p_status, p_priority, p_from, p_greeting, p_signature);
    end send_html;

    procedure send_text(
        p_to varchar2,
        p_subject varchar2,
        p_message in out nocopy at_type.lvarchars,
        p_cc varchar2 default null,
        p_bcc varchar2 default null,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    )
    is
        NL varchar2(10) := utl_tcp.CRLF;
    begin
        p_message(0) :=
            nvl(p_greeting, at_env.c_email_text_greeting) ||
            case p_status
                when at_env.c_status_test then
                    '>>>' || NL ||
                    'To: ' || p_to || NL ||
                    'Cc: ' || p_cc || NL ||
                    'Bcc: ' || p_bcc || NL ||
                    '>>>' || NL || NL
                else
                    ''
            end ||
            case
                when p_message.exists(0) then
                    p_message(0)
                else
                    ''
            end
        ;
        p_message(p_message.count) := nvl(p_signature, at_env.c_email_text_signature);

        at_smtp.send(
            p_from => p_from,
            p_to   => case p_status when at_env.c_status_test then at_env.c_email_test else p_to end,
            p_cc   => case p_status when at_env.c_status_test then '' else p_cc end,
            p_bcc  => case p_status when at_env.c_status_test then '' else p_bcc end,
            p_subject  => at_env.c_email_subj_prefix || ' ' || p_subject,
            p_message  => p_message,
            p_mime_type => 'text/plain',
            p_priority => p_priority
        );
    end send_text;

    procedure send_text(
        p_owner varchar2,
        p_subject varchar2,
        p_message in out nocopy at_type.lvarchars,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    )
    is
        l_to varchar2(4000);
        l_cc varchar2(4000);
        l_bcc varchar2(4000);
    begin
        at_conf.get_email(p_owner, l_to, l_cc, l_bcc);
        send_text(l_to, p_subject, p_message, l_cc, l_bcc, p_status, p_priority, p_from, p_greeting, p_signature);
    end send_text;

    procedure send_text(
        p_to varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_cc varchar2 default null,
        p_bcc varchar2 default null,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    )
    is
        l_message at_type.lvarchars;
    BEGIN
        l_message(1) := p_message;
        send_text(p_to, p_subject, l_message, p_cc, p_bcc, p_status, p_priority, p_from, p_greeting, p_signature);
    end send_text;

    procedure send_text(
        p_owner varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    )
    is
        l_to varchar2(4000);
        l_cc varchar2(4000);
        l_bcc varchar2(4000);
    begin
        at_conf.get_email(p_owner, l_to, l_cc, l_bcc);
        send_text(l_to, p_subject, p_message, l_cc, l_bcc, p_status, p_priority, p_from, p_greeting, p_signature);
    end send_text;

    procedure send_html_table(
        p_to varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_cc varchar2 default null,
        p_bcc varchar2 default null,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    )
    is
        l_data at_type.lvarchars;
    begin
        at_out.put_html_to_array(
            p_cursor   => p_cursor,
            p_colnames => send_html_table.p_colnames,
            o_array    => l_data
        );

        if l_data.count > 0 then
            l_data(0) := regexp_replace(p_message, '\{\{\s*rowcount\s*\}\}', l_data.count-2/*omit 1st and last lines*/);
            send_html(
                p_to    => p_to,
                p_cc    => p_cc,
                p_bcc   => p_bcc,
                p_subject   => p_subject,
                p_message   => l_data,
                p_status    => p_status,
                p_priority  => p_priority,
                p_from  => p_from,
                p_greeting  => p_greeting,
                p_signature => p_signature
            );
        end if;
    end send_html_table;

    procedure send_html_table(
        p_owner varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    )
    is
        l_to varchar2(4000);
        l_cc varchar2(4000);
        l_bcc varchar2(4000);
    begin
        at_conf.get_email(p_owner, l_to, l_cc, l_bcc);
        send_html_table(
            p_to => l_to,
            p_cc => l_cc,
            p_bcc => l_bcc,
            p_subject => p_subject,
            p_message => p_message,
            p_cursor => p_cursor,
            p_colnames => p_colnames,
            p_status => p_status,
            p_priority => p_priority,
            p_from => p_from,
            p_greeting => p_greeting,
            p_signature => p_signature
        );
    end send_html_table;

    procedure send_html_file(
        p_to varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_filename varchar2,
        p_compress pls_integer default 0,
        p_cc varchar2 default null,
        p_bcc varchar2 default null,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    )
    is
        l_data at_type.lvarchars;
        l_message at_type.lvarchars;
    begin
        at_out.put_csv_to_array(
            p_cursor   => send_html_file.p_cursor,
            p_colnames => send_html_file.p_colnames,
            o_array    => l_data,
            p_nls_lang => at_env.c_nls_lang
        );

        if l_data.count > 0 then
            at_smtp.reset;
            if p_compress = 1 then
                at_smtp.attach(at_util.zipped(l_data, p_filename), p_filename||'.zip', 'application/zip');
            else
                at_smtp.attach(l_data, p_filename, 'text/csv');
            end if;

            l_message(1) := regexp_replace(p_message, '\{\{\s*rowcount\s*\}\}', l_data.count-1/*1st line is column titles*/);
            send_html(
                p_to    => p_to,
                p_cc    => p_cc,
                p_bcc   => p_bcc,
                p_subject   => p_subject,
                p_message   => l_message,
                p_status    => p_status,
                p_priority  => p_priority,
                p_from  => p_from,
                p_greeting  => p_greeting,
                p_signature => p_signature
            );
        end if;
    end send_html_file;

    procedure send_html_file(
        p_owner varchar2,
        p_subject varchar2,
        p_message varchar2,
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_filename varchar2,
        p_compress pls_integer default 0,
        p_status varchar2 default at_env.c_status_on,
        p_priority pls_integer default 3, /*3 - normal, 2 - high, 1 - highest*/
        p_from varchar2 default at_env.c_email_from,
        p_greeting varchar2 default null,
        p_signature varchar2 default null
    )
    is
        l_to varchar2(4000);
        l_cc varchar2(4000);
        l_bcc varchar2(4000);
    begin
        at_conf.get_email(p_owner, l_to, l_cc, l_bcc);
        send_html_file(
            p_to => l_to,
            p_cc => l_cc,
            p_bcc => l_bcc,
            p_subject => p_subject,
            p_message => p_message,
            p_cursor => p_cursor,
            p_colnames => p_colnames,
            p_filename => p_filename,
            p_compress => p_compress,
            p_status => p_status,
            p_priority => p_priority,
            p_from => p_from,
            p_greeting => p_greeting,
            p_signature => p_signature
        );
    end send_html_file;

end at_mail;
/
