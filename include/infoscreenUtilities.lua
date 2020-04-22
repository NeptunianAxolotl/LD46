
local function DrawButton(buttonX, buttonY, hovered, infoscreenData, mouseX, mouseY, index, text)
	if UTIL.PosInRectangle(buttonX + 9, buttonY + 9, 156, 42, mouseX, mouseY) then
		love.graphics.setColor(0.8, 1, 0.8, 1)
		hovered = index
	elseif infoscreenData.displayedScreen == index then
		love.graphics.setColor(0.8, 1, 0.8, 1)
	else
		love.graphics.setColor(0.8, 0.8, 0.8, 1)
	end
	love.graphics.draw(DEFS.images.buttonInterface, buttonX, buttonY, 0, 1, 1, 0, 0, 0, 0)
	
	love.graphics.setColor(0, 0, 0, 1)
	font.SetSize(2)
	love.graphics.print(text, buttonX + 38, buttonY + 22)
	
	buttonX = buttonX + 164
	return buttonX, buttonY, hovered
end

--------------------------------------------------
-- Building Screen
--------------------------------------------------

local function DrawBuildScreen(infoscreenData, world, interface, mouseX, mouseY)
	love.graphics.setColor(0, 0, 0, 1)
	
	font.SetSize(0)
	love.graphics.print("Construct a Building", 328 + 128, 90)
	
	local buildOptions = world.GetBuildOptions()
	local startHeight = 150
	local drawX = 330 + 128
	local drawY = startHeight
	
	for i = 1, #buildOptions do
		if drawY > 600 then
			drawY = startHeight
			drawX = drawX + 290
		end
		local roomDef = DEFS.roomDefNames[buildOptions[i]]
		if UTIL.PosInRectangle(drawX - 80, drawY, 255, 72, mouseX, mouseY) then
			love.graphics.setColor(1, 0, 0, 1)
			infoscreenData.hoveredOption = {build = buildOptions[i]}
		else
			love.graphics.setColor(0, 0, 0, 1)
		end
		font.SetSize(1)
		love.graphics.print(roomDef.humanName or roomDef.name, drawX, drawY)
		drawY = drawY + 28
		font.SetSize(2)
		love.graphics.print(roomDef.desc or "", drawX + 8, drawY)
		
		love.graphics.setColor(1, 1, 1, 1)
		local scale = 1.1/math.max(3, math.max(roomDef.width, roomDef.height))
		love.graphics.draw(roomDef.image, drawX - 80, drawY - 3*roomDef.drawOriginY - 28, 0, scale, scale, 0, 0, 0, 0)
		
		drawY = drawY + 64
	end
	
	if GLOBAL.DEMOLISH_BUILDING then
		drawY = drawY + 10
		if UTIL.PosInRectangle(drawX-70, drawY - 10, 240, 40, mouseX, mouseY) then
			love.graphics.setColor(1, 0, 0, 1)
			infoscreenData.hoveredOption = {demolish = true}
		else
			love.graphics.setColor(0, 0, 0, 1)
		end
		font.SetSize(1)
		love.graphics.print("Cancel Construction", drawX - 70, drawY)
	end
end

--------------------------------------------------
-- Laptop Screen
--------------------------------------------------

