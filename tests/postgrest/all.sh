#!/bin/bash
# https://github.com/lehmannro/assert.sh
. assert.sh

GET="curl http://localhost:3000"

# basic GET directly to postgrest works
assert "$GET/items?id=eq.1" '[{"id":1,"name":"item_1","private":false,"mine":null}]'

# end of test suite
assert_end postgrest