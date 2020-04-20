
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
	love.graphics.print(text, buttonX + 42, buttonY + 18)
	
	buttonX = buttonX + 164
	return buttonX, buttonY, hovered
end

--------------------------------------------------
-- Building Screen
--------------------------------------------------

local function DrawBuildScreen(infoscreenData, world, interface, mouseX, mouseY)
	love.graphics.setColor(0, 0, 0, 1)
	
	font.SetSize(0)
	love.graphics.print("Pick a Structure", 374, 90)
	
	local buildOptions = world.GetBuildOptions()
	local startHeight = 165
	local drawX = 256
	local drawY = startHeight
	
	font.SetSize(1)
	for i = 1, #buildOptions do
		if UTIL.PosInRectangle(drawX, drawY, 130, 34, mouseX, mouseY) then
			love.graphics.setColor(1, 0, 0, 1)
			infoscreenData.hoveredOption = {build = buildOptions[i]}
		else
			love.graphics.setColor(0, 0, 0, 1)
		end
		love.graphics.print(buildOptions[i], drawX, drawY)
		drawY = drawY + 36
		if drawY > 630 then
			drawY = startHeight
			drawX = drawX + 160
		end
	end
end

--------------------------------------------------
-- Trade Screen
--------------------------------------------------

local function DrawLaptopScreen(infoscreenData, world, interface, mouseX, mouseY)
	love.graphics.setColor(0, 0, 0, 1)
	
	font.SetSize(0)
	love.graphics.print("Laptop Status", 395, 90)
    
    local laptopData = world.GetOrModifyLaptopStatus()
    local originalX = 240
    local drawX = originalX
    local drawY = 165
    local powerBarWidth = 200
    local powerBarHeight = 50
    
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
    elseif laptopData.charge < 0.3 then
        love.graphics.setColor(1, 1, 0)
    else
        love.graphics.setColor(0, 1, 0)
    end
	love.graphics.rectangle("fill", drawX+2, drawY+2, (powerBarWidth-4)*laptopData.charge, powerBarHeight-4, 2, 0, 0 )
	
	love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(math.ceil(laptopData.charge*100) .. "%", drawX+powerBarWidth/2-12, drawY+powerBarHeight/2-10)
    
    drawX = originalX
    drawY = drawY + powerBarHeight
    drawY = drawY + 25
    love.graphics.setColor(0, 0, 0)
    
    love.graphics.print("Power Consumption Rate: ", drawX, drawY)
    drawY = drawY + 100
    
    love.graphics.print("Current Peripherals: ", drawX, drawY)
    
end

--------------------------------------------------
-- Trade Screen
--------------------------------------------------

local function DrawTradeScreen(infoscreenData, world, interface, mouseX, mouseY)
	love.graphics.setColor(0, 0, 0, 1)
	
	font.SetSize(0)
	love.graphics.print("Trading Post", 400, 90)
	
	local tradeData = world.GetOrModifyTradeStatus()
	local drawX = 240
	local drawY = 165
	
	local room = tradeData.room
	
	font.SetSize(2)
	love.graphics.print("Money: " .. tradeData.money, drawX, drawY)
	drawY = drawY + 55
	
	local startX = drawX
	love.graphics.print("Good", drawX, drawY)
	drawX = drawX + 135
	love.graphics.print("Sell Price", drawX, drawY)
	drawX = drawX + 50
	
	drawX = drawX + 78
	love.graphics.print("Buy Price", drawX, drawY)
	
	drawX = drawX + 140
	love.graphics.print("Stored", drawX, drawY)
	
	drawY = drawY + 40
	
	for i = 1, #tradeData.goods do
		drawX = startX
		local good = tradeData.goods[i]
		love.graphics.print(good.name, drawX, drawY)
		drawX = drawX + 85
		
		drawX = drawX + 50
		love.graphics.print(math.floor(good.price), drawX, drawY)
		drawX = drawX + 50
		
		if UTIL.PosInRectangle(drawX, drawY, 120, 34, mouseX, mouseY) then
			love.graphics.setColor(1, 0, 0, 1)
			infoscreenData.hoveredOption = {toggleSell = i}
		else
			love.graphics.setColor(0, 0, 0, 1)
		end
		love.graphics.print("Sell", drawX, drawY)
		love.graphics.setColor(0, 0, 0, 1)
		drawX = drawX + 40
		
		drawX = drawX + 40
		love.graphics.print(math.floor(good.price*good.buyMarkup), drawX, drawY)
		drawX = drawX + 50
		
		if UTIL.PosInRectangle(drawX, drawY, 120, 34, mouseX, mouseY) then
			love.graphics.setColor(1, 0, 0, 1)
			infoscreenData.hoveredOption = {buy = i}
		else
			love.graphics.setColor(0, 0, 0, 1)
		end
		love.graphics.print("Buy", drawX, drawY)
		love.graphics.setColor(0, 0, 0, 1)
		drawX = drawX + 90
		
		love.graphics.print(room.GetResourceCount(good.name), drawX, drawY)
		drawX = drawX + 40
		if UTIL.PosInRectangle(drawX, drawY, 120, 34, mouseX, mouseY) then
			love.graphics.setColor(1, 0, 0, 1)
			infoscreenData.hoveredOption = {stockpileToggle = i}
		else
			love.graphics.setColor(0, 0, 0, 1)
		end
		love.graphics.print((good.requesting and "Stocking") or "Not Stocking", drawX, drawY)
		love.graphics.setColor(0, 0, 0, 1)
		
		drawY = drawY + 40
	end
