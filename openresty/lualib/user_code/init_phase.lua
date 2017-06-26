cjson = require('cjson')
utils = require('utils')

hooks = require("hooks")

if type(hooks.on_init) == 'function' then
	hooks.on_init()
end

