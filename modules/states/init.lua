local objects = {}
local current, last
local statesPath = "game/states/%s"

local function load(...)

	local statesTable = {...}

	for statesTableIndex = 1, #statesTable do

		local index = statesTable[statesTableIndex]
		local stateClassPath = statesPath:format(index)

		if love.filesystem.getInfo(stateClassPath) then

			local stateClass = require(stateClassPath)
			local stateInstance = stateClass()

			objects[index] = stateInstance

		else

			print(string.format("[STATES] Couldnt load %s!", index))

		end

	end

end

local function get(index)

	index = index or current

	return objects[index]

end

local function set(index)

	if current then

		get():disable()

		last = current

	end

	current = index

	get(index):enable()

end

return {
	load = load,
	get = get,
	set = set
}