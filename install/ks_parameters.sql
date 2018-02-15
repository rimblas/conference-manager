create table ks_parameters (
    id            number        generated by default on null as identity (start with 1) primary key
  , category      varchar2(100) not null
  , name_key      varchar2(200) not null
  , value         varchar2(4000)
  , description   varchar2(4000)
  , created_by    varchar2(60) default 
                    coalesce(
                       sys_context('APEX$SESSION','app_user')
                       ,regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
                       ,sys_context('userenv','session_user')
                       )
                    not null
  , created_on    date         default sysdate not null
  , updated_by    varchar2(60)
  , updated_on    date
)
enable primary key using index
/

create unique index ks_parameters_u01
  on ks_parameters(name_key)
/

comment on table ks_parameters is 'Application parameters.';

comment on column ks_parameters.category is 'Informational field to group parameters by functional area. New categories are added by a developer.';
comment on column ks_parameters.name_key is 'Unique name to identify a parameter.';

--------------------------------------------------------
--  DDL for Trigger ks_parameters_u_trg
--------------------------------------------------------
create or replace trigger ks_parameters_u_trg
before insert or update
on  ks_parameters
referencing old as old new as new
for each row
begin
  :new.updated_on := sysdate;
  :new.updated_by := coalesce(
                     sys_context('APEX$SESSION','app_user')
                     ,regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
                     ,sys_context('userenv','session_user')
                     );

end;
/
alter trigger ks_parameters_u_trg enable;
