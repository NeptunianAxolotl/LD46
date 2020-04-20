
local PRODUCE = "battery_spent"

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
	local laptopData = GetWorld().GetOrModifyLaptopStatus()
	laptopUtilities.UpdateLaptop(laptopData, dt)
end

local function CheckEligible(station, room, monk, workData, dt)
	local skillDef, progress = monk.GetSkill()
	if (not skillDef) or (progress == 1) then
		return false
	end
	local laptopData = GetWorld().GetOrModifyLaptopStatus()
	
	if laptopData.charge < laptopData.chargeForUse then
		return false
	end
	
	for i = 1, #skillDef.requiredPeripherals do
		if not laptopData.peripherals[skillDef.requiredPeripherals[i]] then
			return false
		end
	end
	
	-- Check peripherals
	return true
end

local function DoUseLaptop(station, room, monk, workData, dt)
	if not CheckEligible(station, room, monk, workData, dt) then
		return true
	end
	local laptopData = GetWorld().GetOrModifyLaptopStatus()
	if laptopData.charge < laptopData.chargeForUse then
		return true
	end
	
	monk.ModifyFatigue(-0.06*dt)
	monk.ModifyFood(-0.035*dt)
	laptopData.charge = laptopData.charge - dt*(laptopData.currentDrain - laptopData.passiveDrain)
	
	local skillDef, progress = monk.GetSkill()
	return monk.AddSkillProgress(0.023*dt, true), skillDef.preferedTask
end

local function CollectAction(station, room, monk, workData, dt)
	if room.GetResourceCount(PRODUCE) >= 1 then
		room.AddResource(PRODUCE, -1)
		monk.SetResource(PRODUCE, 1)
		return true
	end
end

local collectRequirement = {
	{
		resType = PRODUCE,
		resCount = 1,
	}
}

local function DrawSupply(self, drawX, drawY)
	font.SetSize(1)
	--local text = love.graphics.newText(font.GetFont(), text)
	love.graphics.setColor(0.2, 1, 0.3)
	love.graphics.print(math.floor(self.GetResourceCount("battery")), drawX + 1.55*GLOBAL.TILE_SIZE, drawY + 0.45*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 0.5, 0.4)
	love.graphics.print(math.floor(self.GetResourceCount("battery_spent")), drawX + 0.75*GLOBAL.TILE_SIZE, drawY + 1.25*GLOBAL.TILE_SIZE)
	
	local laptopCharge = GetWorld().GetOrModifyLaptopStatus().charge

	love.graphics.setColor(0.2, 0.2, 0.2)
	love.graphics.rectangle("fill", drawX + 1.5*GLOBAL.TILE_SIZE, drawY + 1.04*GLOBAL.TILE_SIZE, 0.7*GLOBAL.TILE_SIZE, 0.1*GLOBAL.TILE_SIZE, 2, 6, 4 )
	love.graphics.setColor(1 - laptopCharge, laptopCharge, 0)
	love.graphics.rectangle("fill", drawX + 1.5*GLOBAL.TILE_SIZE, drawY + 1.04*GLOBAL.TILE_SIZE, 0.7*GLOBAL.TILE_SIZE*laptopCharge, 0.1*GLOBAL.TILE_SIZE, 2, 6, 4 )
	
	love.graphics.setColor(1, 1, 1)
end

local data = {
	name = "laptop",
	image = "laptop_room.png",
    desc = "Source of knowledge",
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
	spawnResources = {
		{"battery", 1},
	},
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
			},
		},
		{
			pos = {0.5, 0.5},
			taskType = "get_battery_spent",
			PerformAction = CollectAction,
			requireResources = collectRequirement,
			doors = {
                {
                    entryPath = {{-1,2}, {0.5,1.8}}
                },
			},
		},
		{
			pos = {1.27, 1.85},
			taskType = "use_laptop",
			PerformAction = DoUseLaptop,
			AvailibleFunc = CheckEligible,
			doors = {
                {
                    entryPath = {{1,4}}
                },
                {
                    entryPath = {{-1,2},{0,2},{1,2.4}}
                },
			},
		},
	}
}

return data
