
local data = {
	"sleep",
	"make_grain",
	"get_grain",
	"make_veg",
	"get_veg",
	"cook",
	"eat",
	"build",
	"chop",
	"make_wood",
	"get_wood",
	"add_wood",
	"make_stone",
	"get_stone",
	"add_stone",
	"upkeep_laptop",
	"use_laptop",
	
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
	"get_book",
	"transcribe",
}

local stationTypeNames = {
	sleep = "Sleeping",
	get_veg = "Pick Vegetables",
	make_grain = "Reap Grain",
	get_grain = "Fetch Grain",
	make_veg = "Tend Vegetables",
	cook = "Cook Food",
	eat = "Eat",
	build = "Build",
	get_wood = "Gather Wood",
	make_wood = "Gather Wood",
	add_wood = "Fetch Wood",
	add_stone = "Gather Stone",
	get_stone = "Fetch Stone",
	make_stone = "Quarry Stone",
	upkeep_laptop = "Monitor Batteries",
	use_laptop = "Use Laptop",
	library_learn = "Book Learning",
	chop = "Fell Tree",
	get_book = "Fetch Blank Book",
	transcribe = "Transcribe Book",
	play_organ = "Play Organ",
	get_battery_spent = "Fetch Low Battery",
	get_battery = "Fetch Battery",
	charge_battery = "Charge Battery",
	make_bread = "Bake Bread",
	get_bread = "Fetch Bread",
	make_beer = "brew Beer",
	get_beer = "Fetch Beer",
	trade = "Trade",
	pray = "Pray",
}

local resourceNames = {
	["log"] = "Tree",
	wood = "Wood",
	beer = "Beer",
	book = "Blank Book",
}

local taskSubgoal = {}

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
	local taskTypes = tradeUtilities.GetFetchTasks() -- NOTE THIS IS DIFFERENT TO USUAL
	
	-- Find the closest station where we can find the resource, if it exists.
	local station, taskType = stationUtilities.ReserveClosestStationMultiType(monk, false, false, stationsByUse, taskTypes)
	return taskType, station, nil, not taskType
end

local function AddTaskSubgoal(taskName, getTasks)
	taskSubgoal[taskName] = function(monk, currentGoal, stationsByUse)
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
		local station, taskType = stationUtilities.ReserveClosestStationMultiType(monk, false, false, stationsByUse, getTasks)
		return taskType, station, nil, not taskType
	end
end

AddTaskSubgoal("make_bread", {"get_grain"})
AddTaskSubgoal("make_beer", {"get_grain"})
AddTaskSubgoal("charge_battery", {"get_battery_spent"})
AddTaskSubgoal("upkeep_laptop", {"get_battery"})

function taskSubgoal.transcribe(monk, currentGoal, stationsByUse)
	-- If we don't have a place to make the resource, there is no point fetching it.
	if not currentGoal.station then
		return false
	end
	local skillDef, progress = monk.GetSkill()
	if skillDef then
		local knowData = GetWorld().GetOrModifyKnowStatus()
		if knowData.bookProgress[skillDef.name] then
			-- A book has already been spent.
			return false
		end
	end
	
	-- If we have the resource in our inventory then don't fetch it.
	local resource, count = monk.GetResource()
	if resource == "book" and count > 0 then
		return false
	end
	
	-- Find the closest station where we can find the resource, if it exists.
	local station, taskType = stationUtilities.ReserveClosestStationMultiType(monk, false, false, stationsByUse, {"get_book"})
	return taskType, station, nil, not taskType
end

return {data, stationTypeNames, taskSubgoal, resourceNames}
