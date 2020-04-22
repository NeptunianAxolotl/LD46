local IterableMap = require("include/IterableMap")
local cameraUtilities = require("include/cameraUtilities")
local interfaceUtilities = require("include/interfaceUtilities")
local infoscreenUtilities = require("include/infoscreenUtilities")

popupUtilities = require("include/popupUtilities")

local function GetNewInterface(world)

	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	local width, height = love.graphics.getDimensions()

	--------------------------------------------------
	-- Locals
	--------------------------------------------------
	local cameraX, cameraY = GLOBAL.CAMERA_START_X, GLOBAL.CAMERA_START_Y
	local camSpeedX, camSpeedY = 0, 0
	local placingStructure = false
	local selectedMonk = false
	local demolishMode = false
	local hoveredMonk = false
	
	local uiClick = false
	local buttonHovered = false
	
	local infoscreenData = {
		active = false,
		currentScreen = 0
	}
	
	local externalFuncs = {}

	--------------------------------------------------
	-- Utilities
	--------------------------------------------------
	
	function externalFuncs.SetPlacingStructure(newPlacingStructure)
		placingStructure = newPlacingStructure
		demolishMode = false
	end
	
	function externalFuncs.SetDemolish()
		placingStructure = false
		demolishMode = true
	end
	
	--------------------------------------------------
	-- Input
	--------------------------------------------------


	function externalFuncs.MouseMoved(mouseX, mouseY, dx, dy, istouch)
		
	end

	function externalFuncs.MousePressed(mouseX, mouseY, button, istouch, presses)
		if buttonHovered then
			demolishMode = false
			infoscreenUtilities.ButtonClicked(infoscreenData, world, externalFuncs, buttonHovered)
			return
		elseif infoscreenData.active then
			infoscreenUtilities.HandleClick(infoscreenData, world, externalFuncs, mouseX, mouseY)
			return
		end
		
		if uiClick then
			if uiClick.removePriority then
				uiClick.monk.RemovePriority(uiClick.removePriority)
			end
			return
		end
		
		if demolishMode then
			demolishMode = false
			if button ~= 2 and not hoveredMonk then
				local room = interfaceUtilities.ScreenToRoom(externalFuncs, world.GetRoomList(), mouseX, mouseY)
				if room then
					local roomDef = room.GetDef()
					if roomDef.demolishable then
						room.Destroy()
						return
					end
				end
			end
			placingStructure = false
		end
		
		if placingStructure then
			if button == 2 then
				placingStructure = false
			else
				local def = DEFS.roomDefNames[placingStructure]
				local px, py = externalFuncs.ScreenToWorld(mouseX, mouseY)
				px, py = interfaceUtilities.SnapStructure(def, px, py)
				local canPlace = interfaceUtilities.CheckStructurePlacement(world.GetRoomList(), world.GetMonkList(), def, px, py)
				
				if canPlace then
					local newRoom = world.CreateRoom(def.buildDef, px, py)
					if selectedMonk then
						local roomDef = newRoom.GetDef()
						selectedMonk.SetNewPriority(newRoom, "build", true)
					end
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
		
		if selectedMonk then
			local room = interfaceUtilities.ScreenToRoom(externalFuncs, world.GetRoomList(), mouseX, mouseY)
			if room then
				local roomDef = room.GetDef()
				local clickTask = roomDef.clickTask
				if( not clickTask) and roomDef.clickTaskFunc then
					local wx, wy = externalFuncs.ScreenToWorld(mouseX, mouseY)
					local pos = room.GetPosition()
					clickTask = roomDef.clickTaskFunc(wx - pos[1], wy - pos[2])
				end
				
				if clickTask then
					if (clickTask == "use_laptop" or clickTask == "library_learn") and (not selectedMonk.MidwayThroughLaptop()) then
						infoscreenUtilities.SetInfoscreen(infoscreenData, world, 0, {
							monk = selectedMonk,
							alreadyHasSkill = selectedMonk.HasSkill(),
							isLibrary = (clickTask == "library_learn"),
							clickRoom = room,
							clickTask = clickTask,
						})
					else
						selectedMonk.SetNewPriority(room, clickTask, false, true)
					end
				end
				return
			end
		end
		
		selectedMonk = false
	end

	function externalFuncs.MouseReleased(mouseX, mouseY, button, istouch, presses)
		
	end

	function externalFuncs.KeyPressed(key, scancode, isRepeat)
		if key == "r" and (love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl")) and (love.keyboard.isDown("rshift") or love.keyboard.isDown("lshift")) then
			RestartGame()
		end
		if infoscreenData.active and infoscreenUtilities.KeyPressed(infoscreenData, world, interface, key) then
			return
		end
		if key == "space" then
			world.SetPaused(not world.GetPaused())
			return
		end
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
		
		--if true then
		--	local x, y = externalFuncs.ScreenToWorld(mouseX, mouseY, true)
		--	print(x, y)
		--end
		
		love.graphics.setLineWidth(2)
		
		hoveredMonk = false
		if not (buttonHovered or uiClick or infoscreenData.active) then
			if placingStructure then
				local def = DEFS.roomDefNames[placingStructure]
				local x, y = externalFuncs.ScreenToWorld(mouseX, mouseY)
				x, y = interfaceUtilities.SnapStructure(def, x, y)
				local canPlace = interfaceUtilities.CheckStructurePlacement(world.GetRoomList(), world.GetMonkList(), def, x, y)
				
				x, y = externalFuncs.WorldToScreen(x, y, def.drawOriginX, def.drawOriginY)
				love.graphics.setColor(0.8, (canPlace and 0.8) or 0.3, (canPlace and 0.8) or 0.3, 0.4)
				love.graphics.draw(def.image, x, y, 0, 1, 1, 0, 0, 0, 0)
			else
				hoveredMonk = interfaceUtilities.ScreenToMonk(externalFuncs, world.GetMonkList(), mouseX, mouseY)
				if hoveredMonk then
					local x, y, w, h = interfaceUtilities.MonkToScreen(externalFuncs, hoveredMonk)
					love.graphics.setColor(GLOBAL.BAR_FOOD_RED, GLOBAL.BAR_FOOD_GREEN, GLOBAL.BAR_FOOD_BLUE, 0.5)
					love.graphics.rectangle("line", x, y, w, h, 2, 6, 4 )
				end
			end
		end
		
		
		if demolishMode and not (hoveredMonk or uiClick or buttonHovered or infoscreenData.active) then
			local room = interfaceUtilities.ScreenToRoom(externalFuncs, world.GetRoomList(), mouseX, mouseY)
			if room then
				local roomDef = room.GetDef()
				if roomDef.demolishable then
					love.graphics.setColor(1, 0, 0, 0.1)
					local vertices = interfaceUtilities.RoomToScreen(externalFuncs, room)
					love.graphics.polygon("fill", vertices)
					love.graphics.setColor(1, 0, 0)
					love.graphics.polygon("line", vertices)
				end
			end
		end
		
		if selectedMonk then
			local x, y, w, h = interfaceUtilities.MonkToScreen(externalFuncs, selectedMonk)
			love.graphics.setColor(GLOBAL.BAR_FOOD_RED, GLOBAL.BAR_FOOD_GREEN, GLOBAL.BAR_FOOD_BLUE)
			love.graphics.rectangle("line", x, y, w, h, 2, 6, 4 )
			
			local clickTask = false
			
			if (not uiClick) and (not demolishMode) and (not buttonHovered) and (not (hoveredMonk or placingStructure or infoscreenData.active)) then
				local room = interfaceUtilities.ScreenToRoom(externalFuncs, world.GetRoomList(), mouseX, mouseY)
				if room then
					love.graphics.setColor(GLOBAL.BAR_FOOD_RED, GLOBAL.BAR_FOOD_GREEN, GLOBAL.BAR_FOOD_BLUE)
					local vertices = interfaceUtilities.RoomToScreen(externalFuncs, room)
					love.graphics.polygon("line", vertices)
					
					local roomDef = room.GetDef()
					clickTask = roomDef.clickTask
					if( not clickTask) and roomDef.clickTaskFunc then
						local wx, wy = externalFuncs.ScreenToWorld(mouseX, mouseY)
						local pos = room.GetPosition()
						clickTask = roomDef.clickTaskFunc(wx - pos[1], wy - pos[2])
					end
				end
			end
			
			uiClick = interfaceUtilities.DrawMonkInterface(externalFuncs, selectedMonk, mouseX, mouseY, clickTask)
		else
			uiClick = false
		end
		
		buttonHovered = infoscreenUtilities.Draw(infoscreenData, world, externalFuncs, mouseX, mouseY)
		
		popupUtilities.Draw(world, externalFuncs)
	end
	
	--------------------------------------------------
	-- Finish Initialising
	--------------------------------------------------

	infoscreenUtilities.SetInfoscreen(infoscreenData, world, 5)

	return externalFuncs
end

return GetNewInterface
