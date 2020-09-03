local loveGraphics, loveFileSystem = love.graphics, love.filesystem
local inputs = engine.inputs

local resolutionWidth, resolutionHeight = loveGraphics.getDimensions()
local bindPattern = "[bind]%s([^%s]+)%s([^%s]+)%s([^%s]+)%s*"
local flagPattern = "[flag]%s([^%s]+)%s([^%s]+)%s*"
local resolutionPattern = "[resolution]%s(%d+)%s(%d+)%s*"
local flags = {fullscreen = false, fullscreentype = "desktop", vsync = true, msaa = 0, resizable = true, borderless = false, centered = true, display = 1, minwidth = 800, minheight = 600, highdpi = false, x = nil, y = nil}

local function readCFG()

	if not loveFileSystem.getInfo("settings.cfg") then return end

	local inputsBinds = inputs.binds

	for line in loveFileSystem.lines("settings.cfg") do

		local bindDeviceString, bindKey, bindCommand = line:match(bindPattern)
		local flagNameString, flagValueString = line:match(flagPattern)
		local resolutionWidthValue, resolutionHeightValue = line:match(resolutionPattern)

		if bindDeviceString and bindKey and bindCommand then

			inputsBinds:add(bindDeviceString, bindKey:toValue(), bindCommand)

		end
		
		if flagNameString and flagValueString and flags[flagNameString] ~= nil then

			flags[flagNameString] = flagValueString:toValue()

		end

		resolutionWidth = resolutionWidthValue and resolutionWidthValue or resolutionWidth
		resolutionHeight = resolutionHeightValue and resolutionHeightValue or resolutionHeight

	end
	
	love.window.setMode(resolutionWidth, resolutionHeight, flags)

end

return {readCFG = readCFG}