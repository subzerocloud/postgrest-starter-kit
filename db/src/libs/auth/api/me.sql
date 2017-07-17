create or replace function me() returns "user" as $$
   select json_populate_record(null::"user", row_to_json(u.*))
   from data.user as u
   where id = request.user_id()
$$ stable security definer language sql;

revoke all privileges on function me() from public;
