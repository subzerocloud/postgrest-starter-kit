drop schema if exists api cascade;
create schema api;
set search_path = api, public;

-- this role will be used as the owner of the views in the api schema
-- it is needed for the definition of the RLS policies
drop role if exists api;
create role api;
grant api to current_user; -- this is a workaround for RDS where the master user does not have SUPERUSER priviliges  

-- redifine this type to control the user properties returned by auth endpoints
\ir ../libs/auth/api/user_type.sql
-- include all auth endpoints
\ir ../libs/auth/api/all.sql

-- our endpoints
\ir todos.sql
