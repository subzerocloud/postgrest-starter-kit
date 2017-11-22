create or replace function refresh_token() returns text as $$
declare
	usr record;
	token text;
begin

    EXECUTE format(
		' select row_to_json(u.*) as j'
        ' from %I."user" as u'
        ' where u.id = $1'
		, quote_ident(settings.get('auth.data-schema')))
   	INTO usr
   	USING request.user_id();

    if usr is NULL then
    	raise exception 'user not found';
    else
    	select auth.sign_jwt(auth.get_jwt_payload(usr.j))
    	into token;
    	return token;
    end if;
end
$$ stable security definer language plpgsql;

-- by default all functions are accessible to the public, we need to remove that and define our specific access rules
revoke all privileges on function refresh_token() from public;
