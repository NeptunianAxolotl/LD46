
local function FieldAction(room, monk, workData, dt)
	room.AddResource("grain", dt*0.02)
	monk.ModifyFatigue(-0.15*dt)
end

local function CollectAction(room, monk, workData, dt)

end

local function DrawField(self, drawX, drawY)
	font.SetSize(1)
	--local text = love.graphics.newText(font.GetFont(), text)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(math.floor(self.GetResourceCount("grain")*10)/10, drawX + 0.2*GLOBAL.TILE_SIZE, drawY + 2.2*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 1, 1)
end

local data = {
	name = "field",
	image = "field.png",
	width = 3,
	height = 3,
	resources = {},
	DrawFunc = DrawField,
	stations = {
		{
			pos = {1, 0.5},
			taskType = "field",
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
			taskType = "field",
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
			taskType = "getGrain",
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
