
local function DrawButton(buttonX, buttonY, hovered, infoscreenData, mouseX, mouseY, index, text)
	if infoscreenData.displayedScreen == index or UTIL.PosInRectangle(buttonX + 9, buttonY + 9, 156, 42, mouseX, mouseY) then
		love.graphics.setColor(0.8, 1, 0.8, 1)
		hovered = index
	else
		love.graphics.setColor(0.8, 0.8, 0.8, 1)
	end
	love.graphics.draw(DEFS.images.buttonInterface, buttonX, buttonY, 0, 1, 1, 0, 0, 0, 0)
	
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print(text, buttonX + 42, buttonY + 18)
	
	buttonX = buttonX + 164
	return buttonX, buttonY, hovered
end

local function DrawInfoscreen(infoscreenData)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(DEFS.images.infoscreen, 0, 0, 0, 1, 1, 0, 0, 0, 0)
end

--------------------------------------------------
-- External Interface
--------------------------------------------------

local function HandleClick(infoscreenData, world, interface, mouseX, mouseY)
end

local function ButtonClicked(infoscreenData, world, interface, buttonHovered)
	infoscreenData.active = true
	infoscreenData.displayedScreen = buttonHovered
	world.SetPaused(true)
end

local function KeyPressed(infoscreenData, world, interface, key)

end

local function Draw(infoscreenData, world, interface, mouseX, mouseY)
	local windowHeight = love.graphics.getHeight()
	
	if infoscreenData.active then
		DrawInfoscreen(infoscreenData, world, interface, mouseX, mouseY)
	end
	
	local buttonX = 0
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
	
	buttonX, buttonY, hovered = DrawButton(buttonX, buttonY, hovered, infoscreenData, mouseX, mouseY, index, "Learning")
	index = index + 1
	
	
	return hovered
end

return {
	HandleClick = HandleClick,
	ButtonClicked = ButtonClicked,
	KeyPressed = KeyPressed,
	Draw = Draw,
}
