create or replace package at_file is
/*******************************************************************************
    File operations using UTL_FILE, DBMS_BLOB, etc.

Changelog
    2016-09-05 Andrei Trofimov create package
    2018-08-03 Andrei Trofimov add file_to_blob, clob_to_file, blob_to_file.

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

    -- File opertaions using UTL_FILE.
    function out_file(
        p_file_name in varchar2,
        p_dir in varchar2 default at_env.c_out_dir,
        p_buff_size in binary_integer default 32767)
    return utl_file.file_type;

    function in_file(
        p_file_name in varchar2,
        p_dir in varchar2 default at_env.c_in_dir,
        p_buff_size in binary_integer := 32767)
    return utl_file.file_type;

    procedure write(
        p_file in utl_file.file_type,
        p_text in varchar2,
        p_lang in varchar2 default at_env.c_nls_lang
    );

    procedure read(
        p_file in utl_file.file_type,
        o_text out varchar2,
        p_lang in varchar2 default at_env.c_nls_lang
    );

    procedure close(p_file in out utl_file.file_type);

    procedure rename(
        p_src_file_name in varchar2,
        p_dest_file_name in varchar2,
        p_src_dir in varchar2 default at_env.c_out_dir,
        p_dest_dir in varchar2 default at_env.c_out_dir
    );

    -- Return CLOB loaded from specified file.
    -- When no longer needed remember to free the CLOB with dbms_lob.freetemporary(l_clob).
    function file_to_clob(
        p_file_name varchar2,
        p_dir varchar2 default at_env.c_in_dir,
        p_charset varchar2 default at_env.c_charset
    ) return clob;

    -- Return CLOB loaded from specified file.
    -- When no longer needed remember to free the CLOB with dbms_lob.freetemporary(l_blob).
    function file_to_blob(
        p_file_name varchar2,
        p_dir varchar2 default at_env.c_in_dir
    ) return blob;

    -- Write clob to file.
    procedure clob_to_file(
        p_clob in clob,
        p_file_name varchar2,
        p_dir varchar2 default at_env.c_out_dir
    );
            
    -- Write blob to file.
    procedure blob_to_file(
        p_blob in blob,
        p_file_name varchar2,
        p_dir varchar2 default at_env.c_out_dir
    );

    -- Write at_type.varchars to file.
    procedure varchars_to_file(
        p_content in at_type.varchars,
        p_file_name varchar2,
        p_dir varchar2 default at_env.c_out_dir,
        p_lang in varchar2 default at_env.c_nls_lang
    );

    -- Write at_type.lvarchars to file.
    procedure lvarchars_to_file(
        p_content in at_type.lvarchars,
        p_file_name varchar2,
        p_dir varchar2 default at_env.c_out_dir,
        p_lang in varchar2 default at_env.c_nls_lang
    );

    -- Get table from the csv-file clob.
    -- select * from table(at_file.csv_table(<clob>));
    function csv_table(
        p_clob clob,
        p_delim varchar2 default ';',
        p_optionally_enclosed varchar2 default '"'
    ) return at_table pipelined;

    -- Get table from the blob.
    -- select * from table(at_file.csv_table(<blob>));
    function csv_table(
        p_blob blob,
        p_delim varchar2 default ';',
        p_optionally_enclosed varchar2 default '"',
        p_charset varchar2 default at_env.c_charset
    ) return at_table pipelined;

    -- Get table from the specified csv-file.
    -- select * from table(at_file.csv_table('datafile.csv'));
    function csv_table(
        p_file_name varchar2,
        p_delim varchar2 default ';',
        p_optionally_enclosed varchar2 default '"',
        p_dir varchar2 default at_env.c_in_dir,
        p_charset varchar2 default at_env.c_charset
    ) return at_table pipelined;

    -- Load csv data into at_file_ table and return
    --    o_load_id  - id of inserted data
    --    o_rowcount - number of inserted rows
    -- Get loaded data with query
    --    select data from at_file_ where id = <o_load_id> order by line;
    procedure load_csv(
        p_clob clob,
        p_delim varchar2 default ';',
        p_optionally_enclosed varchar2 default '"',
        p_com1 at_file_.com1%type default null,
        p_com2 at_file_.com2%type default null,
        o_load_id out at_file_.id%type,
        o_rowcount out pls_integer
    );

    procedure load_csv(
        p_blob blob,
        p_delim varchar2 default ';',
        p_optionally_enclosed varchar2 default '"',
        p_charset varchar2 default at_env.c_charset,
        p_com1 at_file_.com1%type default null,
        p_com2 at_file_.com2%type default null,
        o_load_id out at_file_.id%type,
        o_rowcount out pls_integer
    );

    procedure load_csv(
        p_file_name varchar2,
        p_delim varchar2 default ';',
        p_optionally_enclosed varchar2 default '"',
        p_dir varchar2 default at_env.c_in_dir,
        p_charset varchar2 default at_env.c_charset,
        p_com1 at_file_.com1%type default null,
        p_com2 at_file_.com2%type default null,
        o_load_id out at_file_.id%type,
        o_rowcount out pls_integer
    );
end at_file;
/
create or replace package body at_file is

    -- Max number of cols is number of attributes c1,..c100 of at_row type
    c_columns_limit constant pls_integer := 100;

    -- File opertaions using UTL_FILE.
    function out_file(
        p_file_name in varchar2,
        p_dir in varchar2 default at_env.c_out_dir,
        p_buff_size in binary_integer default 32767)
    return utl_file.file_type
    is
    begin
        return utl_file.fopen(p_dir, p_file_name, 'w', p_buff_size);
    end out_file;

    function in_file(
        p_file_name in varchar2,
        p_dir in varchar2 default at_env.c_in_dir,
        p_buff_size in binary_integer default 32767)
    return utl_file.file_type
    is
    begin
        return utl_file.fopen(p_dir, p_file_name, 'r', p_buff_size);
    end in_file;

    procedure write(
        p_file in utl_file.file_type,
        p_text in varchar2,
        p_lang in varchar2 default at_env.c_nls_lang
    ) is
    begin
        utl_file.put_line(p_file, utl_raw.cast_to_varchar2(utl_raw.convert(utl_raw.cast_to_raw(p_text), p_lang, userenv('language'))), true);
    end write;

    procedure read(
        p_file in utl_file.file_type,
        o_text out varchar2,
        p_lang in varchar2 default at_env.c_nls_lang
    ) is
    begin
        utl_file.get_line(p_file, o_text);
        o_text := utl_raw.cast_to_varchar2(utl_raw.convert(utl_raw.cast_to_raw(o_text), userenv('language'), p_lang));
    exception
        when no_data_found then
            o_text := null;
    end read;

    procedure close(p_file in out utl_file.file_type)
    is
    begin
        if utl_file.is_open(p_file) then
           utl_file.fclose(p_file);
        end if;
    end close;

    procedure rename(
        p_src_file_name in varchar2,
        p_dest_file_name in varchar2,
        p_src_dir in varchar2 default at_env.c_out_dir,
        p_dest_dir in varchar2 default at_env.c_out_dir
    ) is
    begin
        utl_file.frename(
            src_location => p_src_dir,
            src_filename => p_src_file_name,
            dest_location => p_dest_dir,
            dest_filename => p_dest_file_name,
            overwrite => true
        );
    end rename;

    -- Return CLOB loaded from specified file.
    -- When no longer needed remember to free the CLOB with dbms_lob.freetemporary(l_clob).
    function file_to_clob(
        p_file_name varchar2,
        p_dir varchar2 default at_env.c_in_dir,
        p_charset varchar2 default at_env.c_charset
    ) return clob
    is
        l_clob clob;
        l_bfile bfile;
        l_dest_offset number;
        l_src_offset number;
        l_lang_ctx number := dbms_lob.default_lang_ctx;
        l_warning number;
    begin
        l_bfile := bfilename(p_dir, p_file_name);

        dbms_lob.createtemporary(l_clob, true);
        l_dest_offset := 1; -- from the begining
        l_src_offset := 1;  -- from the begining

        dbms_lob.fileopen(l_bfile);
        dbms_lob.loadclobfromfile(
            dest_lob    => l_clob,
            src_bfile   => l_bfile,
            amount      => dbms_lob.lobmaxsize,
            dest_offset => l_dest_offset,
            src_offset  => l_src_offset,
            -- database csid by default or nls_charset_id('AL32UTF8')
            -- bfile_csid  => dbms_lob.default_csid,
            bfile_csid  => nls_charset_id(p_charset),
            lang_context => l_lang_ctx,
            warning     => l_warning
        );
        dbms_lob.fileclose(l_bfile);

        if l_warning != 0 then
            raise_application_error(
                at_exc.c_general_error_code,
                'Error loading file to clob: '||l_warning
            );
        end if;
        return l_clob;
        --should be freed after using dbms_lob.freetemporary(l_clob);
    end file_to_clob;

    -- Return BLOB loaded from specified file.
    -- When no longer needed remember to free the CLOB with dbms_lob.freetemporary(l_blob).
    function file_to_blob(
        p_file_name varchar2,
        p_dir varchar2 default at_env.c_in_dir
    ) return blob
    is
        l_blob blob;
        l_bfile bfile;
        l_dest_offset number;
        l_src_offset number;
    begin
        l_bfile := bfilename(p_dir, p_file_name);

        dbms_lob.createtemporary(l_blob, true);
        l_dest_offset := 1; -- from the begining
        l_src_offset := 1;  -- from the begining

        dbms_lob.fileopen(l_bfile);
        dbms_lob.loadblobfromfile(
            dest_lob    => l_blob,
            src_bfile   => l_bfile,
            amount      => dbms_lob.lobmaxsize,
            dest_offset => l_dest_offset,
            src_offset  => l_src_offset
        );
        dbms_lob.fileclose(l_bfile);

        return l_blob;
        --should be freed after using dbms_lob.freetemporary(l_clob);
    end file_to_blob;

    -- Write clob to file.
    procedure clob_to_file(
        p_clob in clob,
        p_file_name varchar2,
        p_dir varchar2 default at_env.c_out_dir
    ) is
        l_clob_len pls_integer;
        l_file     utl_file.file_type;
        l_buffer   varchar2(32767);
        l_amount   pls_integer;
        l_pos      binary_integer := 1;
    begin
        l_clob_len := dbms_lob.getlength(p_clob);
        l_amount := least(dbms_lob.getchunksize(p_clob), floor(32767 / 4) /*utf-8*/);

        l_file := utl_file.fopen(p_dir, p_file_name, 'wb', 32767);

        while l_pos < l_clob_len loop
            dbms_lob.read(p_clob, l_amount, l_pos, l_buffer);
            utl_file.put_raw(l_file, utl_raw.cast_to_raw(l_buffer), true);
            l_pos := l_pos + l_amount;
        end loop;

        utl_file.fclose(l_file);
    exception
        when others then
            if utl_file.is_open(l_file) then
                utl_file.fclose(l_file);
            end if;
            raise;
    end clob_to_file;
            
    -- Write blob to file.
    procedure blob_to_file(
        p_blob in blob,
        p_file_name varchar2,
        p_dir varchar2 default at_env.c_out_dir
    ) is
        l_blob_len pls_integer;
        l_file     utl_file.file_type;
        l_buffer   raw(32767);
        l_amount   pls_integer := 32767;
        l_pos      binary_integer := 1;
    begin
        l_blob_len := dbms_lob.getlength(p_blob);
        l_file := utl_file.fopen(p_dir, p_file_name, 'wb', 32767);

        while l_pos < l_blob_len loop
            dbms_lob.read(p_blob, l_amount, l_pos, l_buffer);
            utl_file.put_raw(l_file, l_buffer, true);
            l_pos := l_pos + l_amount;
        end loop;

        utl_file.fclose(l_file);
    exception
        when others then
            if utl_file.is_open(l_file) then
                utl_file.fclose(l_file);
            end if;
            raise;
    end blob_to_file;

    -- Write at_type.varchars to file.
    procedure varchars_to_file(
        p_content in at_type.varchars,
        p_file_name varchar2,
        p_dir varchar2 default at_env.c_out_dir,
        p_lang in varchar2 default at_env.c_nls_lang
    ) is
        i pls_integer;
        l_file utl_file.file_type;
    begin
        l_file := out_file(p_file_name, p_dir);
        if p_content.count > 0 then
            i := p_content.first;
            while i is not null loop
                write(l_file, p_content(i), p_lang);
                i := p_content.next(i);
            end loop;
        end if;
        at_file.close(l_file);
    exception
        when others then
            at_file.close(l_file);
            raise;
    end varchars_to_file;

    -- Write at_type.lvarchars to file.
    procedure lvarchars_to_file(
        p_content in at_type.lvarchars,
        p_file_name varchar2,
        p_dir varchar2 default at_env.c_out_dir,
        p_lang in varchar2 default at_env.c_nls_lang
    ) is
        i pls_integer;
        l_file utl_file.file_type;
    begin
        l_file := out_file(p_file_name, p_dir);
        if p_content.count > 0 then
            i := p_content.first;
            while i is not null loop
                write(l_file, p_content(i), p_lang);
                i := p_content.next(i);
            end loop;
        end if;
        at_file.close(l_file);
    exception
        when others then
            at_file.close(l_file);
            raise;
    end lvarchars_to_file;

    -- Get table from the csv-file clob.
    -- select * from table(at_file.csv_table(<clob>));
    function csv_table(
        p_clob clob,
        p_delim varchar2 default ';',
        p_optionally_enclosed varchar2 default '"'
    ) return at_table pipelined
    is
        l_char char(1);
        l_lookahead char(1);
        l_pos pls_integer := 0;
        l_token varchar2(32767) := null;
        l_token_complete boolean := false;
        l_line_complete boolean := false;
        l_new_token boolean := true;
        l_enclosed boolean := false;
        l_lineno pls_integer := 1;
        l_columnno pls_integer := 1;
        l_len pls_integer;

        l_cols at_type.varchars;
    begin
        -- The following parsing code adapted from the code found at address
        -- http://christopherbeck.wordpress.com/2012/04/03/parsing-a-csv-file-in-plsql/
        l_len := dbms_lob.getLength(p_clob);
        loop
            -- increment position index
            l_pos := l_pos + 1;

            -- get next character from clob
            l_char := dbms_lob.substr(p_clob, 1, l_pos);

            -- exit when no more characters to process
            exit when l_char is null or l_pos > l_len;

            -- if first character of new token is optionally enclosed character
            -- note that and skip it and get next character
            if l_new_token and l_char = p_optionally_enclosed then
                l_enclosed := true;
                l_pos := l_pos + 1;
                l_char := dbms_lob.substr(p_clob, 1, l_pos);
            end if;
            l_new_token := false;

            -- get look ahead character
            l_lookahead := dbms_lob.substr(p_clob, 1, l_pos+1);

            -- inspect character (and lookahead) to determine what to do
            if l_char = p_optionally_enclosed and l_enclosed then

                if l_lookahead = p_optionally_enclosed then
                    l_pos := l_pos + 1;
                    l_token := l_token || l_lookahead;
                elsif l_lookahead = p_delim then
                    l_pos := l_pos + 1;
                    l_token_complete := true;
                else
                    l_enclosed := false;
                end if;

            elsif l_char in (at_env.cr, at_env.lf) and not l_enclosed then
                l_token_complete := true;
                l_line_complete := true;

                if l_lookahead in (at_env.cr, at_env.lf) then
                    l_pos := l_pos + 1;
                end if;

            elsif l_char = p_delim and not l_enclosed then
                l_token_complete := true;

            elsif l_pos = l_len then
                l_token := l_token || l_char;
                l_token_complete := true;
                l_line_complete := true;

            else
                l_token := l_token || l_char;
            end if;

            -- process a new token
            if l_token_complete then
                l_cols(l_columnno) := l_token;
                l_columnno := l_columnno + 1;
                l_token := null;
                l_enclosed := false;
                l_new_token := true;
                l_token_complete := false;
            end if;

            -- process end-of-line here
            if l_line_complete then
                while l_columnno <= c_columns_limit loop
                    l_cols(l_columnno) := null;
                    l_columnno := l_columnno + 1;
                end loop;
                pipe row(
                    at_row(
                        l_cols(1), l_cols(2), l_cols(3), l_cols(4), l_cols(5), l_cols(6), l_cols(7), l_cols(8), l_cols(9), l_cols(10),
                        l_cols(11), l_cols(12), l_cols(13), l_cols(14), l_cols(15), l_cols(16), l_cols(17), l_cols(18), l_cols(19), l_cols(20),
                        l_cols(21), l_cols(22), l_cols(23), l_cols(24), l_cols(25), l_cols(26), l_cols(27), l_cols(28), l_cols(29), l_cols(30),
                        l_cols(31), l_cols(32), l_cols(33), l_cols(34), l_cols(35), l_cols(36), l_cols(37), l_cols(38), l_cols(39), l_cols(40),
                        l_cols(41), l_cols(42), l_cols(43), l_cols(44), l_cols(45), l_cols(46), l_cols(47), l_cols(48), l_cols(49), l_cols(50),
                        l_cols(51), l_cols(52), l_cols(53), l_cols(54), l_cols(55), l_cols(56), l_cols(57), l_cols(58), l_cols(59), l_cols(60),
                        l_cols(61), l_cols(62), l_cols(63), l_cols(64), l_cols(65), l_cols(66), l_cols(67), l_cols(68), l_cols(69), l_cols(70),
                        l_cols(71), l_cols(72), l_cols(73), l_cols(74), l_cols(75), l_cols(76), l_cols(77), l_cols(78), l_cols(79), l_cols(80),
                        l_cols(81), l_cols(82), l_cols(83), l_cols(84), l_cols(85), l_cols(86), l_cols(87), l_cols(88), l_cols(89), l_cols(90),
                        l_cols(91), l_cols(92), l_cols(93), l_cols(94), l_cols(95), l_cols(96), l_cols(97), l_cols(98), l_cols(99), l_cols(100)
                    ));
                l_lineno := l_lineno + 1;
                l_columnno := 1;
                l_line_complete := false;
                l_cols.delete;
            end if;
        end loop;
    end csv_table;

    -- Get table from the blob.
    -- select * from table(at_file.csv_table(<blob>));
    function csv_table(
        p_blob blob,
        p_delim varchar2 default ';',
        p_optionally_enclosed varchar2 default '"',
        p_charset varchar2 default at_env.c_charset
    ) return at_table pipelined
    is
        l_clob clob;
        l_char char(1);
        l_lookahead char(1);
        l_pos pls_integer := 0;
        l_token varchar2(32767) := null;
        l_token_complete boolean := false;
        l_line_complete boolean := false;
        l_new_token boolean := true;
        l_enclosed boolean := false;
        l_lineno pls_integer := 1;
        l_columnno pls_integer := 1;
        l_len pls_integer;

        l_cols at_type.varchars;
    begin
        l_clob := at_type.blob_to_clob(p_blob, p_charset);

        -- The following parsing code adapted from the code found at address
        -- http://christopherbeck.wordpress.com/2012/04/03/parsing-a-csv-file-in-plsql/
        l_len := dbms_lob.getLength(l_clob);
        loop
            -- increment position index
            l_pos := l_pos + 1;

            -- get next character from clob
            l_char := dbms_lob.substr(l_clob, 1, l_pos);

            -- exit when no more characters to process
            exit when l_char is null or l_pos > l_len;

            -- if first character of new token is optionally enclosed character
            -- note that and skip it and get next character
            if l_new_token and l_char = p_optionally_enclosed then
                l_enclosed := true;
                l_pos := l_pos + 1;
                l_char := dbms_lob.substr(l_clob, 1, l_pos);
            end if;
            l_new_token := false;

            -- get look ahead character
            l_lookahead := dbms_lob.substr(l_clob, 1, l_pos+1);

            -- inspect character (and lookahead) to determine what to do
            if l_char = p_optionally_enclosed and l_enclosed then

                if l_lookahead = p_optionally_enclosed then
                    l_pos := l_pos + 1;
                    l_token := l_token || l_lookahead;
                elsif l_lookahead = p_delim then
                    l_pos := l_pos + 1;
                    l_token_complete := true;
                else
                    l_enclosed := false;
                end if;

            elsif l_char in (at_env.cr, at_env.lf) and not l_enclosed then
                l_token_complete := true;
                l_line_complete := true;

                if l_lookahead in (at_env.cr, at_env.lf) then
                    l_pos := l_pos + 1;
                end if;

            elsif l_char = p_delim and not l_enclosed then
                l_token_complete := true;

            elsif l_pos = l_len then
                l_token := l_token || l_char;
                l_token_complete := true;
                l_line_complete := true;

            else
                l_token := l_token || l_char;
            end if;

            -- process a new token
            if l_token_complete then
                l_cols(l_columnno) := l_token;
                l_columnno := l_columnno + 1;
                l_token := null;
                l_enclosed := false;
                l_new_token := true;
                l_token_complete := false;
            end if;

            -- process end-of-line here
            if l_line_complete then
                while l_columnno <= c_columns_limit loop
                    l_cols(l_columnno) := null;
                    l_columnno := l_columnno + 1;
                end loop;
                pipe row(
                    at_row(
                        l_cols(1), l_cols(2), l_cols(3), l_cols(4), l_cols(5), l_cols(6), l_cols(7), l_cols(8), l_cols(9), l_cols(10),
                        l_cols(11), l_cols(12), l_cols(13), l_cols(14), l_cols(15), l_cols(16), l_cols(17), l_cols(18), l_cols(19), l_cols(20),
                        l_cols(21), l_cols(22), l_cols(23), l_cols(24), l_cols(25), l_cols(26), l_cols(27), l_cols(28), l_cols(29), l_cols(30),
                        l_cols(31), l_cols(32), l_cols(33), l_cols(34), l_cols(35), l_cols(36), l_cols(37), l_cols(38), l_cols(39), l_cols(40),
                        l_cols(41), l_cols(42), l_cols(43), l_cols(44), l_cols(45), l_cols(46), l_cols(47), l_cols(48), l_cols(49), l_cols(50),
                        l_cols(51), l_cols(52), l_cols(53), l_cols(54), l_cols(55), l_cols(56), l_cols(57), l_cols(58), l_cols(59), l_cols(60),
                        l_cols(61), l_cols(62), l_cols(63), l_cols(64), l_cols(65), l_cols(66), l_cols(67), l_cols(68), l_cols(69), l_cols(70),
                        l_cols(71), l_cols(72), l_cols(73), l_cols(74), l_cols(75), l_cols(76), l_cols(77), l_cols(78), l_cols(79), l_cols(80),
                        l_cols(81), l_cols(82), l_cols(83), l_cols(84), l_cols(85), l_cols(86), l_cols(87), l_cols(88), l_cols(89), l_cols(90),
                        l_cols(91), l_cols(92), l_cols(93), l_cols(94), l_cols(95), l_cols(96), l_cols(97), l_cols(98), l_cols(99), l_cols(100)
                    ));
                l_lineno := l_lineno + 1;
                l_columnno := 1;
                l_line_complete := false;
                l_cols.delete;
            end if;
        end loop;

        if 1 = dbms_lob.istemporary(l_clob) then
            dbms_lob.freetemporary(l_clob);
        end if;
    end csv_table;

    -- Get table from the specified csv-file.
    -- select * from table(at_file.csv_table('datafile.csv'));
    function csv_table(
        p_file_name varchar2,
        p_delim varchar2 default ';',
        p_optionally_enclosed varchar2 default '"',
        p_dir varchar2 default at_env.c_in_dir,
        p_charset varchar2 default at_env.c_charset
    ) return at_table pipelined
    is
        l_clob clob;
        l_char char(1);
        l_lookahead char(1);
        l_pos pls_integer := 0;
        l_token varchar2(32767) := null;
        l_token_complete boolean := false;
        l_line_complete boolean := false;
        l_new_token boolean := true;
        l_enclosed boolean := false;
        l_lineno pls_integer := 1;
        l_columnno pls_integer := 1;
        l_len pls_integer;

        l_cols at_type.varchars;
    begin
        l_clob := file_to_clob(p_file_name, p_dir, p_charset);

        -- The following parsing code adapted from the code found at address
        -- http://christopherbeck.wordpress.com/2012/04/03/parsing-a-csv-file-in-plsql/
        l_len := dbms_lob.getLength(l_clob);
        loop
            -- increment position index
            l_pos := l_pos + 1;

            -- get next character from clob
            l_char := dbms_lob.substr(l_clob, 1, l_pos);

            -- exit when no more characters to process
            exit when l_char is null or l_pos > l_len;

            -- if first character of new token is optionally enclosed character
            -- note that and skip it and get next character
            if l_new_token and l_char = p_optionally_enclosed then
                l_enclosed := true;
                l_pos := l_pos + 1;
                l_char := dbms_lob.substr(l_clob, 1, l_pos);
            end if;
            l_new_token := false;

            -- get look ahead character
            l_lookahead := dbms_lob.substr(l_clob, 1, l_pos+1);

            -- inspect character (and lookahead) to determine what to do
            if l_char = p_optionally_enclosed and l_enclosed then

                if l_lookahead = p_optionally_enclosed then
                    l_pos := l_pos + 1;
                    l_token := l_token || l_lookahead;
                elsif l_lookahead = p_delim then
                    l_pos := l_pos + 1;
                    l_token_complete := true;
                else
                    l_enclosed := false;
                end if;

            elsif l_char in (at_env.cr, at_env.lf) and not l_enclosed then
                l_token_complete := true;
                l_line_complete := true;

                if l_lookahead in (at_env.cr, at_env.lf) then
                    l_pos := l_pos + 1;
                end if;

            elsif l_char = p_delim and not l_enclosed then
                l_token_complete := true;

            elsif l_pos = l_len then
                l_token := l_token || l_char;
                l_token_complete := true;
                l_line_complete := true;

            else
                l_token := l_token || l_char;
            end if;

            -- process a new token
            if l_token_complete then
                l_cols(l_columnno) := l_token;
                l_columnno := l_columnno + 1;
                l_token := null;
                l_enclosed := false;
                l_new_token := true;
                l_token_complete := false;
            end if;

            -- process end-of-line here
            if l_line_complete then
                while l_columnno <= c_columns_limit loop
                    l_cols(l_columnno) := null;
                    l_columnno := l_columnno + 1;
                end loop;
                pipe row(
                    at_row(
                        l_cols(1), l_cols(2), l_cols(3), l_cols(4), l_cols(5), l_cols(6), l_cols(7), l_cols(8), l_cols(9), l_cols(10),
                        l_cols(11), l_cols(12), l_cols(13), l_cols(14), l_cols(15), l_cols(16), l_cols(17), l_cols(18), l_cols(19), l_cols(20),
                        l_cols(21), l_cols(22), l_cols(23), l_cols(24), l_cols(25), l_cols(26), l_cols(27), l_cols(28), l_cols(29), l_cols(30),
                        l_cols(31), l_cols(32), l_cols(33), l_cols(34), l_cols(35), l_cols(36), l_cols(37), l_cols(38), l_cols(39), l_cols(40),
                        l_cols(41), l_cols(42), l_cols(43), l_cols(44), l_cols(45), l_cols(46), l_cols(47), l_cols(48), l_cols(49), l_cols(50),
                        l_cols(51), l_cols(52), l_cols(53), l_cols(54), l_cols(55), l_cols(56), l_cols(57), l_cols(58), l_cols(59), l_cols(60),
                        l_cols(61), l_cols(62), l_cols(63), l_cols(64), l_cols(65), l_cols(66), l_cols(67), l_cols(68), l_cols(69), l_cols(70),
                        l_cols(71), l_cols(72), l_cols(73), l_cols(74), l_cols(75), l_cols(76), l_cols(77), l_cols(78), l_cols(79), l_cols(80),
                        l_cols(81), l_cols(82), l_cols(83), l_cols(84), l_cols(85), l_cols(86), l_cols(87), l_cols(88), l_cols(89), l_cols(90),
                        l_cols(91), l_cols(92), l_cols(93), l_cols(94), l_cols(95), l_cols(96), l_cols(97), l_cols(98), l_cols(99), l_cols(100)
                    ));
                l_lineno := l_lineno + 1;
                l_columnno := 1;
                l_line_complete := false;
                l_cols.delete;
            end if;
        end loop;

        if 1 = dbms_lob.istemporary(l_clob) then
            dbms_lob.freetemporary(l_clob);
            --dbms_output.put_line('temp clob deleted');
        end if;
    end csv_table;

    -- Load csv data into at_file_ table and return
    --    o_load_id  - id of inserted data
    --    o_rowcount - number of inserted rows
    -- Get loaded data with query
    --    select data from at_file_ where id = <o_load_id> order by line;
    procedure load_csv(
        p_clob clob,
        p_delim varchar2 default ';',
        p_optionally_enclosed varchar2 default '"',
        p_com1 at_file_.com1%type default null,
        p_com2 at_file_.com2%type default null,
        o_load_id out at_file_.id%type,
        o_rowcount out pls_integer
    ) is
        l_char char(1);
        l_lookahead char(1);
        l_pos pls_integer := 0;
        l_token varchar2(32767) := null;
        l_token_complete boolean := false;
        l_line_complete boolean := false;
        l_new_token boolean := true;
        l_enclosed boolean := false;
        l_lineno pls_integer := 0;
        l_columnno pls_integer := 1;
        l_len pls_integer;
        l_id varchar2(32) := sys_guid();

        l_cols at_type.varchars;
    begin
        -- The following parsing code adapted from the code found at address
        -- http://christopherbeck.wordpress.com/2012/04/03/parsing-a-csv-file-in-plsql/
        l_len := dbms_lob.getLength(p_clob);
        loop
            -- increment position index
            l_pos := l_pos + 1;

            -- get next character from clob
            l_char := dbms_lob.substr(p_clob, 1, l_pos);

            -- exit when no more characters to process
            exit when l_char is null or l_pos > l_len;

            -- if first character of new token is optionally enclosed character
            -- note that and skip it and get next character
            if l_new_token and l_char = p_optionally_enclosed then
                l_enclosed := true;
                l_pos := l_pos + 1;
                l_char := dbms_lob.substr(p_clob, 1, l_pos);
            end if;
            l_new_token := false;

            -- get look ahead character
            l_lookahead := dbms_lob.substr(p_clob, 1, l_pos+1);

            -- inspect character (and lookahead) to determine what to do
            if l_char = p_optionally_enclosed and l_enclosed then

                if l_lookahead = p_optionally_enclosed then
                    l_pos := l_pos + 1;
                    l_token := l_token || l_lookahead;
                elsif l_lookahead = p_delim then
                    l_pos := l_pos + 1;
                    l_token_complete := true;
                else
                    l_enclosed := false;
                end if;

            elsif l_char in (at_env.cr, at_env.lf) and not l_enclosed then
                l_token_complete := true;
                l_line_complete := true;

                if l_lookahead in (at_env.cr, at_env.lf) then
                    l_pos := l_pos + 1;
                end if;

            elsif l_char = p_delim and not l_enclosed then
                l_token_complete := true;

            elsif l_pos = l_len then
                l_token := l_token || l_char;
                l_token_complete := true;
                l_line_complete := true;

            else
                l_token := l_token || l_char;
            end if;

            -- process a new token
            if l_token_complete then
                l_cols(l_columnno) := l_token;
                l_columnno := l_columnno + 1;
                l_token := null;
                l_enclosed := false;
                l_new_token := true;
                l_token_complete := false;
            end if;

            -- process end-of-line here
            if l_line_complete then
                while l_columnno <= c_columns_limit loop
                    l_cols(l_columnno) := null;
                    l_columnno := l_columnno + 1;
                end loop;
                l_lineno := l_lineno + 1;
                insert into at_file_ (
                    id,
                    line,
                    when,
                    com1,
                    com2,
                    c1, c2, c3, c4, c5, c6, c7, c8, c9, c10,
                    c11, c12, c13, c14, c15, c16, c17, c18, c19, c20,
                    c21, c22, c23, c24, c25, c26, c27, c28, c29, c30,
                    c31, c32, c33, c34, c35, c36, c37, c38, c39, c40,
                    c41, c42, c43, c44, c45, c46, c47, c48, c49, c50,
                    c51, c52, c53, c54, c55, c56, c57, c58, c59, c60,
                    c61, c62, c63, c64, c65, c66, c67, c68, c69, c70,
                    c71, c72, c73, c74, c75, c76, c77, c78, c79, c80,
                    c81, c82, c83, c84, c85, c86, c87, c88, c89, c90,
                    c91, c92, c93, c94, c95, c96, c97, c98, c99, c100
                ) values (
                    l_id,
                    l_lineno,
                    systimestamp,
                    p_com1,
                    p_com2,
                    l_cols(1), l_cols(2), l_cols(3), l_cols(4), l_cols(5), l_cols(6), l_cols(7), l_cols(8), l_cols(9), l_cols(10),
                    l_cols(11), l_cols(12), l_cols(13), l_cols(14), l_cols(15), l_cols(16), l_cols(17), l_cols(18), l_cols(19), l_cols(20),
                    l_cols(21), l_cols(22), l_cols(23), l_cols(24), l_cols(25), l_cols(26), l_cols(27), l_cols(28), l_cols(29), l_cols(30),
                    l_cols(31), l_cols(32), l_cols(33), l_cols(34), l_cols(35), l_cols(36), l_cols(37), l_cols(38), l_cols(39), l_cols(40),
                    l_cols(41), l_cols(42), l_cols(43), l_cols(44), l_cols(45), l_cols(46), l_cols(47), l_cols(48), l_cols(49), l_cols(50),
                    l_cols(51), l_cols(52), l_cols(53), l_cols(54), l_cols(55), l_cols(56), l_cols(57), l_cols(58), l_cols(59), l_cols(60),
                    l_cols(61), l_cols(62), l_cols(63), l_cols(64), l_cols(65), l_cols(66), l_cols(67), l_cols(68), l_cols(69), l_cols(70),
                    l_cols(71), l_cols(72), l_cols(73), l_cols(74), l_cols(75), l_cols(76), l_cols(77), l_cols(78), l_cols(79), l_cols(80),
                    l_cols(81), l_cols(82), l_cols(83), l_cols(84), l_cols(85), l_cols(86), l_cols(87), l_cols(88), l_cols(89), l_cols(90),
                    l_cols(91), l_cols(92), l_cols(93), l_cols(94), l_cols(95), l_cols(96), l_cols(97), l_cols(98), l_cols(99), l_cols(100)
                );
                l_columnno := 1;
                l_line_complete := false;
                l_cols.delete;
            end if;
        end loop;

        o_load_id := l_id;
        o_rowcount := l_lineno;
    end load_csv;

    procedure load_csv(
        p_blob blob,
        p_delim varchar2 default ';',
        p_optionally_enclosed varchar2 default '"',
        p_charset varchar2 default at_env.c_charset,
        p_com1 at_file_.com1%type default null,
        p_com2 at_file_.com2%type default null,
        o_load_id out at_file_.id%type,
        o_rowcount out pls_integer
    ) is
        l_clob clob;
    begin
        l_clob := at_type.blob_to_clob(p_blob, p_charset);
        load_csv(
            p_clob => l_clob,
            p_delim => p_delim,
            p_optionally_enclosed => p_optionally_enclosed,
            p_com1 => p_com1,
            p_com2 => p_com2,
            o_load_id => o_load_id,
            o_rowcount => o_rowcount
        );
        if 1 = dbms_lob.istemporary(l_clob) then
            dbms_lob.freetemporary(l_clob);
        end if;
    end load_csv;

    procedure load_csv(
        p_file_name varchar2,
        p_delim varchar2 default ';',
        p_optionally_enclosed varchar2 default '"',
        p_dir varchar2 default at_env.c_in_dir,
        p_charset varchar2 default at_env.c_charset,
        p_com1 at_file_.com1%type default null,
        p_com2 at_file_.com2%type default null,
        o_load_id out at_file_.id%type,
        o_rowcount out pls_integer
    ) is
        l_clob clob;
    begin
        l_clob := file_to_clob(p_file_name, p_dir, p_charset);
        load_csv(
            p_clob => l_clob,
            p_delim => p_delim,
            p_optionally_enclosed => p_optionally_enclosed,
            p_com1 => p_com1,
            p_com2 => p_com2,
            o_load_id => o_load_id,
            o_rowcount => o_rowcount
        );
        if 1 = dbms_lob.istemporary(l_clob) then
            dbms_lob.freetemporary(l_clob);
        end if;
    end load_csv;

end at_file;
/
