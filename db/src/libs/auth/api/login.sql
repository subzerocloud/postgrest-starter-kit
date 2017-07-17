set search_path = api, public;
create or replace function login(email text, password text) returns session as $$
declare
    usr data.user;
begin
    select * into usr
    from data.user as u
    where u.email = $1 and u.password = crypt($2, u.password);

    if not found then
        raise exception 'invalid email/password';
    else
        return (
            row_to_json(json_populate_record(null::"user", row_to_json(usr))),
            auth.sign_jwt(auth.get_jwt_payload(usr))
        );
    end if;
end
$$ stable security definer language plpgsql;
-- by default all functions are accessible to the public, we need to remove that and define our specific access rules
revoke all privileges on function login(text, text) from public;