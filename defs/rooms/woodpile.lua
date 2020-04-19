
local STORE_LIMIT = 4

local function DoProcess(station, room, monk, workData, dt)
	workData.timer = (workData.timer or 0) + 0.6*dt
	monk.ModifyFatigue(-0.07*dt)
	monk.ModifyFood(-0.07*dt)
	if workData.timer > 1 then
		monk.SetResource(false, 0)
		room.AddResource("wood", 1)
		return true
	end
end

local function CollectAction(station, room, monk, workData, dt)
	if room.GetResourceCount("wood") > 1 then
		room.AddResource("wood", -1)
		monk.SetResource("wood", 1)
		return true
	end
end

local function CheckStoreLimit(station, room, monk)
	if room.GetResourceCount("wood") >= STORE_LIMIT then
		return false
	end
	return true
end

local function DrawSupply(self, drawX, drawY)
	font.SetSize(1)
	--local text = love.graphics.newText(font.GetFont(), text)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(math.floor(self.GetResourceCount("wood")*10)/10, drawX + 1.2*GLOBAL.TILE_SIZE, drawY + 0.2*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 1, 1)
end

local data = {
	name = "woodpile",
	image = "woodPile.png",
	drawOriginX = 0,
	drawOriginY = 0.5,
	width = 2,
	height = 1,
	DrawFunc = DrawSupply,
	stations = {
		{
			pos = {0, 0},
			taskType = "make_wood",
			PerformAction = DoProcess,
			doors = {
                {
                    entryPath = {{-1,0}}
                },
                {
                    entryPath = {{0,-1}}
                },
                {
                    entryPath = {{0,1}}
                },
			},
		},
		{
			pos = {1, 0},
			taskType = "get_wood",
			PerformAction = CollectAction,
			allowParallelUse = true,
			requireResources = {
				{
					resType = "wood",
					resCount = 1,
				}
			},
			doors = {
                {
                    entryPath = {{2,0}}
                },
                {
                    entryPath = {{1,-1}}
                },
                {
                    entryPath = {{1,1}}
                },
			},
		},
	}
}

return data

