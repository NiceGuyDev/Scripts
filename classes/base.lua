local class, classMetaMethods, classMetaObjects = {__type = "baseClass"}, {}, {__index = classMetaMethods}

function class.new()

	return {}

end

function class:derive(name)

	local methods = {__type = name}
	local metaMethods = {__index = self}
	local metaObjects = {__index = methods}

	metaMethods.__call = function(self, ...)

		return setmetatable(self.new(...), metaObjects)

	end

	return setmetatable(methods, metaMethods), metaMethods, metaObjects

end

function class:getType()

	return self.__type

end

function class:getBase()

	return getmetatable(self).__index

end

function class:isBasedOn(classType)

	local base = self:getBase()

	if not base then return false end

	if base:getType() == classType then

		return true

	end

	return base:isBasedOn(classType)

end

classMetaMethods.__call = function(self)

	return setmetatable(class.new(), classMetaObjects)

end

return setmetatable(class, classMetaMethods)