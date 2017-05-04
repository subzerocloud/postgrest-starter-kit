\echo # Loading roles privilege
-------------------------------------------------------------------------------
-- api
grant usage on schema api to anonymous;
grant usage on schema api to webuser;
grant usage on schema request to public;
-------------------------------------------------------------------------------
-- me
grant execute on function api.me() to webuser;
-------------------------------------------------------------------------------
-- signup
grant execute on function api.signup(text, text, text) to anonymous;
-------------------------------------------------------------------------------
-- login
grant execute on function api.login(text,text) to anonymous;
grant execute on function api.login(text,text) to webuser;
-------------------------------------------------------------------------------
-- refresh_token
grant execute on function api.refresh_token() to webuser;
-------------------------------------------------------------------------------
-- items
-- give access to the view owner to this table
grant select, insert, update, delete on data.items to api;
grant usage on data.items_id_seq to webuser;
-- define the RLS policy
create policy items_access_policy on data.items to api 
using (
	-- the authenticated users can see all his items
	-- notice how the rule changes based on the current user id
	-- which is specific to each individual request
	(request.user_role() = 'webuser' and request.user_id() = owner_id)

	or
	-- everyone can see public items
	(private = false)
)
with check (
	-- authenticated users can only update/delete their items
	(request.user_role() = 'webuser' and request.user_id() = owner_id)
);

-- While grants to the view owner and the RLS policy on the underlying table 
-- takes care of what rows the view can see, we still need to define what 
-- are the rights of our application user in regard to this api view.
grant select, insert, update, delete on api.items to webuser;
grant select on api.items to anonymous;
-------------------------------------------------------------------------------
-- subitems
-- give access to the view owner to this table
grant select, insert, update, delete on data.subitems to api;
grant usage on data.subitems_id_seq to webuser;

-- define the RLS policy
-- this helper function was used because if we tried to inline the select statement
-- inside the policy, the RLS for the items table whould have kicked in
-- which would have resulted in no rows returned which in turn means
-- no subitems would be visible
create or replace function public_items() returns setof int as $$
    select id from data.items where private = false
$$ stable security definer language sql;

create policy subitems_access_policy on data.subitems to api 
using (
	-- the authenticated users can see all his items
	(request.user_role() = 'webuser' and request.user_id() = owner_id)

	or
	-- everyone can see subitems of public items
	-- while this rule is not very optimal, it shows that you can construct
	-- it using any sql you like that can access data from other tables,
	-- not just the current one
	(item_id in (select public_items()))
)
with check (
	-- authenticated users can only update/delete their subitems
	(request.user_role() = 'webuser' and request.user_id() = owner_id)
);

grant select, insert, update, delete on api.subitems to webuser;
grant select on api.subitems to anonymous;
-------------------------------------------------------------------------------

