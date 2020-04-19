
local function CheckCookGoal(monk)
	local resource, count = monk.GetResource()
	if resource ~= "grain" or count < 1 then
		return "getGrain"
	end
end

local function CheckSubGoal(monk, currentGoal)
	if not currentGoal then
		return false
	end
	if currentGoal.taskType == "cook" then
		return CheckCookGoal(monk)
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
