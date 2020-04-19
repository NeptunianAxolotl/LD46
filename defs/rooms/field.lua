
local STORE_LIMIT = 4

local function FieldAction(station, room, monk, workData, dt)
	local boundReached = room.AddResource("grain", dt*0.35, STORE_LIMIT)
	monk.ModifyFatigue(-0.08*dt)
	monk.ModifyFood(-0.07*dt)
	if boundReached then
		return true
	end
end

local function CollectAction(station, room, monk, workData, dt)
	if room.GetResourceCount("grain") > 1 then
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

local function DrawField(self, drawX, drawY)
	font.SetSize(1)
	--local text = love.graphics.newText(font.GetFont(), text)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(math.floor(self.GetResourceCount("grain")*10)/10, drawX + 0.2*GLOBAL.TILE_SIZE, drawY + 2.2*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 1, 1)
end

local data = {
	name = "field",
	image = "field.png",
	drawOriginX = 0,
	drawOriginY = 0,
	width = 3,
	height = 3,
	DrawFunc = DrawField,
	stations = {
		{
			pos = {1, 0.5},
			taskType = "field",
			PerformAction = FieldAction,
			AvailibleFunc = CheckGrainLimit,
			doors = {
				{
					pathLength = math.sqrt(2),
					pathFunc = function (progress)
						return -1 + 2*progress, 1 - 0.5*progress, math.rad(0)
					end
				},
			},
		},
		{
			pos = {1, 1.5},
			taskType = "field",
			PerformAction = FieldAction,
			AvailibleFunc = CheckGrainLimit,
			doors = {
				{
					pathLength = math.sqrt(5),
					pathFunc = function (progress)
						return -1 + 2*progress, 1 + 0.5*progress, math.rad(0)
					end
				},
			},
		},
		{
			pos = {0, 2},
			taskType = "getGrain",
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
					pathLength = 1,
					pathFunc = function (progress)
						return 0, 3 - progress, math.rad(0)
					end
				},
			},
		},
	}
}

return data
