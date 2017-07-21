create or replace function signup(name text, email text, password text) returns session as $$
declare
    usr record;
    result record;
begin
	EXECUTE 'SET search_path TO ' || quote_ident(settings.get('auth.data-schema')) || ', public';
    insert into "user" as u
    (name, email, password) values
    ($1, $2, $3)
    returning row_to_json(u.*) as j into usr;

    EXECUTE 'SET search_path TO ' || quote_ident(settings.get('auth.api-schema')) || ', public';
    result := (
        row_to_json(json_populate_record(null::"user", usr.j)),
        auth.sign_jwt(auth.get_jwt_payload(usr.j))
    );


    RESET search_path;
    return result;
end
$$ security definer language plpgsql;

revoke all privileges on function signup(text, text, text) from public;
