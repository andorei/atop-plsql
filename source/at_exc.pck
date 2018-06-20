create or replace package at_exc is
/*******************************************************************************
    Provide basic utilities.

Changelog
    2017-12-27 Andrei Trofimov create package.

********************************************************************************
Copyright (C) 2017, 2018 by Andrei Trofimov

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
    c_assertion_error_code constant pls_integer := -20001;
    c_invalid_argument_code constant pls_integer := -20002;
    c_does_not_exist_code constant pls_integer := -20003;
    c_already_exists_code constant pls_integer := -20004;
    c_general_error_code constant pls_integer := -20005;
    
    assertion_error exception;
    pragma exception_init(assertion_error, -20001);
    invalid_argument exception;
    pragma exception_init(invalid_argument, -20002);
    does_not_exist exception;
    pragma exception_init(does_not_exist, -20003);
    already_exists exception;
    pragma exception_init(already_exists, -20004);
    general_error exception;
    pragma exception_init(general_error, -20005);
    
    -- Raise application error with p_message and p_error_code.
    procedure fail(
        p_message varchar2 default null,
        p_error_code pls_integer default c_general_error_code
    );
    
    -- Raise assertion error with p_message unless p_condition is true.
    procedure assert(p_condition boolean, p_message varchar2 default null);

    -- Raise invalid_argument with p_message unless p_condition is true.
    procedure validate(p_condition boolean, p_message varchar2 default null);
/*
    procedure demo;
*/
end at_exc;
/
create or replace package body at_exc is

    -- Raise application error with p_message and p_error_code.
    procedure fail(
        p_message varchar2 default null,
        p_error_code pls_integer default c_general_error_code
    ) is
    begin
        raise_application_error(p_error_code, nvl(p_message, '[no message]'));
    end fail;
            
    -- Raise assertion_error with p_message unless p_condition is true.
    procedure assert(p_condition boolean, p_message varchar2 default null)
    is
    begin
        if p_condition is null or not p_condition then
            raise_application_error(
                c_assertion_error_code,
                'Assertion error' ||
                case 
                    when p_message is not null then 
                        ': ' || p_message 
                    else ''
                end
            );
        end if;
    end assert;

    -- Raise invalid_argument with p_message unless p_condition is true.
    procedure validate(p_condition boolean, p_message varchar2 default null)
    is
    begin
        if p_condition is null or not p_condition then
            raise_application_error(
                c_invalid_argument_code,
                'Invalid argument' ||
                case 
                    when p_message is not null then 
                        ': ' || p_message 
                    else ''
                end
            );
        end if;
    end validate;
/*
    procedure demo
    is
    begin
        
        declare
            -- let these be parameters
            p_one varchar2(50) := 'hello';
            p_two varchar2(50) := 'bye';
        begin
            at_exc.validate(p_one is not null and p_two is not null);
            at_exc.validate(length(p_one) = length(p_two));
        exception
            when at_exc.invalid_argument or at_exc.assertion_error then
                at_out.p(sqlerrm);
        end;
        
        declare
            -- let these be parameters
            p_one varchar2(50) := 'hello';
            p_two varchar2(50) := 'bye';
        begin
            at_exc.assert(length(p_one) = length(p_two));
        exception
            when at_exc.invalid_argument or at_exc.assertion_error then
                at_out.p(sqlerrm);
        end;

    end demo;
*/    
end at_exc;
/
