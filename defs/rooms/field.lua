
local function FieldAction(monk, room)

end

local function CollectAction(monk, room)

end

local data = {
	name = "field",
	image = "field.png",
	width = 3,
	height = 3,
	resources = {},
	stations = {
		{
			pos = {1, 0.5},
			typeName = "field",
			PerformAction = FieldAction,
			doors = {
				{
					pathLength = math.sqrt(2),
					pathFunc = function (progress)
						return -1 + 2*progress, 1 - 0.5*progress, math.rad(0)
					end
				},
			},
		},
		{
			pos = {1, 1.5},
			typeName = "field",
			PerformAction = FieldAction,
			doors = {
				{
					pathLength = math.sqrt(5),
					pathFunc = function (progress)
						return -1 + 2*progress, 1 + 0.5*progress, math.rad(0)
					end
				},
			},
		},
		{
			pos = {0, 2},
			typeName = "getGrain",
			PerformAction = CollectAction,
			allowParallelUse = true,
			requireResources = {
				resType = "grain",
				resCount = 1,
			},
			doors = {
				{
					pathLength = 1,
					pathFunc = function (progress)
						return -1 + progress, 2, math.rad(0)
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
