local round, clamp = math.round, math.clamp

local function posToCoords(x, y, halfW, halfH, divW, divH)

	return round((x + halfW) * divW) - 1, round((y - halfH) * divH)

end

local function boxToCoords(x, y, w, h, halfW, halfH, divW, divH)

	local minCoordX, minCoordY = posToCords(x, y, halfW, halfH, divW, divH)
	local maxCoordX, maxCoordY = posToCords(x + w, y + h, halfW, halfH, divW, divH)

	return minCoordX, minCoordY, maxCoordX, maxCoordY, (maxCoordX - minCoordX), (maxCoordY - minCoordY)

end

local function posToNum(x, y, halfW, halfH, divW, divH, maxCoordX, maxCoordY)

	local coordX = clamp(round((x + halfW) * divW), 1, maxCoordX)
	local coordY = clamp(round((y - halfH) * divH), 0, maxCoordY - 1)

	return (coordY * maxCoordX) + coordX, coordX - 1, coordY

end

local function numToCoords(num, div, half)

	local coordY = round(((num - 1) * div) + 0.5)
	local coordX = half - ((coordY * half) - num)

	return coordX - 1, coordY - 1

end

local function numToPos(num, div, half, size)

	local coordX, coordY = numToCoords(num, div, half)

	return coordX * size, coordY * size

end

local function findAroundNum(num, x, y, maxCoordX, maxCoordY)

	x = x or 0
	y = y or 0

	if x ~= 0 or y ~= 0 then

		local currentY = round(((num - 1) / maxCoordX) + 0.5)
		local predictX = clamp((currentY * maxCoordX) - (num + x), 0, maxCoordX)
		local predictmax = clamp(currenty + y, 1, maxCoordY) * maxCoordX

		return clamp(predictmax - predictX, predictmax - (maxCoordX - 1), predictmax)

	end

	return num
	
end

return {
	posToCoords = posToCoords,
	boxToCoords = boxToCoords,
	posToNum = posToNum,
	numToCoords = numToCoords,
	numToPos = numToPos,
	findAroundNum = findAroundNum
}