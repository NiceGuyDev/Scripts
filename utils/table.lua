function table.copy(array)

	local res = {}

	for key, value in pairs(array) do

		if type(value) == "table" then

			res[key] = table.copy(value)

		else

			res[key] = value

		end

	end

	return res

end

function table.random(array)

	local numIndexes = #array

	if numIndexes > 0 then

		if numIndexes > 1 then

			local randomIndex = math.random(1, numIndexes)

			return array[randomIndex], randomIndex

		else

			return array[1], 1

		end

	end

end

function table.isEmpty(array)

	for k, v in pairs(array) do

		return false

	end

	return true

end