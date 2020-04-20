
local STORE_LIMIT = 4

local function MakeAction(station, room, monk, workData, dt)
	local boundReached = room.AddResource("stone", dt*0.35, STORE_LIMIT)
	monk.ModifyFatigue(-0.08*dt)
	monk.ModifyFood(-0.07*dt)
	if boundReached then
		return true
	end
end

local function CollectAction(station, room, monk, workData, dt)
	if room.GetResourceCount("stone") >= 1 then
		room.AddResource("stone", -1)
		monk.SetResource("stone", 1)
		return true
	end
end

local function CheckLimit(station, room, monk)
	if room.GetResourceCount("stone") >= STORE_LIMIT then
		return false
	end
	return true
end

local function DrawSupply(self, drawX, drawY)
	font.SetSize(1)
	--local text = love.graphics.newText(font.GetFont(), text)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(math.floor(self.GetResourceCount("stone")), drawX + 0.95*GLOBAL.TILE_SIZE, drawY + 0.28*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 1, 1)
end

local data = {
	name = "quarry",
	humanName = "Stone Quarry",
	image = "quarry.png",
	buildDef = "quarry_build",
    desc = "Collect stone\nCost: 2 wood",
	clickTask = "make_stone",
	drawOriginX = 0,
	drawOriginY = 1,
	width = 2,
	height = 2,
	DrawFunc = DrawSupply,
	stations = {
		{
			pos = {0.5, 0.5},
			taskType = "make_stone",
			PerformAction = MakeAction,
			AvailibleFunc = CheckLimit,
			doors = {
                {
                    entryPath = {{2, 0}, {0.8, 0.7}}
                },
			},
		},
		{
			pos = {1.8, 0.2},
			taskType = "get_stone",
			PerformAction = CollectAction,
			allowParallelUse = true,
			requireResources = {
				{
					resType = "stone",
					resCount = 1,
				}
			},
			doors = {
                {
                    entryPath = {{1,-1}}
                },
                {
                    entryPath = {{2,-1}}
                },
                {
                    entryPath = {{2,0}}
                },
			},
		},
	}
}

return data

