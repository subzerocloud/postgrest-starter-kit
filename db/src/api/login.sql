
create or replace function login(email text, password text) returns json as $$
declare
    usr record;
begin

	select * from data."user" as u
    where u.email = $1 and u.password = public.crypt($2, u.password)
   	INTO usr;

    if usr is NULL then
        raise exception 'invalid email/password';
    else
        
        return json_build_object(
            'me', json_build_object(
                'id', usr.id,
                'name', usr.name,
                'email', usr.email,
                'role', 'customer'
            ),
            'token', pgjwt.sign(
                json_build_object(
                    'role', usr.role,
                    'user_id', usr.id,
                    'exp', extract(epoch from now())::integer + settings.get('jwt_lifetime')::int -- token expires in 1 hour
                ),
                settings.get('jwt_secret')
            )
        );
    end if;
end
$$ stable security definer language plpgsql;
-- by default all functions are accessible to the public, we need to remove that and define our specific access rules
revoke all privileges on function login(text, text) from public;