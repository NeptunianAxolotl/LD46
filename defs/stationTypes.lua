
local data = {
	"sleep",
	"make_grain",
	"get_grain",
	"make_veg",
	"get_veg",
	"cook",
	"eat",
	"build",
	"build_adv",
	"chop",
	"make_wood",
	"get_wood",
	"add_wood",
	"make_stone",
	"get_stone",
	"add_stone",
	"upkeep_laptop",
	"use_laptop",
	
	-- Unused so far
	"make_bread",
	"get_bread",
	"make_beer",
	"get_beer",
	"trade",
	"charge_battery",
	"get_battery",
	"get_battery_spent",
	"pray",
	"play_organ",
	"library_learn",
	"transcribe",
}

local stationTypeNames = {
	sleep = "Sleeping",
	get_veg = "Picking Vegetables",
	make_grain = "Reaping Grain",
	get_grain = "Fetching Grain",
	make_veg = "Picking Vegetables",
	cook = "Cooking Food",
	eat = "Eating",
	build = "Building ", -- Add variable for building name
	build_adv = "Building ", -- Add variable for building name
	get_wood = "Gathering Timber",
	make_wood = "Gathering Wood",
	add_wood = "Getting Timber",
	add_stone = "Getting Stone",
	get_stone = "Getting Stone",
	make_stone = "Quarrying Stone",
	upkeep_laptop = "Changing Batteries",
	use_laptop = "Using Laptop",
	chop = "Felling Tree",
}

local resourceNames = {
	["log"] = "Tree",
	wood = "Wood",
	beer = "Beer",
}

local taskSubgoal = {}

function taskSubgoal.make_beer(monk, currentGoal, stationsByUse)
	-- If we don't have a place to make the resource, there is no point fetching it.
	if not currentGoal.station then
		return false
	end
	
	-- If we have the resource in our inventory then don't fetch it.
	local resource, count = monk.GetResource()
	if currentGoal.station.IsFetchResource(resource) then
		return false
	end
	
	-- Find the closest station where we can find the resource, if it exists.
	local station, taskType = stationUtilities.ReserveClosestStationMultiType(monk, false, false, stationsByUse, {"get_grain"})
	return taskType, station
end

function taskSubgoal.trade(monk, currentGoal, stationsByUse)
	-- If we don't have a place to make the resource, there is no point fetching it.
	if not currentGoal.station then
		return false
	end
	
	-- If we have the resource in our inventory then don't fetch it.
	local resource, count = monk.GetResource()
	if currentGoal.station.IsFetchResource(resource) then
		return false
	end
	local taskTypes = tradeUtilities.GetFetchTasks()
	
	-- Find the closest station where we can find the resource, if it exists.
	local station, taskType = stationUtilities.ReserveClosestStationMultiType(monk, false, false, stationsByUse, taskTypes)
	return taskType, station
end

return {data, stationTypeNames, taskSubgoal, resourceNames}
