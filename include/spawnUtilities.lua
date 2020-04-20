
local spawnLocations = {
	{0, -30},
	{45, 16},
	{4, 58},
	{-42, 12},
}

local function InitSpawnStatus(monk, potentialStations, requiredRoom)
	local spawnData = {
		progress = 0,
		rate = 0.04,
	}
	
	return spawnData
end

local function SpawnMonk(spawnData, room)
	spawnData.rate = spawnData.rate*0.6 + 0.002
	local pos = spawnLocations[math.floor(4*math.random()) + 1] or spawnLocations[1]
	local monk = GetWorld().CreateMonk(pos[1], pos[2])
	monk.SetNewPriority(room, "pray", true)
end

return {
	InitSpawnStatus = InitSpawnStatus,
	SpawnMonk = SpawnMonk,
}
