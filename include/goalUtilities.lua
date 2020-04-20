
local function CheckCookGoal(monk, currentGoal, stationsByUse)
	if not currentGoal.station then
		return false
	end
	local resource, count = monk.GetResource()
	if (resource == "bread" or resource == "veg") and count > 0 then
		return false
	end
	
	local station, taskType = stationUtilities.ReserveClosestStationMultiType(monk, false, false, stationsByUse, {"get_bread", "get_veg"})
	return taskType, station, nil, not taskType
end

local function CheckMakeWoodGoal(monk)
	local resource, count = monk.GetResource()
	if resource ~= "log" or count < 1 then
		return "chop"
	end
end

local function CheckBuildGoal(monk, currentGoal, stationsByUse)
	if not currentGoal.station then
		return
	end
	local room = currentGoal.station.GetParent()
	
	local taskTypes = {}
	if room.GetResourceCount("reqWood") > 0 then
		taskTypes[#taskTypes + 1] = "add_wood"
	end
	if room.GetResourceCount("reqStone") > 0 then
		taskTypes[#taskTypes + 1] = "add_stone"
	end
	if #taskTypes > 0 then
		local station, taskType = stationUtilities.ReserveClosestStationMultiType(monk, room, false, stationsByUse, taskTypes)
		return taskType, station, room, not taskType
	end
end

-- Goals are not interruptable if a monk is carrying a resource
-- destined for the station that their goal is about.
-- This prevents resources being destroyed.
local function CheckGoalInterrupt(monk, currentGoal)
	if not (currentGoal and currentGoal.station) then
		return true
	end
	local resource, count = monk.GetResource()
	if (not resource) or (count == 0) then
		return true
	end
	
	local haveResource, needResource = currentGoal.station.IsFetchResource(resource)
	if haveResource then
		return false
	end
	return true
end

local function CheckSubGoal(monk, currentGoal, stationsByUse)
	if not currentGoal then
		return false
	end
	
	if not CheckGoalInterrupt(monk, currentGoal) then
		return false
	end
	
	if DEFS.taskSubgoal[currentGoal.taskType] then
		return DEFS.taskSubgoal[currentGoal.taskType](monk, currentGoal, stationsByUse)
	elseif currentGoal.taskType == "cook" then
		return CheckCookGoal(monk, currentGoal, stationsByUse)
	elseif currentGoal.taskType == "build" then
		return CheckBuildGoal(monk, currentGoal, stationsByUse)
	--elseif currentGoal.taskType == "chop" then
	--	local resource, count = monk.GetResource()
	--	if resource == "log" and count > 0 then
	--		return "make_wood"
	--	end
	--elseif currentGoal.taskType == "make_wood" then
	--	return CheckMakeWoodGoal(monk)
	--elseif currentGoal.taskType == "get_wood" and not currentGoal.station then
	--	local potentialStations = stationsByUse[currentGoal.taskType]
	--	local pos = monk.GetPosition()
	--	currentGoal.station = stationUtilities.ReserveClosestStation(monk, currentGoal.requiredRoom, currentGoal.preferredRoom, potentialStations)
	--	currentGoal.wantRepath = true
	--	if not currentGoal.station then
	--		return "make_wood"
	--	end
	elseif currentGoal.taskType == "get_stone" and not currentGoal.station then
		local potentialStations = stationsByUse[currentGoal.taskType]
		local pos = monk.GetPosition()
		currentGoal.station = stationUtilities.ReserveClosestStation(monk, currentGoal.requiredRoom, currentGoal.preferredRoom, potentialStations)
		currentGoal.wantRepath = true
		if not currentGoal.station then
			return "make_stone"
		end
	elseif currentGoal.taskType == "add_wood" then
		local resource, count = monk.GetResource()
		if resource ~= "wood" or count < 1 then
			return "get_wood"
		end
	elseif currentGoal.taskType == "add_stone" then
		local resource, count = monk.GetResource()
		if resource ~= "stone" or count < 1 then
			return "get_stone"
		end
	end
	return false
end

local function RemoveMonkRoomLinks(room, monkList)
	for _, monk in monkList.Iterator() do
		if monk.IsUsingRoom(room) then
			return false
		end
	end
	
	monkList.ApplySelf("DiscardRoomGoals", room)
	return true
end

return {
	CheckSubGoal = CheckSubGoal,
	RemoveMonkRoomLinks = RemoveMonkRoomLinks,
	CheckGoalInterrupt = CheckGoalInterrupt,
}
