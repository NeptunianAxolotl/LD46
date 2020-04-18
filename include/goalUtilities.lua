
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

return {
	CheckSubGoal = CheckSubGoal,
}