end


--------------------------------------------------
-- Skill Selection Screen
--------------------------------------------------

local function DrawSkillSelectScreen(infoscreenData, world, interface, mouseX, mouseY)
	love.graphics.setColor(0, 0, 0, 1)
	
	font.SetSize(0)
	love.graphics.print("Select a Skill", 374, 90)
	
	local options = DEFS.skillDefs
	local startHeight = 165
	local drawX = 256
	local drawY = startHeight
	
	font.SetSize(1)
	for i = 1, #options do
		if UTIL.PosInRectangle(drawX, drawY, 130, 34, mouseX, mouseY) then
			love.graphics.setColor(1, 0, 0, 1)
			infoscreenData.hoveredOption = {skill = options[i].name}
		else
			love.graphics.setColor(0, 0, 0, 1)
		end
		love.graphics.print(options[i].humanName, drawX, drawY)
		drawY = drawY + 36
		if drawY > 630 then
			drawY = startHeight
			drawX = drawX + 160
		end
	end
end

--------------------------------------------------
-- Handler
--------------------------------------------------

local function DrawInfoscreen(infoscreenData, world, interface, mouseX, mouseY)
	infoscreenData.hoveredOption = false
	
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(DEFS.images.infoscreen, 0, 0, 0, 1, 1, 0, 0, 0, 0)
	
	if UTIL.PosInRectangle(808, 66, 32, 32, mouseX, mouseY) then
		infoscreenData.hoveredOption = {closeScreen = true}
		love.graphics.setColor(1, 1, 1, 1)
	else
		love.graphics.setColor(0.8, 0.8, 0.8, 1)
	end
	love.graphics.draw(DEFS.images.closescreen, 808, 66, 0, 1, 1, 0, 0, 0, 0)
	
	if infoscreenData.displayedScreen == 0 then
		DrawSkillSelectScreen(infoscreenData, world, interface, mouseX, mouseY)
	elseif infoscreenData.displayedScreen == 1 then
		DrawBuildScreen(infoscreenData, world, interface, mouseX, mouseY)
	elseif infoscreenData.displayedScreen == 2 then
        DrawLaptopScreen(infoscreenData, world, interface, mouseX, mouseY)
	elseif infoscreenData.displayedScreen == 3 then
		DrawTradeScreen(infoscreenData, world, interface, mouseX, mouseY)
	elseif infoscreenData.displayedScreen == 4 then
	elseif infoscreenData.displayedScreen == 5 then
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

local function HandleClick(infoscreenData, world, interface)
	if not (infoscreenData and infoscreenData.hoveredOption) then
		return
	end

	if infoscreenData.hoveredOption.closeScreen then
		CloseScreen(infoscreenData, world, interface)
		return
	end
	
	if infoscreenData.displayedScreen == 0 then
		infoscreenData.extraData.monk.SetDesiredSkill(infoscreenData.hoveredOption.skill)
		CloseScreen(infoscreenData, world, interface)
	end
	if infoscreenData.displayedScreen == 1 then
		interface.SetPlacingStructure(infoscreenData.hoveredOption.build)
		CloseScreen(infoscreenData, world, interface)
	end
	if infoscreenData.displayedScreen == 3 then
		tradeUtilities.PerformAction(world.GetOrModifyTradeStatus(), infoscreenData.hoveredOption)
	end
end

local function SetInfoscreen(infoscreenData, world, newDisplayedScreen, data)
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
	
	local buttonX = 94
	local buttonY = windowHeight - 60
	local hovered = false
	
	local index = 1
	buttonX, buttonY, hovered = DrawButton(buttonX, buttonY, hovered, infoscreenData, mouseX, mouseY, index, "Build")
	index = index + 1
	
	buttonX, buttonY, hovered = DrawButton(buttonX, buttonY, hovered, infoscreenData, mouseX, mouseY, index, "Laptop")
	index = index + 1
	
	buttonX, buttonY, hovered = DrawButton(buttonX, buttonY, hovered, infoscreenData, mouseX, mouseY, index, "Trade")
	index = index + 1
	
	buttonX, buttonY, hovered = DrawButton(buttonX, buttonY, hovered, infoscreenData, mouseX, mouseY, index, "Knowledge")
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
