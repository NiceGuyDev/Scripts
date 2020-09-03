local loveGraphics = love.graphics
local nodes = engine.nodes
local nodeClass, nodeClassMetaMethods, nodeClassMetaObjects = baseClass:derive("node")

function nodeClass.new(ID)
	
	return {
		__ID = ID, 
		active = true,
		hovering = false,
		pos = vector(0, 0),
		scale = vector(1, 1),
		dimensions = {
			base = {
				width = 10,
				height = 10
			},
			half = {
				width = 5,
				height = 5
			},
			div = {
				width = 0.1,
				height = 0.1
			}
		}
	}

end

function nodeClass:clearRelations()

	node.clearObjectRelation(self:getID())

end

function nodeClass:init()

end

function nodeClass:setVars()

end

function nodeClass:isActive(parentAffected)

	parentAffected = parentAffected or false

	local parent = self:getParentObject()

	if not parentAffected or (parentAffected and not parent) then

		return self.active

	end

	return parent:isActive(true)

end

function nodeClass:setActive(bool)

	self.active = bool

end

function nodeClass:childsMouseHoverPressed(x, y, button, isTouch, presses)

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do

			local childObject = nodes.getObject(childsList[relationIndex])

			if childObject:isActive() and childObject:isHovering(x, y) then

				if childObject:mouseHoverPressed(x, y, button, isTouch, presses) then

					return true, childObject

				end

			end
			
		end

	end

end

function nodeClass:mouseHoverPressed(x, y, button, isTouch, presses)

	local childBlock, childObject = self:childsMouseHoverPressed(x, y, button, isTouch, presses)

	if childBlock then

		return true, childObject

	end

	return not self:onMouseHoverPressed(x, y, button, isTouch, presses) 

end

function nodeClass:childsMouseHoverReleased(x, y, button, isTouch, presses)

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do

			local childObject = nodes.getObject(childsList[relationIndex])

			if childObject:isActive() and childObject:isHovering(x, y) then

				if childObject:mouseHoverReleased(x, y, button, isTouch, presses) then

					return true, childObject

				end

			end
			
		end

	end

end

function nodeClass:mouseHoverReleased(x, y, button, isTouch, presses)

	local childBlocked, childObject = self:childsMouseHoverReleased(x, y, button, isTouch, presses)

	if childBlocked then

		return true, childObject

	end

	return not self:onMouseHoverReleased(x, y, button, isTouch, presses) 

end

function nodeClass:clearChilds()

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do

			nodes.remove(childsList[relationIndex])
			
		end

	end

end

function nodeClass:childsMousePressed(x, y, button, isTouch, presses)

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do

			local childObject = nodes.getObject(childsList[relationIndex])

			if childObject:isActive() and childObject:mousePressed(x, y, button, isTouch, presses) then

				return true, childObject

			end
			
		end

	end

end

function nodeClass:childsMouseReleased(x, y, button, isTouch, presses)

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do

			local childObject = nodes.getObject(childsList[relationIndex])

			if childObject:isActive() and childObject:mouseReleased(x, y, button, isTouch, presses) then

				return true, childObject

			end
			
		end

	end

end

function nodeClass:childsKeyPressed(key)

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do

			local childObject = nodes.getObject(childsList[relationIndex])

			if childObject:isActive() and childObject:keyPressed(key) then

				return true, childObject

			end
			
		end

	end

end


function nodeClass:childsKeyReleased(key)

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do

			local childObject = nodes.getObject(childsList[relationIndex])

			if childObject:isActive() and childObject:keyReleased(key) then

				return true, childObject

			end
			
		end

	end

end

function nodeClass:keyPressed(key)

	local childBlock, childObject = self:childsKeyPressed(key)

	if childBlock then
		
		return true, childObject

	end

	return self:onKeyPressed(key) 

end

function nodeClass:keyReleased(key)

	local childBlock, childObject = self:childsKeyReleased(key)

	if childBlock then
		
		return true, childObject

	end

	return self:onKeyReleased(key) 

