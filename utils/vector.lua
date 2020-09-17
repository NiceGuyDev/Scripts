local vectorClass, vectorMetaMethods, vectorMetaObjects = baseClass:derive("vector")
local mathLength, mathDistance, mathNormalize, mathAtan2 = math.length, math.distance, math.normalize, math.atan2

function vectorMetaObjects:__call()

	return self.x, self.y

end

function vectorMetaObjects:__add(vec)

	return vectorClass(self.x + vec.x, self.y + vec.y)

end

function vectorMetaObjects:__sub(vec)

	return vectorClass(self.x - vec.x, self.y - vec.y)

end

function vectorMetaObjects:__mul(number)

	return vectorClass(self.x * number, self.y * number)

end

function vectorMetaObjects:__div(number)

	if number ~= 0 then

		return vectorClass(self.x / number, self.y / number)

	end

end

function vectorMetaObjects:__eq(vec)

	return (self.x == vec.x and self.y == vec.y)

end

function vectorMetaObjects:__pow(number)

	return vectorClass(self.x ^ number, self.y ^ number)

end

function vectorClass.new(x, y)

	return {
		x = x or 0,
		y = y or 0
	}

end

function vectorClass:length()

	return mathLength(self.x, self.y)

end

function vectorClass:distance(vec)

  	return mathDistance(self.x, self.y, vec.x, vec.y)

end

function vectorClass:normalize()

	return mathNormalize(self.x, self.y)

end

function vectorClass:radian()

	return mathAtan2(self.x, self.y)

end

function vectorClass:degree()

	return self:radian() * 180 / math.pi

end

return vectorClass