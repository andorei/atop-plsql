create or replace package at_jour authid current_user is
/*******************************************************************************
    Manage audit [jour]nals on tables.

Changelog
    2012-04-03 Andrei Trofimov create package
    2012-06-06 Andrei Trofimov use timestamp instead of date
    2015-09-28 Andrei Trofimov add support for creating journal in specified schema

********************************************************************************
Copyright (C) 2012-2016 by Andrei Trofimov

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

    /*
    grant create any table TO &package_owner;
    grant create any trigger TO &package_owner;
    grant alter any table TO &package_owner;
    grant alter any trigger TO &package_owner;
    grant drop any table TO &package_owner;
    grant drop any trigger TO &package_owner;
    grant select any table TO &package_owner;
    grant delete any table TO &package_owner;
    --
    grant select on sys.v_$session to &journal_owner;
    */  

    procedure configure(
        p_journal_prefix varchar2 default at_env.c_jour_jr_prefix,
        p_journal_suffix varchar2 default at_env.c_jour_jr_suffix,
        p_column_prefix varchar2 default at_env.c_jour_jr_col_prefix,
        p_journal_owner varchar2 default at_env.c_jour_jr_owner,
        p_table_owner varchar2 default at_env.c_jour_tab_owner
    );

    function journal_prefix return varchar2;
    function journal_suffix return varchar2;
    function column_prefix return varchar2;
    function journal_owner return varchar2;
    function table_owner return varchar2;

    -- Produce journal table name for table p_table_name like this:
    --     journal_prefix||p_table_name||journal_suffix
    function journal_name(p_table_name in varchar2) return varchar2;
    
    -- Produce journal trigger name for table p_table_name like this:
    --     journal_prefix||p_table_name||journal_suffix
    function trigger_name(p_table_name in varchar2) return varchar2;
    
    -- Check if journal on table p_table_name exists.
    function journal_exists(p_table_name in varchar2) return boolean;
    
    -- Create journal on table p_table_name.
    -- The journal will either
    -- - log old values when tablename is UPDATED (log_old_values = 1), or
    -- - omit old values when tablename is UPDATED (log_old_values != 1).
    procedure create_journal(
        p_table_name in varchar2,
        p_log_old_values pls_integer default 0,
        p_on_insert pls_integer default 1,
        p_on_update pls_integer default 1,
        p_on_delete pls_integer default 1
    );

    -- Drop journal table and journal trigger on table p_table_name.
    procedure drop_journal(p_table_name in varchar2);
    
    -- Disable journal trigger on table p_table_name - stop logging changes.
    procedure disable_journal(p_table_name in varchar2);
    
    -- Enable journal trigger on table p_table_name - resume logging changes.
    procedure enable_journal(p_table_name in varchar2);
    
    -- Truncate journal table for table p_table_name.
    procedure truncate_journal(p_table_name in varchar2);
    
    -- Delete records of journal table for table p_table_name
    procedure purge_journal(
        p_table_name in varchar2,
        p_where in varchar2
    );

    -- Makes journal either
    -- - log old values when tablename is UPDATED (log_old_values = 1), or
    -- - do not log old values when tablename is UPDATED (log_old_values != 1).
    procedure alter_journal(
        p_table_name in varchar2,
        p_log_old_values pls_integer default 0,
        p_on_insert pls_integer default 1,
        p_on_update pls_integer default 1,
        p_on_delete pls_integer default 1
    );

