

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
				{
					pathLength = math.sqrt(2),
					pathFunc = function (progress)
						return 1.5 - progress, -0.5 + progress, math.rad(225)
					end
				},
				{
					pathLength = math.sqrt(5),
					pathFunc = function (progress)
						return 1.5 - progress, 2.5  -2*progress, math.rad(225)
					end
				},
			},
		},
		{
			pos = {0.5, 1.5},
			typeName = "sleep",
			doors = {
				{
					pathLength = math.sqrt(5),
					pathFunc = function (progress)
						return 1.5 - progress, -0.5 + 2*progress, math.rad(225)
					end
				},
				{
					pathLength = math.sqrt(2),
					pathFunc = function (progress)
						return 1.5 - progress, 2.5 - progress, math.rad(225)
					end
				},
			},
		},
		{
			pos = {2.5, 1.5},
			typeName = "sleep",
			doors = {
				{
					pathLength = math.sqrt(5),
					pathFunc = function (progress)
						return 1.5 + progress, -0.5 + 2*progress, math.rad(225)
					end
				},
				{
					pathLength = math.sqrt(2),
					pathFunc = function (progress)
						return 1.5 + progress, 2.5 - progress, math.rad(225)
					end
				},
			},
		},
	}
}

for i = 1, #data.stations do
	local station = data.stations[i]
	for j = 1, #station.doors do
		local x, y = station.doors[j].pathFunc(0)
		station.doors[j].pos = {x, y}
	end
end

return data
