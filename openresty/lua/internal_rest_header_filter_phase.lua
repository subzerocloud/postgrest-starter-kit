-- call hook function if present
if type(hooks.before_rest_response) == 'function' then
	hooks.before_rest_response()
end