end at_jour;
/
create or replace package body at_jour is

    g_jr_template constant varchar2(4000) := '
        select
           cast(''*'' as char(3))         {pre}operation,
           cast(''*'' as varchar2(30))    {pre}ouser,
           cast(systimestamp as timestamp with time zone) {pre}datetime,
           cast(''*'' as varchar2(240))   {pre}notes,
           cast(''*'' as varchar2(30))    {pre}appln,
           cast(1 as number)              {pre}session
        from dual
        where 1 != 1';
    g_jr_perfix varchar2(5) := at_env.c_jour_jr_prefix;
    g_jr_suffix varchar2(5) := at_env.c_jour_jr_suffix;
    g_jr_col_prefix varchar2(5) := at_env.c_jour_jr_col_prefix;
    g_jr_owner varchar2(30) := at_env.c_jour_jr_owner;
    g_tab_owner varchar2(30) := at_env.c_jour_tab_owner;

    procedure configure(
        p_journal_prefix varchar2 default at_env.c_jour_jr_prefix,
        p_journal_suffix varchar2 default at_env.c_jour_jr_suffix,
        p_column_prefix varchar2 default at_env.c_jour_jr_col_prefix,
        p_journal_owner varchar2 default at_env.c_jour_jr_owner,
        p_table_owner varchar2 default at_env.c_jour_tab_owner
    ) is
    begin
        at_exc.assert(
            p_journal_owner is not null and p_table_owner is not null,
            'Journal owner and table owner can not be NULL.'
        );
        at_exc.assert(
            p_journal_prefix is not null or p_journal_suffix is not null,
            'Journal prefix and suffix can not be NULL both.'
        );
        g_jr_perfix := p_journal_prefix;
        g_jr_suffix := p_journal_suffix;
        g_jr_col_prefix := p_column_prefix;
        g_jr_owner := p_journal_owner;
        g_tab_owner := p_table_owner;
    end configure;        

    function journal_prefix return varchar2 is begin return g_jr_perfix; end;
    function journal_suffix return varchar2 is begin return g_jr_suffix; end;
    function column_prefix return varchar2 is begin return g_jr_col_prefix; end;
    function journal_owner return varchar2 is begin return g_jr_owner; end;
    function table_owner return varchar2 is begin return g_tab_owner; end;
    
    -- Produce journal table name for table p_table_name.
    function journal_name(p_table_name in varchar2) return varchar2
    is
    begin
        return g_jr_perfix || p_table_name || g_jr_suffix;
    end journal_name;

    -- Produce journal trigger name for table p_table_name.
    function trigger_name(p_table_name in varchar2) return varchar2
    is
    begin
        -- The same as journal name.
        return g_jr_perfix || p_table_name || g_jr_suffix;
    end trigger_name;

    function table_columns(p_table_name in varchar2, p_table_owner varchar2) return varchar2
    is
        l_cols varchar2(32000) := '';
    begin
        for r in (
            select column_name 
            from all_tab_columns c 
            where c.table_name = p_table_name 
                and c.owner = p_table_owner
            order by c.column_id
        ) loop
            -- Comma goes first!
            l_cols := l_cols || ',' || r.column_name;
        end loop;
        return l_cols;
    end table_columns;

    -- Check if journal on p_table_name exists.
    function journal_exists(p_table_name in varchar2) return boolean
    is
        l_dummy varchar2(30);
        l_trigger_name varchar2(30);
        l_journal_name varchar2(30);
    begin
        l_trigger_name := trigger_name(p_table_name);
        select table_name
        into l_dummy
        from all_triggers
        where trigger_name = l_trigger_name
            and owner = g_jr_owner;

        l_journal_name := journal_name(p_table_name);
        select table_name
        into l_dummy
        from all_tables
        where table_name = l_journal_name
            and owner = g_jr_owner;
        
        return true;
    exception
        when no_data_found then
            return false;
    end journal_exists;
	
    -- Create journal on table p_table_name.
    procedure create_journal_table(p_table_name in varchar2)
    is
        l_journal_name varchar2(30);
    begin
        l_journal_name := journal_name(p_table_name);
        execute immediate
            'CREATE TABLE ' || g_jr_owner || '.' || l_journal_name ||
            ' AS SELECT j.*, t.* FROM (' ||
            replace(g_jr_template, '{pre}', g_jr_col_prefix) ||
            ') j, ' || g_tab_owner || '.' || p_table_name || ' t';
        -- Remove not null constraints to make journal table as light as possible.
        for c in (
            select constraint_name 
            from all_constraints 
            where table_name = l_journal_name 
                and owner = g_jr_owner
        ) loop
            execute immediate
                'ALTER TABLE ' || g_jr_owner || '.' || l_journal_name || 
                ' DROP CONSTRAINT ' || c.constraint_name;
        end loop;
    end create_journal_table;

    procedure create_journal_trigger(
        p_table_name in varchar2,
        p_log_old_values pls_integer default 1,
        p_on_insert pls_integer default 1,
        p_on_update pls_integer default 1,
        p_on_delete pls_integer default 1)
    is
        l_table_cols varchar2(32000);
        l_journal_cols varchar2(32000);
        l_trigger_name varchar2(30);
        l_journal_name varchar2(30);
        l_after_clause varchar2(30);
    begin
        l_trigger_name := trigger_name(p_table_name);
        l_journal_name := journal_name(p_table_name);
        l_table_cols := table_columns(p_table_name, g_tab_owner);
        l_journal_cols := substr(table_columns(l_journal_name, g_jr_owner), 2);
        
        l_after_clause :=
            case p_on_insert 
            when 1 then 
                'INSERT'
            else
                null
            end;
        l_after_clause :=
            case p_on_update 
            when 1 then
                case 
                when l_after_clause is not null then
                    l_after_clause || ' OR UPDATE'
                else 
                    'UPDATE'
                end
            else
                l_after_clause
            end;
        l_after_clause :=
            case p_on_delete
            when 1 then
                case
                when l_after_clause is not null then
                    l_after_clause || ' OR DELETE'
                else 
                    'DELETE'
                end
            else
                l_after_clause
            end;
        
        execute immediate
