select settings.set('auth.api-schema', current_schema);
create type "user" as (id int, name text, email text, role text);
