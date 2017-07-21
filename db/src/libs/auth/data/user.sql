select settings.set('auth.data-schema', current_schema);
create table "user" (
	id                   serial primary key,
	name                 text not null,
	email                text not null unique,
	"password"           text not null,
	"role"				 user_role not null default settings.get('auth.default-role')::user_role,

	check (length(name)>2),
	check (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$')
);

create trigger user_encrypt_pass_trigger
before insert or update on "user"
for each row
execute procedure auth.encrypt_pass();
