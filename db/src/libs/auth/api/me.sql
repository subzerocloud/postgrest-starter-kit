create or replace function me() returns "user" as $$
declare
	usr record;
begin
	
	EXECUTE format(
		' select row_to_json(u.*) as j'
		' from %I."user" as u'
		' where id = $1'
		, quote_ident(settings.get('auth.data-schema')))
   	INTO usr
   	USING request.user_id();

	EXECUTE format(
		'select json_populate_record(null::%I."user", $1) as r'
		, quote_ident(settings.get('auth.api-schema')))
   	INTO usr
	USING usr.j;

	return usr.r;
end
$$ stable security definer language plpgsql;

revoke all privileges on function me() from public;
