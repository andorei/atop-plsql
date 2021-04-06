CREATE OR REPLACE PACKAGE at_smtp IS
/*******************************************************************************
    Send email with optional attachments.

    This package was created based on MAIL_PKG package by Alexander Nekrasov.

********************************************************************************
Copyright (C) 2013-2021 by Andrei Trofimov

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

    -- Set smtp server and port.
    procedure set_smtp_server(
        p_server varchar2 default 'localhost',
        p_port number default 25
    );

    -- Set user and password for smtp server.
    procedure set_smtp_auth(
        p_user varchar2 default null,
        p_pswd varchar2 default null
    );

    -- Reset the email being prepared.
    procedure reset;

    -- Attach content of at_type.lvarchars to the email being prepared.
    procedure attach(
        p_content   in at_type.lvarchars,
        p_file_name in varchar2,
        p_mime_type in varchar2 default 'text/plain',
        p_name      in varchar2 default null
    );

    -- Attach blob to the email being prepared.
    procedure attach(
        p_content   in blob,
        p_file_name in varchar2,
        p_mime_type in varchar2 default 'application/zip',
        p_name      in varchar2 default null
    );

    -- Attach external file to the email being prepared.
    procedure attach(
        p_dir       in varchar2,
        p_file_name in varchar2,
        p_mime_type in varchar2 default 'text/plain',
        p_name      in varchar2 default null
    );

    -- Send prepared message.
    procedure send(
        p_from     in varchar2,
        p_to       in varchar2,
        p_cc       in varchar2 default null,
        p_bcc      in varchar2 default null,
        p_subject  in varchar2,
        p_message  in at_type.lvarchars,
        p_mime_type in varchar2 default 'text/plain',
        p_priority in number default null,
        p_reply_to in varchar2 default null,
        p_return_path in varchar2 default null
    );

    procedure send(
        p_from     in varchar2,
        p_to       in varchar2,
        p_cc       in varchar2 default null,
        p_bcc      in varchar2 default null,
        p_subject  in varchar2,
        p_message  in clob,
        p_mime_type in varchar2 default 'text/plain',
        p_priority in number default null,
        p_reply_to in varchar2 default null,
        p_return_path in varchar2 default null
    );

end at_smtp;
/
create or replace package body at_smtp is

    c_crlf constant varchar2(2) := utl_tcp.crlf;

    g_smtp_server varchar2(30) := at_env.c_smtp_server;
    g_smtp_port   pls_integer  := at_env.c_smtp_port;
    g_smtp_user   varchar2(50) := at_env.c_smtp_user;
    g_smtp_pswd   varchar2(50) := at_env.c_smtp_pswd;

    type attached_file is record (
        dirname  varchar2(30),
        filename varchar2(255),
        name     varchar2(255),
        mimetype varchar2(30)
    );
    type attached_files_list is table of attached_file;
    g_attached_files attached_files_list;

    type attached_array is record (
        content at_type.lvarchars,
        filename varchar2(255),
        name     varchar2(255),
        mimetype varchar2(30)
    );
    type attached_arrays_list is table of attached_array;
    g_attached_arrays attached_arrays_list;

    type attached_blob is record (
        content  blob,
        filename varchar2(255),
        name     varchar2(255),
        mimetype varchar2(30)
    );
    type attached_blobs_list is table of attached_blob;
    g_attached_blobs attached_blobs_list;

    type rcpt_row is record (
        rcptname varchar2(100),
        rcptmail varchar2(400)
    );
    type rcpt_list is table of rcpt_row;

    procedure set_smtp_server(
        p_server varchar2 default 'localhost',
        p_port number default 25
    ) is
    begin
        g_smtp_server := p_server;
        g_smtp_port   := p_port;
    end set_smtp_server;

    procedure set_smtp_auth(
        p_user varchar2 default null,
        p_pswd varchar2 default null
    ) is
    begin
        g_smtp_user := p_user;
        g_smtp_pswd := p_pswd;
    end set_smtp_auth;

    function encode(
        p_data in varchar2,
        p_type in varchar2 default 'B'
    ) return varchar2
    is
    begin
        if p_type = 'B' then
            return
                '=?utf-8?b?' ||
                utl_raw.cast_to_varchar2(utl_encode.base64_encode(utl_raw.cast_to_raw(convert(substr(p_data, 1, 24), 'UTF8')))) ||
                '?=' ||
                case when substr(p_data, 25) is not null then c_crlf || ' ' || encode(substr(p_data, 25), p_type) end;
        elsif p_type = 'Q' then
            -- �����������32 ��, ���; ��� BASE64
            return
                '=?utf-8?q?' ||
                utl_raw.cast_to_varchar2(utl_encode.quoted_printable_encode(utl_raw.cast_to_raw(convert(substr(p_data, 1, 8), 'UTF8')))) ||
                '?=' ||
                case when substr(p_data, 9) is not null then c_crlf || ' ' || encode(substr(p_data, 9), p_type) end;
        else
            return p_data;
        end if;
    end encode;

    procedure reset is
    begin
        g_attached_files  := attached_files_list();
        g_attached_arrays := attached_arrays_list();
        g_attached_blobs  := attached_blobs_list();
    end reset;

    -- Attach external file to the email being prepared.
    procedure attach(
        p_dir       in varchar2,
        p_file_name in varchar2,
        p_mime_type in varchar2 default 'text/plain',
        p_name      in varchar2 default null
    ) is
        l_file bfile := bfilename(p_dir, p_file_name);
    begin
        if dbms_lob.fileexists(l_file) = 1 then
            g_attached_files.extend;
            g_attached_files(g_attached_files.count).dirname := p_dir;
            g_attached_files(g_attached_files.count).filename := p_file_name;
            g_attached_files(g_attached_files.count).name := nvl(p_name, p_file_name);
            g_attached_files(g_attached_files.count).mimetype := p_mime_type;
        else
            raise_application_error(-20001, 'File does not exist');
        end if;
    end attach;

    -- Attach content of at_type.lvarchars to the email being prepared.
    procedure attach(
        p_content   in at_type.lvarchars,
        p_file_name in varchar2,
        p_mime_type in varchar2 default 'text/plain',
        p_name      in varchar2 default null
    ) is
    begin
        g_attached_arrays.extend;
        g_attached_arrays(g_attached_arrays.count).content := p_content;
        g_attached_arrays(g_attached_arrays.count).filename := p_file_name;
        g_attached_arrays(g_attached_arrays.count).name := nvl(p_name, p_file_name);
        g_attached_arrays(g_attached_arrays.count).mimetype := p_mime_type;
    end attach;

    -- Attach blob to the email being prepared.
    procedure attach(
        p_content   in blob,
        p_file_name in varchar2,
        p_mime_type in varchar2 default 'application/zip',
        p_name      in varchar2 default null
    ) is
    begin
        g_attached_blobs.extend;
        g_attached_blobs(g_attached_blobs.count).content  := p_content;
        g_attached_blobs(g_attached_blobs.count).filename := p_file_name;
        g_attached_blobs(g_attached_blobs.count).name     := nvl(p_name, p_file_name);
        g_attached_blobs(g_attached_blobs.count).mimetype := p_mime_type;
    end attach;

    function create_rcpt_list(p_list in varchar2) return rcpt_list
    is
        l_list varchar2(4096) := replace(p_list, ';', ',') || ',';
        l_item varchar2(255);
        l_addr varchar2(255);
        l_pos    integer;
        l_result rcpt_list := rcpt_list();
    begin
        for maxrcptnts in 1 .. 50 loop
            l_pos := instr(l_list, ',');
            l_item  := substr(l_list, 1, l_pos - 1);
            if l_pos > 0 then
                if instr(l_item, '<') > 0 and instr(l_item, '>') > 0 then
                    l_addr := substr(l_item, instr(l_item, '<') + 1, instr(substr(l_item, instr(l_item, '<') + 1), '>') - 1);
                    if l_addr is not null then
                        l_result.extend;
                        l_result(l_result.count).rcptmail := trim(l_addr);
                        l_result(l_result.count).rcptname := trim(substr(l_item, 1, instr(l_item, '<') - 1));
                    end if;
                else
                    l_addr := trim(l_item);
                    if l_addr is not null then
                        l_result.extend;
                        l_result(l_result.count).rcptmail := trim(l_addr);
                    end if;
                end if;
            else
                exit;
            end if;
            l_list := substr(l_list, l_pos + 1);
        end loop;
        return l_result;
    end create_rcpt_list;

    procedure send(
        p_from     in varchar2,
        p_to       in varchar2,
        p_cc       in varchar2 default null,
        p_bcc      in varchar2 default null,
        p_subject  in varchar2,
        p_message  in at_type.lvarchars,
        p_mime_type in varchar2 default 'text/plain',
        p_priority in number default null,
        p_reply_to in varchar2 default null,
        p_return_path in varchar2 default null
    ) is
    begin
        send(p_from      => p_from,
             p_to        => p_to,
             p_cc        => p_cc,
             p_bcc       => p_bcc,
             p_subject   => p_subject,
             p_message   => at_type.lvarchars_to_clob(p_message),
             p_mime_type => p_mime_type,
             p_priority  => p_priority,
             p_reply_to  => p_reply_to,
             p_return_path => p_return_path
        );
    end send;

    procedure send(
        p_from     in varchar2,
        p_to       in varchar2,
        p_cc       in varchar2 default null,
        p_bcc      in varchar2 default null,
        p_subject  in varchar2,
        p_message  in clob,
        p_mime_type in varchar2 default 'text/plain',
        p_priority in number default null,
        p_reply_to in varchar2 default null,
        p_return_path in varchar2 default null
    ) is
        c_boundary constant varchar2(50) := '-----7D81B75CCC90DFRW4F7A1CBD';
        -- 48 bytes binary convert to 128 bytes of base64
        c_amount constant binary_integer := 48;

        l_conn     utl_smtp.connection;
        l_file     bfile;
        l_raw      raw(32767);
        l_amt      binary_integer;
        l_pos      binary_integer := 1;
        l_mime     varchar2(30);
        l_replies  utl_smtp.replies;

        l_to_list  rcpt_list;
        l_cc_list  rcpt_list;
        l_bcc_list rcpt_list;
        l_from     rcpt_row;
        l_return_path rcpt_row;
        l_reply_to rcpt_row;

        procedure write_recipients(
            p_conn in out utl_smtp.connection,
            p_toccbcc in varchar2, -- 'To: ' or 'Cc: ' or 'Bcc: '
            p_list in rcpt_list
        ) is
        begin
            utl_smtp.write_data(p_conn, p_toccbcc);
            for i in 1 .. p_list.count loop
                if i > 1 then
                    utl_smtp.write_data(p_conn, ',');
                end if;
                if p_list(i).rcptname is not null then
                    utl_smtp.write_data(
                        p_conn,
                        encode(p_list(i).rcptname) || ' <' || p_list(i).rcptmail || '>');
                else
                    utl_smtp.write_data(p_conn, p_list(i).rcptmail);
                end if;
            end loop;
            utl_smtp.write_data(p_conn, c_crlf);
        end write_recipients;

        procedure write_attachment_header(
            p_conn in out utl_smtp.connection,
            p_mime_type varchar2,
            p_name varchar2
        ) is
        begin
            utl_smtp.write_data(p_conn, '--' || c_boundary || c_crlf);
            utl_smtp.write_data(p_conn, 'Content-Type: ' || p_mime_type || ';' || c_crlf);
            utl_smtp.write_data(p_conn, ' name="' || encode(p_name) || '"' || c_crlf);
            utl_smtp.write_data(p_conn, 'Content-Transfer-Encoding: base64' || c_crlf);
            utl_smtp.write_data(p_conn, 'Content-Disposition: attachment;' || c_crlf);
            utl_smtp.write_data(p_conn, ' filename="' || encode(p_name) || '"' || c_crlf);
            utl_smtp.write_data(p_conn, c_crlf);
        END write_attachment_header;

    begin
        at_exc.assert(p_mime_type in ('text/html', 'text/plain'), 'Mime type must be "text/html" or "text/plain".');
        l_mime := p_mime_type;

        l_to_list := create_rcpt_list(p_to);
        at_exc.assert(l_to_list.count > 0, 'Recipients required.');
        l_cc_list := create_rcpt_list(p_cc);
        l_bcc_list := create_rcpt_list(p_bcc);

        l_conn := utl_smtp.open_connection(g_smtp_server, g_smtp_port);
        l_replies := utl_smtp.ehlo(l_conn, g_smtp_server);

        if g_smtp_user is not null then
            for x in 1 .. l_replies.count loop
                dbms_output.put_line(l_replies(x).text);
                if instr(l_replies(x).text, 'AUTH') > 0 then
                    utl_smtp.command(l_conn, 'AUTH LOGIN');
                    utl_smtp.command(
                        l_conn,
                        utl_raw.cast_to_varchar2(utl_encode.base64_encode(utl_raw.cast_to_raw(g_smtp_user)))
                    );
                    utl_smtp.command(
                        l_conn,
                        utl_raw.cast_to_varchar2(utl_encode.base64_encode(utl_raw.cast_to_raw(g_smtp_pswd)))
                    );
                    exit;
                end if;
            end loop;
        end if;

        l_from := create_rcpt_list(p_from)(1);
        if p_return_path is not null then
            l_return_path := create_rcpt_list(p_return_path)(1);
            utl_smtp.mail(l_conn, l_return_path.rcptmail);
        else
            utl_smtp.mail(l_conn, l_from.rcptmail);
        end if;

        -- set addressees
        for i in 1 .. l_to_list.count loop
            utl_smtp.rcpt(l_conn, l_to_list(i).rcptmail);
        end loop;
        for i in 1 .. l_cc_list.count loop
            utl_smtp.rcpt(l_conn, l_cc_list(i).rcptmail);
        end loop;
        for i in 1 .. l_bcc_list.count loop
            utl_smtp.rcpt(l_conn, l_bcc_list(i).rcptmail);
        end loop;

        utl_smtp.open_data(l_conn);

        -- write headers
        utl_smtp.write_data(l_conn, 'Date: ' || to_char(sys_extract_utc(systimestamp), 'Dy, DD Mon YYYY hh24:mi:ss', 'NLS_DATE_LANGUAGE = ''american''') || c_crlf);
        utl_smtp.write_data(l_conn, 'From: ');
        if l_from.rcptname is not null then
            utl_smtp.write_data(l_conn, encode(l_from.rcptname) || ' <' || l_from.rcptmail || '>');
        else
            utl_smtp.write_data(l_conn, l_from.rcptmail);
        end if;
        utl_smtp.write_data(l_conn, c_crlf);
        if p_reply_to is not null then
            l_reply_to := create_rcpt_list(p_reply_to)(1);
            utl_smtp.write_data(l_conn, 'Reply-To: ');
            if l_reply_to.rcptname is not null then
                utl_smtp.write_data(l_conn, encode(l_reply_to.rcptname) || ' <' || l_reply_to.rcptmail || '>');
            else
                utl_smtp.write_data(l_conn, l_reply_to.rcptmail);
            end if;
            utl_smtp.write_data(l_conn, c_crlf);
        end if;
        utl_smtp.write_data(l_conn, 'Subject: ' || encode(p_subject) || c_crlf);
        write_recipients(l_conn, 'To: ', l_to_list);
        write_recipients(l_conn, 'Cc: ', l_cc_list);
        if p_priority is not null and p_priority between 1 and 5 then
            utl_smtp.write_data(l_conn, 'X-Priority: ' || p_priority || c_crlf);
        end if;
        utl_smtp.write_data(l_conn, 'MIME-version: 1.0' || c_crlf);
        utl_smtp.write_data(l_conn, 'Content-Type: multipart/mixed;' || c_crlf);
        utl_smtp.write_data(l_conn, ' boundary="' || c_boundary || '"' || c_crlf);
        utl_smtp.write_data(l_conn, c_crlf);

        utl_smtp.write_data(l_conn, '--' || c_boundary || c_crlf);
        utl_smtp.write_data(l_conn, 'Content-Type: ' || l_mime || '; charset=utf-8' || c_crlf);
        utl_smtp.write_data(l_conn, 'Content-Transfer-Encoding: base64' || c_crlf);
        utl_smtp.write_data(l_conn, c_crlf);

        -- write message body
        declare
            l_message blob;
            l_dest_offset number := 1;
            l_src_offset number  := 1;
            l_lang_ctx number := 0; -- the default
            l_warning number;
        begin
            -- make it UTF8 and convert to blob
            dbms_lob.createtemporary(l_message, true);
            dbms_lob.converttoblob(
                dest_lob    => l_message,
                src_clob    => convert(p_message, 'UTF8'),
                amount      => dbms_lob.lobmaxsize,
                dest_offset => l_dest_offset,
                src_offset  => l_src_offset,
                blob_csid   => 0,
                lang_context => l_lang_ctx,
                warning     => l_warning
            );
            -- make it base64
            l_pos := 1;
            l_amt := c_amount;
            loop
                begin
                    dbms_lob.read(l_message, l_amt, l_pos, l_raw);
                    l_pos := l_pos + l_amt;
                    utl_smtp.write_raw_data(l_conn, utl_encode.base64_encode(l_raw));
                exception
                when no_data_found then
                    exit;
                end;
            end loop;
            utl_smtp.write_data(l_conn, c_crlf || c_crlf);
        end;

        -- write attachments

        -- Convert at_type.lvarchars attachments to blob attachments.
        if g_attached_arrays is not null then
            for i in 1 .. g_attached_arrays.count loop
                attach(
                    at_type.lvarchars_to_blob(g_attached_arrays(i).content),
                    g_attached_arrays(i).filename,
                    g_attached_arrays(i).mimetype,
                    g_attached_arrays(i).name
                );
            end loop;
        end if;

        -- external file attachments
        if g_attached_files is not null then
            for i in 1 .. g_attached_files.count loop
                l_file := bfilename(g_attached_files(i).dirname, g_attached_files(i).filename);
                dbms_lob.fileopen(l_file, dbms_lob.file_readonly);

                write_attachment_header(l_conn, g_attached_files(i).mimetype, g_attached_files(i).name);
                -- make it base64
                l_pos := 1;
                l_amt := c_amount;
                loop
                    begin
                        dbms_lob.read(l_file, l_amt, l_pos, l_raw);
                        l_pos := l_pos + l_amt;
                        utl_smtp.write_raw_data(l_conn, utl_encode.base64_encode(l_raw));
                    exception
                    when no_data_found then
                        exit;
                    end;
                end loop;
                utl_smtp.write_data(l_conn, c_crlf || c_crlf);

                dbms_lob.fileclose(l_file);
            end loop;
        end if;

        -- blob attachments
        if g_attached_blobs is not null then
            for i in 1 .. g_attached_blobs.count loop

                write_attachment_header(l_conn, g_attached_blobs(i).mimetype, g_attached_blobs(i).name);
                -- make it base64
                l_pos := 1;
                l_amt := c_amount;
                loop
                    begin
                        dbms_lob.read(g_attached_blobs(i).content, l_amt, l_pos, l_raw);
                        l_pos := l_pos + l_amt;
                        utl_smtp.write_raw_data(l_conn, utl_encode.base64_encode(l_raw));
                    exception
                    when no_data_found then
                        exit;
                    end;
                end loop;
                utl_smtp.write_data(l_conn, c_crlf || c_crlf);

            end loop;
        end if;

        -- final boundary
        utl_smtp.write_data(l_conn, '--' || c_boundary || '--');

        utl_smtp.close_data(l_conn);
        utl_smtp.quit(l_conn);

        -- clear attachments
        reset;
    exception
        when others then
            begin
                reset;
                utl_smtp.rset(l_conn);
                utl_smtp.quit(l_conn);
            exception
                when others then
                    null;
            end;
            raise;
    end send;

begin
    reset;
end at_smtp;
/
