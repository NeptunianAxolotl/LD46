
local function DoSleep(station, room, monk, workData, dt)
	return monk.ModifyFatigue(0.18*dt)
end

local data = {
	name = "dorm_small",
	image = "slum_dorm.png",
	width = 2,
	height = 2,
    drawOriginX = 0,
	drawOriginY = 1,
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
	}
}

return data
