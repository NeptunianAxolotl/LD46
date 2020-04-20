
local function DoSleep(station, room, monk, workData, dt)
	return monk.ModifyFatigue(0.3*dt)
end

local data = {
	name = "dorm",
	buildDef = "dorm_build",
	image = "fancy_dorm.png",
	width = 3,
	height = 2,
    drawOriginX = 0,
	drawOriginY = 1.5,
	stations = {
		{
			pos = {0, 0},
            overrideDir = 0,
			taskType = "sleep",
			PerformAction = DoSleep,
			doors = {
                {
                    entryPath = {{1,-1},{1,0}},
                    teleportToStation = true,
                },
                {
                    entryPath = {{1,2},{1,0}},
                    teleportToStation = true,
                },
			},
		},
		{
			pos = {0, 1},
            overrideDir = 0,
			taskType = "sleep",
			PerformAction = DoSleep,
			doors = {
                {
                    entryPath = {{1,-1},{1,1}},
                    teleportToStation = true,
                },
                {
                    entryPath = {{1,2},{1,1}},
                    teleportToStation = true,
                },
			},
		},
		{
			pos = {2, 1},
            overrideDir = 0,
			taskType = "sleep",
			PerformAction = DoSleep,
			doors = {
                {
                    entryPath = {{1,-1},{1,0}},
                    teleportToStation = true,
                },
                {
                    entryPath = {{1,2},{1,1}},
                    teleportToStation = true,
                },
			},
		},
	}
}

return data
