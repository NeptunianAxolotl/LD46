
local function SpawnAction(station, room, monk, workData, dt)
	local spawnData = GetWorld().GetOrModifySpawnStatus()
	
	monk.ModifyFatigue(-0.02*dt)
	monk.ModifyFood(-0.02*dt)
	spawnData.progress = spawnData.progress + spawnData.rate*dt*monk.GetTaskMod("play_organ")
	if spawnData.progress > 1 then
		spawnData.progress = spawnData.progress - 1
		spawnUtilities.SpawnMonk(spawnData, room)
	end
end

local function Pray(station, room, monk, workData, dt)
	monk.ModifyFatigue(-0.002*dt)
	monk.ModifyFood(-0.002*dt)
end

local data = {
	name = "chapel",
	humanName = "Chapel",
	buildDef = "chapel_build",
	desc = "Attracts monks\nCost: 5 wood, 8 stone",
	image = "chapel.png",
	clickTask = "play_organ",
	drawOriginX = 0,
	drawOriginY = 2,
	width = 4,
	height = 3,
	stations = {
		{
			pos = {0.8, 0.4},
			taskType = "play_organ",
            overrideDir = 3*math.pi/2,
			PerformAction = SpawnAction,
			doors = {
                {
                    entryPath = {{-1,1}, {0,1}}
                },
			},
		},
		{
			pos = {2, 0},
			taskType = "pray",
			PerformAction = Pray,
            overrideDir = 0,
			doors = {
                {
                    entryPath = {{2,-1}}
                },
			},
		},
		{
			pos = {2,2},
			taskType = "pray",
			PerformAction = Pray,
            overrideDir = 0,
			doors = {
                {
                    entryPath = {{2,3}}
                },
			},
		},
		{
			pos = {0.4, 1.5},
			taskType = "pray",
			PerformAction = Pray,
            overrideDir = 0,
			allowParallelUse = true, -- Monks can stack in the last one.
			doors = {
                {
                    entryPath = {{-1,1}, {0,1}}
                },
			},
		},
	}
}

return data

