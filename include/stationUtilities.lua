local FindPath = require("include/pathfinder")

local function GetPathMaybeFromRoom(pos, goalPos, roomList, atStation, atStationDoor)
	if not atStation then
		local path = FindPath(pos, goalPos, roomList)
		return path
	end
	
	if not atStationDoor then
		atStationDoor = atStation.GetClosestDoor(goalPos[1], goalPos[2])
	end
	pos = atStation.GetDoorPosition(atStationDoor)
	
	local path = FindPath(pos, goalPos, roomList)
	return path, atStationDoor
end

local function FindStationPath(monk, pos, roomList, potentialStations, requiredRoom, preferredRoom, alreadySetGoalStation, atStation, atStationDoor)
	local closeStation = alreadySetGoalStation
	
	if not closeStation then
		local costDist
		for _, station in potentialStations.Iterator() do
			if ((not requiredRoom) or requiredRoom.index == station.GetParent().index) and station.IsAvailible(monk) then
				local dist = station.Distance(pos[1], pos[2])
				if preferredRoom and preferredRoom.index == station.GetParent().index then
					dist = dist - 1000000
				end
				if (not costDist) or (dist < costDist) then
					closeStation = station
					costDist = dist
				end
			end
		end
	
		if not closeStation then
			return false
		end
	end
	local closeDoor = closeStation.GetClosestDoor(pos[1], pos[2])
	
	local stationPath, leaveByDoor = GetPathMaybeFromRoom(pos, closeStation.GetDoorPosition(closeDoor), roomList, atStation, atStationDoor)
	if not alreadySetGoalStation then
		closeStation.AddReservation()
	end
	
	return closeStation, closeDoor, stationPath, leaveByDoor
end

local function ReserveClosestStation(monk, requiredRoom, preferredRoom, pos, potentialStations)
	local closeStation
	local costDist
	for _, station in potentialStations.Iterator() do
		if ((not requiredRoom) or requiredRoom.index == station.GetParent().index) and station.IsAvailible(monk) then
			local dist = station.Distance(pos[1], pos[2])
			if preferredRoom and preferredRoom.index == station.GetParent().index then
				dist = dist - 1000000
			end
			if (not costDist) or (dist < costDist) then
				closeStation = station
				costDist = dist
			end
		end
	end
	
	if not closeStation then
		return false
	end
	
	if not alreadySetGoalStation then
		closeStation.AddReservation()
	end
	
	return closeStation
end

local function CheckFreeStation(monk, potentialStations, requiredRoom)
	for _, station in potentialStations.Iterator() do
		if ((not requiredRoom) or requiredRoom.index == station.GetParent().index) and station.IsAvailible(monk) then
			return true
		end
	end
	return false
end

return {
	FindStationPath = FindStationPath,
	ReserveClosestStation = ReserveClosestStation,
	CheckFreeStation = CheckFreeStation,
}
