
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
	sleep = "Sleep",
	get_veg = "Seek Vegies",
	chop = "Fell Tree",
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
	if (resource == "grain") and count > 0 then
		return false
	end
	
	-- Find the closest station where we can find the resource, if it exists.
	local station, taskType = stationUtilities.ReserveClosestStationMultiType(monk, false, false, stationsByUse, {"get_grain"})
	return taskType, station
end

return {data, stationTypeNames, taskSubgoal, resourceNames}
