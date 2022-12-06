create or replace package at_out is
/*******************************************************************************
    Utilities to retrieve and output data.

********************************************************************************
Copyright (C) 2018, 2020 by Andrei Trofimov

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

    -- Enrich p_message with p1 .. p9
    function f(
        p_message varchar2,
        p1 varchar2,
        p2 varchar2 default null,
        p3 varchar2 default null,
        p4 varchar2 default null,
        p5 varchar2 default null,
        p6 varchar2 default null,
        p7 varchar2 default null,
        p8 varchar2 default null,
        p9 varchar2 default null
    ) return varchar2;

    -- Shortcut for dbms_output.put_line.
    procedure p(p_message varchar2);

    -- Print out p_message enriched with p1 .. p9
    procedure p(
        p_message varchar2,
        p1 varchar2,
        p2 varchar2 default null,
        p3 varchar2 default null,
        p4 varchar2 default null,
        p5 varchar2 default null,
        p6 varchar2 default null,
        p7 varchar2 default null,
        p8 varchar2 default null,
        p9 varchar2 default null
    );

    -- Print header.
    procedure h(p_header varchar2);

    -- Quote p_text escaping special symbols \ and " with \
    -- Example:
    --     select at_out.quoted('a\"b\c"d\\e""f') from dual;
    --     "a\\\"b\\c\"d\\\\e\"\"f"
    function quoted(p_text varchar2) return varchar2;

    -- Replace dangerous symbols with entities.
    function safe_html(p_text varchar2) return varchar2;

    -- Fetch row with p_noc columns from cursor into table of varchar2
    procedure fetch_row(p_cursor sys_refcursor, p_noc pls_integer, o in out nocopy at_type.varchars);

    --
    -- The following put_<format>_to_<destination> procedures
    --     - fetch rows from the dynamic cursor p_cursor,
    --     - format them as specified, and
    --     - output them to the destination.
    -- Use column names from p_colnames or get them from cursor metadata.
    -- Use p_nls_lang as output charset/encoding.
    --

    -- Get p_cursor rows and output them as csv using dbms_output.put_line().
    procedure put_csv(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_nls_lang varchar2 default userenv('language')
    );

    -- Get p_cursor rows and output them as csv using htp.p().
    procedure put_csv_to_owa(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_nls_lang varchar2 default userenv('language')
    );

    -- Get p_cursor rows and output them as csv to file p_file in p_dir.
    procedure put_csv_to_file(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_file varchar2,
        p_dir varchar2 default at_env.c_out_dir,
        p_nls_lang varchar2 default at_env.c_nls_lang
    );

    -- Get p_cursor rows and put them as csv into at_type.lvarchars array.
    procedure put_csv_to_array(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        o_array out nocopy at_type.lvarchars,
        p_nls_lang varchar2 default userenv('language')
    );

    -- Get p_cursor rows and output them as html table using dbms_output.put_line().
    procedure put_html(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_nls_lang varchar2 default userenv('language'),
        p_safe_html boolean default false
    );

    -- Get p_cursor rows and output them as html table using htp.p().
    procedure put_html_to_owa(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_nls_lang varchar2 default userenv('language'),
        p_safe_html boolean default false,
        p_table_css_class varchar2 default null
    );

    -- Get p_cursor rows and output them as html table to file p_file in p_dir.
    procedure put_html_to_file(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_file varchar2,
        p_dir varchar2 default at_env.c_out_dir,
        p_nls_lang varchar2 default at_env.c_nls_lang,
        p_safe_html boolean default false
    );

    -- Get p_cursor rows and put them as html table into at_type.lvarchars array.
    procedure put_html_to_array(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        o_array out nocopy at_type.lvarchars,
        p_nls_lang varchar2 default userenv('language'),
        p_safe_html boolean default false
    );

    -- Get p_cursor rows and output them as json using dbms_output.put_line().
    procedure put_json(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_nls_lang varchar2 default userenv('language')
    );

    -- Get p_cursor rows and output them as json using htp.p().
    procedure put_json_to_owa(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_nls_lang varchar2 default userenv('language')
    );

    -- Get p_cursor rows and output them as json to file p_file in p_dir.
    procedure put_json_to_file(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_file varchar2,
        p_dir varchar2 default at_env.c_out_dir,
        p_nls_lang varchar2 default at_env.c_nls_lang
    );

    -- Get p_cursor rows and put them as json into at_type.lvarchars array.
    procedure put_json_to_array(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        o_array out nocopy at_type.lvarchars,
        p_nls_lang varchar2 default userenv('language')
    );

    -- Get p_cursor rows and put them as xlsx to blob o_blob.
    procedure put_xlsx(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_colwidths at_numbers default at_numbers(),
        p_new_workbook boolean default true,
        p_new_sheet boolean default true,
        p_finish boolean default true,
        p_skip_rows pls_integer default 0,
        o_blob out nocopy blob
    );

    -- Get p_cursor rows and put them as xlsx into at_type.lvarchars array.
    procedure put_xlsx(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_colwidths at_numbers default at_numbers(),
        p_file varchar2,
        p_dir varchar2 default at_env.c_out_dir
    );

end at_out;
/
create or replace package body at_out is

    c_as_csv  constant varchar2(5) := 'csv';
    c_as_html constant varchar2(5) := 'html';
    c_as_json constant varchar2(5) := 'json';
    c_to_out  constant varchar2(5) := 'out';
    c_to_owa  constant varchar2(5) := 'owa';
    c_to_file constant varchar2(5) := 'file';
    c_to_array constant varchar2(5) := 'array';

    -- Enrich p_message with p1 .. p9
    function f(
        p_message varchar2,
        p1 varchar2,
        p2 varchar2 default null,
        p3 varchar2 default null,
        p4 varchar2 default null,
        p5 varchar2 default null,
        p6 varchar2 default null,
        p7 varchar2 default null,
        p8 varchar2 default null,
        p9 varchar2 default null
    ) return varchar2
    is
        nul char(6) := '<null>';
    begin
        return
            replace(
                replace(
                    replace(
                        replace(
                            replace(
                                replace(
                                    replace(
                                        replace(
                                            replace(
                                                p_message, ':1', nvl(p1, nul)
                                            ), ':2', nvl(p2, nul)
                                        ), ':3', nvl(p3, nul)
                                    ), ':4', nvl(p4, nul)
                                ), ':5', nvl(p5, nul)
                            ), ':6', nvl(p6, nul)
                        ), ':7', nvl(p7, nul)
                    ), ':8', nvl(p8, nul)
                ), ':9', nvl(p9, nul)
            )
        ;
    end f;

    -- Shortcut for dbms_output.put_line
    procedure p(p_message varchar2)
    is
    begin
        dbms_output.put_line(p_message);
    end p;

    -- Print out p_message enriched with p1 .. p9
    procedure p(
        p_message varchar2,
        p1 varchar2,
        p2 varchar2 default null,
        p3 varchar2 default null,
        p4 varchar2 default null,
        p5 varchar2 default null,
        p6 varchar2 default null,
        p7 varchar2 default null,
        p8 varchar2 default null,
        p9 varchar2 default null
    ) is
    begin
        dbms_output.put_line(f(p_message, p1, p2, p3, p4, p5, p6, p7, p8, p9));                
    end p;

    -- Print header.
    procedure h(p_header varchar2)
    is
    begin
        dbms_output.put_line(
            rpad('-',80,'-') || chr(10) ||
            '-- ' || p_header || chr(10) ||
            rpad('-', 80, '-') || chr(10)
        );
    end h;

    -- Quote p_text escaping special symbols \ and " with \
    -- Example:
    --     select at_out.quoted('a\"b\c"d\\e""f') from dual;
    --     "a\\\"b\\c\"d\\\\e\"\"f"
    function quoted(p_text varchar2) return varchar2
    is
    begin
        return
            case
                when p_text like '"%"' then
                    p_text
                else
                    '"' || regexp_replace(regexp_replace(p_text, '([^\]?)\\([^\]?)', '\1\\\\\2'), '([^\]?)"', '\1\"') || '"'
            end;
    end quoted;

    -- Replace dangerous symbols with entities.
    function safe_html(p_text varchar2) return varchar2
    is
    begin
        return replace(replace(replace(p_text, '&', '&amp;'), '<', '&lt;'), '>', '&gt;');
    end safe_html;

    -- Fetch row with p_noc columns from cursor into table of varchar2
    procedure fetch_row(p_cursor sys_refcursor, p_noc pls_integer, o in out nocopy at_type.varchars)
    is
    begin
        case p_noc
            when 1 then
                fetch p_cursor into o(1);
            when 2 then
                fetch p_cursor into o(1),o(2);
            when 3 then
                fetch p_cursor into o(1),o(2),o(3);
            when 4 then
                fetch p_cursor into o(1),o(2),o(3),o(4);
            when 5 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5);
            when 6 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6);
            when 7 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7);
            when 8 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8);
            when 9 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9);
            when 10 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10);
            when 11 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11);
            when 12 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12);
            when 13 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13);
            when 14 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14);
            when 15 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15);
            when 16 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16);
            when 17 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17);
            when 18 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18);
            when 19 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19);
            when 20 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20);
            when 21 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21);
            when 22 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22);
            when 23 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23);
            when 24 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24);
            when 25 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25);
            when 26 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26);
            when 27 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27);
            when 28 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28);
            when 29 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29);
            when 30 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30);
            when 31 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31);
            when 32 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32);
            when 33 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33);
            when 34 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34);
            when 35 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35);
            when 36 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36);
            when 37 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37);
            when 38 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38);
            when 39 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39);
            when 40 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40);
            when 41 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41);
            when 42 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42);
            when 43 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43);
            when 44 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44);
            when 45 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45);
            when 46 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46);
            when 47 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47);
            when 48 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48);
            when 49 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49);
            when 50 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50);
            when 51 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51);
            when 52 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52);
            when 53 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53);
            when 54 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54);
            when 55 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55);
            when 56 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56);
            when 57 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57);
            when 58 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58);
            when 59 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59);
            when 60 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60);
            when 61 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61);
            when 62 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62);
            when 63 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63);
            when 64 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64);
            when 65 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65);
            when 66 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66);
            when 67 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67);
            when 68 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68);
            when 69 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69);
            when 70 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70);
            when 71 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71);
            when 72 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72);
            when 73 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73);
            when 74 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74);
            when 75 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75);
            when 76 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76);
            when 77 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77);
            when 78 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78);
            when 79 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79);
            when 80 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80);
            when 81 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81);
            when 82 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82);
            when 83 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83);
            when 84 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84);
            when 85 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85);
            when 86 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86);
            when 87 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87);
            when 88 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87),o(88);
            when 89 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87),o(88),o(89);
            when 90 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87),o(88),o(89),o(90);
            when 91 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87),o(88),o(89),o(90),o(91);
            when 92 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87),o(88),o(89),o(90),o(91),o(92);
            when 93 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87),o(88),o(89),o(90),o(91),o(92),o(93);
            when 94 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87),o(88),o(89),o(90),o(91),o(92),o(93),o(94);
            when 95 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87),o(88),o(89),o(90),o(91),o(92),o(93),o(94),o(95);
            when 96 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87),o(88),o(89),o(90),o(91),o(92),o(93),o(94),o(95),o(96);
            when 97 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87),o(88),o(89),o(90),o(91),o(92),o(93),o(94),o(95),o(96),o(97);
            when 98 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87),o(88),o(89),o(90),o(91),o(92),o(93),o(94),o(95),o(96),o(97),o(98);
            when 99 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87),o(88),o(89),o(90),o(91),o(92),o(93),o(94),o(95),o(96),o(97),o(98),o(99);
            when 100 then
                fetch p_cursor into o(1),o(2),o(3),o(4),o(5),o(6),o(7),o(8),o(9),o(10),o(11),o(12),o(13),o(14),o(15),o(16),o(17),o(18),o(19),o(20),
                    o(21),o(22),o(23),o(24),o(25),o(26),o(27),o(28),o(29),o(30),o(31),o(32),o(33),o(34),o(35),o(36),o(37),o(38),o(39),o(40),
                    o(41),o(42),o(43),o(44),o(45),o(46),o(47),o(48),o(49),o(50),o(51),o(52),o(53),o(54),o(55),o(56),o(57),o(58),o(59),o(60),
                    o(61),o(62),o(63),o(64),o(65),o(66),o(67),o(68),o(69),o(70),o(71),o(72),o(73),o(74),o(75),o(76),o(77),o(78),o(79),o(80),
                    o(81),o(82),o(83),o(84),o(85),o(86),o(87),o(88),o(89),o(90),o(91),o(92),o(93),o(94),o(95),o(96),o(97),o(98),o(99),o(100);
        end case;
    end fetch_row;

    --
    -- Get p_cursor rows and put them to p_dest formatting as p_format.
    -- Use column names specified in p_colnames or get them from query metadata.
    --
    -- For example, put all_users data into file as csv:
    -- open l_cursor for select * from all_users;
    -- at_out.put(l_cursor, at_svarchars(), 'file', 'csv', 'testfile.csv');
    -- close l_cursor;
    --
    procedure put(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_dest varchar2,   -- c_to_out | c_to_owa | c_to_file | c_to_array
        p_format varchar2, -- c_as_csv | c_as_html | c_as_json
        p_nls_lang varchar2 default USERENV('language'),
        p_file varchar2 default null,
        p_dir varchar2 default at_env.c_out_dir,
        o_array out nocopy at_type.lvarchars,
        p_header boolean default true,
        p_safe_html boolean default false,
        p_table_css_class varchar2 default null
    ) is
        l_dsql_cursor pls_integer;
        l_col_count pls_integer;
        l_desc_table dbms_sql.desc_tab3;
        l_colnames at_varchars := p_colnames;
        l_coltypes at_type.numbers;

        c at_type.varchars;
        l_line varchar2(32767);
        l_output boolean := false;
        l_file utl_file.file_type;

        l_convert boolean := p_nls_lang != userenv('language');

        procedure initialize is
        begin
            case p_dest
            when c_to_out then
                dbms_output.enable(1000000);
            when c_to_owa then
                null;
            when c_to_file then
                l_file := at_file.out_file(p_file, p_dir);
            when c_to_array then
                o_array.delete;
            end case;
        end initialize;

        procedure finalize is
        begin
            case p_dest
            when c_to_out then
                null;
            when c_to_owa then
                null;
            when c_to_file then
                at_file.close(l_file);
            when c_to_array then
                null;
            end case;
        end finalize;

        procedure output(p_line varchar2) is
        begin
            case p_dest
            when c_to_out then
                dbms_output.put_line(case when l_convert then at_util.to_nls_lang(p_line, p_nls_lang) else p_line end);
            when c_to_owa then
                htp.p(case when l_convert then at_util.to_nls_lang(p_line, p_nls_lang) else p_line end);
            when c_to_file then
                at_file.write(l_file, p_line, p_nls_lang);
            when c_to_array then
                o_array(o_array.count+1) := case when l_convert then at_util.to_nls_lang(p_line, p_nls_lang) else p_line end || at_env.nl;
            end case;
        end output;
    begin
        -- Get column types and column names if needed.
        l_dsql_cursor := dbms_sql.to_cursor_number(p_cursor);
        dbms_sql.describe_columns3(l_dsql_cursor, l_col_count, l_desc_table);

        at_exc.assert(l_colnames.count in (0, l_col_count), 'Query and column names do not match.');
        at_exc.assert(l_col_count between 1 and 100, 'Query should have 1 to 100 columns.');

        for i in 1 .. l_col_count loop
            l_coltypes(i) := l_desc_table(i).col_type;
        end loop;
        if l_colnames.count = 0 then
            for i in 1 .. l_col_count loop
                l_colnames.extend;
                l_colnames(i) := l_desc_table(i).col_name;
            end loop;
        end if;

        p_cursor := dbms_sql.to_refcursor(l_dsql_cursor);

        initialize;

        -- Prepare the first line.
        case p_format
            when c_as_html then
                if p_header then
                    if p_safe_html then
                        for i in 1 .. l_colnames.count loop
                            l_colnames(i) := safe_html(l_colnames(i));
                        end loop;
                    end if;
                    l_line := at_util.joined(l_colnames, '</th><th>', '<table' || case when p_table_css_class is not null then ' class="' || p_table_css_class || '"' end || '>' || at_env.nl || '<tr><th>', '</th></tr>');
                else
                    l_line := '<table' || case when p_table_css_class is not null then ' class="' || p_table_css_class || '"' end || '>';
                end if;
            when c_as_json then
                l_line := '[';
            else
                if p_header then
                    l_line := at_util.joined(l_colnames, ';', '', ';');
                else
                    l_line := null;
                end if;
        end case;

        -- Get and process query data.
        loop
            fetch_row(p_cursor, l_colnames.count, c);
            exit when p_cursor%notfound;

            if l_line is not null then
                -- Put previous line.
                pragma inline(output, 'YES');
                output(l_line);
                l_output := true;
            end if;

            -- Prepare next line.
            case p_format
                when c_as_html then
                    for i in 1 .. l_colnames.count loop
                        if p_safe_html and c(i) is not null then
                            c(i) := safe_html(c(i));
                        end if;
                    end loop;
                    l_line := at_util.joined(c, '</td><td>', '<tr><td>', '</td></tr>');
                when c_as_json then
                    l_line := '{';
                    for i in 1 .. l_colnames.count loop
                        l_line := l_line ||
                            '"' || l_colnames(i) || '":' ||
                            case
                                when c(i) is null then
                                    'null'
                                when l_coltypes(i) = dbms_types.TYPECODE_NUMBER then
                                    c(i)
                                else
                                    quoted(c(i))
                            end ||
                            ',';
                    end loop;
                    l_line := rtrim(l_line, ',') || '},';
                else
                    l_line := at_util.joined(c, ';', '', ';');
            end case;
        end loop;

        if l_output then
            case p_format
                when c_as_html then
                    -- Put previous line.
                    output(l_line);
                    -- Prepare and put the last line.
                    l_line := '</table>';
                    output(l_line);
                when c_as_json then
                    -- Put previous line.
                    output(rtrim(l_line, ','));
                    -- Prepare and put the last line.
                    l_line := ']';
                    output(l_line);
                else
                    -- Put previous (and the last) line.
                    output(l_line);
            end case;
        end if;

        finalize;
    end put;

    -- Wrapper utilities.
    procedure put_csv(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_nls_lang varchar2 default userenv('language')
    ) is
    begin
        put(
            p_cursor   => p_cursor,
            p_colnames => p_colnames,
            p_dest     => c_to_out,
            p_format   => c_as_csv,
            p_nls_lang => p_nls_lang,
            o_array    => at_type.g_empty_lvarchars,
            p_header   => p_header
        );
    end put_csv;

    procedure put_csv_to_owa(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_nls_lang varchar2 default userenv('language')
    ) is
    begin
        put(
            p_cursor   => p_cursor,
            p_colnames => p_colnames,
            p_dest     => c_to_owa,
            p_format   => c_as_csv,
            p_nls_lang => p_nls_lang,
            o_array    => at_type.g_empty_lvarchars,
            p_header   => p_header
        );
    end put_csv_to_owa;

    procedure put_csv_to_file(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_file varchar2,
        p_dir varchar2 default at_env.c_out_dir,
        p_nls_lang varchar2 default at_env.c_nls_lang
    ) is
    begin
        put(
            p_cursor   => p_cursor,
            p_colnames => p_colnames,
            p_dest     => c_to_file,
            p_format   => c_as_csv,
            p_file     => p_file,
            p_dir      => p_dir,
            p_nls_lang => p_nls_lang,
            o_array    => at_type.g_empty_lvarchars,
            p_header   => p_header
        );
    end put_csv_to_file;

    procedure put_csv_to_array(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        o_array out nocopy at_type.lvarchars,
        p_nls_lang varchar2 default userenv('language')
    ) is
    begin
        put(
            p_cursor   => p_cursor,
            p_colnames => p_colnames,
            p_dest     => c_to_array,
            p_format   => c_as_csv,
            p_nls_lang => p_nls_lang,
            o_array    => o_array,
            p_header   => p_header
        );
    end put_csv_to_array;

    procedure put_html(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_nls_lang varchar2 default userenv('language'),
        p_safe_html boolean default false
    ) is
    begin
        put(
            p_cursor   => p_cursor,
            p_colnames => p_colnames,
            p_dest     => c_to_out,
            p_format   => c_as_html,
            p_nls_lang => p_nls_lang,
            o_array    => at_type.g_empty_lvarchars,
            p_header   => p_header,
            p_safe_html=> p_safe_html
        );
    end put_html;

    procedure put_html_to_owa(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_nls_lang varchar2 default userenv('language'),
        p_safe_html boolean default false,
        p_table_css_class varchar2 default null
    ) is
    begin
        put(
            p_cursor   => p_cursor,
            p_colnames => p_colnames,
            p_dest     => c_to_owa,
            p_format   => c_as_html,
            p_nls_lang => p_nls_lang,
            o_array    => at_type.g_empty_lvarchars,
            p_header   => p_header,
            p_safe_html=> p_safe_html
        );
    end put_html_to_owa;

    procedure put_html_to_file(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_file varchar2,
        p_dir varchar2 default at_env.c_out_dir,
        p_nls_lang varchar2 default at_env.c_nls_lang,
        p_safe_html boolean default false
    ) is
    begin
        put(
            p_cursor   => p_cursor,
            p_colnames => p_colnames,
            p_dest     => c_to_file,
            p_format   => c_as_html,
            p_file     => p_file,
            p_dir      => p_dir,
            p_nls_lang => p_nls_lang,
            o_array    => at_type.g_empty_lvarchars,
            p_header   => p_header,
            p_safe_html=> p_safe_html
        );
    end put_html_to_file;

    procedure put_html_to_array(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        o_array out nocopy at_type.lvarchars,
        p_nls_lang varchar2 default userenv('language'),
        p_safe_html boolean default false
    ) is
    begin
        put(
            p_cursor   => p_cursor,
            p_colnames => p_colnames,
            p_dest     => c_to_array,
            p_format   => c_as_html,
            p_nls_lang => p_nls_lang,
            o_array    => o_array,
            p_header   => p_header,
            p_safe_html=> p_safe_html
        );
    end put_html_to_array;

    procedure put_json(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_nls_lang varchar2 default userenv('language')
    ) is
    begin
        put(
            p_cursor   => p_cursor,
            p_colnames => p_colnames,
            p_dest     => c_to_out,
            p_format   => c_as_json,
            p_nls_lang => p_nls_lang,
            o_array    => at_type.g_empty_lvarchars
        );
    end put_json;

    procedure put_json_to_owa(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_nls_lang varchar2 default userenv('language')
    ) is
    begin
        put(
            p_cursor   => p_cursor,
            p_colnames => p_colnames,
            p_dest     => c_to_owa,
            p_format   => c_as_json,
            p_nls_lang => p_nls_lang,
            o_array    => at_type.g_empty_lvarchars
        );
    end put_json_to_owa;

    procedure put_json_to_file(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_file varchar2,
        p_dir varchar2 default at_env.c_out_dir,
        p_nls_lang varchar2 default at_env.c_nls_lang
    ) is
    begin
        put(
            p_cursor   => p_cursor,
            p_colnames => p_colnames,
            p_dest     => c_to_file,
            p_format   => c_as_json,
            p_file     => p_file,
            p_dir      => p_dir,
            p_nls_lang => p_nls_lang,
            o_array    => at_type.g_empty_lvarchars
        );
    end put_json_to_file;

    procedure put_json_to_array(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        o_array out nocopy at_type.lvarchars,
        p_nls_lang varchar2 default userenv('language')
    ) is
    begin
        put(
            p_cursor   => p_cursor,
            p_colnames => p_colnames,
            p_dest     => c_to_array,
            p_format   => c_as_json,
            p_nls_lang => p_nls_lang,
            o_array    => o_array
        );
    end put_json_to_array;

    procedure put_xlsx(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_colwidths at_numbers default at_numbers(),
        p_new_workbook boolean default true,
        p_new_sheet boolean default true,
        p_finish boolean default true,
        p_skip_rows pls_integer default 0,
        o_blob out nocopy blob
    ) is
        l_dsql_cursor pls_integer;
        l_col_count pls_integer;
        l_desc_table dbms_sql.desc_tab3;
        l_colnames at_varchars := p_colnames;
        l_coltypes at_type.numbers;

        c at_type.varchars;
        l_row_count pls_integer := p_skip_rows;
        
        c_align_right as_xlsx.tp_alignment := as_xlsx.get_alignment(p_horizontal => 'right', p_vertical => 'middle', p_wraptext => false);
        c_align_center as_xlsx.tp_alignment := as_xlsx.get_alignment(p_horizontal => 'center', p_vertical => 'middle', p_wraptext => false);
        c_align_left as_xlsx.tp_alignment := as_xlsx.get_alignment(p_horizontal => 'left', p_vertical => 'middle', p_wraptext => false);
        c_border pls_integer := as_xlsx.get_border('thin', 'thin', 'thin', 'thin');
    begin
        -- Get column types and column names if needed.
        l_dsql_cursor := dbms_sql.to_cursor_number(p_cursor);
        dbms_sql.describe_columns3(l_dsql_cursor, l_col_count, l_desc_table);

        at_exc.assert(l_colnames.count in (0, l_col_count), 'Query and column names do not match.');
        at_exc.assert(l_col_count between 1 and 100, 'Query should have 1 to 100 columns.');
        at_exc.assert(p_colwidths.count in (0, l_col_count), 'Query and column widths do not match.');

        for i in 1 .. l_col_count loop
            l_coltypes(i) := l_desc_table(i).col_type;
        end loop;
        if l_colnames.count = 0 then
            for i in 1 .. l_col_count loop
                l_colnames.extend;
                l_colnames(i) := l_desc_table(i).col_name;
            end loop;
        end if;

        p_cursor := dbms_sql.to_refcursor(l_dsql_cursor);

        if p_new_workbook then
            as_xlsx.clear_workbook; 
        end if;
        if p_new_sheet then
            as_xlsx.new_sheet;
        end if;
        
        if p_header then
            -- Make title row.
            l_row_count := l_row_count + 1;
            as_xlsx.set_row(
                l_row_count,
                p_fontId => as_xlsx.get_font('Calibri', p_bold => true)
            ); 
            for i in 1 .. l_colnames.count loop
                as_xlsx.cell(
                    i, l_row_count, l_colnames(i),
                    p_borderId => c_border, --as_xlsx.get_border('thin', 'thin', 'thin', 'thin'),
                    p_alignment => /*c_align_center*/ as_xlsx.get_alignment(p_horizontal => 'center', p_vertical => 'center', p_wraptext => true)
                );
            end loop;
            if p_colwidths.count > 0 then
                -- Set column widths.
                for i in 1 .. p_colwidths.count loop
                    as_xlsx.set_column_width(p_col => i, p_width => as_xlsx.width_pix_to_characters(p_colwidths(i)));
                end loop;
            end if;
        end if;

        -- Get and process query data.
        loop
            fetch_row(p_cursor, l_colnames.count, c);
            exit when p_cursor%notfound;

            -- Make data row.
            l_row_count := l_row_count + 1;
            for i in 1 .. l_colnames.count loop
                case l_coltypes(i)
                    when dbms_types.TYPECODE_NUMBER then
                        as_xlsx.cell(
                            i, l_row_count, to_number(c(i)),
                            p_alignment => c_align_right, --as_xlsx.get_alignment(p_horizontal => 'right', p_vertical => 'middle', p_wraptext => false),
                            p_borderId => c_border --as_xlsx.get_border('thin', 'thin', 'thin', 'thin')
                        );
                    when dbms_types.TYPECODE_DATE then
                        as_xlsx.cell(
                            i, l_row_count, to_date(c(i)),
                            p_alignment => c_align_center, --as_xlsx.get_alignment(p_horizontal => 'center', p_vertical => 'middle', p_wraptext => false),
                            p_borderId => c_border --as_xlsx.get_border('thin', 'thin', 'thin', 'thin')
                        );
                    else
                        as_xlsx.cell(
                            i, l_row_count, nvl(c(i), ''), -- PL/SQL empty line is important
                            p_alignment => c_align_left, --as_xlsx.get_alignment(p_horizontal => 'left', p_vertical => 'middle', p_wraptext => false),
                            p_borderId => c_border --as_xlsx.get_border('thin', 'thin', 'thin', 'thin')
                        );
                end case;
            end loop;

        end loop;

        if p_finish then
            o_blob := as_xlsx.finish;
        end if;
    end put_xlsx;

    procedure put_xlsx(
        p_cursor in out nocopy sys_refcursor,
        p_colnames at_varchars,
        p_header boolean default true,
        p_colwidths at_numbers default at_numbers(),
        p_file varchar2,
        p_dir varchar2 default at_env.c_out_dir
    ) is
        l_blob blob;
    begin
        put_xlsx(
            p_cursor => p_cursor,
            p_colnames => p_colnames,
            p_header => p_header,
            p_colwidths => p_colwidths,
            o_blob => l_blob
        );
        at_file.blob_to_file(
            p_blob => l_blob,
            p_file_name => p_file,
            p_dir  => p_dir
        );
        dbms_lob.freetemporary(l_blob);
    end put_xlsx;


end at_out;
/
