
local STORE_LIMIT = 4

local function UpdateFunc(room, dt)
	local boundReached = room.AddResource("veg", dt*0.02, STORE_LIMIT)
end

local function FieldAction(station, room, monk, workData, dt)
	local boundReached = room.AddResource("veg", dt*0.35*monk.GetTaskMod("make_veg"), STORE_LIMIT)
	monk.ModifyFatigue(-0.08*dt)
	monk.ModifyFood(-0.07*dt)
	if boundReached then
		return true
	end
end

local function CheckLimit(station, room, monk)
	if room.GetResourceCount("veg") >= STORE_LIMIT then
		return false
	end
	return true
end

local function DrawSupply(self, drawX, drawY)
	font.SetSize(1)
	--local text = love.graphics.newText(font.GetFont(), text)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(math.floor(self.GetResourceCount("grain")*10)/10, drawX + 0.8*GLOBAL.TILE_SIZE, drawY + 1.6*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 1, 1)
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
	humanName = "Veggie Patch",
	buildDef = "garden_build",
    desc = "Grow vegetables\nCost: 2 wood",
	image = "garden.png",
	width = 2,
	height = 2,
	drawOriginX = 0,
	drawOriginY = 1,
	UpdateFunc = UpdateFunc,
	demolishable = true,
	DrawFunc = DrawSupply,
	stations = {
		{
			pos = {1, 0},
			taskType = "make_veg",
			PerformAction = FieldAction,
			AvailibleFunc = CheckLimit,
			doors = {
                {
                    entryPath = {{2,0}}
                },
			},
		},
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
