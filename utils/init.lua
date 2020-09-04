baseClass = require("engine/classes/base")

require("engine/utils/math")
require("engine/utils/string")
require("engine/utils/table")
require("engine/utils/coroutine")

local loveFileSystem = love.filesystem
local pathFormat = "%s/%s"

function requireFolder(folderPath, callback)

	for fileNum, fileResult in pairs(loveFileSystem.getDirectoryItems(folderPath)) do

		local filePath = pathFormat:format(folderPath, fileResult)
		local fileInfos = loveFileSystem.getInfo(filePath)

		if fileInfos.type == "directory" then

			requireFolder(filePath, callback)

		elseif fileResult:find(".lua") then

			local fileName = fileResult:sub(0, -5)
			local var = require(pathFormat:format(folderPath, fileName))

			if callback then

				callback(var, fileName)

			end

		end

	end

end

function module(fileName)

	return require("engine/modules/" .. fileName)

end

function memoryUsage()

	return collectgarbage("count") / 1024

end

local baseClass = require("engine/classes/base")

function class(classType, classBase)

	assert(classType, "Missing string required at argument #1")

	if not classBase then

		return baseClass:derive(classType)

	end

	return classBase:derive(classType)

end

function engineTime()

	return love.timer.getTime()

end

function gameTime()

	return game:getTime()

end

function isValid(var)

	return var ~= nil and true or false

end

ffi = require("ffi")
bitser = require("engine/utils/bitser")
events = require("engine/utils/events")
vector = require("engine/utils/vector")
color = require("engine/utils/color")
variables = require("engine/utils/variables")