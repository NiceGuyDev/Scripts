local stateClass = baseClass:derive("state")

stateClass.name = "Unamed"

function stateClass.new()

	return {}

end

function stateClass:load()

end

function stateClass:enable()

end

function stateClass:disable()

end

function stateClass:update(dt, interpolation)
	
end

function stateClass:tick(timeStep)

end

function stateClass:mousePressed(x, y, button, isTouch, presses)

end

function stateClass:mousePressedEmpty(x, y, button, isTouch, presses)

end

function stateClass:mouseReleasedEmpty(x, y, button, isTouch, presses)

end

function stateClass:mouseReleased(x, y, button, isTouch, presses)

end

function stateClass:mouseWheel(x, y)

end

function stateClass:keyPressed(key)

end

function stateClass:keyReleased(key)

end

function stateClass:drawDesktop(interpolation)

end

function stateClass:drawGUI(interpolation)

end

function stateClass:drawWindows(interpolation)

end

function stateClass:resize(width, height)

end

function stateClass:focus(bool)

end

function stateClass:textInput(char)

end

function stateClass:gamepadPressed(gamepad, button)

end

function stateClass:gamepadReleased(gamepad, button)

end

function stateClass:gamepadAxis(gamepad, axis, value)

end

function stateClass:gamepadHat(gamepad, hat, direction)

end

function stateClass:gamepadAdded(gamepad)

end

function stateClass:gamepadRemoved(gamepad)

end

return stateClass