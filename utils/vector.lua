local vector, vectorMetaMethods, vectorMetaObjects = baseClass:derive("vector")
local mathLength, mathDistance, mathNormalize, mathAtan2 = math.length, math.distance, math.normalize, math.atan2

function vectorMetaObjects:__call()

	return self.x, self.y

end

function vectorMetaObjects:__add(vec)

	return vector(self.x + vec.x, self.y + vec.y)

end

function vectorMetaObjects:__sub(vec)

	return vector(self.x - vec.x, self.y - vec.y)

end

function vectorMetaObjects:__mul(number)

	return vector(self.x * number, self.y * number)

end

function vectorMetaObjects:__div(number)

	if number ~= 0 then

		return vector(self.x / number, self.y / number)

	end

end

function vectorMetaObjects:__eq(vec)

	return (self.x == vec.x and self.y == vec.y)

end

function vectorMetaObjects:__pow(number)

	return vector(self.x ^ number, self.y ^ number)

end

function vector.new(x, y)

	return {
		x = x or 0,
		y = y or 0
	}

end

function vector:length()

	return mathLength(self.x, self.y)

end

function vector:distance(vec)

  	return mathDistance(self.x, self.y, vec.x, vec.y)

end

function vector:normalize()

	return mathNormalize(self.x, self.y)

end

function vector:radian()

	return mathAtan2(self.x, self.y)

end

function vector:degree()

	return self:radian() * 180 / math.pi

end

return vector