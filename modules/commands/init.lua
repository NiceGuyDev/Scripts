local registered = {}

local function create(name, func)

	registered[name] = func

end

local function call(name, ...)

	registered[name](...)

end

return {create = create, call = call}