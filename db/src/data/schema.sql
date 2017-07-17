drop schema if exists data cascade;
create schema data;
set search_path = data, public;

-- import the type specifying the types of users we have (this is an enum).
-- you most certainly will have to redefine this type for your application
\ir ../libs/auth/data/user_role_type.sql

-- import the default table definition for the user model used by the auth lib
-- you can choose to define the "user" table yourself if you need additional columns
\ir ../libs/auth/data/user.sql

-- import our application models
\ir todo.sql
