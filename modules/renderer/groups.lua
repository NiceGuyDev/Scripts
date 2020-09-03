local groups = {}
local order = {}

RENDER_GROUP_GAME = 1

local function create(name)
		
	assert(name, "[RENDERER] Missing string for group name.")

	groups[name] = {
		num = 0,
		funcs = {},
		owners = {}
	}

	table.insert(order, name)

end

local function add(name, func, owner)
	
	local groupData = groups[name]

	if groupData and func then

		local nextID = groupData.num + 1

		groupData.owners[nextID] = owner
		groupData.funcs[nextID] = func
		groupData.num = nextID

		return nextID

	end

end

local function draw(interpolation)

	for orderIndex = 1, #order do

		local groupName = order[orderIndex]
		local groupData = groups[groupName]

		if groupData then

			for i = 1, groupData.num do

				groupData.funcs[i](groupData.owners[i], interpolation)

			end

		end

	end

end

return {
	create = create,
	add = add,
	draw = draw
}