-- response body postprocess mode
local NONE = 0
local CHUNKS = 1
local ALL = 2

local function set_body_postprocess_mode(mode)
    ngx.ctx.body_postprocess_mode = mode
end

local function get_body_postprocess_mode()
    return ngx.ctx.body_postprocess_mode
end

local function get_body_postprocess_fn()
	return ngx.ctx.body_postprocess_fn
end

local function set_body_postprocess_fn(fn)
	ngx.ctx.body_postprocess_fn = fn
end

local function buffer_response_body()
    local chunk, eof = ngx.arg[1], ngx.arg[2] 
    local buffered = ngx.ctx.buffered_respose_body 
    if not buffered then 
        buffered = {}
        ngx.ctx.buffered_respose_body = buffered 
    end 
    if chunk ~= "" then 
        buffered[#buffered + 1] = chunk 
        ngx.arg[1] = nil 
    end 
    if eof then 
        local response = table.concat(buffered)
        ngx.ctx.buffered_respose_body = nil 
        --ngx.arg[1] = response
        ngx.arg[1] = nil
        return response
    end 
end

return {
	postprocess_modes = {
		NONE = NONE,
		CHUNKS = CHUNKS,
		ALL = ALL
	},
	set_body_postprocess_mode = set_body_postprocess_mode,
	get_body_postprocess_mode = get_body_postprocess_mode,
	buffer_response_body = buffer_response_body,
	get_body_postprocess_fn = get_body_postprocess_fn,
	set_body_postprocess_fn = set_body_postprocess_fn
}