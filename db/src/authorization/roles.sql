-- This file contains the definition of the applications specific roles
-- the roles defined here should not be made owners of database entities (tables/views/...)

\echo # Loading roles

-- the role used by postgrest to connect to the database
-- notice how this role does not have any privileges attached specifically to it
-- it can only switch to other roles
drop role if exists :authenticator;
create role :"authenticator" with login password :'authenticator_pass';

-- this is an application level role
-- requests that are not authenticated will be executed with this role's privileges

drop role if exists :"anonymous";
create role :"anonymous";
grant :"anonymous" to :"authenticator";


-- create all the applications user roles that are defined using the "user_role" type
-- we use a function here in order to be able add new roles just by redefining the type
create or replace function _temp_create_application_roles("authenticator" text, "roles" text[]) returns void as $$
declare r record;
begin
for r in
   select unnest(roles) as role
loop
   execute 'drop role if exists ' || quote_ident(r.role);
   execute 'create role ' || quote_ident(r.role);
   execute 'grant ' || quote_ident(r.role) || ' to ' || quote_ident(authenticator);
end loop;
end;
$$  language plpgsql;;

select _temp_create_application_roles(:'authenticator', enum_range(null::data.user_role)::text[]);
drop function _temp_create_application_roles(text, text[]);
