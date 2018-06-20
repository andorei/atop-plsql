create or replace package at_delta2 is
/*******************************************************************************
    For delta client to acknowledge reception of delta.

Changelog
    2016-08-30 Andrei Trofimov create package
    2018-04-06 Andrei Trofimov redesign API

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

    -- Acknowledge reception of changes with cnum <= p_last_cnum.
    procedure acknowledge(
        p_client at_svs_.client%type,
        p_service at_svs_.service%type,
        p_last_scn at_svs_.last_scn%type
    );

end at_delta2;
/
create or replace package body at_delta2 is

    -- Acknowledge reception of changes with cnum <= p_last_cnum.
    procedure acknowledge(
        p_client at_svs_.client%type,
        p_service at_svs_.service%type,
        p_last_scn at_svs_.last_scn%type
    ) is
    begin
        update at_svs_
        set last_scn = p_last_scn,
            last_when = systimestamp
        where client = upper(p_client)
            and service = upper(p_service)
        ;
        if sql%rowcount = 0 then
            raise_application_error(-20005, 'Failed to acknowledge: "'||p_client||'", "'||p_service||'"');
        end if;
    end acknowledge;

end at_delta2;
/
