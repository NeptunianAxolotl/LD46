local IterableMap = require("include/IterableMap")
local cameraUtilities = require("include/cameraUtilities")

local function GetNewInterface(world)

	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	local width, height = love.graphics.getDimensions()

	--------------------------------------------------
	-- Locals
	--------------------------------------------------
	local cameraX, cameraY = 0, 0
	local camSpeedX, camSpeedY = 0, 0
	local placingStructure = false

	--------------------------------------------------
	-- Utilities
	--------------------------------------------------
	
	--------------------------------------------------
	-- Input
	--------------------------------------------------
	local externalFuncs = {}


	function externalFuncs.MouseMoved(x, y, dx, dy, istouch)
		
	end

	function externalFuncs.MousePressed(x, y, button, istouch, presses)
		
	end

	function externalFuncs.MouseReleased(x, y, button, istouch, presses)
		
	end

	function externalFuncs.KeyPressed(key, scancode, isRepeat)
		placingStructure = "dorm"
	end

	--------------------------------------------------
	-- Interface
	--------------------------------------------------
	
	function externalFuncs.GetCameraOffset()
		return cameraX, cameraY
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
			local x, y = cameraX + mouseX - 0.5*GLOBAL.TILE_SIZE*def.width, cameraY + mouseY - 0.5*GLOBAL.TILE_SIZE*def.height
			
			x = math.floor((x + 0.5*GLOBAL.TILE_SIZE)/GLOBAL.TILE_SIZE)*GLOBAL.TILE_SIZE - cameraX
			y = math.floor((y + 0.5*GLOBAL.TILE_SIZE)/GLOBAL.TILE_SIZE)*GLOBAL.TILE_SIZE - cameraY
			
			love.graphics.setColor(0.8, 0.8, 0.8, 0.4)
			love.graphics.draw(def.image, x, y, 0, 1, 1, 0, 0, 0, 0)
		end
	end
	
	return externalFuncs
end

return GetNewInterface
