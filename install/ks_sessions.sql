
create table ks_sessions (
    id             number        generated by default on null as identity (start with 1) primary key
  , event_id       number
  , event_track_id number
  , session_num    number not null
  , sub_category   varchar2(500)
  , session_type   varchar2(500)
  , title          varchar2(500)
  , presenter      varchar2(500)
  , company        varchar2(500)
  , co_presenter   varchar2(500)
  , status_code    varchar2(20)
  , notes          varchar2(4000)
  , tags           varchar2(4000)
  , created_by     varchar2(60) default 
                    coalesce(
                       sys_context('APEX$SESSION','app_user')
                       ,regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
                       ,sys_context('userenv','session_user')
                       )
                    not null
  , created_on     date         default sysdate not null
  , updated_by     varchar2(60)
  , updated_on     date
  , constraint ks_events_fk foreign key ( event_id ) references ks_events ( id ) not deferrable
  , constraint ks_event_track_sessions_fk foreign key ( event_track_id ) references ks_event_tracks ( id ) not deferrable
)
/

create unique index ks_sessions_u01 on ks_sessions(session_num);
create index ks_sessions_n01 on ks_sessions(event_id);
create index ks_sessions_n02 on ks_sessions(event_track_id);

comment on table ks_sessions is 'Event Sessions.';

comment on column ks_sessions.session_num is 'Unique session identifier assigned by ODTUG';
comment on column ks_sessions.event_id is 'Event this session belongs to.';
comment on column ks_sessions.event_track_id is 'Track this session was submitted.';
comment on column ks_sessions.presenter is 'The name of the presenter for this session.';
comment on column ks_sessions.company is 'The company the presenter works for.';
comment on column ks_sessions.created_by is 'User that created this record';
comment on column ks_sessions.created_on is 'Date the record was first created';
comment on column ks_sessions.updated_by is 'User that last modified this record';
comment on column ks_sessions.updated_on is 'Date the record was last modified';

create or replace trigger ks_sessions_iu_trg 
before insert or update
on ks_sessions
referencing old as old new as new
for each row
begin
  if updating then
    :new.updated_on := sysdate;
    :new.updated_by := coalesce(
                         sys_context('APEX$SESSION','app_user')
                         ,regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
                         ,sys_context('userenv','session_user')
                       );
  end if;
/* this install trigger gets replaces by ks_tags_post_install.sql
  ks_tags_api.tag_sync(
     p_new_tags      => :new.tags,
     p_old_tags      => :old.tags,
     p_content_type  => 'SESSION',
     p_content_id    => :new.session_num );
*/
end;
/