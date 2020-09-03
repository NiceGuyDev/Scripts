local loveGraphics = love.graphics
local frameBuffer = {stencil = true, depth = true}
local groups = require("engine/modules/renderer/groups")

local function resize(screenWidth, screenHeight)
	
	frameBuffer[1] = loveGraphics.newCanvas(screenWidth, screenHeight)

end

events.add("resize", "renderer_resize", resize)

local function draw(interpolation)

	groups.draw(interpolation)

end

events.add("draw", "renderer_draw", draw, renderer)

return {
	groups = groups
}