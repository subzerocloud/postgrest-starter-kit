#!/bin/bash
# https://github.com/lehmannro/assert.sh
. assert.sh
# curl -sD - http://localhost:8080/rest/items
GET="curl http://localhost:8080/rest"

# basic GET works
assert "$GET/items?id=eq.1" '[{"id":1,"name":"item_1","private":false,"mine":null}]'

# get by primary key works
assert "$GET/items/1?select=id,name" '{"id":1,"name":"item_1"}'

# end of test suite
assert_end openresty