create or replace view api.subitems as
select id, name, item_id, (owner_id = request.user_id()) as mine from data.subitems;
alter view api.subitems owner to api;