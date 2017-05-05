cjson = require('cjson')
utils = require('utils')

hooks = {}
local _status, _hooks = pcall(require, "hooks")
if _status then
    hooks = _hooks
end

if type(hooks.on_init) == 'function' then
	hooks.on_init()
end

