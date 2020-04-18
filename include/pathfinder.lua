
local function FindPath(start, goal, roomList)

	local popCount = 0

	local externalFuncs = {}
	
	function externalFuncs.GetNextNode()
		if popCount == 0 then
			popCount = popCount + 1
			return UTIL.Add(start, {1, 0}), false
		end
		if popCount == 1 then
			popCount = popCount + 1
			return UTIL.Add(start, {0, 1}), true
		end
		if popCount == 2 then
			popCount = popCount + 1
			return goal, false
		end
		return false, false
	end
	
	return externalFuncs
end

return FindPath