local function DrawLaptopScreen(infoscreenData, world, interface, mouseX, mouseY)
	love.graphics.setColor(0, 0, 0, 1)
	
	font.SetSize(0)
	love.graphics.print("Laptop Status", 395 + 128, 90)
    
    local laptopData = world.GetOrModifyLaptopStatus()
    local originalX = 240 + 128
    local drawX = originalX
    local drawY = 165
    local powerBarWidth = 200
    local powerBarHeight = 50
    local tickboxSize = 30
	
	local laptopRoom = laptopData.room
    
    -- battery
    font.SetSize(2)
	love.graphics.print("Battery Life: ", drawX, drawY)
    drawY = drawY + 25
    love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", drawX, drawY, powerBarWidth, powerBarHeight, 2, 0, 0 )
    love.graphics.rectangle("fill", drawX+powerBarWidth-2, drawY+powerBarHeight/5, powerBarWidth/20, 3*powerBarHeight/5, 2, 0, 0 )
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle("fill", drawX+2, drawY+2, powerBarWidth-4, powerBarHeight-4, 2, 0, 0 )
    love.graphics.rectangle("fill", drawX+powerBarWidth, drawY+powerBarHeight/5+2, powerBarWidth/20-4, 3*powerBarHeight/5-4, 2, 0, 0 )
    love.graphics.setColor(0, 0, 0)
    if laptopData.charge < 0.1 then
        love.graphics.setColor(1, 0, 0)
    elseif laptopData.charge < laptopData.chargeForBattery then
        love.graphics.setColor(1, 1, 0)
    else
        love.graphics.setColor(0, 1, 0)
    end
	love.graphics.rectangle("fill", drawX+2, drawY+2, (powerBarWidth-4)*laptopData.charge, powerBarHeight-4, 2, 0, 0 )
   
	love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(math.ceil(laptopData.charge*100) .. "%", drawX+powerBarWidth/2-12, drawY+powerBarHeight/2-10)
    
    drawX = originalX
    drawY = drawY + powerBarHeight
    drawY = drawY + 28
    love.graphics.setColor(0, 0, 0)
    
    -- power
    love.graphics.print("Power Consumption (Half When Idle): " .. math.ceil(60*(laptopData.currentDrain or -1)*100) .. "% per minute", drawX, drawY)
    
	local mult = math.max(1.04, 1.11 - 2*laptopData.passiveDrain)
	local nextDrain = laptopData.currentDrain*mult
	drawY = drawY + 28
	love.graphics.print("Power Consumption For Next Battery: " .. math.ceil(60*nextDrain*100) .. "% per minute", drawX, drawY)
	
    drawX = originalX
    drawY = drawY + 40
    love.graphics.setColor(0, 0, 0)
	love.graphics.print("Charged Batteries in Laptop Room: " .. laptopRoom.GetResourceCount("battery"), drawX, drawY)
	 drawY = drawY + 28
	love.graphics.print("Spent Batteries in Laptop Room: " .. laptopRoom.GetResourceCount("battery_spent"), drawX, drawY)
	 drawY = drawY + 28
    
	if laptopData.charge < laptopData.chargeForUse then
		love.graphics.print("Laptop power below " .. (laptopData.chargeForUse*100) .. "%, switching to passive mode.", drawX, drawY)
	end
	 drawY = drawY + 40
	 
    -- peripherals
    love.graphics.print("Current Peripherals: ", drawX, drawY)
    drawY = drawY + 28
    
    love.graphics.rectangle("line", drawX, drawY, tickboxSize, tickboxSize, 2, 0, 0 )
    if laptopData.peripherals.speakers then
        love.graphics.setColor(0, 0.4, 0)
        font.SetSize(1)
        love.graphics.print("X",drawX+tickboxSize/2-7,drawY+tickboxSize/2-10)
        font.SetSize(2)
    end
    love.graphics.setColor(0, 0, 0)
    drawX = drawX + tickboxSize + 10
    love.graphics.print("Speakers", drawX, drawY+tickboxSize/2-10)
    love.graphics.setColor(0, 0, 0)
    
    drawX = drawX + 100
    love.graphics.rectangle("line", drawX, drawY, tickboxSize, tickboxSize, 2, 0, 0 )
    if laptopData.peripherals.monitor then
        love.graphics.setColor(0, 0.4, 0)
        font.SetSize(1)
        love.graphics.print("X",drawX+tickboxSize/2-7,drawY+tickboxSize/2-10)
        font.SetSize(2)
    end
    love.graphics.setColor(0, 0, 0)
    drawX = drawX + tickboxSize + 10
    love.graphics.print("Widescreen Monitor", drawX, drawY+tickboxSize/2-10)
    love.graphics.setColor(0, 0, 0)
    
    drawX = drawX + 185
    love.graphics.rectangle("line", drawX, drawY, tickboxSize, tickboxSize, 2, 0, 0 )
    if laptopData.peripherals.graphicscard then
        love.graphics.setColor(0, 0.4, 0)
        font.SetSize(1)
        love.graphics.print("X",drawX+tickboxSize/2-7,drawY+tickboxSize/2-10)
        font.SetSize(2)
    end
    love.graphics.setColor(0, 0, 0)
    drawX = drawX + tickboxSize + 10
    love.graphics.print("Graphics Card", drawX, drawY+tickboxSize/2-10)
    love.graphics.setColor(0, 0, 0)
    
    drawX = originalX
    drawY = drawY + 75
    love.graphics.setColor(0, 0, 0)
    
end

