stationUtilities = require("include/stationUtilities")
goalUtilities = require("include/goalUtilities")

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
			taskType = "build",
		},
		{
			taskType = "make_grain",
		},
		{
			taskType = "cook",
		},
	}
	-- taskType
	-- requiredRoom
	-- preferredRoom
	
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
	
	local function GetCurrentGoal()
		return goals[#goals]
	end
	
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
	
	local function SetNewGoal(newTaskType, requiredRoom, preferredRoom)
		ClearGoals()
		AddGoal(newTaskType, nil, false, requiredRoom, preferredRoom)
	end
	
	local function UpdateStationPosition(progress, dirMod)
		local x, y, dir = atStation.GetTransitionPosition(atStationDoor, progress)
		pos[1], pos[2], direction = x, y, dir + dirMod
	end

	local function FindGoal(dt, stationsByUse)
		for i = 1, #priorities do
			local priData = priorities[i]
			local reservedStation = stationUtilities.ReserveClosestStation(externalFuncs, priData.requiredRoom, priData.preferredRoom, pos, stationsByUse[priData.taskType])
			if reservedStation then
				AddGoal(priData.taskType, stationsByUse, true, priData.requiredRoom, priData.preferredRoom, reservedStation)
				return
			end
		end
	end

	local function UpdateSubgoal(dt, stationsByUse)
		local currentGoal = GetCurrentGoal()
		local subGoal, foundStation, requiredRoom = goalUtilities.CheckSubGoal(externalFuncs, currentGoal, stationsByUse)
		while subGoal do
			AddGoal(subGoal, stationsByUse, true, requiredRoom, nil, foundStation)
			currentGoal = GetCurrentGoal()
			subGoal, foundStation, requiredRoom = goalUtilities.CheckSubGoal(externalFuncs, currentGoal, stationsByUse)
		end
		return currentGoal
	end

	--------------------------------------------------
	-- Utilities
	--------------------------------------------------

	local function CheckWants(currentGoal)
		if currentGoal and (currentGoal.taskType == "sleep" or currentGoal.taskType == "eat") then
			return false -- We are already pursuing a want.
		end
		if resourceCarried then
			--return false
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
	
	function externalFuncs.SetNewPriority(room, newTaskType, taskRequires, taskPrefers)
		-- Toggle priority if the task is already at the top of the list.
		if priorities[1] and priorities[1].taskType == newTaskType then
			priorities[1].requiredRoom = taskRequires and room
			priorities[1].preferredRoom = taskPrefers and room
			SetNewGoal(newTaskType, priorities[1].requiredRoom, priorities[1].preferredRoom)
			return
		end
		
		-- Move priority around if the task is already a priority
		local priMatch = false
		for i = #priorities, 2, -1 do
			if priMatch then
				priorities[i] = priorities[i - 1]
			elseif priorities[i].taskType == newTaskType then
				priMatch = priorities[i]
				priorities[i] = priorities[i - 1]
			end
		end
		
		if priMatch then
			priorities[1] = priMatch
			priMatch.requiredRoom = taskRequires and room
			priMatch.preferredRoom = taskPrefers and room
			
			SetNewGoal(newTaskType, priMatch.requiredRoom, priMatch.preferredRoom)
			return
		end
		
		-- The new priority is not in the list. Move everything and add one.
		for i = math.min(#priorities + 1, GLOBAL.PRIORITY_COUNT), 2, -1 do
			priorities[i] = priorities[i - 1]
		end
		
		priorities[1] = {
			taskType = newTaskType,
			requiredRoom = taskRequires and room,
			preferredRoom = taskPrefers and room,
		}
		SetNewGoal(newTaskType, priorities[1].requiredRoom, priorities[1].preferredRoom)
	end

	function externalFuncs.RemovePriority(index)
		for i = index, #priorities - 1 do
			priorities[i] = priorities[i + 1]
		end
		priorities[#priorities] = nil
	end

	function externalFuncs.GetStatus()
		local currentGoal = GetCurrentGoal()
		return sleep, food, resourceCarried, (currentGoal and currentGoal.taskType), "Roderick " .. externalFuncs.index, priorities
	end
	
	--------------------------------------------------
	-- Pathing and Attributes
	--------------------------------------------------

	function externalFuncs.ModifyFatigue(change)
		sleep = sleep + change*GLOBAL.DRAIN_MULT
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
		food = food + change*GLOBAL.DRAIN_MULT
		if change < 0 and food < 0 then
			food = 0
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
	
	function externalFuncs.GetDirection()
		return direction
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
				if (goalData.preferredRoom and goalData.preferredRoom.index == room.index) then
					goalData.preferredRoom = nil
				end
				if goalRead ~= goalWrite then
					goals[goalRead] = nil
					goals[goalWrite] = goalData
				end
				goalRead = goalRead + 1
				goalWrite = goalWrite + 1
			end
		end
		
		local priCount = #priorities
		local priRead, priWrite = 1, 1
		while priRead <= priCount do
			local priData = priorities[priRead]
			
			if (priData.requiredRoom and priData.requiredRoom.index == room.index) then
				priorities[priRead] = nil
				priRead = priRead + 1
			else
				if (priData.preferredRoom and priData.preferredRoom.index == room.index) then
					priData.preferredRoom = nil
				end
				if priRead ~= priWrite then
					priorities[priRead] = nil
					priorities[priWrite] = priData
				end
				priRead = priRead + 1
				priWrite = priWrite + 1
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
		
		local currentGoal = GetCurrentGoal()
		-- Check whether the goal needs changing to satisfy a want
		local wantGoal = CheckWants(currentGoal)
		if wantGoal then
			SetNewGoal(wantGoal)
			currentGoal = GetCurrentGoal()
			--print("wantGoal", wantGoal, #goals)
		end
		
		-- Find a goal?
		if (#goals == 0) then
			FindGoal(dt, stationsByUse)
			currentGoal = GetCurrentGoal()
		end
		
		-- Add any required subgoals.
		currentGoal = UpdateSubgoal(dt, stationsByUse)
		
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
						--print("RemoveCurrentGoal", #goals)
						--for i = 1, #goals do
						--	print(i, goals[i].taskType)
						--end
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
			if movingToPos then
				direction = UTIL.Angle(movingToPos[1] - pos[1], movingToPos[2] - pos[2])
			end
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
	function externalFuncs.GetNonIntegerPos()
		if movingToPos then
			local x = (pos[1]*(1 - movingProgress) + movingToPos[1]*movingProgress)
			local y = (pos[2]*(1 - movingProgress) + movingToPos[2]*movingProgress)
			return x, y
		end
		return pos[1], pos[2]
	end
	
	local function GetDrawPos(interface)
		local x, y = externalFuncs.GetNonIntegerPos()
		x, y = interface.WorldToScreen(x, y, def.drawOriginX, def.drawOriginY)
		return x, y
	end

	function externalFuncs.Draw(interface)
		local x, y = GetDrawPos(interface)
        local imageToDraw = def.defaultImage
        if def.images then
            local imageDirection = math.floor((direction + math.pi/8) / (math.pi/4)) % 8 + 1
            local dirlookup = {def.images.move_NE,def.images.move_E,def.images.move_SE,def.images.move_S,def.images.move_SW,def.images.move_W,def.images.move_NW,def.images.move_N}
            --print(direction)
            --print(imageDirection)
            imageToDraw = dirlookup[imageDirection][1] or def.defaultImage
        end
        w,h = love.graphics.getDimensions(imageToDraw)
        love.graphics.draw(imageToDraw, x, y, 0, 2*GLOBAL.TILE_SIZE / w, 1.2*GLOBAL.TILE_SIZE / h, 0, 0, 0, 0)
	end
	
	function externalFuncs.DrawPost(interface)
		local x, y = GetDrawPos(interface)
		
		love.graphics.setColor(GLOBAL.BAR_RED, GLOBAL.BAR_GREEN, GLOBAL.BAR_BLUE)
		love.graphics.rectangle("fill", x + 0.05*GLOBAL.TILE_SIZE, y, 0.9*GLOBAL.TILE_SIZE, 0.1*GLOBAL.TILE_SIZE, 2, 6, 4 )
		love.graphics.setColor(GLOBAL.BAR_SLEEP_RED, GLOBAL.BAR_SLEEP_GREEN, GLOBAL.BAR_SLEEP_BLUE)
		love.graphics.rectangle("fill", x + 0.05*GLOBAL.TILE_SIZE, y, 0.9*GLOBAL.TILE_SIZE*sleep, 0.1*GLOBAL.TILE_SIZE, 2, 6, 4 )
		
		love.graphics.setColor(GLOBAL.BAR_RED, GLOBAL.BAR_GREEN, GLOBAL.BAR_BLUE)
		love.graphics.rectangle("fill", x + 0.05*GLOBAL.TILE_SIZE, y + 0.14*GLOBAL.TILE_SIZE, 0.9*GLOBAL.TILE_SIZE, 0.1*GLOBAL.TILE_SIZE, 2, 6, 4 )
		love.graphics.setColor(GLOBAL.BAR_FOOD_RED, GLOBAL.BAR_FOOD_GREEN, GLOBAL.BAR_FOOD_BLUE)
		love.graphics.rectangle("fill", x + 0.05*GLOBAL.TILE_SIZE, y + 0.14*GLOBAL.TILE_SIZE, 0.9*GLOBAL.TILE_SIZE*food, 0.1*GLOBAL.TILE_SIZE, 2, 6, 4 )
		
		font.SetSize(2)
		love.graphics.setColor(1, 1, 1)
		local currentGoal = GetCurrentGoal()
		if currentGoal and currentGoal.taskType then
			--local text = love.graphics.newText(font.GetFont(), text)
			love.graphics.print(currentGoal.taskType, x + 0.1*GLOBAL.TILE_SIZE, y + 0.3*GLOBAL.TILE_SIZE)
		end
		love.graphics.print(math.floor(direction*180/math.pi), x + 0.1*GLOBAL.TILE_SIZE, y + 0.6*GLOBAL.TILE_SIZE)
	end
	
	return externalFuncs
end

return New
