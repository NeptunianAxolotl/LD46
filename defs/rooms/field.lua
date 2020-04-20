
local STORE_LIMIT = 8

local function FieldAction(station, room, monk, workData, dt)
	local boundReached = room.AddResource("grain", dt*0.09*monk.GetTaskMod("make_grain"), STORE_LIMIT)
	monk.ModifyFatigue(-0.09*dt)
	monk.ModifyFood(-0.045*dt)
	if boundReached then
		return true
	end
end

local function CollectAction(station, room, monk, workData, dt)
	if room.GetResourceCount("grain") >= 1 then
		room.AddResource("grain", -1)
		monk.SetResource("grain", 1)
		return true
	end
end

local function CheckGrainLimit(station, room, monk)
	if room.GetResourceCount("grain") >= STORE_LIMIT then
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

local data = {
	name = "field",
	humanName = "Field",
	buildDef = "field_build",
	image = "fields.png",
	clickTask = "make_grain",
    desc = "Grow grain\nCost: 2 wood",
	width = 3,
	height = 3,
    drawOriginX = 0,
	drawOriginY = 1.5,
	DrawFunc = DrawSupply,
	demolishable = true,
	stations = {
		{
			pos = {1.4, 0.5},
			taskType = "make_grain",
			PerformAction = FieldAction,
			AvailibleFunc = CheckGrainLimit,
			doors = {
                {
                    entryPath = {{1,3}, {1.4, 2.6}}
                },
                {
                    entryPath = {{1,-1}, {1.4, -0.6}}
                },
			},
		},
		{
			pos = {1.4, 1.5},
			taskType = "make_grain",
			PerformAction = FieldAction,
			AvailibleFunc = CheckGrainLimit,
			doors = {
                {
                    entryPath = {{1,3}, {1.4, 2.6}}
                },
                {
                    entryPath = {{1,-1}, {1.4, -0.6}}
                },
			},
		},
		{
			pos = {-0.4, 0.7},
			taskType = "get_grain",
			PerformAction = CollectAction,
			allowParallelUse = true,
			requireResources = {
				{
					resType = "grain",
					resCount = 1,
				}
			},
			doors = {
                {
                    entryPath = {{-1,1}, {-0.7, 0.7}}
                },
			},
		},
	}
}

return data