end

function nodeClass:mousePressed(x, y, button, isTouch, presses)

	local childBlock, childObject = self:childsMousePressed(x, y, button, isTouch, presses)

	if childBlock then
		
		return true, childObject

	end

	return self:onMousePressed(x, y, button, isTouch, presses) 

end

function nodeClass:mouseReleased(x, y, button, isTouch, presses)

	local childBlock, childObject = self:childsMouseReleased(x, y, button, isTouch, presses)

	if childBlock then

		return true, childObject

	end

	return self:onMouseReleased(x, y, button, isTouch, presses) 

end

function nodeClass:getParentObject()

	return nodes.getObject(self:getParent())

end

function nodeClass:getChildObject(var)

	local childsList = self:getChilds()

	if childsList then
		
		for relationIndex = 1, #childsList do

			local childID = childsList[relationIndex]
			local childObject = nodes.getObject(childID)
			local varType = type(var)

			if childObject and ((varType == "number" and childID == var) or (varType == "string" and childObject:getName() == var)) then

				return childObject, childID

			end

		end

	end

	return nodes.getObject(self:getParent())

end

function nodeClass:getParent()

	return nodes.getObjectParent(self:getID())

end

function nodeClass:getChilds()

	return nodes.getObjectChilds(self:getID())

end

function nodeClass:getChild(childID)

	local childs = nodes.getObjectChilds(self:getID())

	return childs[childID]

end

function nodeClass:addChild(child)

	nodes.addObjectRelation(child:getID(), self:getID())

	nodeClass:onAddChild(child)

end

function nodeClass:removeChild(childID)

	nodes.removeObjectRelation(childID, self:getID())

	self:onRemoveChild(childID)

end

function nodeClass:setParent(parent)

	local ID = self:getID()

	if parent then

		nodes.addObjectRelation(ID, parent:getID())

	else

		nodes.removeObjectRelation(ID, nodes.getObjectParent(ID))

	end

	self:onSetParent(parent)

end

function nodeClass:setName(name)

	self.name = name

end

function nodeClass:getName()

	return self.name

end

function nodeClass:updateChilds(deltaTime, interpolation)

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do
				
			local childObject = nodes.getObject(childsList[relationIndex])

			if childObject:isActive() then

				childObject:update(deltaTime, interpolation)

			end
			
		end

	end

end

function nodeClass:update(deltaTime, interpolation)

	self:updateChilds(deltaTime, interpolation)
	self:onUpdate(deltaTime, interpolation)

end

function nodeClass:tickChilds(timeStep)

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do

			local childObject = nodes.getObject(childsList[relationIndex])

			if childObject:isActive() then

				childObject:tick(timeStep)
				
			end

		end

	end

end

function nodeClass:tick(timeStep)

	self:tickChilds(timeStep)

	self:onTick(timeStep)

end

function nodeClass:remove()

	if childsList then

		for relationIndex = #childsList, 1, -1 do

			local childObject = nodes.getObject(childsList[relationIndex])
			childObject:remove()

		end

	end

	nodes.remove(self:getID())

end

function nodeClass:addScript(script)

	nodes.addScript(self:getID(), script)

end

function nodeClass:getID()

	return self.__ID

end

function nodeClass:canvasResize(width, height)

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do

			local childObject = nodes.getObject(childsList[relationIndex])

			if childObject:isActive() then

				childObject:canvasResize(width, height)
			
			end

		end

	end

end


function nodeClass:center()

	local parent = self:getParentObject()
	local baseWidth, baseHeight = self:getBaseDimensions()

	if parent then

		self:setPos(parent:getWidth() * 0.5 - self:getWidth() * 0.5, parent:getHeight() * 0.5 - self:getHeight() * 0.5)

		return

	end

	local sreenWidth, screenHeight = loveGraphics.getDimensions()
	self:setPos((sreenWidth * 0.5) - (baseWidth * 0.5), (screenHeight * 0.5) - (baseHeight * 0.5))

end

