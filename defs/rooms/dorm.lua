

local data = {
	name = "dorm",
	image = "dorm.png",
	width = 3,
	height = 2,
	resources = {},
	stations = {
		{
			pos = {0.5, 0.5},
			typeName = "sleep",
			doors = {
				pos = {1.5, -0.5},
				pathLength = 200,
				pathFunc = function (progress)
					return 1.5 - progress, -0.5 + progress, math.rad(225)
				end
			},
		},
	}
}

return data
