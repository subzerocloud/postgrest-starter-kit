create or replace function me() returns "user" as $$
declare
	usr record;
begin
	EXECUTE 'SET search_path TO ' || quote_ident(settings.get('auth.data-schema')) || ', public';
	select row_to_json(u.*) as j into usr
    from "user" as u
    where id = request.user_id();

    EXECUTE 'SET search_path TO ' || quote_ident(settings.get('auth.api-schema')) || ', public';
	select json_populate_record(null::"user", usr.j) as r into usr;

	RESET search_path;
	return usr.r;
end
$$ security definer language plpgsql;

revoke all privileges on function me() from public;
