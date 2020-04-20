local function InitLaptopStatus(monk, potentialStations, requiredRoom) 
    local laptopData = {
        charge = 0.053,
        peripherals = {
            speakers = false,
            monitor = false,
            graphics = false,
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