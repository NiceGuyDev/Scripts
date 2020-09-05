local gameClass = baseClass:derive("gameClass")

function gameClass.new()

	local instance = {
		pause = false,
		focusing = true,
		running = false,
		time = 0
	}

	events.call("gameSetVars", instance)

	return instance

end

function gameClass:load()

	require("game/assets")

	events.call("gameLoad", self)

	events.add("focus", "game_focus", self.focus, self)
	events.add("update", "game_update", self.update, self)
	events.add("tick", "game_tick", self.tick, self)
	events.add("mousePressed", "game_mousePressed", self.mousePressed, self)
	events.add("mouseReleased", "game_mouseReleased", self.mouseReleased, self)
	events.add("mouseWheel", "game_mouseWheel", self.mouseWheel, self)
	events.add("keyPressed", "game_keyPressed", self.keyPressed, self)
	events.add("keyReleased", "game_keyReleased", self.keyReleased, self)
	events.add("gamepadPressed", "game_gamepadPressed", self.gamepadPressed, self)
	events.add("gamepadReleased", "game_gamepadReleased", self.gamepadReleased, self)
	events.add("gamepadAdded", "game_gamepadAdded", self.gamepadAdded, self)
	events.add("gamepadRemoved", "game_gamepadRemoved", self.gamepadRemoved, self)
	events.add("gamepadAxis", "game_gamepadAxis", self.gamepadAxis, self)
	events.add("gamepadHat", "game_gamepadHat", self.gamepadHat, self)
	events.add("textInput", "game_textInput", self.textInput, self)
	events.add("resize", "game_resize", self.resize, self)

end

function gameClass:getName()

	return self.name

end

function gameClass:start()	

	self.running = true
	self.pause = false

	events.call("gameStart", self)

end

function gameClass:stop()

	events.call("gameStop", self)

	self:setVars()

	collectgarbage()

end

function gameClass:getRunning()

	return self.running

end

function gameClass:isActive()

	return (self:getRunning() and not self:getPause())

end

function gameClass:setPause(bool)

	self.pause = bool or false

end

function gameClass:getPause()

	return self.pause

end

function gameClass:setTime(time)

	self.time = time

end

function gameClass:getTime()

	return self.time

end

function gameClass:addTime(addTime)

	local lastTime = self:getTime()
	local currentTime = lastTime + addTime

	self:setTime(currentTime)

	events.call("gameTimeAdvance", lastTime, currentTime, addTime)

end

function gameClass:getFocus()

	return self.focusing

end

function gameClass:focus(bool)

	self.focusing = bool

end

function gameClass:update(deltaTime, interpolation)

	if self:getRunning() and self:getPause() then

		self:addTime(deltaTime)

	end

end

function gameClass:textInput(letter) end
function gameClass:mousePressed(x, y, button, isTouch, presses) end
function gameClass:mouseReleased(x, y, button, isTouch, presses) end
function gameClass:resize(width, height) end
function gameClass:mouseWheel(x, y) end
function gameClass:drawPostProcessing() end
function gameClass:keyPressed(key) end
function gameClass:keyReleased(key) end
function gameClass:tick(timeStep) end
function gameClass:gamepadPressed(gamepad, button) end
function gameClass:gamepadReleased(gamepad, button) end
function gameClass:gamepadAxis(gamepad, axis, value) end
function gameClass:gamepadHat(gamepad, hat, direction) end
function gameClass:gamepadAdded(gamepad) end
function gameClass:gamepadRemoved(gamepad) end

return gameClass