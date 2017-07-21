\echo # Loading auth schema

-- functions for JWT token generation in the database context
\ir ../pgjwt/schema.sql


drop schema if exists auth cascade;
create schema auth;
set search_path = auth, public;

create extension if not exists pgcrypto;



create or replace function encrypt_pass() returns trigger as $$
begin
  if new.password is not null then
  	new.password = crypt(new.password, gen_salt('bf'));
  end if;
  return new;
end
$$ language plpgsql;


create or replace function sign_jwt(json) returns text as $$
    select pgjwt.sign($1, settings.get('jwt_secret'))
$$ stable language sql;

create or replace function get_jwt_payload(json) returns json as $$
    select json_build_object(
                'role', $1->'role',
                'user_id', $1->'id',
                'exp', extract(epoch from now())::integer + settings.get('jwt_lifetime')::int -- token expires in 1 hour
            )
$$ stable language sql;


create or replace function set_auth_endpoints_privileges("schema" text, "anonymous" text, "roles" text[]) returns void as $$
declare r record;
begin
  execute 'grant execute on function ' || quote_ident(schema) || '.login(text,text) to ' || quote_ident(anonymous);
  execute 'grant execute on function ' || quote_ident(schema) || '.signup(text,text,text) to ' || quote_ident(anonymous);
  for r in
     select unnest(roles) as role
  loop
     execute 'grant execute on function ' || quote_ident(schema) || '.me() to ' || quote_ident(r.role);
     execute 'grant execute on function ' || quote_ident(schema) || '.login(text,text) to ' || quote_ident(r.role);
     execute 'grant execute on function ' || quote_ident(schema) || '.refresh_token() to ' || quote_ident(r.role);
  end loop;
end;
$$  language plpgsql;;

