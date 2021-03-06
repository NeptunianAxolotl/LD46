
local STORE_LIMIT = 12
local NEED = "grain"
local PRODUCE = "beer"

local function MakeAction(station, room, monk, workData, dt)
	local resource, count = monk.GetResource()
	if resource ~= NEED then
		return true
	end
	workData.timer = (workData.timer or 0) + 0.11*dt*monk.GetTaskMod("make_beer")
	monk.ModifyFatigue(-0.075*dt)
	monk.ModifyFood(-0.05*dt)
	if workData.timer > 1 then
		monk.SetResource(false, 0)
		room.AddResource(PRODUCE, 1)
		return true
	end
end

local function CollectAction(station, room, monk, workData, dt)
	if room.GetResourceCount(PRODUCE) >= 1 then
		room.AddResource(PRODUCE, -1)
		monk.SetResource(PRODUCE, 1)
		return true
	end
end

local function CheckStorageLimit(station, room, monk)
	if room.GetResourceCount(PRODUCE) >= STORE_LIMIT then
		return false
	end
	return true
end

local function DrawSupply(self, drawX, drawY)
	font.SetSize(1)
	--local text = love.graphics.newText(font.GetFont(), text)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(math.floor(self.GetResourceCount(PRODUCE)), drawX + 1.35*GLOBAL.TILE_SIZE, drawY + 0.4*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 1, 1)
end

local collectRequirement = {
	{
		resType = PRODUCE,
		resCount = 1,
	}
}

local data = {
	name = "brewery",
	humanName = "Brewery",
	image = "brewery.png",
	buildDef = "brewery_build",
    desc = "Wheat to beer to trade\nCost: 6 wood, 4 stone",
	clickTask = "make_beer",
	drawOriginX = 0,
	drawOriginY = 1.5,
	width = 3,
	height = 3,
	demolishable = false,
	DrawFunc = DrawSupply,
	stations = {
		{
			pos = {0.5,0.5},
			taskType = "get_" .. PRODUCE,
			PerformAction = CollectAction,
			requireResources = collectRequirement,
			allowParallelUse = true,
			doors = {
                {
                    entryPath = {{1,-1},{1,1}}
                },
                {
                    entryPath = {{1,3},{1,1}}
                },
                {
                    entryPath = {{-1,1},{1,1}}
                },
			},
		},
		{
			pos = {1.5, 1.4},
			taskType = "make_" .. PRODUCE,
			fetchResource = {NEED},
			PerformAction = MakeAction,
			AvailibleFunc = CheckStorageLimit,
            overrideDir = 0,
			doors = {
                {
                    entryPath = {{1,-1},{1,1}}
                },
                {
                    entryPath = {{1,3},{1,1}}
                },
                {
                    entryPath = {{-1,1},{1,1}}
                },
			},
		},
	}
}

return data

