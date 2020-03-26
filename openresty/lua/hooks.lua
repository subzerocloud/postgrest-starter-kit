local utils = require 'utils'
local cjson = require 'cjson'

local function on_init()
    -- print "on_init called"
end

local function on_rest_request()
    -- print "on_rest_request called"
end

local function before_rest_response()
    -- print "before_rest_response called"
    -- postprocess response
    -- utils.set_body_postprocess_mode(utils.postprocess_modes.ALL)
    -- utils.set_body_postprocess_fn(function(body)
    --     local b = cjson.decode(body)
    --     b.custom_key = 'custom_value'
    --     return cjson.encode(b)
    -- end)
end

return {
    on_init = on_init,
    on_rest_request = on_rest_request,
    before_rest_response = before_rest_response,
}