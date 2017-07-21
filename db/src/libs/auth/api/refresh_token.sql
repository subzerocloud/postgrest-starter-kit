create or replace function refresh_token() returns text as $$
declare
	usr record;
	token text;
begin
    EXECUTE 'SET search_path TO ' || quote_ident(settings.get('auth.data-schema')) || ', public';
    select row_to_json(u.*) as j into usr
    from "user" as u
    where u.id = request.user_id();

    RESET search_path;
    
    if not found then
    	raise exception 'user not found';
    else
    	select auth.sign_jwt(auth.get_jwt_payload(usr.j))
    	into token;
    	return token;
    end if;
end
$$ security definer language plpgsql;

-- by default all functions are accessible to the public, we need to remove that and define our specific access rules
revoke all privileges on function refresh_token() from public;
