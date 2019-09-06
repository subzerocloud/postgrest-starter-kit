create or replace function signup(name text, email text, password text) returns json as $$
declare
    usr record;
begin
    insert into data."user" as u
    (name, email, password) values ($1, $2, $3)
    returning *
   	into usr;

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
end
$$ security definer language plpgsql;

revoke all privileges on function signup(text, text, text) from public;
