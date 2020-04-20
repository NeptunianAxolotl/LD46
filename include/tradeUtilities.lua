
local function InitTradeStatus(monk, potentialStations, requiredRoom)
	local tradeData = {
		money = 20,
		goods = {
			{
				name = "battery",
				requesting = false,
				price = 32.2,
				get = "get_battery",
			},
			{
				name = "beer",
				requesting = false,
				price = 50.2,
				get = "get_beer",
			},
			{
				name = "book",
				requesting = false,
				price = 24.2,
				priceShift = 4,
				get = "get_book",
			},
			{
				name = "bread",
				requesting = false,
				price = 11.2,
				get = "get_bread",
			},
			{
				name = "veg",
				requesting = false,
				price = 8.2,
				get = "get_veg",
			},
			{
				name = "wood",
				requesting = false,
				price = 12.2,
				get = "get_wood",
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
		good.minPrice = good.price*0.7
		good.maxPrice = good.price*4
		good.buyMarkup = 1.6
		good.priceShift = good.priceShift or good.price*0.02
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

local function BuyPeripheral(tradeData, index)
	local laptopData = GetWorld().GetOrModifyLaptopStatus()
	local periphData = laptopData.peripheralList[index]
	local havePeriph = laptopData.peripherals
	
	if havePeriph[periphData.name] then
		return
	end
	
	if periphData.price > tradeData.money then
		return
	end
	tradeData.money = tradeData.money - periphData.price
	havePeriph[periphData.name] = true
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
	elseif actionData.buyPeriph then
		BuyPeripheral(tradeData, actionData.buyPeriph)
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
