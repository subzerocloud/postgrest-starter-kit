create or replace function refresh_token() returns text as $$
declare
	usr data.user;
	token text;
begin
    select * into usr
    from data.user as u
    where u.id = request.user_id();
    if not found then
    	raise exception 'user not found';
    else
    	select auth.sign_jwt(auth.get_jwt_payload(usr))
    	into token;
    	return token;
    end if;
end
$$ stable security definer language plpgsql;

-- by default all functions are accessible to the public, we need to remove that and define our specific access rules
revoke all privileges on function refresh_token() from public;
