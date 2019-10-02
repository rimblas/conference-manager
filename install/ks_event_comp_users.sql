PRO .. ks_event_comp_users 

-- drop table ks_event_comp_users cascade constraints purge;

-- Keep table names under 24 characters
--           1234567890123456789012345
create table ks_event_comp_users (
    id              number        generated by default on null as identity (start with 1) primary key not null
  , event_id        number        not null
  , user_id         number        not null
  , reason          varchar2(250)
  , created_by      varchar2(60) default 
                    coalesce(
                        sys_context('APEX$SESSION','app_user')
                      , regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
                      , sys_context('userenv','session_user')
                    )
                    not null
  , created_on      date         default sysdate not null
  , updated_by      varchar2(60)
  , updated_on      date
  , constraint ks_event_comp_user_fk foreign key ( event_id ) references ks_events ( id ) not deferrable
  , constraint ks_event_comp_users_fk foreign key ( user_id ) references ks_users ( id ) not deferrable
)
enable primary key using index
/

comment on table ks_event_comp_users is 'Users with attendance comps for the event';

comment on column ks_event_comp_users.id is 'Primary Key ID';
comment on column ks_event_comp_users.event_id is 'Event for which the user is comped';
comment on column ks_event_comp_users.user_id is 'User begin comped';
comment on column ks_event_comp_users.reason is 'Reason or information for comped';
comment on column ks_event_comp_users.created_by is 'User that created this record';
comment on column ks_event_comp_users.created_on is 'Date the record was first created';
comment on column ks_event_comp_users.updated_by is 'User that last modified this record';
comment on column ks_event_comp_users.updated_on is 'Date the record was last modified';


--------------------------------------------------------
--                        123456789012345678901234567890
create or replace trigger ks_event_comp_users_u_trg
before update
on ks_event_comp_users
referencing old as old new as new
for each row
begin
  :new.updated_on := sysdate;
  :new.updated_by := coalesce(
                         sys_context('APEX$SESSION','app_user')
                       , regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
                       , sys_context('userenv','session_user')
                     );
end;
/