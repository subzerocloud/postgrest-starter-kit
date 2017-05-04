-- define the view which is just selecting everything from the underlying table
-- although it looks like a user would see all the rows by looking just at this definition,
-- the RLS policy defined on the underlying table attached to the view owner (api_users)
-- will make sure only the appropriate roles will be reviled.
-- notice how for the api we don't expose the owner_id column even though it exists and is used
-- in the RLS policy
create or replace view api.items as
select id, name, private, (owner_id = request.user_id()) as mine from data.items;
alter view api.items owner to api; -- it is important to set the correct owner to the RLS policy kicks in