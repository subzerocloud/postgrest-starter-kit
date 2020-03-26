-- support /endpoint/:id url style
local m, err = ngx.re.match(ngx.var.uri, "^/([a-z_]+)/([0-9]+)")
if m then
    ngx.req.set_uri('/' .. m[1])
    local args = ngx.req.get_uri_args()
    args.id = 'eq.' .. m[2]
    ngx.req.set_uri_args(args)
    ngx.req.set_header('Accept', 'application/vnd.pgrst.object+json')
end

-- call hook function if present
if type(hooks.on_rest_request) == 'function' then
	hooks.on_rest_request()
end
