create or replace function signup(name text, email text, password text) returns session as $$
declare
    usr record;
    result record;
    usr_api record;
begin
    EXECUTE format(
        ' insert into %I."user" as u'
        ' (name, email, password) values'
        ' ($1, $2, $3)'
        ' returning row_to_json(u.*) as j'
		, quote_ident(settings.get('auth.data-schema')))
   	INTO usr
   	USING $1, $2, $3;

    EXECUTE format(
        ' select json_populate_record(null::%I."user", $1) as r'
        , quote_ident(settings.get('auth.api-schema')))
    INTO usr_api
    USING usr.j;

    result := (
        row_to_json(usr_api.r),
        auth.sign_jwt(auth.get_jwt_payload(usr.j))
    );

    return result;
end
$$ security definer language plpgsql;

revoke all privileges on function signup(text, text, text) from public;
