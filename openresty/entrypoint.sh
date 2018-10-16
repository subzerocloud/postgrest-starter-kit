#!/bin/sh
set -e

# nginx needes resolver definitions for the host name to work
# since that (IP) is a specific setting for each deployment
# we make it by translating the hostname on startup
DB_HOST=`getent hosts $DB_HOST | awk '{ print $1 }'`
POSTGREST_HOST=`getent hosts $POSTGREST_HOST | awk '{ print $1 }'`
exec /usr/local/openresty/bin/openresty -g "daemon off; error_log /dev/stderr info;"