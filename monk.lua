local stationUtilities = require("include/stationUtilities")

local function New(init)
	local food = 1
	local sleep = 1
	local moral = 1
	
	local taskType = "field"
	
	local station = nil
	local stationDoor = nil
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
			station.PerformAction(externalFuncs)
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
				movingProgress = movingProgress + moveSpeed*dt*GLOBAL.INV_DIAG
			else
				movingProgress = movingProgress + moveSpeed*dt
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
	
	local function GetDrawPos(offsetX, offsetY)
		if movingToPos then
			local x = (pos[1]*(1 - movingProgress) + movingToPos[1]*movingProgress)*GLOBAL.TILE_SIZE - offsetX
			local y = (pos[2]*(1 - movingProgress) + movingToPos[2]*movingProgress)*GLOBAL.TILE_SIZE - offsetY
			return x + 0.5*GLOBAL.TILE_SIZE, y + 0.5*GLOBAL.TILE_SIZE
		end
		local x = pos[1]*GLOBAL.TILE_SIZE - offsetX
		local y = pos[2]*GLOBAL.TILE_SIZE - offsetY
		return x + 0.5*GLOBAL.TILE_SIZE, y + 0.5*GLOBAL.TILE_SIZE
	end

	function externalFuncs.Draw(offsetX, offsetY)
		local x, y = GetDrawPos(offsetX, offsetY)
		love.graphics.draw(def.image, x, y, direction, 1, 1, originX, originY, 0, 0)
	end
	
	function externalFuncs.DrawPost(offsetX, offsetY)
		local x, y = GetDrawPos(offsetX, offsetY)
		
		love.graphics.setColor(GLOBAL.BAR_RED, GLOBAL.BAR_GREEN, GLOBAL.BAR_BLUE)
		love.graphics.rectangle("fill", x - 0.45*GLOBAL.TILE_SIZE, y - 0.45*GLOBAL.TILE_SIZE, 0.9*GLOBAL.TILE_SIZE, 0.15*GLOBAL.TILE_SIZE, 2, 6, 4 )
		love.graphics.setColor(GLOBAL.BAR_SLEEP_RED, GLOBAL.BAR_SLEEP_GREEN, GLOBAL.BAR_SLEEP_BLUE)
		love.graphics.rectangle("fill", x - 0.45*GLOBAL.TILE_SIZE, y - 0.45*GLOBAL.TILE_SIZE, 0.9*GLOBAL.TILE_SIZE*sleep, 0.15*GLOBAL.TILE_SIZE, 2, 6, 4 )
		
	end
	
	return externalFuncs
end

return New
