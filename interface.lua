local IterableMap = require("include/IterableMap")

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
	
	local function UpdateCamera(dt)
		local xAccel, yAccel = false, false
		if love.keyboard.isDown("a") then
			camSpeedX = camSpeedX - dt*GLOBAL.CAM_ACCEL
			xAccel = true
		elseif love.keyboard.isDown("d") then
			camSpeedX = camSpeedX + dt*GLOBAL.CAM_ACCEL
			xAccel = true
		end
		
		if love.keyboard.isDown("w") then
			camSpeedY = camSpeedY - dt*GLOBAL.CAM_ACCEL
			yAccel = true
		elseif love.keyboard.isDown("s") then
			camSpeedY = camSpeedY + dt*GLOBAL.CAM_ACCEL
			yAccel = true
		end
		
		if camSpeedX ~= 0 then
			if camSpeedX < 0 then
				if camSpeedX < -GLOBAL.CAM_SPEED then
					camSpeedX = -GLOBAL.CAM_SPEED
				end
				if not xAccel then
					camSpeedX = camSpeedX + dt*GLOBAL.CAM_ACCEL
					if camSpeedX > 0 then
						camSpeedX = 0
					end
				end
			else
				if camSpeedX > GLOBAL.CAM_SPEED then
					camSpeedX = GLOBAL.CAM_SPEED
				end
				if not xAccel then
					camSpeedX = camSpeedX - dt*GLOBAL.CAM_ACCEL
					if camSpeedX < 0 then
						camSpeedX = 0
					end
				end
			end
			cameraX = cameraX + dt*camSpeedX
		end
		
		if camSpeedY ~= 0 then
			if camSpeedY < 0 then
				if camSpeedY < -GLOBAL.CAM_SPEED then
					camSpeedY = -GLOBAL.CAM_SPEED
				end
				if not yAccel then
					camSpeedY = camSpeedY + dt*GLOBAL.CAM_ACCEL
					if camSpeedY > 0 then
						camSpeedY = 0
					end
				end
			else
				if camSpeedY > GLOBAL.CAM_SPEED then
					camSpeedY = GLOBAL.CAM_SPEED
				end
				if not yAccel then
					camSpeedY = camSpeedY - dt*GLOBAL.CAM_ACCEL
					if camSpeedY < 0 then
						camSpeedY = 0
					end
				end
			end
			cameraY = cameraY + dt*camSpeedY
		end
	end
	
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
		UpdateCamera(dt)
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
