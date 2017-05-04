create table data.items ( -- df: mult=3.0
	id    serial primary key,
	name  text not null,
	private boolean default true,  
	owner_id int references data.users(id) default request.user_id()
);
-- the default policy should be to enable RLS for all tables then selectively allow access to rows
alter table data.items enable row level security;
