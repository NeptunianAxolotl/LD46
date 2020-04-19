
local function DoSleep(station, room, monk, workData, dt)
	if math.random() < 0.01 then
		room.Destroy()
	end
	return monk.ModifyFatigue(0.3*dt)
end

local data = {
	name = "dorm",
	buildDef = "dorm_build",
	image = "dorm.png",
	drawOriginX = 0,
	drawOriginY = 0,
	width = 3,
	height = 2,
	stations = {
		{
			pos = {0, 0},
			taskType = "sleep",
			PerformAction = DoSleep,
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
		{
			pos = {0, 1},
			taskType = "sleep",
			PerformAction = DoSleep,
			doors = {
				{
					pathLength = math.sqrt(5),
					pathFunc = function (progress)
						return 1 - progress, -1 + 2*progress, math.rad(225)
					end
				},
				{
					pathLength = math.sqrt(2),
					pathFunc = function (progress)
						return 1 - progress, 2 - progress, math.rad(225)
					end
				},
			},
		},
		{
			pos = {2, 1},
			taskType = "sleep",
			PerformAction = DoSleep,
			doors = {
				{
					pathLength = math.sqrt(5),
					pathFunc = function (progress)
						return 1 + progress, -1 + 2*progress, math.rad(225)
					end
				},
				{
					pathLength = math.sqrt(2),
					pathFunc = function (progress)
						return 1 + progress, 2 - progress, math.rad(225)
					end
				},
			},
		},
	}
}

return data
