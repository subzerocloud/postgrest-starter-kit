create table todo (
	id    serial primary key,
	todo  text not null,
	private boolean default true,  
	owner_id int references "user"(id) default request.user_id()
);

-- attach the trigger to send events to rabbitmq
-- there is a 8000 bytes hard limit on the message payload size (PG NOTIFY) so it's better not to send data that is not used
-- on_row_change call can take the following forms
-- on_row_change() - send all columns
-- on_row_change('{"include":["id"]}'::json) - send only the listed columns
-- on_row_change('{"exclude":["bigcolumn"]}'::json) - exclude listed columns from the payload

create trigger send_todo_change_event
after insert or update or delete on todo
for each row execute procedure rabbitmq.on_row_change('{"include":["id","todo"]}');