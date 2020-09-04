local floor, min, max, sqrt, sin, atan2, pi = math.floor, math.min, math.max, math.sqrt, math.sin, math.atan2, math.pi

local function scale(x, y, scale, viewX, viewY)

	return (x / scale) - viewX, (y / scale) - viewY

end

local function round(num, decimals) -- stolen

	decimals = decimals or 0

	if decimals > 0 then

		local powerten = 10 ^ decimals

		return floor((num * powerten) + 0.5) / powerten

	end

	return floor(num + 0.5)

end

local function clamp(value, minValue, maxValue)
	
	return max(minValue, min(maxValue, value))

end

local function angle(x1, y1, x2, y2)

	return atan2(y2 - y1, x2 - x1)

end

local function pythagoras(x, y)

	return (x * x) + (y * y)

end

local function length(x, y)
	
	return sqrt(pythagoras(x, y))

end

local function distance(x1, y1, x2, y2)

	local distX, distY = (x1 - x2), (y1 - y2)

	return sqrt((distX * distX) + (distY * distY))

end

local function dotProduct(x1, y1, x2, y2)

	return (x1 * y2 + y1 * x2)

end

local function lerp(current, target, time)

	return current + (target - current) * time

end

local function approach(current, target, step)

	if current < target then

		return min(current + step, target)

	elseif current > target then

		return max(current - step, target)

	end

	return target

end

local function normalize(x, y)

	local length = length(x, y)
	
	if length ~= 0 then 

		return x / length, y / length

	end

	return 0, 0

end

local function sinLerp(current, target, step, force, lastDelta, rest, dec)

	local newValue = lerp(current, target, step)
	local delta = newValue - current

	rest = clamp((lastDelta - delta) * force + rest * dec, -pi, pi)

	return newValue + sin(rest / pi), delta, rest

end

math.angle = angle
math.pythagoras = pythagoras
math.length = length
math.distance = distance
math.dotProduct = dotProduct
math.lerp = lerp
math.approach = approach
math.normalize = normalize
math.sinLerp = sinLerp
math.scale = scale
math.round = round
math.clamp = clamp