local stationUtilities = require("include/stationUtilities")

local function New(init)
	local hunger = 0
	local fatigue = 0
	
	local station = nil
	local stationDoor = nil
	local taskType = "sleep"
	local currentPath = nil
	
	local atStation = false
	local movingToPos = false
	local movingDiagonal = false
	local movingProgress = 0
	local moveSpeed = 0.8
	
	local originX = GLOBAL.TILE_SIZE/2
	local originY = GLOBAL.TILE_SIZE/2

	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	local def       = DEFS.monkDef
	local pos       = init.pos
	local direction = math.random()

	init = nil
	--------------------------------------------------
	-- Locals
	--------------------------------------------------


	--------------------------------------------------
	-- Interface
	--------------------------------------------------
	local externalFuncs = {}

	function externalFuncs.UpdateMonk(dt, roomList, stationsByUse)
		-- Do station stuff
		if atStation then
			return
		end
		
		-- Find a station to be at.
		if not station then
			local potentialStations = stationsByUse[taskType]
			station, stationDoor, currentPath = stationUtilities.FindStationPath(pos, roomList, potentialStations)
		end
		
		-- Moving towards an adjacent square. Update position.
		if movingToPos then
			if movingDiagonal then
				movingProgress = movingProgress + moveSpeed*dt
			else
				movingProgress = movingProgress + moveSpeed*dt*GLOBAL.INV_DIAG
			end
			if movingProgress < 1 then
				return
			end
			pos = movingToPos
			movingProgress = movingProgress - 1
		end
		
		-- Moving towards a station entrance. Get next adjacent position
		if currentPath then
			movingToPos, movingDiagonal = currentPath.GetNextNode()
		end
		
		-- Entering a station
		if station and not movingToPos then
			if movingProgress > 1 then
				atStation = true
				movingProgress = 1
			end
			local x, y, dir = station.GetTransitionPosition(stationDoor, movingProgress)
			pos[1], pos[2], direction = x, y, dir
			
			if atStation then
				movingProgress = 1
			else
				movingProgress = movingProgress + moveSpeed*dt/station.GetPathLength(stationDoor)
			end
		end
		
	end

	function externalFuncs.Draw(offsetX, offsetY)
		local x, y
		if movingToPos then
			x = (pos[1]*(1 - movingProgress) + movingToPos[1]*movingProgress)*GLOBAL.TILE_SIZE - offsetX
			y = (pos[2]*(1 - movingProgress) + movingToPos[2]*movingProgress)*GLOBAL.TILE_SIZE - offsetY
		else
			x = pos[1]*GLOBAL.TILE_SIZE - offsetX
			y = pos[2]*GLOBAL.TILE_SIZE - offsetY
		end
		
		love.graphics.draw(def.image, x, y, direction, 1, 1, originX, originY, 0, 0)
	end
	
	return externalFuncs
end

return New
