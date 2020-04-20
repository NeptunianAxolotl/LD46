local STORE_LIMIT = 30
local NEED = "grain"
local PRODUCE = "bread"

local function MakeAction(station, room, monk, workData, dt)
	local resource, count = monk.GetResource()
	if resource ~= NEED then
		return true
	end
	workData.timer = (workData.timer or 0) + 0.6*dt
	monk.ModifyFatigue(-0.05*dt)
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
	love.graphics.print(math.floor(self.GetResourceCount(PRODUCE)*10)/10, drawX + 1*GLOBAL.TILE_SIZE, drawY + 1.7*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 1, 1)
end

local collectRequirement = {
	{
		resType = PRODUCE,
		resCount = 1,
	}
}

local data = {
	name = "bakery",
	humanName = "Bakery",
	buildDef = "bakery_build",
	image = "bakery.png",
	clickTask = "make_bread",
    desc = "Wheat -> tasty bread\nCost: 5 wood, 3 stone",
	drawOriginX = 0,
	drawOriginY = 1.5,
	width = 3,
	height = 2,
	demolishable = true,
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
                    entryPath ={{-1,1},{-0.3,0.5}}
                },
                {
                    entryPath ={{-1,0},{-0.3,0.5}}
                },
			},
		},
		{
			pos = {0.5, 0.25},
			taskType = "make_" .. PRODUCE,
			fetchResource = {NEED},
			PerformAction = MakeAction,
			AvailibleFunc = CheckStorageLimit,
            overrideDir = 0,
			doors = {
                {
                    entryPath ={{-1,1},{-0.3,0.5}}
                },
                {
                    entryPath ={{-1,0},{-0.3,0.5}}
                },
			},
		},
	}
}

return data

