local mathAbs = math.abs
local engineWorld = engine.world
local gridClass = require("engine/classes/grid")
local checkInfos = {
	[1] = {
		offset = vector(0, -1),
		sizeIndex = "height"
	},
	[2] = {
		offset = vector(0, 1),
		sizeIndex = "height"
	},
	[3] = {
		offset = vector(-1, 0),
		sizeIndex = "width"
	},
	[4] = {
		offset = vector(1, 0),
		sizeIndex = "width"
	}
}

local open, closed, parent, gCost, heuristic, coords, callback, numOpen
local grid = gridClass(64, 64, false)

local function setCellsDimensions(width, height)

	grid:setCellsDimensions(width, height)

end

local function checkNode(coordX, coordY)

	if not grid:getCell(coordX, coordY) then

		local nodeIndex = grid:numCells() + 1

		coords.x[nodeIndex], coords.y[nodeIndex] = coordX, coordY

		grid:addCell(coordX, coordY, nodeIndex)

		return nodeIndex

	end

	return grid:getCell(coordX, coordY)

end

local function setCallback(func)

	callback = func

end

local function openNode(index, gCostValue, heuristic, parentIndex)

	gCost[index] = gCostValue
	open[index] = gCostValue + heuristic
	parent[index] = parentIndex

	numOpen = numOpen + 1

end

local function lowestCostNode()

	local fCost = math.huge
	local lowestCoordX, lowestCoordY, lowestNodeIndex

	for nodeIndex, nodeCost in pairs(open) do --pure autism, but it works

		if nodeCost < fCost then

			fCost = nodeCost
			lowestCoordX, lowestCoordY = coords.x[nodeIndex], coords.y[nodeIndex]

			lowestNodeIndex = nodeIndex

		end

	end

	return lowestCoordX, lowestCoordY, lowestNodeIndex

end

local function getNodeCoords(nodeIndex)

	return coords.x[nodeIndex], coords.y[nodeIndex]

end

local function getNodeParent(nodeIndex)

	return parent[nodeIndex]

end

local function closeNode(nodeIndex)

	closed[nodeIndex] = open[nodeIndex]
	open[nodeIndex] = nil

	numOpen = numOpen - 1

end

local function nodeDirVec(increment)

	local checkInfos = checkInfos[increment]
	local offset = checkInfos.offset
	local cellsDimensions = grid:getCellsDimensionsTable()

	return offset.x, offset.y, cellsDimensions.basic[checkInfos.sizeIndex]

end

local function nodeHeuristic(nodesWidth, nodesHeight, openCoordX, openCoordY, endCoordX, endCoordY)

	local openX, openY = openCoordX * nodesWidth, openCoordY * nodesHeight
	local endX, endY = endCoordX * nodesWidth, endCoordY * nodesHeight

	return mathAbs(endX - openX) + mathAbs(endY - openY)

end

local function canOpen(nodeIndex, gCostValue)

	if not gCost[nodeIndex] or gCostValue < gCost[nodeIndex] then

		return true

	end

	return false

end

local function tracePath(endNodeIndex, numSaved, savedX, savedY)

	if not numSaved then

		local nextNode = endNodeIndex
		local nextNodeCoordX, nextNodeCoordY, checkNodeCoordX, checkNodeCoordY

		numSaved, savedX, savedY = 0, {}, {}

		while nextNode do

			nextNodeCoordX, nextNodeCoordY = getNodeCoords(nextNode)
			checkNodeCoordX, checkNodeCoordY = nextNodeCoordX, nextNodeCoordY

			nextNode = getNodeParent(nextNode)
			numSaved = numSaved + 1
			savedX[numSaved], savedY[numSaved] = checkNodeCoordX, checkNodeCoordY

		end

	end

	for nodeIndex = numSaved - 1, 1, -1 do

		callback(savedX[nodeIndex], savedY[nodeIndex], nodeIndex, numSaved)
		
	end

	return numSaved, savedX, savedY

end

local function clear()

	grid:clearCells()
	open, closed, parent, gCost, heuristic, coords = nil, nil, nil, nil, nil, nil

end

local results = setmetatable({}, {__mode = "kv"})

local function generate(startCoordX, startCoordY, endCoordX, endCoordY)

	assert(callback, "[PATHFINDING] Missing callback.")

	local key = string.format("%x%x%x%x", startCoordX, startCoordY, endCoordX, endCoordY)
	local lastResult = results[key]

	if lastResult then

		tracePath(lastResult.lowestNode, lastResult.numSaved, lastResult.savedX, lastResult.savedY)
		clear()

		return

	end

	open, closed, parent, gCost, heuristic, coords, numOpen = {}, {}, {}, {}, {}, {x = {}, y = {}}, 0

	local worldTilemap = engine.world.getTilemap()
	local cellWidth, cellHeight = grid:getCellsDimensions()

	openNode(checkNode(startCoordX, startCoordY), 0, 0, nil)

	local lowestCoordX, lowestCoordY, lowestNodeIndex, numSaved, savedX, savedY

	while numOpen > 0 do
		
		lowestCoordX, lowestCoordY, lowestNodeIndex = lowestCostNode()

		if lowestCoordX == endCoordX and lowestCoordY == endCoordY then

			numSaved, savedX, savedY = tracePath(lowestNodeIndex)

			break

		else

			closeNode(lowestNodeIndex)

			for i = 1, 4 do

				local aroundNodeDirX, aroundNodeDirY, aroundNodeGValue = nodeDirVec(i)
				local aroundNodeCoordX, aroundNodeCoordY = lowestCoordX + aroundNodeDirX, lowestCoordY + aroundNodeDirY
				local aroundNodeIndex = checkNode(aroundNodeCoordX, aroundNodeCoordY)

				if not closed[aroundNodeIndex] and worldTilemap:getCell(aroundNodeCoordX, aroundNodeCoordY) then

					local checkGCost = gCost[lowestNodeIndex] + aroundNodeGValue

					if canOpen(aroundNodeIndex, checkGCost) then

						local heur = heuristic[aroundNodeIndex]

						if not heur then

							heur = nodeHeuristic(cellWidth, cellHeight, aroundNodeCoordX, aroundNodeCoordY, endCoordX, endCoordY)
							heuristic[aroundNodeIndex] = heur

						end

						openNode(aroundNodeIndex, checkGCost, heur, lowestNodeIndex)

					end

				end

			end

		end

	end

	results[key] = {lowestNode = lowestNodeIndex, numSaved = numSaved, savedX = savedX, savedY = savedY}
	clear()

end

return {
	generate = generate,
	setCallback = setCallback,
	setCellsDimensions = setCellsDimensions,
}