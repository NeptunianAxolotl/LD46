
local function DoUpkeepLaptop(station, room, monk, workData, dt)
	local resource, count = monk.GetResource()
	if resource ~= "battery" then
		return true
	end
	workData.timer = (workData.timer or 0) + 0.9*dt
	monk.ModifyFatigue(-0.05*dt)
	monk.ModifyFood(-0.05*dt)
	if workData.timer > 1 then
		monk.SetResource(false, 0)
		room.AddResource("battery", 1)
		return true
	end
end

local function UpdateFunc(room, dt)
	laptopUtilities.UpdateLaptop(dt)
end

local function CheckEligible(station, room, monk, workData, dt)
	local skillDef, rank, progress, desiredChange  = monk.GetSkill()
	if (not (skillDef or desiredChange)) or (rank >= 2) then
		return false
	end
	
	-- Check peripherals
	return true
end

local function DrawSupply(self, drawX, drawY)
	font.SetSize(1)
	--local text = love.graphics.newText(font.GetFont(), text)
	love.graphics.setColor(0.2, 1, 0.3)
	love.graphics.print(math.floor(self.GetResourceCount("battery")), drawX + 1.55*GLOBAL.TILE_SIZE, drawY + 0.45*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 0.3, 0.3)
	love.graphics.print(math.floor(self.GetResourceCount("battery_spent")), drawX + 0.75*GLOBAL.TILE_SIZE, drawY + 1.25*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 1, 1)
end


local function DoUseLaptop(station, room, monk, workData, dt)
	if not CheckEligible(station, room, monk, workData, dt) then
		return true
	end
	
	return monk.AddSkillProgress(0.05*dt, true), "make_grain"
end

local data = {
	name = "laptop",
	image = "laptop_room.png",
	clickTaskFunc = function (x, y)
		if y < 1.8 then
			return "upkeep_laptop"
		end
		return "use_laptop"
	end,
	width = 3,
	height = 4,
    drawOriginX = 0,
	drawOriginY = 1.5,
	UpdateFunc = UpdateFunc,
	DrawFunc = DrawSupply,
	isLaptop = true,
	stations = {
		{
			pos = {1.5, 0.3},
			taskType = "upkeep_laptop",
			fetchResource = {"battery"},
			PerformAction = DoUpkeepLaptop,
			doors = {
                {
                    entryPath = {{1,-1}, {1, 0.3}}
                },
                {
                    entryPath = {{-1,0}, {1, 0.3}}
                },
			},
		},
		{
			pos = {1, 2},
			taskType = "use_laptop",
			PerformAction = DoUseLaptop,
			AvailibleFunc = CheckEligible,
			doors = {
                {
                    entryPath = {{1,4}}
                },
			},
		},
	}
}

return data
