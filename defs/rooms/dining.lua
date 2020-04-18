
local function DoCook(station, room, monk, workData, dt)
	workData.timer = (workData.timer or 0) + 0.6*dt
	if workData.timer > 1 then
		monk.SetResource(false, 0)
		room.AddResource("food", 1)
		return true
	end
end

local function DrawDining(self, drawX, drawY)
	font.SetSize(1)
	--local text = love.graphics.newText(font.GetFont(), text)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(math.floor(self.GetResourceCount("food")*10)/10, drawX + 2.35*GLOBAL.TILE_SIZE, drawY + 0.2*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 1, 1)
end

local data = {
	name = "dining",
	image = "dining.png",
	width = 3,
	height = 3,
	DrawFunc = DrawDining,
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
		{
			pos = {2, 2},
			taskType = "cook",
			PerformAction = DoCook,
			doors = {
				{
					pathLength = math.sqrt(2),
					pathFunc = function (progress)
						return 3 - progress, 2, math.rad(135)
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
