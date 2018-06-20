create table at_log_ (
    id       number primary key,
    when     timestamp with time zone not null,
    kind     char not null,
    message  varchar2(4000) not null,
    addinfo  varchar2(4000),
    progname varchar2(50) not null,
    username varchar2(50) not null,
    tag      varchar2(50),
    constraint at_log_kind_ck check (kind in ('i','d','w','e','p'))
);

comment on table at_log_ is 'Log table for applications';
comment on column at_log_.id is 'Log record id';
comment on column at_log_.when is 'Log record creation time';
comment on column at_log_.kind is 'Log record type';
comment on column at_log_.message is 'Message';
comment on column at_log_.addinfo is 'Additional info';
comment on column at_log_.progname is 'Program name';
comment on column at_log_.username is 'User name, if applicable';
comment on column at_log_.tag is 'Keyword to further specify logging context';

create sequence at_log_seq;
