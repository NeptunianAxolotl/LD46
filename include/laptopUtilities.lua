local function InitLaptopStatus(monk, potentialStations, requiredRoom) 
    local laptopData = {
        -- 1 = full charge, 0 = empty charge
        charge = 0.053,
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

local function UpdateLaptop(dt)
	
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