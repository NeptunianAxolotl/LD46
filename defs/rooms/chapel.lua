
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
			pos = {1.4, 0.5},
			taskType = "play_organ",
			PerformAction = SpawnAction,
			doors = {
                {
                    entryPath = {{-1,0}, {1.4, 2.6}}
                },
			},
		},
		{
			pos = {2.4, 0.5},
			taskType = "pray",
			PerformAction = Pray,
			doors = {
                {
                    entryPath = {{-1,0}, {1.4, 2.6}}
                },
			},
		},
		{
			pos = {1.8, 0.5},
			taskType = "pray",
			PerformAction = Pray,
			doors = {
                {
                    entryPath = {{-1,0}, {1.4, 2.6}}
                },
			},
		},
		{
			pos = {1.4, 0.5},
			taskType = "pray",
			PerformAction = Pray,
			allowParallelUse = true, -- Monks can stack in the last one.
			doors = {
                {
                    entryPath = {{-1,0}, {1.4, 2.6}}
                },
			},
		},
	}
}

return data

