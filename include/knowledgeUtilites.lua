
local function InitKnowStatus(monk, potentialStations, requiredRoom)
	local knowData = {
		booksWritten = {},
		bookProgress = {}
	}
	
	return knowData
end


return {
	InitKnowStatus = InitKnowStatus,
}
