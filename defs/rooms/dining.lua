
local function DoCook(station, room, monk, workData, dt)
	workData.timer = (workData.timer or 0) + 0.6*dt
	monk.ModifyFatigue(-0.05*dt)
	monk.ModifyFood(-0.05*dt)
	if workData.timer > 1 then
		monk.SetResource(false, 0)
		room.AddResource("food", 1)
		return true
	end
end

local function DoEat(station, room, monk, workData, dt)
	local full = monk.ModifyFood(0.9*dt)
	if full then
		room.AddResource("food", -1)
		return true
	end
end

local eatRequirement = {
	{
		resType = "food",
		resCount = 1,
	}
}

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
			pos = {0, 1},
			taskType = "eat",
			PerformAction = DoEat,
			requireResources = eatRequirement,
			doors = {
				{
					pathLength = 1,
					pathFunc = function (progress)
						return -1 + progress, 1, math.rad(270)
					end
				},
			},
		},
		{
			pos = {1, 0},
			taskType = "eat",
			PerformAction = DoEat,
			requireResources = eatRequirement,
			doors = {
				{
					pathLength = 1,
					pathFunc = function (progress)
						return 1, -1 + progress, math.rad(180)
					end
				},
			},
		},
		{
			pos = {1, 2},
			taskType = "eat",
			PerformAction = DoEat,
			requireResources = eatRequirement,
			doors = {
				{
					pathLength = 1,
					pathFunc = function (progress)
						return 1, 3 - progress, math.rad(0)
					end
				},
			},
		},
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

return data
