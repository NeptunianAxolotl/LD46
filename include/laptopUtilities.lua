local function InitLaptopStatus(monk, potentialStations, requiredRoom) 
    local laptopData = {
        -- 1 = full charge, 0 = empty charge
        charge = 0.053,
        -- drain per second
        passiveDrain = 0.001,
        currentDrain = 0.002,
        peripherals = {
            speakers = true,
            monitor = false,
            graphicscard = true,
        }
    }
    
    return laptopData
end

local function PerformAction(laptopData, actionData)

end

return {
	InitLaptopStatus = InitLaptopStatus,
	PerformAction = PerformAction,
}