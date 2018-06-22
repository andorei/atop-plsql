create or replace package at_type is
/*******************************************************************************
    Define useful types and related utilities.

Changelog
    2017-12-27 Andrei Trofimov create package.
    2018-02-08 Andrei Trofimov add named_varchars type.
    2018-06-22 Andrei Trofimov raise_application_error in assetred_% procedures.

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

    -- Associative array types.
    type lvarchars is table of varchar2(32767) index by pls_integer;
    type varchars is table of varchar2(4000) index by pls_integer;
    type numbers is table of number index by pls_integer;
    type dates is table of date index by pls_integer;
    type named_varchars is table of varchar2(4000) index by varchar2(30);

    -- Empty associative arrays.
    g_empty_lvarchars at_type.lvarchars;
    g_empty_varchars at_type.varchars;
    g_empty_numbers at_type.numbers;
    g_empty_dates at_type.dates;
    g_empty_named_varchars at_type.named_varchars;

    -- Conversion from assosiative array to SQL nested table.
    function to_at_varchars(p in at_type.varchars) return at_varchars;
    function to_at_numbers(p in at_type.numbers) return at_numbers;
    function to_at_dates(p in at_type.dates) return at_dates;

    -- Create and initialize at_row object.
    -- The alternative would be to have 99 constructors for at_row.
    function  to_at_row(
        c1 varchar2,
        c2 varchar2 default null,
        c3 varchar2 default null,
        c4 varchar2 default null,
        c5 varchar2 default null,
        c6 varchar2 default null,
        c7 varchar2 default null,
        c8 varchar2 default null,
        c9 varchar2 default null,
        c10 varchar2 default null,
        c11 varchar2 default null,
        c12 varchar2 default null,
        c13 varchar2 default null,
        c14 varchar2 default null,
        c15 varchar2 default null,
        c16 varchar2 default null,
        c17 varchar2 default null,
        c18 varchar2 default null,
        c19 varchar2 default null,
        c20 varchar2 default null,
        c21 varchar2 default null,
        c22 varchar2 default null,
        c23 varchar2 default null,
        c24 varchar2 default null,
        c25 varchar2 default null,
        c26 varchar2 default null,
        c27 varchar2 default null,
        c28 varchar2 default null,
        c29 varchar2 default null,
        c30 varchar2 default null,
        c31 varchar2 default null,
        c32 varchar2 default null,
        c33 varchar2 default null,
        c34 varchar2 default null,
        c35 varchar2 default null,
        c36 varchar2 default null,
        c37 varchar2 default null,
        c38 varchar2 default null,
        c39 varchar2 default null,
        c40 varchar2 default null,
        c41 varchar2 default null,
        c42 varchar2 default null,
        c43 varchar2 default null,
        c44 varchar2 default null,
        c45 varchar2 default null,
        c46 varchar2 default null,
        c47 varchar2 default null,
        c48 varchar2 default null,
        c49 varchar2 default null,
        c50 varchar2 default null,
        c51 varchar2 default null,
        c52 varchar2 default null,
        c53 varchar2 default null,
        c54 varchar2 default null,
        c55 varchar2 default null,
        c56 varchar2 default null,
        c57 varchar2 default null,
        c58 varchar2 default null,
        c59 varchar2 default null,
        c60 varchar2 default null,
        c61 varchar2 default null,
        c62 varchar2 default null,
        c63 varchar2 default null,
        c64 varchar2 default null,
        c65 varchar2 default null,
        c66 varchar2 default null,
        c67 varchar2 default null,
        c68 varchar2 default null,
        c69 varchar2 default null,
        c70 varchar2 default null,
        c71 varchar2 default null,
        c72 varchar2 default null,
        c73 varchar2 default null,
        c74 varchar2 default null,
        c75 varchar2 default null,
        c76 varchar2 default null,
        c77 varchar2 default null,
        c78 varchar2 default null,
        c79 varchar2 default null,
        c80 varchar2 default null,
        c81 varchar2 default null,
        c82 varchar2 default null,
        c83 varchar2 default null,
        c84 varchar2 default null,
        c85 varchar2 default null,
        c86 varchar2 default null,
        c87 varchar2 default null,
        c88 varchar2 default null,
        c89 varchar2 default null,
        c90 varchar2 default null,
        c91 varchar2 default null,
        c92 varchar2 default null,
        c93 varchar2 default null,
        c94 varchar2 default null,
        c95 varchar2 default null,
        c96 varchar2 default null,
        c97 varchar2 default null,
        c98 varchar2 default null,
        c99 varchar2 default null,
        c100 varchar2 default null
    ) return at_row;

    -- Conversion from 1 to 10 assosiative arrays to SQL nested table at_table10.
    function to_at_table10(
        c1 in at_type.varchars,
        c2 in at_type.varchars default at_type.g_empty_varchars,
        c3 in at_type.varchars default at_type.g_empty_varchars,
        c4 in at_type.varchars default at_type.g_empty_varchars,
        c5 in at_type.varchars default at_type.g_empty_varchars,
        c6 in at_type.varchars default at_type.g_empty_varchars,
        c7 in at_type.varchars default at_type.g_empty_varchars,
        c8 in at_type.varchars default at_type.g_empty_varchars,
        c9 in at_type.varchars default at_type.g_empty_varchars,
        c10 in at_type.varchars default at_type.g_empty_varchars
    ) return at_table10;

    -- Conversion functions that raise assertion error if conversion fails.

    function asserted_number(
        p in varchar2,
        p_message varchar2 default null
    ) return number;

    function asserted_integer(
        p in varchar2,
        p_message varchar2 default null
    ) return pls_integer;

    function asserted_date(
        p in varchar2,
        p_message varchar2 default null,
        p_format varchar2 default at_env.c_date_format
    ) return date;

    function asserted_datetime(
        p in varchar2,
        p_message varchar2 default null,
        p_format varchar2 default at_env.c_datetime_format
    ) return date;

    function asserted_timestamp(
        p in varchar2,
        p_message varchar2 default null,
        p_format varchar2 default at_env.c_timestamp_format
    ) return timestamp;

    function asserted_timestamp_tz(
        p in varchar2,
        p_message varchar2 default null,
        p_format varchar2 default at_env.c_timestamp_tz_format
    ) return timestamp with time zone;

    -- Convert at_type.lvarchars assosiative array to CLOB.
    function lvarchars_to_clob(
        p_content at_type.lvarchars
    ) return clob;

    -- Convert at_type.lvarchars assosiative array to BLOB.
    function lvarchars_to_blob(
        p_content at_type.lvarchars
    ) return blob;

    -- Return CLOB created from the p_blob BLOB.
    -- When no longer needed remember to free the CLOB with dbms_lob.freetemporary(l_clob).
    function blob_to_clob(
        p_blob blob,
        p_charset varchar2 default at_env.c_charset
    ) return clob;

    -- TODO clob_to_blob

end at_type;
/
create or replace package body at_type is

    -- Conversion from PL/SQL index-by-table to SQL nested-table.

    function to_at_varchars(p in at_type.varchars) return at_varchars
    is
        i pls_integer;
        l_result at_varchars := at_varchars();
    begin
        i := p.first;
        while i is not null loop
            l_result.extend;
            l_result(l_result.last) := p(i);
            i := p.next(i);
        end loop;
        return l_result;
    end to_at_varchars;

    function to_at_numbers(p at_type.numbers) return at_numbers
    is
        i pls_integer;
        l_result at_numbers := at_numbers();
    begin
        i := p.first;
        while i is not null loop
            l_result.extend;
            l_result(l_result.last) := p(i);
            i := p.next(i);
        end loop;
        return l_result;
    end to_at_numbers;

    function to_at_dates(p at_type.dates) return at_dates
    is
        i pls_integer;
        l_result at_dates := at_dates();
    begin
        i := p.first;
        while i is not null loop
            l_result.extend;
            l_result(l_result.last) := p(i);
            i := p.next(i);
        end loop;
        return l_result;
    end to_at_dates;

    -- Create and initialize at_row object.
    -- The alternative would be to have 99 constructors for at_row.
    function to_at_row(
        c1 varchar2,
        c2 varchar2 default null,
        c3 varchar2 default null,
        c4 varchar2 default null,
        c5 varchar2 default null,
        c6 varchar2 default null,
        c7 varchar2 default null,
        c8 varchar2 default null,
        c9 varchar2 default null,
        c10 varchar2 default null,
        c11 varchar2 default null,
        c12 varchar2 default null,
        c13 varchar2 default null,
        c14 varchar2 default null,
        c15 varchar2 default null,
        c16 varchar2 default null,
        c17 varchar2 default null,
        c18 varchar2 default null,
        c19 varchar2 default null,
        c20 varchar2 default null,
        c21 varchar2 default null,
        c22 varchar2 default null,
        c23 varchar2 default null,
        c24 varchar2 default null,
        c25 varchar2 default null,
        c26 varchar2 default null,
        c27 varchar2 default null,
        c28 varchar2 default null,
        c29 varchar2 default null,
        c30 varchar2 default null,
        c31 varchar2 default null,
        c32 varchar2 default null,
        c33 varchar2 default null,
        c34 varchar2 default null,
        c35 varchar2 default null,
        c36 varchar2 default null,
        c37 varchar2 default null,
        c38 varchar2 default null,
        c39 varchar2 default null,
        c40 varchar2 default null,
        c41 varchar2 default null,
        c42 varchar2 default null,
        c43 varchar2 default null,
        c44 varchar2 default null,
        c45 varchar2 default null,
        c46 varchar2 default null,
        c47 varchar2 default null,
        c48 varchar2 default null,
        c49 varchar2 default null,
        c50 varchar2 default null,
        c51 varchar2 default null,
        c52 varchar2 default null,
        c53 varchar2 default null,
        c54 varchar2 default null,
        c55 varchar2 default null,
        c56 varchar2 default null,
        c57 varchar2 default null,
        c58 varchar2 default null,
        c59 varchar2 default null,
        c60 varchar2 default null,
        c61 varchar2 default null,
        c62 varchar2 default null,
        c63 varchar2 default null,
        c64 varchar2 default null,
        c65 varchar2 default null,
        c66 varchar2 default null,
        c67 varchar2 default null,
        c68 varchar2 default null,
        c69 varchar2 default null,
        c70 varchar2 default null,
        c71 varchar2 default null,
        c72 varchar2 default null,
        c73 varchar2 default null,
        c74 varchar2 default null,
        c75 varchar2 default null,
        c76 varchar2 default null,
        c77 varchar2 default null,
        c78 varchar2 default null,
        c79 varchar2 default null,
        c80 varchar2 default null,
        c81 varchar2 default null,
        c82 varchar2 default null,
        c83 varchar2 default null,
        c84 varchar2 default null,
        c85 varchar2 default null,
        c86 varchar2 default null,
        c87 varchar2 default null,
        c88 varchar2 default null,
        c89 varchar2 default null,
        c90 varchar2 default null,
        c91 varchar2 default null,
        c92 varchar2 default null,
        c93 varchar2 default null,
        c94 varchar2 default null,
        c95 varchar2 default null,
        c96 varchar2 default null,
        c97 varchar2 default null,
        c98 varchar2 default null,
        c99 varchar2 default null,
        c100 varchar2 default null
    ) return at_row
    is
        l_row at_row := at_row();
    begin
        l_row.c1 := c1; l_row.c2 := c2; l_row.c3 := c3; l_row.c4 := c4; l_row.c5 := c5;
        l_row.c6 := c6; l_row.c7 := c7; l_row.c8 := c8; l_row.c9 := c9; l_row.c10 := c10;
        l_row.c11 := c11; l_row.c12 := c12; l_row.c13 := c13; l_row.c14 := c14; l_row.c15 := c15;
        l_row.c16 := c16; l_row.c17 := c17; l_row.c18 := c18; l_row.c19 := c19; l_row.c20 := c20;
        l_row.c21 := c21; l_row.c22 := c22; l_row.c23 := c23; l_row.c24 := c24; l_row.c25 := c25;
        l_row.c26 := c26; l_row.c27 := c27; l_row.c28 := c28; l_row.c29 := c29; l_row.c30 := c30;
        l_row.c31 := c31; l_row.c32 := c32; l_row.c33 := c33; l_row.c34 := c34; l_row.c35 := c35;
        l_row.c36 := c36; l_row.c37 := c37; l_row.c38 := c38; l_row.c39 := c39; l_row.c40 := c40;
        l_row.c41 := c41; l_row.c42 := c42; l_row.c43 := c43; l_row.c44 := c44; l_row.c45 := c45;
        l_row.c46 := c46; l_row.c47 := c47; l_row.c48 := c48; l_row.c49 := c49; l_row.c50 := c50;
        l_row.c51 := c51; l_row.c52 := c52; l_row.c53 := c53; l_row.c54 := c54; l_row.c55 := c55;
        l_row.c56 := c56; l_row.c57 := c57; l_row.c58 := c58; l_row.c59 := c59; l_row.c60 := c60;
        l_row.c61 := c61; l_row.c62 := c62; l_row.c63 := c63; l_row.c64 := c64; l_row.c65 := c65;
        l_row.c66 := c66; l_row.c67 := c67; l_row.c68 := c68; l_row.c69 := c69; l_row.c70 := c70;
        l_row.c71 := c71; l_row.c72 := c72; l_row.c73 := c73; l_row.c74 := c74; l_row.c75 := c75;
        l_row.c76 := c76; l_row.c77 := c77; l_row.c78 := c78; l_row.c79 := c79; l_row.c80 := c80;
        l_row.c81 := c81; l_row.c82 := c82; l_row.c83 := c83; l_row.c84 := c84; l_row.c85 := c85;
        l_row.c86 := c86; l_row.c87 := c87; l_row.c88 := c88; l_row.c89 := c89; l_row.c90 := c90;
        l_row.c91 := c91; l_row.c92 := c92; l_row.c93 := c93; l_row.c94 := c94; l_row.c95 := c95;
        l_row.c96 := c96; l_row.c97 := c97; l_row.c98 := c98; l_row.c99 := c99; l_row.c100 := c100;
        return l_row;
    end to_at_row;

    -- Conversion from 1 to 10 assosiative arrays to SQL nested table at_table10.
    function to_at_table10(
        c1 in at_type.varchars,
        c2 in at_type.varchars default at_type.g_empty_varchars,
        c3 in at_type.varchars default at_type.g_empty_varchars,
        c4 in at_type.varchars default at_type.g_empty_varchars,
        c5 in at_type.varchars default at_type.g_empty_varchars,
        c6 in at_type.varchars default at_type.g_empty_varchars,
        c7 in at_type.varchars default at_type.g_empty_varchars,
        c8 in at_type.varchars default at_type.g_empty_varchars,
        c9 in at_type.varchars default at_type.g_empty_varchars,
        c10 in at_type.varchars default at_type.g_empty_varchars
    ) return at_table10
    is
        i pls_integer;
        l_tab10 at_table10 := at_table10();
        l_row10 at_row10;
    begin
        at_exc.assert(
            c2.count in (0, c1.count),
            'c2 should have the same length as c1: c2.count=' || c2.count || ', c1.count=' || c1.count
        );
        at_exc.assert(
            c3.count in (0, c1.count),
            'c3 should have the same length as c1: c3.count=' || c3.count || ', c1.count=' || c1.count
        );
        at_exc.assert(
            c4.count in (0, c1.count),
            'c4 should have the same length as c1: c4.count=' || c4.count || ', c1.count=' || c1.count
        );
        at_exc.assert(
            c5.count in (0, c1.count),
            'c5 should have the same length as c1: c5.count=' || c5.count || ', c1.count=' || c1.count
        );
        at_exc.assert(
            c6.count in (0, c1.count),
            'c6 should have the same length as c1: c6.count=' || c6.count || ', c1.count=' || c1.count
        );
        at_exc.assert(
            c7.count in (0, c1.count),
            'c7 should have the same length as c1: c7.count=' || c7.count || ', c1.count=' || c1.count
        );
        at_exc.assert(
            c8.count in (0, c1.count),
            'c8 should have the same length as c1: c8.count=' || c8.count || ', c1.count=' || c1.count
        );
        at_exc.assert(
            c9.count in (0, c1.count),
            'c9 should have the same length as c1: c9.count=' || c9.count || ', c1.count=' || c1.count
        );
        at_exc.assert(
            c10.count in (0, c1.count),
            'c10 should have the same length as c1: c10.count=' || c10.count || ', c1.count=' || c1.count
        );
        i := c1.first;
        while i is not null loop
            l_row10 := at_row10();
            l_row10.c1 := c1(i);
            if c2.count != 0 then
                l_row10.c2 := c2(i);
            end if;
            if c3.count != 0 then
                l_row10.c3 := c3(i);
            end if;
            if c4.count != 0 then
                l_row10.c4 := c4(i);
            end if;
            if c5.count != 0 then
                l_row10.c5 := c5(i);
            end if;
            if c6.count != 0 then
                l_row10.c6 := c6(i);
            end if;
            if c7.count != 0 then
                l_row10.c7 := c7(i);
            end if;
            if c8.count != 0 then
                l_row10.c8 := c8(i);
            end if;
            if c9.count != 0 then
                l_row10.c9 := c9(i);
            end if;
            if c10.count != 0 then
                l_row10.c10 := c10(i);
            end if;
            l_tab10.extend;
            l_tab10(l_tab10.last) := l_row10;
            i := c1.next(i);
        end loop;
        return l_tab10;
    end to_at_table10;

    -- Conversion functions that raise assertion error if conversion fails.

    function asserted_number(
        p in varchar2,
        p_message varchar2 default null
    ) return number
    is
    begin
        return to_number(p);
    exception
        when value_error then
            raise_application_error(
                at_exc.c_assertion_error_code,
                'Assertion error: ' ||
                case
                    when p_message is not null then
                        p_message
                    else 
                        'number expected, got ''' || p || ''''
                end
            );
    end;

    function asserted_integer(
        p in varchar2,
        p_message varchar2 default null
    ) return pls_integer
    is
        l_int pls_integer;
    begin
        l_int := to_number(p);
        if l_int != to_number(p) then
            raise value_error;
        end if;
        return l_int;
    exception
        when value_error then
            raise_application_error(
                at_exc.c_assertion_error_code,
                'Assertion error: ' ||
                case
                    when p_message is not null then
                        p_message
                    else 
                        'integer expected, got ''' || p || ''''
                end
            );
    end;

    function asserted_date(
        p in varchar2,
        p_message varchar2 default null,
        p_format varchar2 default at_env.c_date_format
    ) return date
    is
    begin
        return to_date(p, p_format);
    exception
        when others then
            raise_application_error(
                at_exc.c_assertion_error_code,
                'Assertion error: ' ||
                case
                    when p_message is not null then
                        p_message
                    else 
                        'date expected, got ''' || p || ''''
                end
            );
    end;

    function asserted_datetime(
        p in varchar2,
        p_message varchar2 default null,
        p_format varchar2 default at_env.c_datetime_format
    ) return date
    is
    begin
        return to_date(p, p_format);
    exception
        when others then
            raise_application_error(
                at_exc.c_assertion_error_code,
                'Assertion error: ' ||
                case
                    when p_message is not null then
                        p_message
                    else 
                        'datetime expected, got ''' || p || ''''
                end
            );
    end;

    function asserted_timestamp(
        p in varchar2,
        p_message varchar2 default null,
        p_format varchar2 default at_env.c_timestamp_format
    ) return timestamp
    is
    begin
        return to_timestamp(p, p_format);
    exception
        when others then
            raise_application_error(
                at_exc.c_assertion_error_code,
                'Assertion error: ' ||
                case
                    when p_message is not null then
                        p_message
                    else 
                        'timestamp expected, got ''' || p || ''''
                end
            );
    end;

    function asserted_timestamp_tz(
        p in varchar2,
        p_message varchar2 default null,
        p_format varchar2 default at_env.c_timestamp_tz_format
    ) return timestamp with time zone
    is
    begin
        return to_timestamp_tz(p, p_format);
    exception
        when others then
            raise_application_error(
                at_exc.c_assertion_error_code,
                'Assertion error: ' ||
                case
                    when p_message is not null then
                        p_message
                    else 
                        'timestamp with time zone expected, got ''' || p || ''''
                end
            );
    end;

    function lvarchars_to_clob(
        p_content at_type.lvarchars
    ) return clob
    is
        l_clob clob;
        i pls_integer;
    begin
        dbms_lob.createtemporary(l_clob, true);
        i := p_content.first;
        while i is not null loop
            dbms_lob.writeappend(l_clob, length(p_content(i)), p_content(i));
            i := p_content.next(i);
        end loop;
        return l_clob;
    end lvarchars_to_clob;

    function lvarchars_to_blob(
        p_content at_type.lvarchars
    ) return blob
    is
        l_blob blob;
        l_raw raw(32767);
        i pls_integer;
    begin
        dbms_lob.createtemporary(l_blob, true);
        i := p_content.first;
        while i is not null loop
            l_raw := utl_raw.cast_to_raw(p_content(i));
            dbms_lob.writeappend(l_blob, utl_raw.length(l_raw), l_raw);
            i := p_content.next(i);
        end loop;
        return l_blob;
    end lvarchars_to_blob;

    -- Return CLOB created from the p_blob BLOB.
    -- When no longer needed remember to free the CLOB with dbms_lob.freetemporary(l_clob).
    function blob_to_clob(
        p_blob blob,
        p_charset varchar2 default at_env.c_charset
    ) return clob
    is
        l_clob         clob;
        l_dest_offsset integer := 1;
        l_src_offsset  integer := 1;
        l_lang_context integer := dbms_lob.default_lang_ctx;
        l_warning      integer;
    begin
        if p_blob is null then
            return null;
        end if;
        if dbms_lob.getlength(p_blob) = 0 then
            return empty_clob;
        end if;
        dbms_lob.createTemporary(
            lob_loc => l_clob,
            cache   => false
        );
        dbms_lob.converttoclob(
            dest_lob     => l_clob,
            src_blob     => p_blob,
            amount       => dbms_lob.lobmaxsize,
            dest_offset  => l_dest_offsset,
            src_offset   => l_src_offsset,
            -- database csid by default or nls_charset_id('AL32UTF8')
            -- blob_csid  => dbms_lob.default_csid,
            blob_csid    => nls_charset_id(p_charset),
            lang_context => l_lang_context,
            warning      => l_warning
        );
        return l_clob;
    end blob_to_clob;

end at_type;
/