--------------------------------------------------
-- Trade Screen
--------------------------------------------------

local function DrawTradeScreen(infoscreenData, world, interface, mouseX, mouseY)
	love.graphics.setColor(0, 0, 0, 1)
	
	font.SetSize(0)
	love.graphics.print("Trading Post", 400 + 128, 90)
	
	local tradeData = world.GetOrModifyTradeStatus()
	local drawX = 240 + 128
	local drawY = 135
	
	local room = tradeData.room
	
	font.SetSize(1)
	love.graphics.print("Coin: " .. tradeData.money, drawX + 30, drawY)
	drawY = drawY + 45
	
	font.SetSize(2)
	local startX = drawX
	love.graphics.print("Good", drawX, drawY)
	drawX = drawX + 135
	love.graphics.print("Buy Price", drawX, drawY)
	drawX = drawX + 50
	
	drawX = drawX + 78
	love.graphics.print("Sell Price", drawX, drawY)
	
	drawX = drawX + 140
	love.graphics.print("Inventory", drawX, drawY)
	
	drawY = drawY + 43
	
	for i = 1, #tradeData.goods do
		drawX = startX
		local good = tradeData.goods[i]
		love.graphics.print(DEFS.resourceNames[good.name] or good.name, drawX, drawY)
		drawX = drawX + 85
		
		drawX = drawX + 50
		love.graphics.print(math.floor(good.price*good.buyMarkup), drawX, drawY)
		drawX = drawX + 40
		
		if UTIL.PosInRectangle(drawX, drawY, 38, 34, mouseX, mouseY) then
			love.graphics.setColor(1, 0, 0, 1)
			infoscreenData.hoveredOption = {buy = i}
		else
			love.graphics.setColor(0, 0, 0, 1)
		end
		love.graphics.print("Buy", drawX, drawY)
		love.graphics.setColor(0, 0, 0, 1)
		drawX = drawX + 50
		
		drawX = drawX + 40
		love.graphics.print(math.floor(good.price), drawX, drawY)
		drawX = drawX + 40
		
		if UTIL.PosInRectangle(drawX, drawY, 38, 34, mouseX, mouseY) then
			love.graphics.setColor(1, 0, 0, 1)
			infoscreenData.hoveredOption = {sell = i}
		else
			love.graphics.setColor(0, 0, 0, 1)
		end
		love.graphics.print("Sell", drawX, drawY)
		love.graphics.setColor(0, 0, 0, 1)
		drawX = drawX + 105
		
		love.graphics.print(room.GetResourceCount(good.name), drawX, drawY)
		drawX = drawX + 35
		if UTIL.PosInRectangle(drawX, drawY, 120, 34, mouseX, mouseY) then
			love.graphics.setColor(1, 0, 0, 1)
			infoscreenData.hoveredOption = {stockpileToggle = i}
		else
			love.graphics.setColor(0, 0, 0, 1)
		end
		love.graphics.print((good.requesting and "Move to Post") or "Take from Post", drawX, drawY)
		love.graphics.setColor(0, 0, 0, 1)
		
		drawY = drawY + 35
	end
	
	
    local laptopData = world.GetOrModifyLaptopStatus()
	local periph = laptopData.peripheralList
	local havePeriph = laptopData.peripherals
	
	drawX = startX
	drawY = drawY + 45
	
	love.graphics.print("Hardware", drawX, drawY)
	drawX = drawX + 135
	love.graphics.print("Buy Price", drawX, drawY)
	drawX = drawX + 50
	
	drawX = drawX + 78
	love.graphics.print("Aquired", drawX, drawY)
	
	drawY = drawY + 43
	
	for i = 1, #periph do
		drawX = startX
		love.graphics.print(periph[i].humanName, drawX, drawY)
		drawX = drawX + 85
		
		drawX = drawX + 50
		love.graphics.print(periph[i].price, drawX, drawY)
		drawX = drawX + 40
		
		if havePeriph[periph[i].name] then
			love.graphics.setColor(0.4, 0.4, 0.4, 1)
		elseif UTIL.PosInRectangle(drawX, drawY, 38, 34, mouseX, mouseY) then
			love.graphics.setColor(1, 0, 0, 1)
			infoscreenData.hoveredOption = {buyPeriph = i}
		else
			love.graphics.setColor(0, 0, 0, 1)
		end
		love.graphics.print("Buy", drawX, drawY)
		love.graphics.setColor(0, 0, 0, 1)
		drawX = drawX + 50
		
		drawX = drawX + 40
		love.graphics.print((havePeriph[periph[i].name] and "Yes") or "No", drawX, drawY)
		
		drawX = drawX + 78
		
		drawY = drawY + 35
	end
