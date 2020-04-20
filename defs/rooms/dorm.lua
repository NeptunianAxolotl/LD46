
local function DoSleep(station, room, monk, workData, dt)
	return monk.ModifyFatigue(0.28*dt)
end

local data = {
	name = "dorm",
	humanName = "Dormitory",
	buildDef = "dorm_build",
    desc = "Fancy lodgings\nCost: 3 wood, 3 stone",
	image = "fancy_dorm.png",
	width = 3,
	height = 2,
    drawOriginX = 0,
	drawOriginY = 1.5,
	demolishable = false,
	stations = {
		{
			pos = {0.3, 0.35},
            overrideDir = 3*math.pi/2,
			taskType = "sleep",
			PerformAction = DoSleep,
			doors = {
                {
                    entryPath = {{1,-1},{1,-0.5},{0.8,0}},
                    teleportToStation = true,
                },
                {
                    entryPath = {{1,2},{1,1},{0.8,0}},
                    teleportToStation = true,
                },
			},
		},
		{
			pos = {1.65, 0.1},
            overrideDir = 0,
			taskType = "sleep",
			PerformAction = DoSleep,
			doors = {
                {
                    entryPath = {{1,-1},{1,0},{1.2,0.5}},
                    teleportToStation = true,
                },
                {
                    entryPath = {{1,2},{1,1},{1.2,0.5}},
                    teleportToStation = true,
                },
			},
		},
		{
			pos = {1.65, 0.9},
            overrideDir = 0,
			taskType = "sleep",
			PerformAction = DoSleep,
			doors = {
                {
                    entryPath = {{1,-1},{1,0},{1.2,0.5}},
                    teleportToStation = true,
                },
                {
                    entryPath = {{1,2},{1,1},{1.2,0.5}},
                    teleportToStation = true,
                },
			},
		},
	}
}

return data
