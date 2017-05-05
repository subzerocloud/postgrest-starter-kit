-- call body postprocess hook function
-- to trigger this code, one would have these lines in one of 
-- the hooks (on_rest_request, before_rest_response)
--[[
    utils.set_body_postprocess_mode(utils.postprocess_modes.ALL)
    utils.set_body_postprocess_fn(function(body)
        local b = cjson.decode(body)
        b.custom_key = 'custom_value'
        return cjson.encode(b)
    end)
--]]
local mode = utils.get_body_postprocess_mode()
local fn = utils.get_body_postprocess_fn()
if type(fn) == 'function' then
    if mode == utils.postprocess_modes.CHUNKS then
        ngx.arg[1], ngx.arg[2] = fn(ngx.arg[1], ngx.arg[2])
    end

    if mode == utils.postprocess_modes.ALL then
        local response_body = utils.buffer_response_body()
        if response_body then
            ngx.arg[1] = fn(response_body)
        end
    end
end
