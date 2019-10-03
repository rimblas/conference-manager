PRO ks_users_v
create or replace view ks_users_v
as
select u.id
     , u.username
     , u.password
     , u.first_name
     , u.last_name
     , u.first_name || nvl2(u.last_name, ' ' || u.last_name, '') full_name
     , u.first_name || nvl2(u.last_name, ' ' || u.last_name, '')  || nvl2(u.first_name || u.last_name, ' (','') || u.username || nvl2(u.first_name || u.last_name, ')','') full_name_extended
     , u.email
     , u.active_ind
     , u.admin_ind
     , u.external_sys_ref
     , u.expired_passwd_flag
     , u.login_attempts
     , u.last_login_date
     , u.created_by
     , u.created_on
     , u.updated_by
     , u.updated_on
  from ks_users u
/
