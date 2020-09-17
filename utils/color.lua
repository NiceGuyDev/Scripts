local colorClass, colorMetaMethods, colorMetaObjects = baseClass:derive("color")

function colorClass.new(r, g, b, a)

	return {

		r = r or 1,
		g = g or 1,
		b = b or 1,
		a = a or 1

	}

end

function colorMetaObjects:__call()

	return self.r, self.g, self.b, self.a

end

function colorMetaObjects:__add(clr)

	return colorClass(self.r + clr.r, self.g + clr.g, self.b + clr.b, self.a + clr.a)

end

function colorMetaObjects:__sub(clr)

	return colorClass(self.r - clr.r, self.g - clr.g, self.b - clr.b, self.a - clr.a)

end

function colorMetaObjects:__mul(number)

	return colorClass(self.r * number, self.g * number, self.b * number, self.a * number)

end

function colorMetaObjects:__div(number)

	if number ~= 0 then

		return colorClass(self.r / number, self.g / number, self.b / number, self.a / number)

	end

end

function colorMetaObjects:__eq(clr)

	return self.r == clr.r and self.g == clr.g and self.b == clr.b and self.a == clr.a

end

return colorClass