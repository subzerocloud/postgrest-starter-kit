create or replace function api.refresh_token() returns text as $$
declare
	usr data.users;
	token text;
begin
    select * into usr
    from data.users as u
    where u.id = request.user_id();
    if not found then
    	raise exception 'user not found';
    else
    	select
			pgjwt.sign(
				json_build_object(
					'role', 'webuser',
					'user_id', usr.id,
					'exp', extract(epoch from now())::integer + 3600 -- token expires in 1 hour
					),
				(select value from data.secrets as s where s.key = 'jwt_secret')
            )
    	into token;
    	return token;
    end if;
end
$$ stable security definer language plpgsql;

-- by default all functions are accessible to the public, we need to remove that and define our specific access rules
revoke all privileges on function api.refresh_token() from public;
