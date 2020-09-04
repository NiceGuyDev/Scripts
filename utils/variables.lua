local variables = {
	list = {}
}

function variables:add(name, var)

	if not self.list[name] and name then

		self.list[name] = var

	end

end

function variables:set(name, var)

	if self:get(name) then

		self.list[name] = var

	end

end

function variables:exist(name)

	if self:get(name) then

		return true

	end

	return false

end

function variables:get(name)

	return self.list[name]

end

return variables