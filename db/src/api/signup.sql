-- since the constraints check that all the fields are valid
-- all we have to do is to execute an insert
-- if the input data is not correct (email already exists)
-- an error will be raised
-- if we wanted to, we could catch that error here and generate a different error message
-- but we will let it bubble up and keep the function simple

create or replace function api.signup(name text, email text, password text) returns boolean as $$
declare
    usr data.users;
begin
    insert into data.users
    (name, email, password) values
    ($1, $2, $3)
    returning * into usr;

    return true;
end
$$ security definer language plpgsql;

-- by default all functions are accessible to the public, we need to remove that and define our specific access rules
revoke all privileges on function api.signup(text, text, text) from public;
