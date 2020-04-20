
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

return {data, stationTypeNames}
