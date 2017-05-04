-- This file contains the definition of the applications specific roles
-- the roles defined here should not be made owners of database entities (tables/views/...)

\echo # Loading roles

-- the role used by postgrest to connect to the database
-- notice how this role does not have any privileges attached specifically to it
-- it can only switch to other roles
\set authenticator `echo $DB_USER`
\set authenticator_pass `echo $DB_PASS`
drop role if exists :authenticator;
create role :authenticator with login password :'authenticator_pass';

-- this is an applciation level role
-- requests that are not authenticated will be executed with this role's privileges
drop role if exists anonymous;
create role anonymous;
grant anonymous to :authenticator;

-- this is the main role used by authenticated users of our application
drop role if exists webuser;
create role webuser;
grant webuser to :authenticator;
