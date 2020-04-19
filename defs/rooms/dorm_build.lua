
local function DoBuild(station, room, monk, workData, dt)
	if math.random() < 0.01 then
		room.Destroy()
	end
	return monk.ModifyFatigue(0.3*dt)
end

local data = {
	name = "dorm_build",
	buildDef = "dorm_build",
	image = "basic3x2.png",
	width = 3,
	height = 2,
    drawOriginX = -3/2,
	drawOriginY = 3/2,
	stations = {
		{
			pos = {0, 0},
			taskType = "build",
			PerformAction = DoBuild,
			doors = {
				{
					pathLength = math.sqrt(2),
					pathFunc = function (progress)
						return 1 - progress, -1 + progress, math.rad(225)
					end
				},
				{
					pathLength = math.sqrt(5),
					pathFunc = function (progress)
						return 1 - progress, 2  -2*progress, math.rad(225)
					end
				},
			},
		},
	}
}

return data
