local function InitLaptopStatus(monk, potentialStations, requiredRoom) 
    local laptopData = {
        -- 1 = full charge, 0 = empty charge
        charge = 0.053,
		chargeForUse = 0.1,
		chargeForBattery = 0.2,
		charging = false,
		chargeRate = 0.55,
		batteriesSpent = 0,
        -- drain per second
        passiveDrain = 0.0032,
        currentDrain = 0.0064,
        peripherals = {
            speakers = false,
            monitor = false,
            graphicscard = false,
        },
		peripheralList = {
			{
				name = "speakers",
				humanName = "Speakers",
				price = 100,
			},
			{
				name = "graphicscard",
				humanName = "Graphics Card",
				price = 200,
			},
			{
				name = "monitor",
				humanName = "Monitor",
				price = 360,
			},
		},
    }
    
    return laptopData
end

local function GetNewDrains(passiveDrain)
	local mult = (1.11 - 2*passiveDrain)
	if IsChallengeMode() then
		mult = math.max(1.001 + 0.09*(1/(1 + 50*passiveDrain)), 1.11 - 2*passiveDrain)
	end
	passiveDrain = passiveDrain*mult
	return passiveDrain, 2*passiveDrain
end

local function UpdateLaptop(laptopData, dt)
	if laptopData.charge <= 0 then
		return
	end
	local laptopRoom = laptopData.room
	
	if laptopData.charging then
		laptopData.charge = laptopData.charge + dt*laptopData.chargeRate
		if laptopData.charge > 1 then
			laptopData.charge = 1
			laptopData.charging = false
			laptopRoom.AddResource("battery_spent", 1)
		end
	else
		laptopData.charge = laptopData.charge - dt*laptopData.passiveDrain*GetDifficultyDrainMult()
	
		if laptopData.charge < laptopData.chargeForBattery then
			if laptopRoom.GetResourceCount("battery") > 0 then
				laptopData.charging = true
				laptopData.charge = laptopData.charge + dt*laptopData.chargeRate
				laptopRoom.AddResource("battery", -1)
				laptopData.batteriesSpent = laptopData.batteriesSpent + 1
				
				laptopData.passiveDrain, laptopData.currentDrain = GetNewDrains(laptopData.passiveDrain)
				
				if laptopData.chargeRate < 5*laptopData.currentDrain then
					laptopData.chargeRate = 5*laptopData.currentDrain
				end
			end
		end
	end
end

local function AddLaptop(laptopData, roomList)
	for _, room in roomList.Iterator() do
		local def = room.GetDef()
		if def.isLaptop then
			laptopData.room = room
			return
		end
	end
end

local function CheckDefeat(laptopData, world)
	if laptopData.charge <= 0 then
		world.DeclareDefeat()
		laptopData.charge = 0
	end
end

return {
	InitLaptopStatus = InitLaptopStatus,
	AddLaptop = AddLaptop,
	GetNewDrains = GetNewDrains,
	UpdateLaptop = UpdateLaptop,
	CheckDefeat = CheckDefeat,
}