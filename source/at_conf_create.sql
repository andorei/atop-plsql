create table at_conf_ (
    owner varchar2(30) not null,
    name varchar2(30) not null,
    param varchar2(4000) not null,
    descr varchar2(4000) null,
    constraint at_conf_pk primary key (owner, name)
);

comment on table at_conf_ is 'Configuration parameters';
comment on column at_conf_.owner is 'Parameter owner';
comment on column at_conf_.name is 'Parameter name';
comment on column at_conf_.param is 'Parameter value';
comment on column at_conf_.descr is 'Parameter description';

create or replace view at_conf_email as
select par_to.owner owner, par_to.param email_to, par_cc.param email_cc, par_bcc.param email_bcc, par_to.descr descr
from
    (select owner, param, descr from at_conf_ where name = '@@email_to') par_to,
    (select owner, param from at_conf_ where name = '@@email_cc') par_cc,
    (select owner, param from at_conf_ where name = '@@email_bcc') par_bcc
where par_to.owner = par_cc.owner(+)
    and par_to.owner = par_bcc.owner(+)
;
