
local data = {
	{
		name = "masonry",
		humanName = "Masonry",
		titleName = "Mason",
		desc = "Do stone",
		learnMod = 1.7,
		practiseMod = 1.3,
		learnPowerDrainMod = 1.2,
		taskSpeed = {
			make_stone = 2,
			build = 1.5,
		}
	},
	{
		name = "farming",
		humanName = "Farming",
		titleName = "Farmer",
		desc = "Do stone",
		learnMod = 1.7,
		practiseMod = 1.3,
		learnPowerDrainMod = 1.2,
		preferedTask = "make_veg",
		taskSpeed = {
			make_grain = 2,
			make_veg = 2,
		}
	},

}

return data