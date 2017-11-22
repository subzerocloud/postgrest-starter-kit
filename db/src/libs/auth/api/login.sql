
create or replace function login(email text, password text) returns session as $$
declare
    usr record;
    usr_api record;
    result record;
begin

    EXECUTE format(
		' select row_to_json(u.*) as j'
        ' from %I."user" as u'
        ' where u.email = $1 and u.password = crypt($2, u.password)'
		, quote_ident(settings.get('auth.data-schema')))
   	INTO usr
   	USING $1, $2;

    if usr is NULL then
        raise exception 'invalid email/password';
    else
        EXECUTE format(
            ' select json_populate_record(null::%I."user", $1) as r'
		    , quote_ident(settings.get('auth.api-schema')))
   	    INTO usr_api
	    USING usr.j;

        result = (
            row_to_json(usr_api.r),
            auth.sign_jwt(auth.get_jwt_payload(usr.j))
        );
        return result;
    end if;
end
$$ stable security definer language plpgsql;
-- by default all functions are accessible to the public, we need to remove that and define our specific access rules
revoke all privileges on function login(text, text) from public;