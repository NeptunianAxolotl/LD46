
local function CheckCookGoal(monk)
	
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
