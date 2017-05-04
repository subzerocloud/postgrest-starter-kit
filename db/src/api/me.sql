create type api.user as (id int, name text, email text);

create or replace function api.me() returns api.user as $$
   select id, name, email 
   from data.users
   where id = request.user_id()

$$ stable security definer language sql;

revoke all privileges on function api.me() from public;