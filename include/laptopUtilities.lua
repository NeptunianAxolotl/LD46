local function InitLaptopStatus(monk, potentialStations, requiredRoom) 
    local laptopData = {
        -- 1 = full charge, 0 = empty charge
        charge = 0.053,
		chargeForUse = 0.1,
		chargeForBattery = 0.2,
		charging = false,
		chargeRate = 0.55,
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

local function UpdateLaptop(laptopData, dt)
	if laptopData.charge <= 0 then
		return
	end
	laptopData.charge = laptopData.charge - dt*laptopData.passiveDrain
	local laptopRoom = laptopData.room
	
	if laptopData.charging then
		laptopData.charge = laptopData.charge + dt*laptopData.chargeRate
		if laptopData.charge > 1 then
			laptopData.charge = 1
			laptopData.charging = false
			laptopRoom.AddResource("battery_spent", 1)
		end
	elseif laptopData.charge < laptopData.chargeForBattery then
		if laptopRoom.GetResourceCount("battery") > 0 then
			laptopData.charging = true
			laptopData.charge = laptopData.charge + dt*laptopData.chargeRate
			laptopRoom.AddResource("battery", -1)
			
			local mult = (1.11 - 2*laptopData.passiveDrain)
			laptopData.passiveDrain = laptopData.passiveDrain*mult
			laptopData.currentDrain = laptopData.currentDrain*mult
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
	UpdateLaptop = UpdateLaptop,
	CheckDefeat = CheckDefeat,
}