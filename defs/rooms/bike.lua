
local STORE_LIMIT = 2
local NEED = "battery_spent"
local PRODUCE = "battery"

local function MakeAction(station, room, monk, workData, dt)
	local resource, count = monk.GetResource()
	if resource ~= NEED then
		return true
	end
	workData.timer = (workData.timer or 0) + 0.05*dt
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
	love.graphics.print(math.floor(self.GetResourceCount("battery")), drawX + 1.35*GLOBAL.TILE_SIZE, drawY + 0.4*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 1, 1)
end

local collectRequirement = {
	{
		resType = PRODUCE,
		resCount = 1,
	}
}

local data = {
	name = "bike",
	humanName = "Generator",
	image = "bike.png",
	buildDef = "bike_build",
	clickTask = "charge_battery",
	drawOriginX = 0,
	drawOriginY = 1,
	width = 2,
	height = 2,
	DrawFunc = DrawSupply,
	stations = {
		{
			pos = {1, 2},
			taskType = "get_battery",
			PerformAction = CollectAction,
			requireResources = collectRequirement,
			doors = {
                {
                    entryPath = {{1,3}}
                },
			},
		},
		{
			pos = {0.6, 0.2},
			taskType = "charge_battery",
			fetchResource = {NEED},
			PerformAction = MakeAction,
			AvailibleFunc = CheckStorageLimit,
			doors = {
                {
                    entryPath = {{1,2},{0.7,1}}
                },
			},
		},
	}
}

return data

