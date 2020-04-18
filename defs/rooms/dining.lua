
local function DoCook(room, monk, workData, dt)
	
end

local data = {
	name = "dining",
	image = "dining.png",
	width = 3,
	height = 3,
	resources = {},
	stations = {
		{
			pos = {2, 1},
			taskType = "cook",
			PerformAction = DoCook,
			doors = {
				{
					pathLength = math.sqrt(2),
					pathFunc = function (progress)
						return 3 - progress, 2 - progress, math.rad(135)
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