end

--------------------------------------------------
-- Help Screen
--------------------------------------------------

local function DrawHelpScreen(infoscreenData, world, interface, mouseX, mouseY)
	love.graphics.setColor(0, 0, 0, 1)
	
	font.SetSize(0)
	love.graphics.print("Vivere Computatrum", 360 + 100, 90)
    
    local laptopData = world.GetOrModifyLaptopStatus()
    local originalX = 240 + 128
    local drawX = originalX
    local drawY = 140
    local linebreak = 21
    local parabreak = 30
	
    font.SetSize(2)
	love.graphics.print("As civilization crumbled, your monastery kept safe a laptop", drawX, drawY)
    drawY = drawY + linebreak
    love.graphics.print("containing the combined knowledge of humanity.", drawX, drawY)
    drawY = drawY + parabreak
    
	love.graphics.print("Now the laptop's batteries are failing and you must transcribe", drawX, drawY)
    drawY = drawY + linebreak
    love.graphics.print("its contents into a library of books, keeping that knowledge", drawX, drawY)
    drawY = drawY + linebreak
    love.graphics.print("alive for future generations. If the laptop turns off nobody", drawX, drawY)
    drawY = drawY + linebreak
    love.graphics.print("remembers the password to log back in again...", drawX, drawY)
    drawY = drawY + parabreak
    
    love.graphics.print("Gather resources, trade for parts, and expand your monastery ", drawX, drawY)
    drawY = drawY + linebreak
    love.graphics.print("to fulfill your goal... Vivere Computatrum!", drawX, drawY)
    drawY = drawY + parabreak + 10
    
    font.SetSize(1)
    love.graphics.print("Controls", drawX, drawY)
    font.SetSize(2)
    drawY = drawY + parabreak
    
    love.graphics.print(" - Use WASD or arrow keys to move the camera", drawX, drawY)
    drawY = drawY + linebreak
    love.graphics.print(" - Click on a monk to select him, click a building assign job", drawX, drawY)
    drawY = drawY + linebreak
    love.graphics.print("    (Click either end of Laptop or Library select one of two jobs)", drawX, drawY)
    drawY = drawY + linebreak
    love.graphics.print(" - Click a Job to remove it. Monks perform their highest Job if able", drawX, drawY)
    drawY = drawY + linebreak
    love.graphics.print(" - Click buttons to open menus, press Space or the red X to close", drawX, drawY)
    drawY = drawY + linebreak
    love.graphics.print(" - Press Ctrl + Shift + R to restart game", drawX, drawY)
    drawY = drawY + parabreak + 10
    
    font.SetSize(1)
    love.graphics.print("Objectives", drawX, drawY)
    font.SetSize(2)
    drawY = drawY + parabreak
    
    love.graphics.print(" - Feed and house the monks while growing the monastry", drawX, drawY)
    drawY = drawY + linebreak
    love.graphics.print(" - Have the monks learn every skill from the laptop", drawX, drawY)
    drawY = drawY + linebreak
    love.graphics.print(" - Buy blank books from the trader and write a book on each skill", drawX, drawY)
    drawY = drawY + linebreak
    love.graphics.print(" - Don't let the laptop reach 0% power and turn off", drawX, drawY)
    drawY = drawY + linebreak
    
    -- battery
end

--------------------------------------------------
-- Skill Selection Screen
--------------------------------------------------

local function CheckPeriph(req, have)
	for i = 1, #req do
		if not have[req[i]] then
			return false
		end
	end
	return true
end

