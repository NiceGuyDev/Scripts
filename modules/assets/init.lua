local fileSystemGetInfo = love.filesystem.getInfo
local imagesMethods, imagesMetaTable, imagesMetaObjects = baseClass:derive("assetsHandler_images")
local soundsMethods, soundsMetaTable, soundsMetaObjects = baseClass:derive("assetsHandler_sounds")
local fontsMethods, fontsMetaTable, fontsMetaObjects = baseClass:derive("assetsHandler_fonts")

local data = {
	images = imagesMethods(),
	sounds = soundsMethods(),
	fonts = fontsMethods()
}

local formats = {
	["png"] = {
		type = "images",
		func = love.graphics.newImage
	},
	["ogg"] = {
		type = "sounds",
		func = love.sound.newSoundData
	},
	["wav"] = {
		type = "sounds",
		func = love.sound.newSoundData
	},
	["ttf"] = {
		type = "fonts",
		func = love.graphics.newFont
	},
	["otf"] = {
		type = "fonts",
		func = love.graphics.newFont
	}
}

local extensionPattern = "%.(%a*)"
local fileNamePattern = "%/([^%/]*)%."

local function add(filePath, ...)

	if fileSystemGetInfo(filePath) then

		local asset
		local fileExtension = filePath:match(extensionPattern)
		local fileName = filePath:match(fileNamePattern)
		local formatInfos = formats[fileExtension]

		if formatInfos then

			asset = formatInfos.func(filePath, ...)
			data[formatInfos.type][filePath] = asset

			print("Asset cached " .. filePath)

			return asset

		end

		print("Unsupported extension " .. fileExtension)

		return

	end

	print("File Doesnt Exists " .. filePath)
	
end

local function get(filePath)

	local fileExtension = filePath:match(extensionPattern)
	local formatInfos = formats[fileExtension]
	local typeData = data[formatInfos.type]

	if not typeData then

		print(""..assetType.." is a wrong asset type!")

		return

	end

	return typeData[filePath]

end

function fontsMetaObjects:__index(key)

	if fileSystemGetInfo(key) then

		local asset = add(key)
		print("Late font precache of " .. key)

		return asset

	end

	return rawget(self, "engine/assets/fonts/apple_kid.ttf")

end

function imagesMetaObjects:__index(key)

	if fileSystemGetInfo(key) then

		local asset = add(key)
		print("Late image precache of " .. key)

		return asset

	end

	return rawget(self, "engine/assets/materials/error.png")

end

function soundsMetaObjects:__index(key)

	if fileSystemGetInfo(key) then

		local asset = add(key)
		print("Late sound precache of " .. key)

		return asset

	end

	return rawget(self, "engine/assets/sounds/error.wav")

end

return {
	get = get,
	add = add
}