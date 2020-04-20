
local function DoCook(station, room, monk, workData, dt)
	local resource, count = monk.GetResource()
	if resource ~= "grain" and resource ~= "veg" then
		return true
	end
	workData.timer = (workData.timer or 0) + 0.6*dt*monk.GetTaskMod("cook")
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
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(math.floor(self.GetResourceCount("food")*10)/10, drawX + 0.55*GLOBAL.TILE_SIZE, drawY + 1.2*GLOBAL.TILE_SIZE)
	love.graphics.setColor(1, 1, 1)
end

local data = {
	name = "dining",
	humanName = "Dining Hall",
	image = "dining.png",
	buildDef = "dining_build",
	clickTask = "cook",
    desc = "Feeds monks\nCost: 8 wood",
	width = 3,
	height = 3,
    drawOriginX = 0,
	drawOriginY = 1.5,
	DrawFunc = DrawDining,
	demolishable = false,
	stations = {
		{
			pos = {0, 1},
			taskType = "eat",
			PerformAction = DoEat,
			requireResources = eatRequirement,
			doors = {
                {
                    entryPath = {{-1,1}}
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
                    entryPath = {{1,-1}}
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
                    entryPath = {{1,3}}
                },
			},
		},
		{
			pos = {2.1, 0.3},
			taskType = "cook",
			fetchResource = {"grain", "veg"},
			PerformAction = DoCook,
			doors = {
                {
                    entryPath = {{3,2},{2,1.2}}
                },
			},
		},
		{
			pos = {1.6, 0.3},
			taskType = "cook",
			fetchResource = {"grain", "veg"},
			PerformAction = DoCook,
            overrideDir = 3*math.pi/2,
			doors = {
                {
                    entryPath = {{3,2},{2,1.2}}
                },
			},
            
		},
	}
}

return data
