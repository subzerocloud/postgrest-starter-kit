begin;
select * from no_plan();

select has_schema('information_schema');

select has_view('information_schema', 'routines', 'has routines information_schema.routines view');

select has_column('information_schema', 'routines', 'specific_name', 'has information_schema.routines.specific_name column');

select * from finish();
rollback;
