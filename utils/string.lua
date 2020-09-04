function string.toVar(str)

	local convertedNumber = tonumber(str)

	if convertedNumber then

		return convertedNumber

	end

	if str:len() > 0 then

		if str == "true" then

			return true

		elseif str == "false" then

			return false

		elseif str == "nil" then

			return

		end

	end
	
	return str

end