function nodeClass:isHovering(x, y) 

	local baseX, baseY = self:getBasePos()
	local baseWidth, baseHeight = self:getBaseDimensions()

	return x >= baseX and x <= (baseX + baseWidth) and y >= baseY and y <= (baseY + baseHeight)

end

function nodeClass:setHovering(bool)

	if self:getHovering() ~= bool then

		self.hovering = bool

		if bool then

			self:hoveringStart()

		else

			self:hoveringEnd()

		end

	end

end

function nodeClass:hoveringStart()

end

function nodeClass:hoveringEnd()

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do
			
			local childObject = nodes.getObject(childsList[relationIndex])

			if childObject:isActive() then

				childObject:setHovering(false)
			
			end

		end

	end

end

function nodeClass:childsHovering(x, y)

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do

			local childObject = nodes.getObject(childsList[relationIndex])

			if childObject:isActive() then

				childObject:mouseHovering(x, y)
			
			end

		end

	end

end

function nodeClass:textInput(char)

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do

			local childObject = nodes.getObject(childsList[relationIndex])

			if childObject:isActive() then

				if childObject:textInput(char) then

					return true, self, childObject

				end
			
			end

		end

	end

end

function nodeClass:getHovering()

	return self.hovering

end

function nodeClass:mouseHovering(x, y)

	if self:isHovering(x, y) then

		self:setHovering(true)
		self:childsHovering(x, y)

		return true

	end

	self:setHovering(false)

	return false

end

function nodeClass:isTextInputTarget()

	return self == game:getTextInputTarget()

end

function nodeClass:getCenter()

	local posX, posY = self:getPos()
	local halfWidth, halfHeight = self:getDimensions("half")

	return posX + halfWidth, posY + halfHeight

end

function nodeClass:getBaseCenter()

	local posX, posY = self:getBasePos()
	local halfWidth, halfHeight = self:getBaseDimensions("half")

	return posX + halfWidth, posY + halfHeight

end

function nodeClass:getDimensions(dimensionType)

	dimensionType = dimensionType or "base"

	local dimensions = self.dimensions
	local dimensionType = dimensions[dimensionType]

	return dimensionType.width, dimensionType.height

end

function nodeClass:getWidth(dimensionType)

	dimensionType = dimensionType or "base"

	local dimensions = self.dimensions
	local dimensionType = dimensions[dimensionType]

	return dimensionType.width

end

function nodeClass:getHeight(dimensionType)

	dimensionType = dimensionType or "base"

	local dimensions = self.dimensions
	local dimensionType = dimensions[dimensionType]

	return dimensionType.height

end

function nodeClass:setDimensions(width, height)

	self:setWidth(width)
	self:setHeight(height)

end

function nodeClass:setWidth(width)

	local dimensionsTypes = self.dimensions

	dimensionsTypes.base.width = width
	dimensionsTypes.half.width = width * 0.5

	dimensionsTypes.div.width = 1 / width

end

function nodeClass:setHeight(height)

	local dimensionsTypes = self.dimensions

	dimensionsTypes.base.height = height
	dimensionsTypes.half.height = height * 0.5

	dimensionsTypes.div.height = 1 / height

end

function nodeClass:getBaseWidth(dimensionType)

	return self:getWidth(dimensionType) * self:getBaseScaleX()

end

function nodeClass:getBaseHeight(dimensionType)

	return self:getHeight(dimensionType) * self:getBaseScaleY()
	
end

function nodeClass:getBaseDimensions()

	return self:getWidth(dimensionType) * self:getBaseScaleX(), self:getHeight(dimensionType) * self:getBaseScaleY()

end

function nodeClass:getPos()

	local pos = self.pos

	return pos.x, pos.y

end

function nodeClass:getOriginX()

	local parentObject = self:getParentObject()

	if parentObject and parentObject.getBasePosX then 

		return parentObject:getBasePosX()

	end

	return 0

end

function nodeClass:getOriginY()

	local parentObject = self:getParentObject()

	if parentObject and parentObject.getBasePosY then 

		return parentObject:getBasePosY()

	end

	return 0

