create table todo (
	id    serial primary key,
	todo  text not null,
	private boolean default true,  
	owner_id int references "user"(id) default request.user_id()
);

create trigger send_change_event
after insert or update or delete on todo
for each row execute procedure rabbitmq.on_row_change();
