#!/bin/sh
set -e

if [ "$DEVELOPMENT" = '1' ]; then
	echo "Enabling query logging"
	perl -pi -e "s/#log_statement = 'none'/log_statement = 'all'/g" /var/lib/postgresql/data/postgresql.conf
	echo "Switching to nonpersistent mode to gain some speed when resetting the database"
	perl -pi -e "s/#fsync = on/fsync = off/g" /var/lib/postgresql/data/postgresql.conf
	perl -pi -e "s/#synchronous_commit = on/synchronous_commit = off/g" /var/lib/postgresql/data/postgresql.conf
	perl -pi -e "s/#full_page_writes = on/full_page_writes = off/g" /var/lib/postgresql/data/postgresql.conf
fi