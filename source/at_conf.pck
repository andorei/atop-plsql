create or replace package at_conf is
/*******************************************************************************
    Configuration parameters API.

********************************************************************************
Copyright (C) 2016-2021 by Andrei Trofimov

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

    c_email_to constant at_conf_.name%type := '@@email_to';
    c_email_cc constant at_conf_.name%type := '@@email_cc';
    c_email_bcc constant at_conf_.name%type := '@@email_bcc';
    c_email_from constant at_conf_.name%type := '@email_from';
    c_email_reply_to constant at_conf_.name%type := '@email_rep';
    c_email_return_path constant at_conf_.name%type := '@email_ret';


    -- Value of configuration parameter p_name of owner p_owner.
    -- If owner p_owner does not exist or does not have parameter p_name then return p_default value.
    function param(
        p_owner at_conf_.owner%type,
        p_name at_conf_.name%type,
        p_default at_conf_.param%type default null
    ) return varchar2;

    -- Set configuration parameter p_name of owner p_owner.
    procedure set_param(
        p_owner at_conf_.owner%type,
        p_name at_conf_.name%type,
        p_param at_conf_.param%type,
        p_descr at_conf_.descr%type default null
    );

    -- Delete configuration parameter p_name of owner p_owner.
    procedure delete_param(
        p_owner at_conf_.owner%type,
        p_name at_conf_.name%type
    );

    -- Configuration parameters of owner p_owner.
    function params(
        p_owner at_conf_.owner%type
    ) return at_type.named_varchars;

    -- Set configuration parameters of owner p_owner.
    procedure set_params(
        p_owner at_conf_.owner%type,
        p_params at_type.named_varchars,
        p_descr at_type.named_varchars default at_type.g_empty_named_varchars
    );


    -- Utilities to manage parameters with email addresses.
    
    function email_to(
        p_owner at_conf_.owner%type,
        p_default at_conf_.param%type default null
    ) return varchar2;

    function email_cc(
        p_owner at_conf_.owner%type,
        p_default at_conf_.param%type default null
    ) return varchar2;

    function email_bcc(
        p_owner at_conf_.owner%type,
        p_default at_conf_.param%type default null
    ) return varchar2;

    function email_from(
        p_owner at_conf_.owner%type,
        p_default at_conf_.param%type default null
    ) return varchar2;

    function email_reply_to(
        p_owner at_conf_.owner%type,
        p_default at_conf_.param%type default null
    ) return varchar2;

    function email_return_path(
        p_owner at_conf_.owner%type,
        p_default at_conf_.param%type default null
    ) return varchar2;

    procedure set_email(
        p_owner at_conf_.owner%type,
        p_to at_conf_.param%type,
        p_cc at_conf_.param%type,
        p_bcc at_conf_.param%type,
        p_descr at_conf_.descr%type
    );

    procedure set_email(
        p_owner at_conf_.owner%type,
        p_to at_conf_.param%type,
        p_cc at_conf_.param%type,
        p_bcc at_conf_.param%type,
        p_from at_conf_.param%type,
        p_reply_to at_conf_.param%type,
        p_return_path at_conf_.param%type,
        p_descr at_conf_.descr%type
    );

    procedure get_email(
        p_owner at_conf_.owner%type,
        o_to out at_conf_.param%type,
        o_cc out at_conf_.param%type,
        o_bcc out at_conf_.param%type
    );

    procedure get_email(
        p_owner at_conf_.owner%type,
        o_to out at_conf_.param%type,
        o_cc out at_conf_.param%type,
        o_bcc out at_conf_.param%type,
        o_from out at_conf_.param%type,
        o_reply_to out at_conf_.param%type,
        o_return_path out at_conf_.param%type
    );

    procedure delete_email(
        p_owner at_conf_.owner%type
    );

end at_conf;
/
create or replace package body at_conf is

    function evaluated(p varchar2, p_skip_re varchar2 default '@') return varchar2
    is
        r varchar2(4000);
    begin
        if p is null or regexp_like(p, p_skip_re) then
            return p;
        else
            execute immediate
                'declare r varchar2(4000); begin :r := '||p||'; end;' using out r;
            return r;
        end if;
    exception
    when others then
        return p;
    end evaluated;

    -- 'ivanov.ii@anywhere.com,,,,,at_env.c_email_admin,Support<support@anywhere.ru>,'
    -- gets converted to
    -- 'ivanov.ii@anywhere.com,admin@company.com,Support<support@anywhere.ru>'
    function evaluated_list(p varchar2, p_skip_re varchar2 default '@') return varchar2
    is
        l_array at_varchars;
        l_result varchar2(4000) := null;
    begin
        if p is null then
            return null;
        end if;
        l_array := at_util.splitted(p, ',', 1);
        for i in l_array.first..l_array.last loop
            if l_array(i) is null then
                continue;
            end if;
            l_result := l_result||','||evaluated(l_array(i), p_skip_re);
        end loop;
        return substr(l_result, 2);
    end evaluated_list;

    function param(
        p_owner at_conf_.owner%type,
        p_name at_conf_.name%type,
        p_default at_conf_.param%type default null
    ) return varchar2
    is
        l_param at_conf_.param%type;
    begin
        select param into l_param from at_conf_ where owner = p_owner and name = p_name;
        return
            case
            when p_name like '@@%' then
                evaluated_list(l_param)
            when p_name like '@%' then
                evaluated(l_param)
            else
                l_param
            end;
    exception
    when no_data_found then
        return p_default;
    end param;

    function params(
        p_owner at_conf_.owner%type
    ) return at_type.named_varchars
    is
        l_params at_type.named_varchars;
    begin
        for r in (select name, param from at_conf_ where owner = p_owner) loop
            l_params(r.name) :=
                case
                when r.name like '@@%' then
                    evaluated_list(r.param)
                when r.name like '@%' then
                    evaluated(r.param)
                else
                    r.param
                end;
        end loop;
        return l_params;
    exception
        when no_data_found then
             return at_type.g_empty_named_varchars;
    end params;

    procedure set_param(
        p_owner at_conf_.owner%type,
        p_name at_conf_.name%type,
        p_param at_conf_.param%type,
        p_descr at_conf_.descr%type default null
    )
    is
    begin
        insert into at_conf_ (owner, name, param, descr)
        values (p_owner, p_name, p_param, p_descr)
        ;
    exception
    when dup_val_on_index then
        update at_conf_ set
            param = p_param,
            descr = p_descr
        where
            owner = p_owner
            and name = p_name
        ;
    end set_param;

    procedure set_params(
        p_owner at_conf_.owner%type,
        p_params at_type.named_varchars,
        p_descr at_type.named_varchars default at_type.g_empty_named_varchars
    )
    is
        l_key varchar2(30);
    begin
        l_key := p_params.first;
        while l_key is not null loop
            set_param(p_owner, l_key, p_params(l_key), case when p_descr.exists(l_key) then p_descr(l_key) else null end);
            l_key := p_params.next(l_key);
        end loop;
    end set_params;

    procedure delete_param(
        p_owner at_conf_.owner%type,
        p_name at_conf_.name%type
    )
    is
    begin
        delete from at_conf_ where owner = p_owner and name = p_name;
    end;

    function email_to(
        p_owner at_conf_.owner%type,
        p_default at_conf_.param%type default null
    ) return varchar2
    is
    begin
        return param(p_owner, c_email_to, p_default);
    end email_to;

    function email_cc(
        p_owner at_conf_.owner%type,
        p_default at_conf_.param%type default null
    ) return varchar2
    is
    begin
        return param(p_owner, c_email_cc, p_default);
    end email_cc;

    function email_bcc(
        p_owner at_conf_.owner%type,
        p_default at_conf_.param%type default null
    ) return varchar2
    is
    begin
        return param(p_owner, c_email_bcc, p_default);
    end email_bcc;

    function email_from(
        p_owner at_conf_.owner%type,
        p_default at_conf_.param%type default null
    ) return varchar2
    is
    begin
        return param(p_owner, c_email_from, p_default);
    end email_from;

    function email_reply_to(
        p_owner at_conf_.owner%type,
        p_default at_conf_.param%type default null
    ) return varchar2
    is
    begin
        return param(p_owner, c_email_reply_to, p_default);
    end email_reply_to;

    function email_return_path(
        p_owner at_conf_.owner%type,
        p_default at_conf_.param%type default null
    ) return varchar2
    is
    begin
        return param(p_owner, c_email_return_path, p_default);
    end email_return_path;

    procedure set_email(
        p_owner at_conf_.owner%type,
        p_to at_conf_.param%type,
        p_cc at_conf_.param%type,
        p_bcc at_conf_.param%type,
        p_descr at_conf_.descr%type
    )
    is
    begin
        if p_to is not null then
            set_param(p_owner, c_email_to, p_to, p_descr);
        else
            delete_param(p_owner, c_email_to);
        end if;
        if p_cc is not null then
            set_param(p_owner, c_email_cc, p_cc, p_descr);
        else
            delete_param(p_owner, c_email_cc);
        end if;
        if p_bcc is not null then
            set_param(p_owner, c_email_bcc, p_bcc, p_descr);
        else
            delete_param(p_owner, c_email_bcc);
        end if;
    end;

    procedure set_email(
        p_owner at_conf_.owner%type,
        p_to at_conf_.param%type,
        p_cc at_conf_.param%type,
        p_bcc at_conf_.param%type,
        p_from at_conf_.param%type,
        p_reply_to at_conf_.param%type,
        p_return_path at_conf_.param%type,
        p_descr at_conf_.descr%type
    )
    is
    begin
        set_email(
            p_owner => p_owner,
            p_to    => p_to,
            p_cc    => p_cc,
            p_bcc   => p_bcc,
            p_descr => p_descr
        );
        if p_from is not null then
            set_param(p_owner, c_email_from, p_from, p_descr);
        else
            delete_param(p_owner, c_email_from);
        end if;
        if p_reply_to is not null then
            set_param(p_owner, c_email_reply_to, p_reply_to, p_descr);
        else
            delete_param(p_owner, c_email_reply_to);
        end if;
        if p_return_path is not null then
            set_param(p_owner, c_email_return_path, p_return_path, p_descr);
        else
            delete_param(p_owner, c_email_return_path);
        end if;
    end;

    procedure get_email(
        p_owner at_conf_.owner%type,
        o_to out at_conf_.param%type,
        o_cc out at_conf_.param%type,
        o_bcc out at_conf_.param%type
    )
    is
    begin
        for r in (
            select name, param
            from at_conf_
            where owner = p_owner
                and name in (c_email_to, c_email_cc, c_email_bcc)
        ) loop
            case r.name
            when c_email_to then
                o_to := evaluated_list(r.param);
            when c_email_cc then
                o_cc := evaluated_list(r.param);
            when c_email_bcc then
                o_bcc := evaluated_list(r.param);
            end case;
        end loop;
    end get_email;

    procedure get_email(
        p_owner at_conf_.owner%type,
        o_to out at_conf_.param%type,
        o_cc out at_conf_.param%type,
        o_bcc out at_conf_.param%type,
        o_from out at_conf_.param%type,
        o_reply_to out at_conf_.param%type,
        o_return_path out at_conf_.param%type
    )
    is
    begin
        for r in (
            select name, param
            from at_conf_
            where owner = p_owner
                and name in (c_email_to, c_email_cc, c_email_bcc, c_email_reply_to, c_email_return_path)
        ) loop
            case r.name
            when c_email_to then
                o_to := evaluated_list(r.param);
            when c_email_cc then
                o_cc := evaluated_list(r.param);
            when c_email_bcc then
                o_bcc := evaluated_list(r.param);
            when c_email_from then
                o_from := evaluated_list(r.param);
            when c_email_reply_to then
                o_reply_to := evaluated_list(r.param);
            when c_email_return_path then
                o_return_path := evaluated_list(r.param);
            end case;
        end loop;
    end get_email;

    procedure delete_email(
        p_owner at_conf_.owner%type
    )
    is
    begin
        delete from at_conf_
        where owner = p_owner
            and name in (c_email_to, c_email_cc, c_email_bcc, c_email_from, c_email_reply_to, c_email_return_path);
    end delete_email;

end at_conf;
/
