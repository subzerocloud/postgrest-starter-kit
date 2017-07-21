
create or replace function login(email text, password text) returns session as $$
declare
    usr record;
    result record;
begin
    EXECUTE 'SET search_path TO ' || quote_ident(settings.get('auth.data-schema')) || ', public';

    select row_to_json(u.*) as j into usr
    from "user" as u
    where u.email = $1 and u.password = crypt($2, u.password);
    

    if not found then
        RESET search_path;
        raise exception 'invalid email/password';
    else
        EXECUTE 'SET search_path TO ' || quote_ident(settings.get('auth.api-schema')) || ', public';
        result = (
            row_to_json(json_populate_record(null::"user", usr.j)),
            auth.sign_jwt(auth.get_jwt_payload(usr.j))
        );
        RESET search_path;
        return result;
    end if;
end
$$ security definer language plpgsql;
-- by default all functions are accessible to the public, we need to remove that and define our specific access rules
revoke all privileges on function login(text, text) from public;