'CREATE OR REPLACE TRIGGER ' || g_jr_owner || '.' || l_trigger_name || '
AFTER ' || l_after_clause || '
ON ' || g_tab_owner || '.' || p_table_name || '
FOR EACH ROW
DECLARE
    l_notes VARCHAR2(240);
    l_app   VARCHAR2(80);
    l_sess  VARCHAR2(80);
    l_op    VARCHAR2(3);
BEGIN
    SELECT rtrim( module || '' ''  || action),
        rtrim( substr( s.program, 1, 30)),
        s.audsid
    INTO l_notes, l_app, l_sess
    FROM sys.v_$session s
    WHERE s.audsid = userenv(''SESSIONID'');

    IF INSERTING THEN
        l_op := ''INS'';
    ELSIF UPDATING THEN
        l_op := ''UPD'';
    ELSIF DELETING THEN
        l_op := ''DEL'';
    END IF;

    IF INSERTING THEN
        INSERT INTO ' || l_journal_name || ' (
            ' || l_journal_cols || '
        ) values (
            l_op,user,systimestamp,l_notes,l_app,l_sess' || replace(l_table_cols,',',',:new.') || '
        );
    ELSIF UPDATING THEN
' ||
    case when p_log_old_values = 1 then
'        INSERT INTO ' || l_journal_name || ' (
            ' || l_journal_cols || '
        ) values (
            ''OLD'',user,systimestamp,l_notes,l_app,l_sess' || replace(l_table_cols,',',',:old.') || '
        );
'
     end ||
'        INSERT INTO ' || l_journal_name || ' (
            ' || l_journal_cols || '
        ) values (
            l_op,user,systimestamp,l_notes,l_app,l_sess' || replace(l_table_cols,',',',:new.') || '
        );
    ELSIF DELETING THEN
        INSERT INTO ' || l_journal_name || ' (
            ' || l_journal_cols || '
        ) values (
            l_op,user,systimestamp,l_notes,l_app,l_sess' || replace(l_table_cols,',',',:old.') || '
        );
    END IF;
