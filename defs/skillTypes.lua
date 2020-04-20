
local data = {
	{
		name = "masonry",
		humanName = "Masonry",
		desc = "Do stone",
		learnMod = 1.7,
		practiseMod = 1.3,
		learnPowerDrainMod = 1.2,
		requiredPerhipherals = {
			
		},
		practiseTasks = {
			"build_adv",
			"make_stone",
		},
		EffectFunc = function (monk, rank, taskType)
			if taskType == "make_stone" and (rank > 1.5) then
				return (rank - 0.83)*1.5 -- Rank 1 is novice, rank 2 adept, rank 3 master. Interpolated.
			end
			return 1
		end,
	},
	{
		name = "farming",
		humanName = "Farming",
		desc = "Do stone",
		learnMod = 1.7,
		practiseMod = 1.3,
		learnPowerDrainMod = 1.2,
		requiredPerhipherals = {
			
		},
		practiseTasks = {
			"make_grain",
			"make_veg",
		},
		EffectFunc = function (monk, rank, taskType)
			if (taskType == "make_grain" or taskType == "make_veg") and (rank > 1.5) then
				return (rank - 0.83)*1.5 -- Rank 1 is novice, rank 2 adept, rank 3 master. Interpolated.
			end
			return 1
		end,
	},

}

return data