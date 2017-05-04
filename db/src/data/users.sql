create table data.users ( -- df: mult=1.0
	id                   serial primary key,
	name                 text not null,
	email                text not null unique, -- df: pattern='user\.[:count format=X:]@email\.com'
	"password"           text not null,

	check (length(name)>2),
	check (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$')
);
-- the default policy should be to enable RLS for all tables then selectively allow access to rows
alter table data.users enable row level security;

-- Below are table specific functions/triggers
-- If you end up having a lot of them, it's a good idea to extract them in separate files
-- placed in "users" directory and use \ir meta command

-- whenever an insert/update happens, this trigger will take care of encrypting the password before storing it
-- this means that when you do and insert/update, the application code can send the password in clear text
create extension if not exists pgcrypto;
create or replace function data.encrypt_pass() returns trigger as $$
begin
  new.password = crypt(new.password, gen_salt('bf'));
  return new;
end
$$ language plpgsql;

create trigger users_encrypt_pass_trigger
  before insert or update on data.users
  for each row
  execute procedure data.encrypt_pass();