END;
';
    end create_journal_trigger;
        
    -- Create journal on table p_table_name.
    -- The journal will either
    -- - log old values when p_table_name is UPDATED (log_old_values = 1), or
    -- - omit old values when p_table_name is UPDATED (log_old_values != 1).
    procedure create_journal(
        p_table_name in varchar2,
        p_log_old_values pls_integer default 0,
        p_on_insert pls_integer default 1,
        p_on_update pls_integer default 1,
        p_on_delete pls_integer default 1
    ) is
    begin
        if journal_exists(p_table_name) then
            raise_application_error(
                at_exc.c_already_exists_code,
                'Journal ' || g_jr_owner || '.' || journal_name(p_table_name) || ' already exists.'
            );
        end if;
        
        create_journal_table(p_table_name);
        create_journal_trigger(p_table_name, p_log_old_values, p_on_insert, p_on_update, p_on_delete);
    end create_journal;

    -- Drop journal table and journal trigger on p_table_name.
    procedure drop_journal(p_table_name in varchar2)
    is
    begin
        if not journal_exists(p_table_name) then
            raise_application_error(
                at_exc.c_does_not_exist_code,
                'Journal ' || g_jr_owner || '.' || journal_name(p_table_name) || ' does not exist.'
            );
        end if;
        execute immediate 'DROP TRIGGER ' || g_jr_owner || '.' || trigger_name(p_table_name);
        execute immediate 'DROP TABLE ' || g_jr_owner || '.' || journal_name(p_table_name);
    end drop_journal;

    -- Disable journal trigger on p_table_name - stop logging changes to journal.
    procedure disable_journal(p_table_name in varchar2)
    is
    begin
        if not journal_exists(p_table_name) then
            raise_application_error(
                at_exc.c_does_not_exist_code,
                'Journal ' || g_jr_owner || '.' || journal_name(p_table_name) || ' does not exist.'
            );
        end if;
        execute immediate 'ALTER TRIGGER ' || g_jr_owner || '.' || trigger_name(p_table_name) || ' DISABLE';
    end disable_journal;

    -- Enable journal trigger on p_table_name - resume logging changes to journal.
    procedure enable_journal(p_table_name in varchar2)
    is
    begin
        if not journal_exists(p_table_name) then
            raise_application_error(
                at_exc.c_does_not_exist_code,
                'Journal ' || g_jr_owner || '.' || journal_name(p_table_name) || ' does not exist.'
            );
        end if;
        execute immediate 'ALTER TRIGGER ' || g_jr_owner || '.' || trigger_name(p_table_name) || ' ENABLE';
    end enable_journal;

    -- Truncate journal table for table p_table_name.
    procedure truncate_journal(p_table_name in varchar2)
    is
    begin
        if not journal_exists(p_table_name) then
            raise_application_error(
                at_exc.c_does_not_exist_code,
                'Journal ' || g_jr_owner || '.' || journal_name(p_table_name) || ' does not exist.'
            );
        end if;
        execute immediate 'TRUNCATE TABLE ' || g_jr_owner || '.' || journal_name(p_table_name);
    end truncate_journal;

    -- Delete rows from journal table for table p_table_name
    -- using condition p_where; 50 000 rows are deleted per transaction.
    procedure purge_journal(
        p_table_name in varchar2,
        p_where in varchar2
    ) is
    begin
        if not journal_exists(p_table_name) then
            raise_application_error(
                at_exc.c_does_not_exist_code,
                'Journal ' || g_jr_owner || '.' || journal_name(p_table_name) || ' does not exist.'
            );
        end if;
        execute immediate
        'begin
            loop
                delete from ' || g_jr_owner || '.' || journal_name(p_table_name) || ' where (' || p_where || ') and rownum <=100000;
                exit when 0 = sql%rowcount;
                commit;
            end loop;
        end;'
        ;
    end purge_journal;

    -- Makes journal either
    -- - log old values when p_table_name is UPDATED (log_old_values = 1), or
    -- - do not log old values when p_table_name is UPDATED (log_old_values != 1).
    procedure alter_journal(
        p_table_name in varchar2,
        p_log_old_values pls_integer default 0,
        p_on_insert pls_integer default 1,
        p_on_update pls_integer default 1,
        p_on_delete pls_integer default 1
    ) is
    begin
        if not journal_exists(p_table_name) then
            raise_application_error(
                at_exc.c_does_not_exist_code,
                'Journal ' || g_jr_owner || '.' || journal_name(p_table_name) || ' does not exist.'
            );
        end if;
        create_journal_trigger(p_table_name, p_log_old_values, p_on_insert, p_on_update, p_on_delete);
    end alter_journal;
    
end at_jour;
/
