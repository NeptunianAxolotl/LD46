
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

local function PerformAction(tradeData, actionData)
	if actionData.buy then
	
	elseif actionData.sell then
	
	elseif actionData.stock then
	
	end
end

return {
	InitTradeStatus = InitTradeStatus,
	AddTradingPost = AddTradingPost,
	PerformAction = PerformAction,
}
