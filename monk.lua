local stationUtilities = require("include/stationUtilities")

local function New(init)
	local food = 1
	local sleep = 1
	local moral = 1
	
	
	local resourceCarried = false
	local resourceCount = 0
	
	local wantThreashold = 0.3
	local moveSpeed = 2
	
	local goals = {}
	-- station
	-- stationDoor
	-- currentPath
	-- taskType
	
	local atStation = false
	local atStationDoor = false
	
	local movingToPos = false
	local movingDiagonal = false
	local movingProgress = 0
	
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
	-- Goal Handling
	--------------------------------------------------
	
	
	--------------------------------------------------
	-- Locals
	--------------------------------------------------

	local function CheckWants(currentGoal)
		if currentGoal and currentGoal.taskType == "sleep" then
			return false -- We are already pursuing a want.
		end
		if sleep < wantThreashold then
			return "sleep"
		end
		return false
	end

	local function AddGoal(newTaskType)
		goals[#goals + 1] = {
			taskType = newTaskType
		}
	end
	
	local function RemoveCurrentGoal()
		if #goals == 0 then
			return false
		end
		if goals[#goals].station then
			goals[#goals].station.RemoveReservation()
		end
		goals[#goals] = nil
		return true
	end
	
	local function ClearGoals()
		while RemoveCurrentGoal() do
		end
	end
	
	local function SetNewGoal(newTaskType)
		ClearGoals()
		AddGoal(newTaskType)
	end
	
	local function UpdateStationPosition(progress)
		local x, y, dir = atStation.GetTransitionPosition(atStationDoor, progress)
		pos[1], pos[2], direction = x, y, dir
	end

	--------------------------------------------------
	-- Interface
	--------------------------------------------------
	local externalFuncs = {}

	function externalFuncs.ModifyFatigue(change)
		sleep = sleep + change
		if change < 0 and sleep < 0 then
			sleep = 0
			return true
		end
		if change > 0 and sleep > 1 then
			sleep = 1
			return true
		end
	end

	--------------------------------------------------
	-- Update
	--------------------------------------------------
	
	function externalFuncs.UpdateMonk(dt, roomList, stationsByUse)
		
		-- Find a goal?
		if (#goals == 0) then
			goals[1] = {
				taskType = "field",
			}
		end
		local currentGoal = goals[#goals]
		
		-- Check whether the goal needs changing to satisfy a want
		local wantGoal = CheckWants(currentGoal)
		if wantGoal then
			SetNewGoal(wantGoal)
			currentGoal = goals[#goals]
			--print("wantGoal", wantGoal, #goals)
		end
		
		-- Find a station to be at.
		if currentGoal and (not currentGoal.station) then
			local potentialStations = stationsByUse[currentGoal.taskType]
			currentGoal.station, currentGoal.stationDoor, currentGoal.currentPath, doorToLeaveBy = stationUtilities.FindStationPath(
			                            pos, roomList, potentialStations, atStation, (movingProgress < 1) and atStationDoor)
			if doorToLeaveBy then
				--print("doorToLeaveBy", doorToLeaveBy, (currentGoal.station or {index = 0}).index)
				atStationDoor = doorToLeaveBy
			end
		end
		
		-- Do station stuff
		if atStation then
			if currentGoal and currentGoal.station and atStation.index == currentGoal.station.index and atStation.GetTaskType() == currentGoal.taskType then
				if movingProgress < 1 then
					movingProgress = movingProgress + moveSpeed*dt / atStation.GetPathLength(atStationDoor)
					if movingProgress > 1 then
						movingProgress = 1
					end
					UpdateStationPosition(movingProgress)
				end
				
				if movingProgress >= 1 then
					local done = atStation.PerformAction(externalFuncs, goalData, dt)
					if done then
						RemoveCurrentGoal()
					end
				end
				return
			end
			
			-- Leave the station
			if not atStationDoor then
				atStationDoor = atStation.GetRandomDoor()
			end
			if movingProgress > 0 then
				movingProgress = movingProgress - moveSpeed*dt / atStation.GetPathLength(atStationDoor)
			end
			if movingProgress > 0 then
				UpdateStationPosition(movingProgress)
				return
			end
			UpdateStationPosition(0)
			atStation = false
			atStationDoor = false
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
		if currentGoal and currentGoal.currentPath then
			movingToPos, movingDiagonal = currentGoal.currentPath.GetNextNode()
		end
		
		-- Entering a station
		if currentGoal and currentGoal.station and not movingToPos then
			atStation = currentGoal.station
			atStationDoor = currentGoal.stationDoor
			UpdateStationPosition(movingProgress)
		end
		
	end
	
	--------------------------------------------------
	-- Drawing
	--------------------------------------------------
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
		
		local currentGoal = goals[#goals]
		if currentGoal and currentGoal.taskType then
			font.SetSize(2)
			--local text = love.graphics.newText(font.GetFont(), text)
			love.graphics.setColor(1, 1, 1)
			love.graphics.print(currentGoal.taskType, x - 0.4*GLOBAL.TILE_SIZE, y - 0.2*GLOBAL.TILE_SIZE)
			if currentGoal.station then
				love.graphics.print(currentGoal.station.index, x - 0.4*GLOBAL.TILE_SIZE, y + 0.1*GLOBAL.TILE_SIZE)
			end
		end
	end
	
	return externalFuncs
end

return New
