local FindPath = require("include/pathfinder")

local function FindStationPath(pos, roomList, potentialStations)
	local closeStation
	local costDist
	
	for _, station in potentialStations.Iterator() do
		if station.IsAvailible() then
			local dist = station.Distance(pos[1], pos[2])
			if (not costDist) or (dist < costDist) then
				closeStation = station
				costDist = dist
			end
		end
	end
	
	if not closeStation then
		return false
	end
	local closeDoor = closeStation.GetClosestDoor(pos[1], pos[2])
	local stationPath = FindPath(pos, closeStation.GetDoorPosition(closeDoor), roomList)
	
	closeStation.SetReserved(true)
	
	return closeStation, closeDoor, stationPath
end


return {
	FindStationPath = FindStationPath,
}