local function DrawSkillSelectScreen(infoscreenData, world, interface, mouseX, mouseY)
	love.graphics.setColor(0, 0, 0, 1)
	
	font.SetSize(0)
	love.graphics.print("Select a Skill", 374 + 128, 90)
	
	local options = DEFS.skillDefs
	local isLibrary = infoscreenData.extraData and infoscreenData.extraData.isLibrary
    local booksWritten = world.GetOrModifyKnowStatus().booksWritten
	
	local startHeight = 165
	local drawX = 256 + 128
	local drawY = startHeight
    local laptopData = world.GetOrModifyLaptopStatus()
	
	for i = 1, #options do
		if (not CheckPeriph(options[i].requiredPeripherals, laptopData.peripherals)) or (isLibrary and not booksWritten[options[i].name]) then
			love.graphics.setColor(0.4, 0.4, 0.4, 1)
		elseif UTIL.PosInRectangle(drawX, drawY, 420, 34, mouseX, mouseY) then
			love.graphics.setColor(1, 0, 0, 1)
			infoscreenData.hoveredOption = {
				skill = options[i].name,
				monk = infoscreenData.extraData and infoscreenData.extraData.monk,
				clickRoom = infoscreenData.extraData and infoscreenData.extraData.clickRoom,
				clickTask = infoscreenData.extraData and infoscreenData.extraData.clickTask,
			}
		else
			love.graphics.setColor(0, 0, 0, 1)
		end
		font.SetSize(1)
		love.graphics.print(options[i].humanName, drawX, drawY)
		font.SetSize(2)
		love.graphics.print(options[i].desc, drawX + 174, drawY + 4)
		drawY = drawY + 36
		if drawY > 630 then
			drawY = startHeight
			drawX = drawX + 160
		end
	end
	
	drawY = drawY + 75
	if infoscreenData.extraData and infoscreenData.extraData.alreadyHasSkill then
		if UTIL.PosInRectangle(drawX, drawY - 8, 350, 30, mouseX, mouseY) then
			love.graphics.setColor(1, 0, 0, 1)
			infoscreenData.hoveredOption = {cancel = true}
		else
			love.graphics.setColor(0, 0, 0, 1)
		end
		font.SetSize(1)
		love.graphics.print("Cancel and keep current skill", drawX, drawY)
	end
end

--------------------------------------------------
-- Book Screen
--------------------------------------------------

local function DrawBookScreen(infoscreenData, world, interface, mouseX, mouseY)
	love.graphics.setColor(0, 0, 0, 1)
	
	font.SetSize(0)
	love.graphics.print("Books", 455 + 128, 90)
	
	local options = DEFS.skillDefs
    local booksWritten = world.GetOrModifyKnowStatus().booksWritten
    local bookProgress = world.GetOrModifyKnowStatus().bookProgress
	
	love.graphics.setColor(0, 0, 0, 1)
	
	local drawX = 240 + 128
	local drawY = 180
	
	font.SetSize(2)
	local startX = drawX
	love.graphics.print("Subject", drawX, drawY)
	drawX = drawX + 155
	love.graphics.print("Title", drawX, drawY)
	
	drawX = drawX + 325
	love.graphics.print("Progress", drawX, drawY)

	drawY = drawY + 43

	for i = 1, #options do
		local name = options[i].name
		drawX = startX
		
		love.graphics.print(options[i].humanName, drawX, drawY)
		drawX = drawX + 155
		if booksWritten[name] or bookProgress[name] then
			love.graphics.print(options[i].bookTitle or "", drawX, drawY)
		end
		drawX = drawX + 325
		love.graphics.print(math.floor((bookProgress[name] or 0)*100) .. "%", drawX, drawY)
		drawY = drawY + 35
	end
	
end

--------------------------------------------------
-- Handler
--------------------------------------------------

local function DrawInfoscreen(infoscreenData, world, interface, mouseX, mouseY)
	infoscreenData.hoveredOption = false
	
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(DEFS.images.infoscreen, 0 + 128, 0, 0, 1, 1, 0, 0, 0, 0)
	
	if UTIL.PosInRectangle(808 + 128, 66, 32, 32, mouseX, mouseY) then
		infoscreenData.hoveredOption = {closeScreen = true}
		love.graphics.setColor(1, 1, 1, 1)
	else
		love.graphics.setColor(0.8, 0.8, 0.8, 1)
	end
	love.graphics.draw(DEFS.images.closescreen, 808 + 128, 66, 0, 1, 1, 0, 0, 0, 0)
	
	if infoscreenData.displayedScreen == 0 then
		DrawSkillSelectScreen(infoscreenData, world, interface, mouseX, mouseY)
	elseif infoscreenData.displayedScreen == 1 then
		DrawBuildScreen(infoscreenData, world, interface, mouseX, mouseY)
	elseif infoscreenData.displayedScreen == 2 then
        DrawLaptopScreen(infoscreenData, world, interface, mouseX, mouseY)
	elseif infoscreenData.displayedScreen == 3 then
		DrawTradeScreen(infoscreenData, world, interface, mouseX, mouseY)
	elseif infoscreenData.displayedScreen == 4 then
		DrawBookScreen(infoscreenData, world, interface, mouseX, mouseY)
	elseif infoscreenData.displayedScreen == 5 then
        DrawHelpScreen(infoscreenData, world, interface, mouseX, mouseY)
	end
