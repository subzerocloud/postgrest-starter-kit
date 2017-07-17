create or replace function signup(name text, email text, password text) returns session as $$
declare
    usr data.user;
begin
    insert into data.user
    (name, email, password) values
    ($1, $2, $3)
    returning * into usr;

    return (
        row_to_json(json_populate_record(null::"user", row_to_json(usr))),
        auth.sign_jwt(auth.get_jwt_payload(usr))
    );
end
$$ security definer language plpgsql;

revoke all privileges on function signup(text, text, text) from public;
