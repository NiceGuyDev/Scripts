local list = {}
local callbacks = {press = {}, hold = {}, release = {}}
local binds = {keyboard = {}, controller = {}, mouse = {}}

function binds:add(device, key, command)

	self[device][key] = command

end

function callbacks:add(action, command, func, owner)

	local actionData = self[action]

	if not actionData[command] then

		actionData[command] = {}

	end

	table.insert(actionData[command], {func = func, owner = owner})

end

function callbacks:run(action, command, key, ...)

	local actionCallbacks = self[action][command]

	if actionCallbacks then

		for callbackIndex = 1, #actionCallbacks do

			local callbackData = actionCallbacks[callbackIndex]

			callbackData.func(callbackData.owner, key, ...)

		end

	end

end

local function add(command, key, ...)

	list[command] = key

	callbacks:run("press", command, key, ...)

end	

local function remove(command, ...)

	list[command] = nil

	callbacks:run("release", command, key, ...)

end

local function get(command)

	return list[command]

end

local function tick(timeStep)

	for command, key in pairs(list) do

		callbacks:run("hold", command, key, timeStep)

	end

end

local function keyPressed(key)

	local keyCommand = binds.keyboard[key]

	if keyCommand then

		add(binds.keyboard[key], key)

	end
	
end

local function keyReleased(key)

	local keyCommand = binds.keyboard[key]

	if keyCommand then

		remove(keyCommand)

	end

end

local function gamepadPressed(gamepad, button)

	local buttonCommand = binds.controller[button]

	if buttonCommand then

		add(buttonCommand, button, gamepad)

	end

end

local function gamepadReleased(gamepad, button)

	local buttonCommand = binds.controller[button]

	if buttonCommand then

		remove(buttonCommand, button, gamepad)

	end

end

local function mousePressed(x, y, button, isTouch, presses)

	local buttonCommand = binds.mouse[button]

	if buttonCommand then

		add(buttonCommand, button, x, y, isTouch, presses)

	end

end

local function mouseReleased(x, y, button, isTouch, presses)

	local buttonCommand = binds.mouse[button]

	if buttonCommand then

		remove(buttonCommand, button, x, y, isTouch, presses)

	end

end

return {
	callbacks = callbacks,
	binds = binds,
	add = add, 
	remove = remove, 
	get = get, 
	tick = tick, 
	keyPressed = keyPressed, 
	keyReleased = keyReleased, 
	gamepadPressed = gamepadPressed, 
	gamepadReleased = gamepadReleased, 
	mousePressed = mousePressed,
	mouseReleased = mouseReleased
}