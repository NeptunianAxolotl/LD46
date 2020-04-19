
local function CheckCookGoal(monk)
	local resource, count = monk.GetResource()
	if resource ~= "grain" or count < 1 then
		return "get_grain"
	end
end

local function CheckMakeWoodGoal(monk)
	local resource, count = monk.GetResource()
	if resource ~= "log" or count < 1 then
		return "chop"
	end
end

local function CheckBuildGoal(monk, currentGoal)
	if not currentGoal.station then
		return
	end
	local room = currentGoal.station.GetParent()
	
	if room.GetResourceCount("reqWood") > 0 then
		return "add_wood", room
	elseif room.GetResourceCount("reqStone") > 0 then
		return "add_stone", room
	end
end

local function CheckSubGoal(monk, currentGoal, stationsByUse)
	if not currentGoal then
		return false
	end
	
	if currentGoal.taskType == "cook" then
		return CheckCookGoal(monk)
	elseif currentGoal.taskType == "make_wood" then
		return CheckMakeWoodGoal(monk)
	elseif currentGoal.taskType == "build" then
		return CheckBuildGoal(monk, currentGoal)
	elseif currentGoal.taskType == "get_wood" and not currentGoal.station then
		local potentialStations = stationsByUse[currentGoal.taskType]
		local pos = monk.GetPosition()
		currentGoal.station = stationUtilities.ReserveClosestStation(monk, currentGoal.requiredRoom, currentGoal.preferredRoom, pos, potentialStations)
		currentGoal.wantRepath = true
		if not currentGoal.station then
			return "make_wood"
		end
	elseif currentGoal.taskType == "add_wood" then
		local resource, count = monk.GetResource()
		if resource ~= "wood" or count < 1 then
			return "get_wood"
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
}
