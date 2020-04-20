
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

return {
	InitKnowStatus = InitKnowStatus,
	CheckVictory = CheckVictory,
}