end

local function CloseScreen(infoscreenData, world)
	infoscreenData.active = false
	infoscreenData.displayedScreen = false
	infoscreenData.hoveredOption = false
	world.SetPaused(false)
end

--------------------------------------------------
-- External Interface
--------------------------------------------------

local function HandleClick(infoscreenData, world, interface, mouseX, mouseY)
	if not UTIL.PosInRectangle(172 + 128, 50, 675, 640, mouseX, mouseY) then
		CloseScreen(infoscreenData, world, interface)
	end
	
	if not (infoscreenData and infoscreenData.hoveredOption) then
		return
	end

	if infoscreenData.hoveredOption.closeScreen then
		CloseScreen(infoscreenData, world, interface)
		return
	end
	
	if infoscreenData.displayedScreen == 0 then
		if infoscreenData.hoveredOption.skill then
			infoscreenData.extraData.monk.SetDesiredSkill(infoscreenData.hoveredOption.skill)
			if infoscreenData.hoveredOption.monk then
				infoscreenData.hoveredOption.monk.SetNewPriority(infoscreenData.hoveredOption.room, infoscreenData.hoveredOption.clickTask, false, true)
			end
		end
		CloseScreen(infoscreenData, world, interface)
	end
	if infoscreenData.displayedScreen == 1 then
		if infoscreenData.hoveredOption.demolish then
			interface.SetDemolish()
		elseif infoscreenData.hoveredOption.build then
			interface.SetPlacingStructure(infoscreenData.hoveredOption.build)
		end
		CloseScreen(infoscreenData, world, interface)
	end
	if infoscreenData.displayedScreen == 3 then
		tradeUtilities.PerformAction(world.GetOrModifyTradeStatus(), infoscreenData.hoveredOption)
	end
end

local function SetInfoscreen(infoscreenData, world, newDisplayedScreen, data)
	if infoscreenData.active and infoscreenData.displayedScreen == newDisplayedScreen then
		CloseScreen(infoscreenData, world)
		return
	end
	infoscreenData.active = true
	infoscreenData.displayedScreen = newDisplayedScreen
	infoscreenData.hoveredOption = false
	infoscreenData.extraData = data
	world.SetPaused(true)
end

local function ButtonClicked(infoscreenData, world, interface, buttonHovered)
	SetInfoscreen(infoscreenData, world, buttonHovered)
end

local function KeyPressed(infoscreenData, world, interface, key)
	if key == "space" then
		CloseScreen(infoscreenData, world)
		return true
	end
end

local function Draw(infoscreenData, world, interface, mouseX, mouseY)
	local windowHeight = love.graphics.getHeight()
	
	if infoscreenData.active then
		DrawInfoscreen(infoscreenData, world, interface, mouseX, mouseY)
	end
	
	local buttonX = 100 + 128
	local buttonY = windowHeight - 60
	local hovered = false
	
	local index = 1
	buttonX, buttonY, hovered = DrawButton(buttonX, buttonY, hovered, infoscreenData, mouseX, mouseY, index, "Build")
	index = index + 1
	
	buttonX, buttonY, hovered = DrawButton(buttonX, buttonY, hovered, infoscreenData, mouseX, mouseY, index, "Laptop")
	index = index + 1
	
	buttonX, buttonY, hovered = DrawButton(buttonX, buttonY, hovered, infoscreenData, mouseX, mouseY, index, "Trade")
	index = index + 1
	
	buttonX, buttonY, hovered = DrawButton(buttonX, buttonY, hovered, infoscreenData, mouseX, mouseY, index, "Books")
	index = index + 1
	
	buttonX, buttonY, hovered = DrawButton(buttonX, buttonY, hovered, infoscreenData, mouseX, mouseY, index, "Help")
	index = index + 1
	
	return hovered
end

return {
	SetInfoscreen = SetInfoscreen,
	HandleClick = HandleClick,
	ButtonClicked = ButtonClicked,
	KeyPressed = KeyPressed,
	Draw = Draw,
}
