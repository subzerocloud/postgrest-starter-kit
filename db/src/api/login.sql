create type api.session as (id int, name text, email text, token text);	
create or replace function api.login(email text, password text) returns api.session as $$
declare
	usr data.users;
begin
    select * into usr
    from data.users as u
    where u.email = $1 and u.password = crypt($2, u.password);

    if not found then
    	raise exception 'invalid email/password';
    else
    	return (usr.id, usr.name, usr.email,
				pgjwt.sign(
					json_build_object(
						'role', 'webuser',
						'user_id', usr.id,
						'exp', extract(epoch from now())::integer + 3600 -- token expires in 1 hour
					),
					(select value from data.secrets as s where s.key = 'jwt_secret')
				));
    end if;
end
$$ stable security definer language plpgsql;

-- by default all functions are accessible to the public, we need to remove that and define our specific access rules
revoke all privileges on function api.login(text, text) from public;
