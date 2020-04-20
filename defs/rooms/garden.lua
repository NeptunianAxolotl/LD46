
local STORE_LIMIT = 4

local function UpdateFunc(room, dt)
	local boundReached = room.AddResource("veg", dt*0.1, STORE_LIMIT)
end

local function CollectAction(station, room, monk, workData, dt)
	if room.GetResourceCount("veg") >= 1 then
		room.AddResource("veg", -1)
		monk.SetResource("veg", 1)
		return true
	end
end

local function DrawSupply(self, drawX, drawY)
	font.SetSize(1)
	--local text = love.graphics.newText(font.GetFont(), text)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(math.floor(self.GetResourceCount("veg")*10)/10, drawX + 0.3*GLOBAL.TILE_SIZE, drawY + 0.85*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 1, 1)
end

local data = {
	name = "garden",
	image = "garden.png",
	width = 2,
	height = 2,
	drawOriginX = 0,
	drawOriginY = 1,
	UpdateFunc = UpdateFunc,
	DrawFunc = DrawSupply,
	stations = {
		{
			pos = {1, 1},
			taskType = "get_veg",
			PerformAction = CollectAction,
			allowParallelUse = true,
			requireResources = {
				{
					resType = "veg",
					resCount = 1,
				}
			},
			doors = {
                {
                    entryPath = {{2,1}}
                },
                {
                    entryPath = {{2,2}}
                },
                {
                    entryPath = {{1,2}}
                },
			},
		},
	}
}

return data
