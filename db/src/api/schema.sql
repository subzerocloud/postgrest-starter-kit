\echo # Loading api schema
drop schema if exists api cascade;
create schema api;

-- this role will be used as the owner of the views in the api schema
-- it is used in the definition of the RLS policies for tables accessed
-- by the views
drop role if exists api;
create role api;

\ir me.sql
\ir items.sql
\ir subitems.sql
\ir signup.sql
\ir login.sql
\ir refresh_token.sql

