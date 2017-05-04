create table data.subitems ( -- df: mult=6.0
	id    serial primary key,
	name  text not null,
	item_id int references data.items(id),
	owner_id int references data.users(id) default request.user_id()
);
-- the default policy should be to enable RLS for all tables then selectively allow access to rows
alter table data.subitems enable row level security;