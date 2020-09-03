local engineGrids = engine.grids
local gridClass = baseClass:derive("grid")

function gridClass.new(cellsWidth, cellsHeight, clearKeep)

	cellsWidth, cellsHeight = cellsWidth or 32, cellsHeight or 32

	local hypotenus = math.length(cellsWidth, cellsHeight)

	return {
		cells = {
			num = 0,
			data = {}
		},
		dimensions = {
			basic = {
				width = cellsWidth,
				height = cellsHeight,
				hypotenus = hypotenus
			},
			half = {
				width = cellsWidth * 0.5,
				height = cellsHeight * 0.5,
				hypotenus = hypotenus * 0.5
			},
			div = {
				width = 1 / cellsWidth,
				height = 1 / cellsHeight,
				hypotenus = 1 / hypotenus
			}
		},
		clearKeep = clearKeep ~= nil and true or false
	}

end

local posToCoords = engineGrids.posToCoords

function gridClass:posToCoords(x, y)

	if x and y then

		local dimensions = self.dimensions
		local half, div = dimensions.half, dimensions.div

		return posToCoords(x, y, half.width, half.height, div.width, div.height)

	end

end

function gridClass:posToCell(x, y)

	return self:getCell(self:posToCoords(x, y))

end

function gridClass:boxToCoords(x, y, width, height)

	if x and y and width and height then

		local dimensions = self.dimensions
		local half, div = dimensions.half, dimensions.div
		
		return engineGrids.boxToCoords(x, y, width, height, half.width, half.height, div.width, div.height)

	end

end

function gridClass:setCellsDimensions(width, height)

	local dimensions = self.dimensions
	local basic, half, div = dimensions.basic, dimensions.half, dimensions.div

	basic.width, basic.height = width, height
	half.width, half.height = width * 0.5, height * 0.5
	div.width, div.height = 1 / width, 1 / height

	local hypotenus = math.length(basic.width, basic.height)

	basic.hypotenus = hypotenus
	half.hypotenus = hypotenus * 0.5
	div.hypotenus = 1 / hypotenus

end

function gridClass:getCellsWidth()

	local dimensions = self.dimensions

	return dimensions.basic.width

end

function gridClass:getCellsHeight()

	local dimensions = self.dimensions

	return dimensions.basic.height

end

function gridClass:getCellsHypotenus()

	local dimensions = self.dimensions

	return dimensions.basic.hypotenus

end

function gridClass:getCellsDimensions()

	return self:getCellsWidth(), self:getCellsHeight(), self:getCellsHypotenus()

end

function gridClass:getCellsDimensionsTable()

	return self.dimensions

end

function gridClass:getCells()

	local cells = self.celss

	return cells.data, cells.num

end

function gridClass:getRow(coordX)

	return self.cells.data[coordX]

end

function gridClass:clearCells()

	local cells = self.cells
	cells.num = 0

	if self.clearKeep then

		for coordX, row in pairs(cells.data) do

			for coordY, cell in pairs(row) do

				cells.data[coordX][coordY] = nil

			end

		end

		return

	end

	cells.data = {}

end

function gridClass:createRow(coordX)

	self.cells.data[coordX] = {}

end

function gridClass:addCell(coordX, coordY, var)

	local cells = self.cells

	if not self:getRow(coordX) then

		self:createRow(coordX)

	end

	cells.data[coordX][coordY] = var
	cells.num = cells.num + 1

	return cells.num

end

function gridClass:setCell(coordX, coordY, var)

	if self:getCell(coordX, coordY) then

		self.cells.data[coordX][coordY] = var

	end

end

function gridClass:numCells()

	return self.cells.num

end

function gridClass:isValidRow(x)

	if self:getRow(x) then

		return true

	end

	return false

end

function gridClass:removeRow(coordX)

	self.cells.data[coordX] = nil

end

function gridClass:isRowEmpty(coordX)

	return table.isEmpty(self:getRow(coordX))

end

function gridClass:removeCell(coordX, coordY)

	local cells = self.cells

	if self:isValidCell(coordX, coordY) then

		cells.data[coordX][coordY] = nil

		if self:isRowEmpty(coordX) then

			self:removeRow(coordX)

		end

		cells.num = cells.num - 1

	end

end

function gridClass:isValidCell(coordX, coordY)

	if self:getCell(coordX, coordY) then

		return true

	end

	return false

end

function gridClass:getCell(coordX, coordY)

	local cellsData = self.cells.data
	local column = cellsData[coordX]
	
	if column then

		return column[coordY]

	end

end

return gridClass