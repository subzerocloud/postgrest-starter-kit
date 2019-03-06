-- define the view which is just selecting everything from the underlying table
-- although it looks like a user would see all the rows by looking just at this definition,
-- the RLS policy defined on the underlying table attached to the view owner (api)
-- will make sure only the appropriate roles will be revealed.
-- notice how for the api we don't expose the owner_id column even though it exists and is used
-- in the RLS policy, also, while out table name is "todo", singular, meant to symbolize a data type/model,
-- the view is named "todos", plural, to match the rest conventions.
create or replace view todos as
select id, todo, private, (owner_id = request.user_id()) as mine from data.todo;
alter view todos owner to api; -- it is important to set the correct owner to the RLS policy kicks in
