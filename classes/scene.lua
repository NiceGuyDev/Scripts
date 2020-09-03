local loveGraphics = love.graphics
local sceneClass = baseClass:derive("scene")

function sceneClass.new(name)

	local canvas = loveGraphics.newCanvas(loveGraphics.getDimensions())

	return {name = name, nodes = {}, color = color(0, 0, 0, 0), canvas = canvas}

end

function sceneClass:init()

end

function sceneClass:update(deltaTime, interpolation)

	local nodes = self.nodes

	for nodeIndex = #nodes, 1, -1 do

		local nodeObject = nodes[nodeIndex]

		if nodeObject:isActive() and nodeObject:update(deltaTime, interpolation) then

			break

		end

	end

end

function sceneClass:transferNode(scene, nodeIndex)

	local nodeObject, nodeIndex = sceneClass:freeNode(var)

end

function sceneClass:setColor(r, g, b, a)

	local clr = self.color

	clr.r = r or 0
	clr.g = g or 0
	clr.b = b or 0
	clr.a = a or 0

end

function sceneClass:enable()

end

function sceneClass:disable()

end

function sceneClass:tick(timeStep)

	local nodes = self.nodes

	for nodeIndex = #nodes, 1, -1 do

		local nodeObject = nodes[nodeIndex]

		if nodeObject:isActive() and nodeObject:tick(timeStep) then

			break

		end

	end

end

function sceneClass:getNodeIndex(nodeObject)

	local nodes = self.nodes

	for nodeIndex = #nodes, 1, -1 do

		if nodes[nodeIndex] == nodeObject then

			return nodeIndex

		end

	end

end

function sceneClass:findNode(name)

	local nodes = self.nodes

	for nodeIndex = 1, #nodes do

		local nodeObject = nodes[nodeIndex]

		if nodeObject:getName() == name then

			return nodeObject, nodeIndex

		end

	end

end

function sceneClass:freeNode(var)

	local nodes = self.nodes
	local varType = type(var)

	if varType == "number" then

		local nodeObject = nodes[var]

		if nodeObject then

			table.remove(nodes, var)

			return nodeObject

		end

	elseif varType == "string" then

		local nodeObject, nodeIndex = self:findNode(var)

		if nodeObject then

			table.remove(nodes, nodeIndex)

			return nodeObject, nodeIndex

		end

	end

end

function sceneClass:removeNode(var)

	local nodeObject, nodeIndex = self:freeNode(var)
	nodeObject:remove()

	return nodeIndex, nodeObject

end

function sceneClass:resize(width, height)

	self.canvas = loveGraphics.newCanvas(width, height)

	local nodes = self.nodes

	for nodeIndex = #nodes, 1, -1 do

		local nodeObject = nodes[nodeIndex]

		if nodeObject:isActive() and nodeObject:canvasResize(width, height) then

			break

		end

	end

end

function sceneClass:setNodeOrder(nodeIndex, order)

	local nodes = self.nodes
	local node = table.remove(nodes, nodeIndex)

	table.insert(nodes, order, node)

end

function sceneClass:draw(interpolation)

	local canvas = self.canvas
	local nodes = self.nodes
	local clr = self.color

	loveGraphics.setCanvas(canvas)

		loveGraphics.clear(clr())

		for nodeIndex = 1, #nodes do

			local nodeObject = nodes[nodeIndex]

			if nodeObject:isActive() then

				nodeObject:draw(interpolation)

			end

		end

	loveGraphics.setCanvas()

	loveGraphics.draw(canvas)

end

function sceneClass:mouseHovering(x, y)

	local nodes = self.nodes

	for nodeIndex = #nodes, 1, -1 do

		local nodeObject = nodes[nodeIndex]

		if nodeObject:isActive() and nodeObject:mouseHovering(x, y, button, isTouch) then

			for nextNodeIndex = nodeIndex - 1, 1, -1 do

				local nextNode = nodes[nextNodeIndex]
				
				nextNode:setHovering(false)

			end

			return true

		end

	end

end

function sceneClass:setHovering(bool)

	local nodes = self.nodes

	for nodeIndex = #nodes, 1, -1 do

		local nodeObject = nodes[nodeIndex]

		nodeObject:setHovering(bool)

	end

end

function sceneClass:mousePressed(x, y, button, isTouch, presses)

	local nodes = self.nodes
	local numNodes = #nodes

	for nodeIndex = numNodes, 1, -1 do

		local nodeObject = nodes[nodeIndex]
		local mousePressedBlock, mousePressedObject = nodeObject:mousePressed(x, y, button, isTouch, presses)

		if nodeObject:isActive() and mousePressedBlock then

			break

		end

	end

	for nodeIndex = numNodes, 1, -1 do

		local nodeObject = nodes[nodeIndex]

		if nodeObject:isActive() and nodeObject:isHovering(x, y) then

			local mouseHoverPressedBlock, mouseHoverPressedObject = nodeObject:mouseHoverPressed(x, y, button, isTouch, presses)

			if  mouseHoverPressedBlock then

				return true, nodeObject, mouseHoverPressedObject

			end

		end

	end

end

function sceneClass:keyPressed(key)

	local nodes = self.nodes
	local numNodes = #nodes

	for nodeIndex = numNodes, 1, -1 do

		local nodeObject = nodes[nodeIndex]

		if nodeObject:isActive() then

			if nodeObject:keyPressed(key) then

				break

			end

		end

	end

end

function sceneClass:keyReleased(key)

	local nodes = self.nodes
	local numNodes = #nodes

	for nodeIndex = numNodes, 1, -1 do

		local nodeObject = nodes[nodeIndex]

		if nodeObject:isActive() then

			if nodeObject:keyReleased(key) then

				break

			end

		end

	end

end

function sceneClass:mouseReleased(x, y, button, isTouch)

	local nodes = self.nodes
	local numNodes = #nodes

	for nodeIndex = numNodes, 1, -1 do

		local nodeObject = nodes[nodeIndex]

		if nodeObject:isActive() then

			if nodeObject:mouseReleased(x, y, button, isTouch, presses) then

				break

			end

		end

	end
	
	for nodeIndex = numNodes, 1, -1 do

		local nodeObject = nodes[nodeIndex]

		if nodeObject:isActive() and nodeObject:isHovering(x, y) then

			local mouseHoverReleasedBlock, mouseHoverReleasedObject = nodeObject:mouseHoverReleased(x, y, button, isTouch, presses)

			if mouseHoverReleasedBlock then

				return true, nodeObject, mouseHoverReleasedObject

			end

		end

	end

end

function sceneClass:getNode(nodeIndex)

	return self.nodes[nodeIndex]

end

function sceneClass:addNode(object)

	local nodes = self.nodes

	nodes[#nodes + 1] = object

end

function sceneClass:getNodes()

	return self.nodes

end

function sceneClass:getName()

	return self.name

end

function sceneClass:setName(name)

	self.name = name

end

return sceneClass