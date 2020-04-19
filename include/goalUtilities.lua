
local function CheckCookGoal(monk)
	local resource, count = monk.GetResource()
	if resource ~= "grain" or count < 1 then
		return "get_grain"
	end
end

local function CheckMakeWoodGoal(monk)
	local resource, count = monk.GetResource()
	if resource ~= "makeWood" or count < 1 then
		return "chop"
	end
end

local function CheckBuildGoal(monk, currentGoal)
	if not currentGoal.station then
		return
	end
	local stationDef = currentGoal.station.GetDef()
	
	if stationDef.taskSubType then
		local resource, count = monk.GetResource()
		if resource == stationDef.taskSubType and count >= 1 then
			return
		end
		return "get_" .. stationDef.taskSubType
	end
end

local function CheckSubGoal(monk, currentGoal)
	if not currentGoal then
		return false
	end
	if currentGoal.taskType == "cook" then
		return CheckCookGoal(monk)
	elseif currentGoal.taskType == "make-_ood" then
		return CheckMakeWoodGoal(monk)
	elseif currentGoal.taskType == "build" then
		return CheckBuildGoal(monk, currentGoal)
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
