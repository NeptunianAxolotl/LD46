
local function InitSpawnStatus(monk, potentialStations, requiredRoom)
	local spawnData = {
		progress = 0,
		rate = 0.5,
	}
	
	return spawnData
end

local function SpawnMonk(spawnData, room)
	spawnData.rate = spawnData.rate*0.85
	local pos = room.GetPosition()
	local monk = GetWorld().CreateMonk(pos[1] - 1, pos[2] - 1)
	monk.SetNewPriority(room, "pray", true)
end

return {
	InitSpawnStatus = InitSpawnStatus,
	SpawnMonk = SpawnMonk,
}
