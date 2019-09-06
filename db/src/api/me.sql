create or replace function me() returns json as $$
declare
    usr record;
begin

    select * from data."user"
    where id = request.user_id()
    into usr;

    return json_build_object(
        'id', usr.id, 
        'name', usr.name,
        'email', usr.email, 
        'role', usr.role
    );
end
$$ stable security definer language plpgsql;

revoke all privileges on function me() from public;
