
local function FetchResourceFunc()
	return tradeUtilities.GetFetchResources()
end

local function DoTrade(station, room, monk, workData, dt)
	local wantedResources = tradeUtilities.GetFetchResources()
	local resource, count = monk.GetResource()
	for i = 1, #wantedResources do
		if resource == wantedResources[i] then
			monk.SetResource(false, 0)
			room.AddResource(resource, 1)
			return true
		end
	end
	return true
end

local data = {
	name = "trade",
	image = "trade.png",
	clickTask = "trade",
    desc = "Trade for goods",
	drawOriginX = 0,
	drawOriginY = 1.5,
	width = 3,
	height = 3,
	tradingPost = true,
	stations = {
		{
			pos = {2.1, 0.3},
			taskType = "trade",
			FetchResourceFunc = FetchResourceFunc,
			PerformAction = DoTrade,
			doors = {
                {
                    entryPath = {{3,2},{2,1.2}}
                },
			},
		},
		
	}
}

local function MakeCollectStation(getResource, resource)
	local function CheckTakeResource(station, room, monk)
		local tradeData = GetWorld().GetOrModifyTradeStatus()
		if tradeData.isRequesting[resource] then
			return false
		end
		if room.GetResourceCount(resource) < 1 then
			return false
		end
		return true
	end

	local function CollectAction(station, room, monk, workData, dt)
		local tradeData = GetWorld().GetOrModifyTradeStatus()
		if (not tradeData.isRequesting[resource]) and room.GetResourceCount(resource) > 0 then
			room.AddResource(resource, -1)
			monk.SetResource(resource, 1)
		end
		return true
	end

	local station = {
		pos = {1, 2},
		taskType = getResource,
		PerformAction = CollectAction,
		requireResources = {
			{
				resType = resource,
				resCount = 1,
			}
		},
		allowParallelUse = true,
		AvailibleFunc = CheckTakeResource,
		doors = {
			{
				entryPath = {{1,3}}
			},
		},
	}
	
	data.stations[#data.stations + 1] = station
end

MakeCollectStation("get_veg", "veg")
MakeCollectStation("get_beer", "beer")
MakeCollectStation("get_battery", "battery")
MakeCollectStation("get_book", "book")
MakeCollectStation("get_bread", "bread")
MakeCollectStation("get_wood", "wood")

return data

