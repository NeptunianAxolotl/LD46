
local function DoSleep(station, room, monk, workData, dt)
	return monk.ModifyFatigue(0.3*dt)
end

local data = {
	name = "dorm",
	buildDef = "dorm_build",
	image = "dorm.png",
	width = 3,
	height = 2,
    drawOriginX = 0,
	drawOriginY = 1.5,
	stations = {
		{
			pos = {0, 0},
			taskType = "sleep",
			PerformAction = DoSleep,
			doors = {
                {
                    entryPath = {{1,-1},{1,0}}
                },
                {
                    entryPath = {{1,2},{1,0}}
                },
			},
		},
		{
			pos = {0, 1},
			taskType = "sleep",
			PerformAction = DoSleep,
			doors = {
                {
                    entryPath = {{1,-1},{1,1}}
                },
                {
                    entryPath = {{1,2},{1,1}}
                },
			},
		},
		{
			pos = {2, 1},
			taskType = "sleep",
			PerformAction = DoSleep,
			doors = {
                {
                    entryPath = {{1,-1},{1,0}}
                },
                {
                    entryPath = {{1,2},{1,1}}
                },
			},
		},
	}
}

return data
