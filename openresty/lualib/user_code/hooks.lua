local function on_init()
    -- print "on_init called"
end

local function on_rest_request()
    -- print "on_rest_request called"
end

local function before_rest_response()
    -- print "before_rest_response called"
end

return {
    on_init = on_init,
    on_rest_request = on_rest_request,
    before_rest_response = before_rest_response,
}