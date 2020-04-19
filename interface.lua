local IterableMap = require("include/IterableMap")
local cameraUtilities = require("include/cameraUtilities")
local interfaceUtilities = require("include/interfaceUtilities")

local function GetNewInterface(world)

	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	local width, height = love.graphics.getDimensions()

	--------------------------------------------------
	-- Locals
	--------------------------------------------------
	local cameraX, cameraY = 0, -400
	local camSpeedX, camSpeedY = 0, 0
	local placingStructure = false
	local selectedMonk = false

	--------------------------------------------------
	-- Utilities
	--------------------------------------------------
	
	--------------------------------------------------
	-- Input
	--------------------------------------------------
	local externalFuncs = {}


	function externalFuncs.MouseMoved(mouseX, mouseY, dx, dy, istouch)
		
	end

	function externalFuncs.MousePressed(mouseX, mouseY, button, istouch, presses)
		if placingStructure then
			if button == 2 then
				placingStructure = false
			else
				local def = DEFS.roomDefNames[placingStructure]
				local px, py = externalFuncs.ScreenToWorld(mouseX, mouseY)
				px, py = interfaceUtilities.SnapStructure(def, px, py)
				local canPlace = interfaceUtilities.CheckStructurePlacement(world.GetRoomList(), world.GetMonkList(), def, px, py)
				
				if canPlace then
					world.CreateRoom(def.buildDef, px, py)
					placingStructure = false
				end
			end
			return
		end
		
		local monk = interfaceUtilities.ScreenToMonk(externalFuncs, world.GetMonkList(), mouseX, mouseY)
		if monk then
			selectedMonk = monk
			return
		end
		
		if button == 1 then
			selectedMonk = false
		end
	end

	function externalFuncs.MouseReleased(mouseX, mouseY, button, istouch, presses)
		
	end

	function externalFuncs.KeyPressed(key, scancode, isRepeat)
		placingStructure = "dorm"
	end

	--------------------------------------------------
	-- Interface
	--------------------------------------------------
	
	function externalFuncs.GetCameraOffset()
		return math.floor(cameraX), math.floor(cameraY)
	end
	
	function externalFuncs.WorldToScreen(x, y, originX, originY)
		local offsetX, offsetY = 0, 0
		if originX then
			offsetX = math.floor(originX * GLOBAL.TILE_SIZE)
		end
		if originY then
			offsetY = math.floor(originY * GLOBAL.TILE_SIZE)
		end
		return (x+y)*GLOBAL.TILE_SIZE/2 - math.floor(cameraX) - offsetX, (y-x)*GLOBAL.TILE_SIZE/2 - math.floor(cameraY) - offsetY
	end
	
	function externalFuncs.ScreenToWorld(sx, sy, integer)
		if integer then
			return math.floor((sx+math.floor(cameraX)-sy-math.floor(cameraY))/GLOBAL.TILE_SIZE), math.floor((sx+math.floor(cameraX)+sy+math.floor(cameraY))/GLOBAL.TILE_SIZE)
		end
		return (sx+math.floor(cameraX)-sy-math.floor(cameraY))/GLOBAL.TILE_SIZE, (sx+math.floor(cameraX)+sy+math.floor(cameraY))/GLOBAL.TILE_SIZE
	end

	--------------------------------------------------
	-- Interface
	--------------------------------------------------

	function externalFuncs.UpdateInterface(dt)
		cameraX, cameraY, camSpeedX, camSpeedY = cameraUtilities.UpdateCamera(dt, cameraX, cameraY, camSpeedX, camSpeedY)
	end

	function externalFuncs.DrawInterface()
		local mouseX, mouseY = love.mouse.getPosition()
		
		if placingStructure then
			local def = DEFS.roomDefNames[placingStructure]
			local x, y = externalFuncs.ScreenToWorld(mouseX, mouseY)
			x, y = interfaceUtilities.SnapStructure(def, x, y)
			local canPlace = interfaceUtilities.CheckStructurePlacement(world.GetRoomList(), world.GetMonkList(), def, x, y)
			
			x, y = externalFuncs.WorldToScreen(x, y, def.drawOriginX, def.drawOriginY)
			love.graphics.setColor(0.8, (canPlace and 0.8) or 0.3, (canPlace and 0.8) or 0.3, 0.4)
			love.graphics.draw(def.image, x, y, 0, 1, 1, 0, 0, 0, 0)
		else
			local monk = interfaceUtilities.ScreenToMonk(externalFuncs, world.GetMonkList(), mouseX, mouseY)
			if monk then
				local x, y, w, h = interfaceUtilities.MonkToScreen(externalFuncs, monk)
				love.graphics.setColor(GLOBAL.BAR_FOOD_RED, GLOBAL.BAR_FOOD_GREEN, GLOBAL.BAR_FOOD_BLUE, 0.5)
				love.graphics.rectangle("line", x, y, w, h, 2, 6, 4 )
			end
		end
		
		if selectedMonk then
			local x, y, w, h = interfaceUtilities.MonkToScreen(externalFuncs, selectedMonk)
			love.graphics.setColor(GLOBAL.BAR_FOOD_RED, GLOBAL.BAR_FOOD_GREEN, GLOBAL.BAR_FOOD_BLUE)
			love.graphics.rectangle("line", x, y, w, h, 2, 6, 4 )
			
			interfaceUtilities.DrawMonkInterface(interface, selectedMonk)
		end
	end
	
	return externalFuncs
end

return GetNewInterface
