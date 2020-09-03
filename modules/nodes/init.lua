local objectsIncrement = 0
local classes = {}
local objects = {}
local scripts = {} 

local relations = {
	childs = {},
	parents = {}
}

local function register(class, name)

	local registeredClass = {
		num = 0,
		class = class,
		IDS = {}
	}

	classes[class:getType()] = registeredClass

end

local function getClass(name)

	return classes[name]

end

local function getObjectParent(index)

	return relations.parents[index]

end

local function getObjectChilds(index)

	return relations.childs[index]

end

local function getObject(objectIndex)

	return objects[objectIndex]

end

local function addObjectRelation(childID, parentID)

	local childObject = getObject(childID)

	if childObject then

		local childs = relations.childs[parentID]

		if not childs then

			childs = {}
			relations.childs[parentID] = childs

		end

		relations.parents[childID] = parentID

		return table.insert(childs, childID)

	end

end

local function clearObjectRelation(objectID)

	local childsList = relations.childs[objectID]

	if childsList then

		for relationID = #childsList, 1, -1 do

			local relationChildID = childsList[relationID]

			relations.parents[relationChildID] = nil

			table.remove(childsList, relationID)

		end

	end

end

local function removeObjectRelation(childID, parentID)

	local childObject = getObject(childID)

	if childObject then

		local childsList = relations.childs[parentID]

		if childsList then

			for relationID = #childsList, 1, -1 do

				local relationChildID = childsList[relationID]

				if relationChildID == childID then

					relations.parents[childID] = nil

					table.remove(childsList, relationID)
					
					return relationID

				end

			end

		end

	end

end

local function create(name, parent)

	local registeredClass = getClass(name)

	if registeredClass then

		objectsIncrement = objectsIncrement + 1

		local nodeInstance = registeredClass.class(objectsIncrement)

		objects[objectsIncrement] = nodeInstance

		registeredClass.num = registeredClass.num + 1

		table.insert(registeredClass.IDS, objectsIncrement)

		if parent then

			addObjectRelation(objectsIncrement, parent:getID())

		end

		nodeInstance:setVars()

		return nodeInstance

	end

end

local function remove(index)

	local parentID = relations.parents[index]
	local childsList = relations.childs[index]

	--scriptEnvPCall(index, "remove")

	if childsList then

		for relationIndex = #childsList, 1, -1 do

			local childID = childsList[relationIndex]

			remove(childID)

		end

	end

	removeObjectRelation(index, parentID)

	objects[index] = nil
	relations.childs[index] = nil

end

local function scriptEnvPCall(scriptEnv, funcIndex, ...)

	setfenv(1, scriptEnv)

	local envFunc = scriptEnv.NODE[funcIndex]

	if envFunc then

		local result, msg = pcall(assert(envFunc, scriptEnv.NODE, ...))

		if not result then

			print(msg)

		end

	end

end

local function addScript(objectID, scriptName)

	local scriptFile = assert(loadfile(string.format("src/%s.lua", scriptName)))
	local scriptEnv = setmetatable({NODE = {object = getObject(objectID)}}, {__index = _G})  

	scripts[#scripts + 1] = scriptEnv

	local result, msg = pcall(setfenv(scriptFile, scriptEnv))

	if not result then

		print(msg)

	else

		scriptEnvPCall(scriptEnv, "init")

	end

end

local function update(deltaTime, interpolation)

	for scriptIndex = #scripts, 1, -1 do

		scriptEnvPCall(scripts[scriptIndex], "update", deltaTime, interpolation)

	end

end

events.add("update", "nodes_update", update)

local function tick(timeStep)

	for scriptIndex = #scripts, 1, -1 do

		scriptEnvPCall(scripts[scriptIndex], "tick", timeStep)

	end

end

events.add("tick", "nodes_tick", tick)

local function draw(interpolation)

	for scriptIndex = #scripts, 1, -1 do

		scriptEnvPCall(scripts[scriptIndex], "draw", interpolation)

	end

end

events.add("draw", "nodes_draw", draw)

local function mousePressed(x, y, button, isTouch, presses)

	for scriptIndex = #scripts, 1, -1 do

		scriptEnvPCall(scripts[scriptIndex], "mousePressed", x, y, button, isTouch, presses)

	end

end

events.add("mousePressed", "nodes_mousePressed", mousePressed)

local function mouseReleased(x, y, button, isTouch, presses)

	for scriptIndex = #scripts, 1, -1 do

		scriptEnvPCall(scripts[scriptIndex], "mouseReleased", x, y, button, isTouch, presses)

	end
	
end

events.add("mouseReleased", "nodes_mouseReleased", mouseReleased)

local function gameLoad(game)

	requireFolder("game/classes/nodes", register)

end

events.add("gameLoad", "nodes_gameLoad", gameLoad)

local function load()

	requireFolder("engine/classes/nodes", register)

end

events.add("load", "nodes_load", load)

local function start()

	for scriptIndex = #scripts, 1, -1 do

		scriptEnvPCall(scripts[scriptIndex], "start")

	end

end

events.add("start", "nodes_start", start)

return {
	addObjectRelation = addObjectRelation,
	removeObjectRelation = removeObjectRelation,
	getObjectChilds = getObjectChilds,
	getObjectParent = getObjectParent,
	register = register,
	getClass = getClass,
	create = create,
	remove = remove,
	getObject = getObject,
	addScript = addScript,
	update = update,
	tick = tick,
	draw = draw
}