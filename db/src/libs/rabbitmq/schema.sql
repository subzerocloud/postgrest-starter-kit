drop schema if exists rabbitmq cascade;
create schema rabbitmq;
grant usage on schema rabbitmq to public;

create or replace function rabbitmq.send_message(
  channel text,
  routing_key text,
  message text) returns void as $$
     
  select  pg_notify(
    channel,  
    routing_key || '|' || message
  );
$$ stable language sql;

create or replace function rabbitmq.on_row_change() returns trigger as $$
  declare
    routing_key text;
    row record;
  begin
    routing_key := 'row_change'
                   '.table-'::text || TG_TABLE_NAME::text || 
                   '.event-'::text || TG_OP::text;
    if (TG_OP = 'DELETE') then
        row := old;
    elsif (TG_OP = 'UPDATE') then
        row := new;
    elsif (TG_OP = 'INSERT') then
        row := new;
    end if;
    perform rabbitmq.send_message('events', routing_key, row_to_json(row)::text);
    return null;
  end;
$$ stable language plpgsql;
