
local function InitKnowStatus(monk, potentialStations, requiredRoom)
	local knowData = {
		booksWritten = {},
		bookProgress = {},
		bookCount = 0
	}
	
	return knowData
end

local function CheckVictory(knowData, world)
	local options = DEFS.skillDefs
	for i = 1, #options do
		if not knowData.booksWritten[options[i].name] then
			return false
		end
	end
	world.DeclareVictory()
end

local function CheckStarvation(world, monkList, roomList)
	local starvation = true
	for _, monk in monkList.Iterator() do
		if not monk.NeedFoodAndNoTask() then
			starvation = false
			if not monk.NeedSleepAndNoTask() then
				starvation = false
				return false
			end
		end
	end
	
	if starvation then
		for _, room in roomList.Iterator() do
			if room.GetResourceCount("food") > 0 then
				return false
			end
		end
	else
		for _, room in roomList.Iterator() do
			if room.GetDef().isSleep then
				return false
			end
		end
	end
	
	world.DeclareDefeat(starvation, not starvation)
	return true
end

return {
	InitKnowStatus = InitKnowStatus,
	CheckVictory = CheckVictory,
	CheckStarvation = CheckStarvation,
}