end

function nodeClass:getOrigin()

	local parentObject = self:getParentObject()

	if parentObject and parentObject.getBasePosX and parentObject.getBasePosY then 

		return parentObject:getBasePos()

	end

	return 0, 0

end

function nodeClass:setScaleX(x)

	local scale = self.scale

	scale.x = x or 1

end

function nodeClass:setScaleY(y)

	local scale = self.scale

	scale.y = y or 1

end

function nodeClass:setScale(x, y)

	local scale = self.scale

	scale.x, scale.y = x or 1, y or 1

end

function nodeClass:getScaleX()

	return self.scale.x

end

function nodeClass:getScaleY()

	return self.scale.y

end

function nodeClass:getScale()

	local scale = self.scale

	return scale.x, scale.y

end

function nodeClass:getBaseScale()

	return self:getBaseScaleX(), self:getBaseScaleY()

end

function nodeClass:getBaseScaleX()

	local parent = self:getParentObject()
	local scaleX = self:getScaleX()

	if parent then

		return scaleX * parent:getBaseScaleX()

	end

	return scaleX

end

function nodeClass:getBaseScaleY()

	local parent = self:getParentObject()
	local scaleY = self:getScaleY()

	if parent then

		return scaleY * parent:getBaseScaleY()

	end

	return scaleY

end

function nodeClass:getBasePos()

	return self:getBasePosX(), self:getBasePosY()

end

function nodeClass:getBasePosX()

	local parent = self:getParentObject()

	if parent then

		return self:getOriginX() + self:getPosX() * parent:getBaseScaleX()

	end

	return self:getOriginX() + self:getPosX()

end

function nodeClass:getBasePosY()

	local parent = self:getParentObject()

	if parent then

		return self:getOriginY() + self:getPosY() * parent:getBaseScaleY()

	end

	return self:getOriginY() + self:getPosY()

end

function nodeClass:calcOffset(x, y)

	if x and y then

		return x - self:getBasePosX(), y - self:getBasePosY()

	end

end

function nodeClass:getPosX()

	return self.pos.x

end

function nodeClass:getPosY()

	return self.pos.y

end

function nodeClass:setPosX(x)

	self.pos.x = x

end

function nodeClass:setPosY(y)

	self.pos.y = y

end

function nodeClass:setPos(x, y)

	local pos = self.pos

	pos.x, pos.y = x, y

end

function nodeClass:drawBackground()

end

function nodeClass:preDraw()

end

function nodeClass:postDraw()

end

function nodeClass:drawContent()

end

function nodeClass:drawChilds(interpolation)

	local childsList = self:getChilds()

	if childsList then

		for relationIndex = #childsList, 1, -1 do
				
			local childObject = nodes.getObject(childsList[relationIndex])

			if childObject:isActive() then

				childObject:draw(interpolation)

			end
			
		end

	end

end

function nodeClass:draw()

	self:preDraw()

	loveGraphics.push()

		loveGraphics.translate(self:getPos())
		
			loveGraphics.scale(self:getScale())

				self:drawBackground()
				self:drawContent()
				self:drawChilds()

	loveGraphics.pop()

	self:postDraw()

end

function nodeClass:onTick(timeStep) end
function nodeClass:onUpdate(deltaTime, interpolation) end
function nodeClass:onAddChild(child) end
function nodeClass:onSetParent(parent) end
function nodeClass:onRemoveChild(childID) end
function nodeClass:onDraw(interpolation) end
function nodeClass:onMousePressed(x, y, button, isTouch) end
function nodeClass:onMouseReleased(x, y, button, isTouch) end
function nodeClass:onMouseHoverPressed(x, y, button, isTouch) end
function nodeClass:onMouseHoverReleased(x, y, button, isTouch) end
function nodeClass:onKeyPressed(key) end
function nodeClass:onKeyReleased(key) end
function nodeClass:onTextInput(char) end

return nodeClass