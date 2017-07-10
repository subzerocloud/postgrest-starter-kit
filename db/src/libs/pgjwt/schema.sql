-- This file is the only one in this directory that is not part of the pgjwt extension distribution
-- It deals with loading https://github.com/michelp/pgjwt extension
-- All the seemingly complicated code related to pgjwt in this file is only because of "on they fly" altering
-- of the distribution code which is meant to be installed as an extension (not possible with AWS RDS)
-- one could just manually edit that file and simply include it.
-- At th same time this goes to show the powerful features you have at your disposal of the psql meta commands

-- decide what is our base dir and the location of the file
\setenv JWT_FILE :base_dir/libs/pgjwt/pgjwt--0.0.1.sql

-- load sql definition in a variable and use sed to make the needed changes
\set pgjwt_schema pgjwt
\setenv pgjwt_schema :pgjwt_schema
\set pgjwt_sql `sed -e 's/\\echo Use "CREATE EXTENSION pgjwt" to load this file. \\quit//g' ${JWT_FILE} | sed -e "s/@extschema@/${pgjwt_schema}/g"`

-- create the jwt schema namespace and all the functions in it
create extension if not exists pgcrypto;
drop schema if exists :pgjwt_schema cascade;	
create schema :pgjwt_schema;
set search_path to pgjwt, public;
:pgjwt_sql
set search_path to public;
