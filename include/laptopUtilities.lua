local function InitLaptopStatus(monk, potentialStations, requiredRoom) 
    local laptopData = {
        -- 1 = full charge, 0 = empty charge
        charge = 0.053,
		chargeForUse = 0.1,
		chargeForBattery = 0.2,
		charging = false,
		chargeRate = 0.55,
        -- drain per second
        passiveDrain = 0.001,
        currentDrain = 0.002,
        peripherals = {
            speakers = false,
            monitor = false,
            graphicscard = false,
        }
    }
    
    return laptopData
end

local function UpdateLaptop(laptopData, dt)
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


return {
	InitLaptopStatus = InitLaptopStatus,
	AddLaptop = AddLaptop,
	UpdateLaptop = UpdateLaptop,
}