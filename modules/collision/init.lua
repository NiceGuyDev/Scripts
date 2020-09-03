local function swept(velX, velY, x, y, w, h, targetX, targetY, targetW, targetH) -- sw, sh = 0 for a ray

	local outsideTimeX, outsideTimeY = 1, 1
	local insideTimeX, insideTimeY = 1, 1
	local normalX, normalY = 0, 0
	local inverseOutsideX, inverseOutsideY = 1, 1
	local inverseInsideX, inverseInsideY = 1, 1

	if velX > 0 then

		inverseOutsideX = targetX - (x + w)
		inverseInsideX = (targetX + targetW) - x

		outsideTimeX = inverseOutsideX / velX
		insideTimeX = inverseInsideX / velX

	elseif velX < 0 then

		inverseOutsideX = (targetX + targetW) - x
		inverseInsideX = targetX - (x + w)

		outsideTimeX = inverseOutsideX / velX
		insideTimeX = inverseInsideX / velX

	elseif velX == 0 then

		outsideTimeX = -math.huge
		insideTimeX = math.huge

	end

	if velY > 0 then

		inverseOutsideY = targetY - (y + h)
		inverseInsideY = (targetY + targetH) - y

		outsideTimeY = inverseOutsideY / velY
		insideTimeY = inverseInsideY / velY

	elseif velY < 0 then

		inverseOutsideY = (targetY + targetH) - y
		inverseInsideY = targetY - (y + h)

		outsideTimeY = inverseOutsideY / velY
		insideTimeY = inverseInsideY / velY

	elseif velY == 0 then

		outsideTimeY = -math.huge
		insideTimeY = math.huge

	end

	local outsideTime, insideTime = math.max(outsideTimeX, outsideTimeY), math.min(insideTimeX, insideTimeY)

	if outsideTime < insideTime and (outsideTimeX >= 0 or outsideTimeY >= 0) and outsideTimeX < 1 and outsideTimeY < 1 then

		if outsideTimeX < 0 and ((x + w) <= targetX or x >= (targetX + targetW)) then

			return 1, 0, 0

		elseif outsideTimeY < 0 and ((y + h) <= targetY or y >= (targetY + targetH)) then
			
			return 1, 0, 0

		elseif outsideTimeX == outsideTimeY then

			return 1, 0, 0

		end

		if outsideTimeX > outsideTimeY then

			normalX = math.clamp(math.round(-inverseInsideX), -1, 1)

		elseif outsideTimeX < outsideTimeY then
			
			normalY = math.clamp(math.round(-inverseInsideY), -1, 1)

		end

		return outsideTime, normalX, normalY

	end

	return 1, 0, 0

end

local function AABBPoint(checkType, pointX, pointY, targetX, targetY, targetW, targetH) 

	if checkType == "touch" then

		return pointX >= targetX and pointX <= (targetX + targetW) and pointY >= targetY and pointY <= (targetY + targetH)

	elseif checkType == "inside" then

		return pointX > targetX and pointX < (targetX + targetW) and pointY > targetY and pointY < (targetY + targetH)

	end

	return false

end

local function AABBCollision(ctype, sx, sy, sw, sh, tx, ty, tw, th)

	if ctype == "touch" then

		return tx <= (sx + sw) and (tx + tw) >= sx and ty <= (sy + sh) and (ty + th) >= sy 

	elseif ctype == "inside" then

		return tx < (sx + sw) and (tx + tw) > sx and ty < (sy + sh) and (ty + th) > sy 

	end

	return false
	
end

local function broadPhase(checkType, vx, vy, sx, sy, sw, sh, tx, ty, tw, th)
	
	if AABBCollision(checkType, sx + math.min(vx, 0), sy + math.min(vy, 0), sw + math.abs(vx), sh + math.abs(vy), tx, ty, tw, th) then
		
		return true

	end

	return false

end

return {
	broadPhase = broadPhase,
	AABBCollision = AABBCollision,
	AABBPoint = AABBPoint,
	swept = swept
}