
local function InitTradeStatus(monk, potentialStations, requiredRoom)
	local tradeData = {
		money = 60,
		goods = {
			{
				name = "beer",
				requesting = false,
				price = 20,
				get = "get_beer",
			},
			{
				name = "battery",
				requesting = false,
				price = 10,
				get = "get_battery",
			},
			{
				name = "grain",
				requesting = false,
				price = 20,
				get = "get_grain",
			},
			{
				name = "veg",
				requesting = false,
				price = 10,
				get = "get_veg",
			},
		},
		isRequesting = {
			beer = false,
			battery = false,
			grain = false,
			veg = false,
		}
	}
	
	for i = 1, #tradeData.goods do
		local good = tradeData.goods[i]
		good.minPrice = good.price*0.5
		good.maxPrice = good.price*4
		good.buyMarkup = 2
		good.priceShift = good.price*0.05
	end
	
	return tradeData
end

local function AddTradingPost(tradeData, roomList)
	for _, room in roomList.Iterator() do
		local def = room.GetDef()
		if def.tradingPost then
			tradeData.room = room
			return
		end
	end
end

local function Buy(tradeData, index)
	local good = tradeData.goods[index]
	local realPrice = math.floor(good.price*good.buyMarkup)
	if realPrice > tradeData.money then
		return
	end
	tradeData.money = tradeData.money - realPrice
	tradeData.room.AddResource(good.name, 1)

	good.price = good.price + good.priceShift
	if good.price > good.maxPrice then
		good.price = good.maxPrice
	end
end

local function Sell(tradeData, index)
	local good = tradeData.goods[index]
	if tradeData.room.GetResourceCount(good.name) < 1 then
		return
	end
	local realPrice = math.floor(good.price)
	tradeData.money = tradeData.money + realPrice
	
	tradeData.room.AddResource(good.name, -1)
	good.price = good.price - good.priceShift
	if good.price < good.minPrice then
		good.price = good.minPrice
	end
end

local function StockToggle(tradeData, index)
	tradeData.goods[index].requesting = not tradeData.goods[index].requesting
	tradeData.isRequesting[tradeData.goods[index].name] = tradeData.goods[index].requesting
end

local function PerformAction(tradeData, actionData)
	if actionData.buy then
		Buy(tradeData, actionData.buy)
		actionData = nil
	elseif actionData.sell then
		Sell(tradeData, actionData.sell)
		actionData = sell
	elseif actionData.stockpileToggle then
		StockToggle(tradeData, actionData.stockpileToggle)
		actionData = stockpileToggle
	end
end

local function GetFetchResources()
	local tradeData = GetWorld().GetOrModifyTradeStatus()
	
	local fetchResources = {}
	for i = 1, #tradeData.goods do
		local good = tradeData.goods[i]
		if good.requesting then
			fetchResources[#fetchResources + 1] = good.name
		end
	end
	
	return fetchResources
end

local function GetFetchTasks()
	local tradeData = GetWorld().GetOrModifyTradeStatus()
	
	local fetchTasks = {}
	for i = 1, #tradeData.goods do
		local good = tradeData.goods[i]
		if good.requesting then
			fetchTasks[#fetchTasks + 1] = good.get
		end
	end
	
	return fetchTasks
end

return {
	InitTradeStatus = InitTradeStatus,
	AddTradingPost = AddTradingPost,
	PerformAction = PerformAction,
	GetFetchResources = GetFetchResources,
	GetFetchTasks = GetFetchTasks,
}
