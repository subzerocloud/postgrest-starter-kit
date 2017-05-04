-- this function is in a separate file since it's very specific to the application
-- and the way the JWT payload is generated, while the other functions are generally useful
create or replace function request.user_id() returns int as $$
    select 
    case request.jwt_claim('user_id') 
    when '' then 0
    else request.jwt_claim('user_id')::int
	end
$$ stable language sql;

create or replace function request.user_role() returns text as $$
    select request.jwt_claim('role')::text;
$$ stable language sql;