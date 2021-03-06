
local function SnapStructure(def, mouseX, mouseY)
	local x, y = math.floor(mouseX - 0.5*def.width + 0.5), math.floor(mouseY - 0.5*def.height + 0.5)
	return x, y
end

local function CheckStructurePlacement(roomList, monkList, def, placeX, placeY)
	local pWidth, pHeight = def.width, def.height
	
	for _, room in roomList.Iterator() do
		local pos, width, height = room.GetPosAndSize()
		if UTIL.IntersectingRectangles(placeX, placeY, pWidth, pHeight, pos[1], pos[2], width, height) then
			return false
		end
	end
	
	for _, monk in monkList.Iterator() do
		local pos, movingToPos = monk.GetPosition()
		if UTIL.PosInRectangle(placeX, placeY, pWidth, pHeight, pos[1], pos[2]) or (movingToPos and UTIL.PosInRectangle(placeX, placeY, pWidth, pHeight, movingToPos[1], movingToPos[2])) then
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
		if UTIL.PosInRectangle(x, y, w, h, mouseX, mouseY) then
			return monk
		end
	end
end

local function RoomToScreen(interface, room)
	local pos, w, h = room.GetPosAndSize()
	local verts = {}
	
	local x, y = interface.WorldToScreen(pos[1], pos[2])
	verts[#verts + 1] = x
	verts[#verts + 1] = y
	
	x, y = interface.WorldToScreen(pos[1] + w, pos[2])
	verts[#verts + 1] = x
	verts[#verts + 1] = y
	
	x, y = interface.WorldToScreen(pos[1] + w, pos[2] + h)
	verts[#verts + 1] = x
	verts[#verts + 1] = y
	
	x, y = interface.WorldToScreen(pos[1], pos[2] + h)
	verts[#verts + 1] = x
	verts[#verts + 1] = y
	return verts
end

local function ScreenToRoom(interface, roomList, mouseX, mouseY)
	local worldX, worldY = interface.ScreenToWorld(mouseX, mouseY)
	for _, room in roomList.Iterator() do
		if room.HitTest() then
			local pos, w, h = room.GetPosAndSize()
			if UTIL.PosInRectangle(pos[1], pos[2], w, h, worldX, worldY) then
				return room
			end
		end
	end
end

local function DrawMonkInterface(interface, monk, mouseX, mouseY, clickTask)
	local uiClick
	
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(DEFS.images.monkInterface, 0, 0, 0, 1, 1, 0, 0, 0, 0)
	
	local sleep, food, resourceCarried, skillDef, skillProgress, currentTaskType, name, priorities = monk.GetStatus()
	
	local currentTaskName = (currentTaskType and (DEFS.stationTypeNames[currentTaskType] or currentTaskType)) or "Idle"
	
	local skillStr = "Unskilled"
	
	if skillDef then
		if skillProgress == 1 then
			skillStr = "Master "
		elseif skillProgress >= 0.5 then
			skillStr = "Adept "
		else
			skillStr = "Novice "
		end
		skillStr = skillStr .. skillDef.titleName
	end
	
	local drawX = 12
	local barY = -6
	local barX = 4
	local barWidth = 232
	local barHeight = 25
	
	local wantRest, wantFood = monk.GetWants()
	wantRest = (wantRest and 0.85) or 1
	wantFood = (wantFood and 0.85) or 1
	
	local drawY = 349
	
	font.SetSize(2)
	love.graphics.setColor(0, 0, 0, 1)
	
	love.graphics.print(name, drawX, drawY)
	drawY = drawY + 26
	
	love.graphics.setColor(GLOBAL.BAR_SKILL_RED, GLOBAL.BAR_SKILL_GREEN, GLOBAL.BAR_SKILL_BLUE)
	love.graphics.rectangle("fill", barX, drawY + barY + 4, skillProgress*barWidth, barHeight, 2, 0, 0 )
	drawY = drawY + 2
	
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print(skillStr, drawX, drawY)
	drawY = drawY + 26
	
	drawY = drawY + 32
	love.graphics.setColor(GLOBAL.BAR_SLEEP_RED*wantRest, GLOBAL.BAR_SLEEP_GREEN*wantRest, GLOBAL.BAR_SLEEP_BLUE*wantRest)
	love.graphics.rectangle("fill", barX, drawY + barY, sleep*barWidth, barHeight, 2, 0, 0 )
	
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print("Rest", drawX, drawY)
	drawY = drawY + 28
	
	love.graphics.setColor(GLOBAL.BAR_FOOD_RED*wantFood, GLOBAL.BAR_FOOD_GREEN*wantFood, GLOBAL.BAR_FOOD_BLUE*wantFood)
	love.graphics.rectangle("fill", barX, drawY + barY, food*barWidth, barHeight, 2, 0, 0 )
	
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print("Satiety", drawX, drawY)
	drawY = drawY + 27
	
	love.graphics.print("Task: " .. currentTaskName, drawX, drawY)
	drawY = drawY + 27
	
	if currentTaskName == "Eat" or currentTaskName == "Sleep" then
		love.graphics.print("Busy With: " .. currentTaskName, drawX, drawY)
	elseif resourceCarried then
		if monk.IsBusy() then
			love.graphics.print("Busy With: " .. (DEFS.resourceNames[resourceCarried] or resourceCarried), drawX, drawY)
		else
			love.graphics.print("Carrying: " .. (DEFS.resourceNames[resourceCarried] or resourceCarried), drawX, drawY)
		end
	end
	drawY = drawY + 27
	
	if clickTask then
		clickTask = DEFS.stationTypeNames[clickTask] or clickTask
		if monk.IsBusy() then
			love.graphics.setColor(0.5, 0, 0, 1)
		else
			love.graphics.setColor(0, 0.5, 0, 1)
		end
		love.graphics.print("Assign: " .. clickTask, drawX, drawY)
		love.graphics.setColor(0, 0, 0, 1)
	end
	
	drawY = drawY + 27
	love.graphics.print("Jobs:", drawX, drawY)
	drawY = drawY + 30
	
	for i = 1, #priorities do
		local name = DEFS.stationTypeNames[priorities[i].taskType] or priorities[i].taskType
		love.graphics.print(" " .. i .. ".   " .. name, drawX - 2, drawY)
		if UTIL.PosInRectangle(10, drawY, 180, 20, mouseX, mouseY) then
			uiClick = {
				monk = monk,
				removePriority = i,
			}
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.draw(DEFS.images.strikeout, 10, drawY, 0, 1, 1, 0, 0, 0, 0)
			love.graphics.setColor(0, 0, 0, 1)
		end
		
		drawY = drawY + 28
	end
	
	if (not uiClick) and UTIL.PosInRectangle(0, 245, 240, 438, mouseX, mouseY) then
		uiClick = {onUI = true}
	end
	
	return uiClick
end

local function CheckCheatCode(cheatCodeData, key)
	if key ~= cheatCodeData.code[cheatCodeData.index] then
		cheatCodeData.index = 1
		return
	end
	cheatCodeData.index = cheatCodeData.index + 1
	if not cheatCodeData.code[cheatCodeData.index] then
		cheatCodeData.index = 1
		cheatCodeData.CallFunc()
		return true
	end
end

return {
	SnapStructure = SnapStructure,
	CheckStructurePlacement = CheckStructurePlacement,
	MonkToScreen = MonkToScreen,
	ScreenToMonk = ScreenToMonk,
	RoomToScreen = RoomToScreen,
	ScreenToRoom = ScreenToRoom,
	DrawMonkInterface = DrawMonkInterface,
	CheckCheatCode = CheckCheatCode,
}
