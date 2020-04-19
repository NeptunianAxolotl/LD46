local stationUtilities = require("include/stationUtilities")
local goalUtilities = require("include/goalUtilities")

local function New(init)
	local food = 1
	local sleep = 1
	local moral = 1
	
	local resourceCarried = false
	local resourceCount = 0
	
	local wantThreashold = 0.3
	local moveSpeed = 2
	
	local goals = {}
	-- taskType
	-- requiredRoom
	-- preferredRoom
	-- station
	-- stationDoor
	-- currentPath
	-- wantRepath
	-- workData
	
	local priorities = {
		{
			taskType = "field",
		},
		{
			taskType = "cook",
		},
	}
	-- taskType
	-- requiredRoom
	-- preferredRoom
	-- tempoary
	
	local atStation = false
	local atStationDoor = false
	
	local movingToPos = false
	local movingDiagonal = false
	local movingProgress = 0

	local externalFuncs = {}
	
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
	
	local function AddGoal(newTaskType, stationsByUse, placeReservation, requiredRoom, preferredRoom, alreadyFoundStation)
		if #goals > 0 then
			goals[#goals].wantRepath = true
		end
		goals[#goals + 1] = {
			taskType = newTaskType,
			requiredRoom = requiredRoom,
			preferredRoom = preferredRoom,
		}
		local goalData = goals[#goals]
		
		if alreadyFoundStation then
			goalData.station = alreadyFoundStation
			goalData.wantRepath = true
		elseif placeReservation then
			local potentialStations = stationsByUse[newTaskType]
			goalData.station = stationUtilities.ReserveClosestStation(externalFuncs, goalData.requiredRoom, goalData.preferredRoom, pos, potentialStations)
			goalData.wantRepath = true
		end
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
	
	local function UpdateStationPosition(progress, dirMod)
		local x, y, dir = atStation.GetTransitionPosition(atStationDoor, progress)
		pos[1], pos[2], direction = x, y, dir + dirMod
	end

	local function FindGoal(stationsByUse)
		local index = 1
		local priorityCount = #priorities
		while index <= priorityCount do
			local pri = priorities[index]
			local reservedStation = stationUtilities.ReserveClosestStation(externalFuncs, pri.requiredRoom, pri.preferredRoom, pos, stationsByUse[pri.taskType])
			if reservedStation then
				AddGoal(pri.taskType, stationsByUse, true, pri.requiredRoom, pri.preferredRoom, reservedStation)
				return
			end
			index = index + 1
		end
	end

	--------------------------------------------------
	-- Utilities
	--------------------------------------------------

	local function CheckWants(currentGoal)
		if currentGoal and (currentGoal.taskType == "sleep" or currentGoal.taskType == "eat") then
			return false -- We are already pursuing a want.
		end
		if sleep < wantThreashold then
			return "sleep"
		end
		if food < wantThreashold then
			return "eat"
		end
		return false
	end

	--------------------------------------------------
	-- Interface
	--------------------------------------------------

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
	
	function externalFuncs.ModifyFood(change)
		food = food + change
		if change < 0 and food < 0 then
			sleep = 0
			return true
		end
		if change > 0 and food > 1 then
			food = 1
			return true
		end
	end
	
	function externalFuncs.GetResource()
		return resourceCarried, resourceCount
	end
	
	function externalFuncs.SetResource(newResource, newCount)
		resourceCarried = newResource
		resourceCount = newCount
	end
	
	function externalFuncs.GetPosition()
		return pos, movingToPos
	end
	
	function externalFuncs.CheckRepath(x, y, w, h)
		if #goals > 0 and goals[#goals].currentPath and goals[#goals].currentPath.NeedRepath(x, y, w, h) then
			goals[#goals].wantRepath = true
		end
	end
	
	--------------------------------------------------
	-- Room Status
	--------------------------------------------------
	
	function externalFuncs.IsUsingRoom(room)
		return atStation and (atStation.GetParent().index == room.index)
	end
	
	function externalFuncs.DiscardRoomGoals(room)
		if atStation and (atStation.GetParent().index == room.index) then
			atStation = false
			atStationDoor = false
		end
		
		local goalCount = #goals
		local goalRead, goalWrite = 1, 1
		while goalRead <= goalCount do
			local goalData = goals[goalRead]
			
			if (goalData.requiredRoom and goalData.requiredRoom.index == room.index) or (goalData.station and goalData.station.GetParent().index == room.index) then
				goals[goalRead] = nil
				goalRead = goalRead + 1
			else
				if goalRead ~= goalWrite then
					goals[goalRead] = nil
					goals[goalWrite] = goalData
				end
				goalRead = goalRead + 1
				goalWrite = goalWrite + 1
			end
		end
	end

	--------------------------------------------------
	-- Update
	--------------------------------------------------
	
	function externalFuncs.UpdateMonk(dt, roomList, stationsByUse)
		externalFuncs.ModifyFatigue(GLOBAL.CONSTANT_FATIGUE*dt)
		externalFuncs.ModifyFood(GLOBAL.CONSTANT_HUNGER*dt)
		
		-- Moving towards an adjacent square. Update position.
		if movingToPos then
			if movingDiagonal then
				movingProgress = movingProgress + moveSpeed*dt*GLOBAL.INV_DIAG
			else
				movingProgress = movingProgress + moveSpeed*dt
			end
			if movingProgress < 1 then
				externalFuncs.ModifyFatigue(GLOBAL.MOTION_FATIGUE*dt)
				externalFuncs.ModifyFood(GLOBAL.MOTION_HUNGER*dt)
				return
			end
			pos = movingToPos
			movingProgress = movingProgress - 1
		end
		
		local currentGoal = goals[#goals]
		-- Check whether the goal needs changing to satisfy a want
		local wantGoal = CheckWants(currentGoal)
		if wantGoal then
			SetNewGoal(wantGoal)
			currentGoal = goals[#goals]
			--print("wantGoal", wantGoal, #goals)
		end
		
		-- Find a goal?
		if (#goals == 0) then
			FindGoal(stationsByUse)
			currentGoal = goals[#goals]
		end
		
		-- Add any required subgoals.
		local subGoal = goalUtilities.CheckSubGoal(externalFuncs, currentGoal)
		while subGoal do
			AddGoal(subGoal, stationsByUse, true, subGoal.requiredRoom)
			currentGoal = goals[#goals]
			subGoal = goalUtilities.CheckSubGoal(externalFuncs, currentGoal)
		end
		
		-- Find a station to be at.
		if currentGoal and (currentGoal.wantRepath or (not currentGoal.station)) then
			local potentialStations = stationsByUse[currentGoal.taskType]
			--print("find path", currentGoal.taskType, (currentGoal.station or {index = 0}).index, (currentGoal.station and currentGoal.station.GetTaskType()) or "none", potentialStations.GetIndexMax())
			currentGoal.station, currentGoal.stationDoor, currentGoal.currentPath, doorToLeaveBy =
			stationUtilities.FindStationPath(
				externalFuncs, pos, roomList, potentialStations,
				currentGoal.requiredRoom, currentGoal.preferredRoom, currentGoal.station,
				atStation, (movingProgress < 1) and atStationDoor
			)
			currentGoal.wantRepath = false
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
					externalFuncs.ModifyFatigue(GLOBAL.MOTION_FATIGUE*dt)
					externalFuncs.ModifyFood(GLOBAL.MOTION_HUNGER*dt)
					UpdateStationPosition(movingProgress, 0)
				end
				
				if movingProgress >= 1 then
					currentGoal.workData = currentGoal.workData or {}
					local done = atStation.PerformAction(externalFuncs, currentGoal.workData, dt)
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
				externalFuncs.ModifyFatigue(GLOBAL.MOTION_FATIGUE*dt)
				externalFuncs.ModifyFood(GLOBAL.MOTION_HUNGER*dt)
				UpdateStationPosition(movingProgress, GLOBAL.PI)
				return
			end
			movingProgress = 0
			UpdateStationPosition(0, GLOBAL.PI)
			atStation = false
			atStationDoor = false
		end
		
		-- Moving towards a station entrance. Get next adjacent position
		if currentGoal and currentGoal.currentPath then
			movingToPos, movingDiagonal = currentGoal.currentPath.GetNextNode()
		end
		
		-- Entering a station
		if currentGoal and currentGoal.station and currentGoal.stationDoor and not movingToPos then
			atStation = currentGoal.station
			atStationDoor = currentGoal.stationDoor
			UpdateStationPosition(movingProgress, 0)
		end
		
	end
	
	--------------------------------------------------
	-- Drawing
	--------------------------------------------------
	local function GetDrawPos()
		if movingToPos then
			local x = (pos[1]*(1 - movingProgress) + movingToPos[1]*movingProgress)
			local y = (pos[2]*(1 - movingProgress) + movingToPos[2]*movingProgress)
			return x - def.drawOriginX, y - def.drawOriginY
		end
		return pos[1] - def.drawOriginX, pos[2] - def.drawOriginY
	end

	function externalFuncs.Draw(interface)
		local x, y = GetDrawPos()
		x, y = interface.WorldToScreen(x, y)
		love.graphics.draw(def.image, x, y, 0, 1, 1, 0, 0, 0, 0)
	end
	
	function externalFuncs.DrawPost(interface)
		local x, y = GetDrawPos()
		x, y = interface.WorldToScreen(x, y)
		
		love.graphics.setColor(GLOBAL.BAR_RED, GLOBAL.BAR_GREEN, GLOBAL.BAR_BLUE)
		love.graphics.rectangle("fill", x + 0.05*GLOBAL.TILE_SIZE, y, 0.9*GLOBAL.TILE_SIZE, 0.1*GLOBAL.TILE_SIZE, 2, 6, 4 )
		love.graphics.setColor(GLOBAL.BAR_SLEEP_RED, GLOBAL.BAR_SLEEP_GREEN, GLOBAL.BAR_SLEEP_BLUE)
		love.graphics.rectangle("fill", x + 0.05*GLOBAL.TILE_SIZE, y, 0.9*GLOBAL.TILE_SIZE*sleep, 0.1*GLOBAL.TILE_SIZE, 2, 6, 4 )
		
		love.graphics.setColor(GLOBAL.BAR_RED, GLOBAL.BAR_GREEN, GLOBAL.BAR_BLUE)
		love.graphics.rectangle("fill", x + 0.05*GLOBAL.TILE_SIZE, y + 0.14*GLOBAL.TILE_SIZE, 0.9*GLOBAL.TILE_SIZE, 0.1*GLOBAL.TILE_SIZE, 2, 6, 4 )
		love.graphics.setColor(GLOBAL.BAR_FOOD_RED, GLOBAL.BAR_FOOD_GREEN, GLOBAL.BAR_FOOD_BLUE)
		love.graphics.rectangle("fill", x + 0.05*GLOBAL.TILE_SIZE, y + 0.14*GLOBAL.TILE_SIZE, 0.9*GLOBAL.TILE_SIZE*food, 0.1*GLOBAL.TILE_SIZE, 2, 6, 4 )
		
		local currentGoal = goals[#goals]
		if currentGoal and currentGoal.taskType then
			font.SetSize(2)
			--local text = love.graphics.newText(font.GetFont(), text)
			love.graphics.setColor(1, 1, 1)
			love.graphics.print(currentGoal.taskType, x + 0.1*GLOBAL.TILE_SIZE, y + 0.3*GLOBAL.TILE_SIZE)
			if currentGoal.station then
				love.graphics.print(currentGoal.station.index, x + 0.1*GLOBAL.TILE_SIZE, y + 0.6*GLOBAL.TILE_SIZE)
			end
		end
	end
	
	return externalFuncs
end

return New
