create table at_cdc_ (
    capture    varchar2(20),
    cdc_type   varchar2(10) not null,
    descr      varchar2(4000),
    preserved  number(1) default 0 not null,
    constraint at_cdc_pk primary key (capture),
    constraint at_cdc_ck check (cdc_type in ('deltascn', 'orarowscn', 'seqn')),
    constraint at_cdc_preserved_ck check (preserved in (0, 1))
);
comment on table at_cdc_ is 'Change data captures';
comment on column at_cdc_.capture is 'Capture name';
comment on column at_cdc_.cdc_type is 'CDC type';
comment on column at_cdc_.descr is 'Capture description';
comment on column at_cdc_.preserved is '1 - do not delete processed rows; 0 - delete processed rows';

create table at_svs_ (
    service    varchar2(30),
    client     varchar2(20),
    capture    varchar2(20),
    descr      varchar2(4000),
    last_scn   number default 0 not null,
    last_when  timestamp with time zone default systimestamp,
    constraint at_svs_pk primary key (client, service),
    constraint at_svs_cdc_fk foreign key (capture) references at_cdc_
);
comment on table at_svs_ is 'Change data capture client''s services';
comment on column at_svs_.service is 'Service name';
comment on column at_svs_.client is 'Client name';
comment on column at_svs_.capture is 'Capture name';
comment on column at_svs_.descr is 'Description';
comment on column at_svs_.last_scn is 'Max SCN already processed by client';
comment on column at_svs_.last_when is 'Last time client used the service';
