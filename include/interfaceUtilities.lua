
local function SnapStructure(def, mouseX, mouseY)
	local x, y = math.floor(mouseX - 0.5*def.width + 0.5), math.floor(mouseY - 0.5*def.height + 0.5)
	return x, y
end

local function IntersectingRectangles(x1, y1, w1, h1, x2, y2, w2, h2)
	return ((x1 + w1 >= x2 and x1 <= x2) or (x2 + w2 >= x1 and x2 <= x1)) and ((y1 + h1 >= y2 and y1 <= y2) or (y2 + h2 >= y1 and y2 <= y1))
end

local function PosInRectangle(x1, y1, w1, h1, x2, y2)
	return (x1 + w1 > x2 and x1 <= x2) and (y1 + h1 > y2 and y1 <= y2)
end

local function CheckStructurePlacement(roomList, monkList, def, placeX, placeY)
	local pWidth, pHeight = def.width, def.height
	
	for _, room in roomList.Iterator() do
		local pos, width, height = room.GetPosAndSize()
		if IntersectingRectangles(placeX, placeY, pWidth, pHeight, pos[1], pos[2], width, height) then
			return false
		end
	end
	
	for _, monk in monkList.Iterator() do
		local pos, movingToPos = monk.GetPosition()
		if PosInRectangle(placeX, placeY, pWidth, pHeight, pos[1], pos[2]) or (movingToPos and PosInRectangle(placeX, placeY, pWidth, pHeight, movingToPos[1], movingToPos[2])) then
			return false
		end
	end
	
	return true
end

local function MonkToScreen(interface, monk)
	local mx, my = monk.GetNonIntegerPos()
	local sx, sy = interface.WorldToScreen(mx, my, -0.2, 0.6)
	return sx, sy, 0.6*GLOBAL.TILE_SIZE, 1*GLOBAL.TILE_SIZE
end

local function ScreenToMonk(interface, monkList, mouseX, mouseY)
	for _, monk in monkList.Iterator() do
		local x, y, w, h = MonkToScreen(interface, monk)
		if PosInRectangle(x, y, w, h, mouseX, mouseY) then
			return monk
		end
	end
end

return {
	SnapStructure = SnapStructure,
	CheckStructurePlacement = CheckStructurePlacement,
	MonkToScreen = MonkToScreen,
	ScreenToMonk = ScreenToMonk,
}
