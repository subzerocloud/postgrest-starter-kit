create type user_role as enum ('webuser');
create table "user" (
	id                   serial primary key,
	name                 text not null,
	email                text not null unique,
	"password"           text not null,
	"role"               user_role not null default 'webuser',

	check (length(name)>2),
	check (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$')
);

create or replace function encrypt_pass() returns trigger as $$
begin
  if new.password is not null then
  	new.password = public.crypt(new.password, public.gen_salt('bf'));
  end if;
  return new;
end
$$ language plpgsql;

create trigger user_encrypt_pass_trigger
before insert or update on "user"
for each row
execute procedure encrypt_pass();

-- attach the trigger to send events to rabbitmq
-- there is a 8000 bytes hard limit on the message payload size (PG NOTIFY) so it's better not to send data that is not used
-- on_row_change call can take the following forms
-- on_row_change() - send all columns
-- on_row_change('{"include":["id"]}'::json) - send only the listed columns
-- on_row_change('{"exclude":["bigcolumn"]}'::json) - exclude listed columns from the payload

create trigger send_user_change_event
after insert or update or delete on "user"
for each row execute procedure rabbitmq.on_row_change('{"include":["id","name","email","role"]}');