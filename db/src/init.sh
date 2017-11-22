#!/bin/bash

CUSTOM_CONFIG=$(cat <<EOF
#------------------------------------------------------------------------------
# CUSTOM SETTINGS (they override the values set above in the config)
#------------------------------------------------------------------------------

# log all queries
log_statement = 'all'

# a few settings to speed up schema reloading at the expense of durability
fsync = off
synchronous_commit = off
full_page_writes = off
EOF
)

set -e

if [ "$DEVELOPMENT" = '1' ]; then
	echo "${CUSTOM_CONFIG}" >> /var/lib/postgresql/data/postgresql.conf
fi