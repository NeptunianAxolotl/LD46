
local function DoSleep(station, room, monk, workData, dt)
	return monk.ModifyFatigue(0.18*dt)
end

local data = {
	name = "dorm_small",
	humanName = "Hut",
	desc = "Meagre lodgings\nCost: 3 wood",
	buildDef = "dorm_small_build",
	image = "slum_dorm.png",
	width = 2,
	height = 2,
    drawOriginX = 0,
	drawOriginY = 1,
	demolishable = false,
	stations = {
		{
			pos = {0.55, 0.4},
			taskType = "sleep",
			PerformAction = DoSleep,
            overrideDir = 0,
			doors = {
                {
                    entryPath = {{0,2},{0.5,1.6},{0.5,1.2}},
                    teleportToStation = true,
                },
                {
                    entryPath = {{1,2},{0.5,1.6},{0.5,1.2}},
                    teleportToStation = true,
                },
			},
		},
	}
}

return data
