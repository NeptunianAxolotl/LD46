
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
			infoscreenData.hoveredOption = buildOptions[i]
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
-- Handler
--------------------------------------------------

local function DrawInfoscreen(infoscreenData, world, interface, mouseX, mouseY)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(DEFS.images.infoscreen, 0, 0, 0, 1, 1, 0, 0, 0, 0)
	
	-- Draw cross to close
	if infoscreenData.displayedScreen == 1 then
		DrawBuildScreen(infoscreenData, world, interface, mouseX, mouseY)
	elseif infoscreenData.displayedScreen == 5 then
		DrawKnowledgeScreen(infoscreenData, world, interface, mouseX, mouseY)
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
	if infoscreenData.displayedScreen == 1 then
		if infoscreenData.hoveredOption then
			interface.SetPlacingStructure(infoscreenData.hoveredOption)
			CloseScreen(infoscreenData, world, interface)
		end
	end
	
	
end

local function ButtonClicked(infoscreenData, world, interface, buttonHovered)
	infoscreenData.active = true
	infoscreenData.displayedScreen = buttonHovered
	infoscreenData.hoveredOption = false
	world.SetPaused(true)
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
	
	local buttonX = 175
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
	
	return hovered
end

return {
	HandleClick = HandleClick,
	ButtonClicked = ButtonClicked,
	KeyPressed = KeyPressed,
	Draw = Draw,
}
