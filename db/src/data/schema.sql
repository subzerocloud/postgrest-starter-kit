\echo # Loading data schema
drop schema if exists data cascade;
create schema data;

\ir users.sql
\ir items.sql
\ir subitems.sql
\ir secrets.sql
