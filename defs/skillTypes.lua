
local basicLearnMod = 1.7
local basicPowerMod = 1.2

local interLearnMod = 1.3
local interPowerMod = 1.6

local advLearnMod = 0.8
local advPowerMod = 2.2

local data = {
    -- basic skills
    {
		name = "farming",
		humanName = "Farming",
		titleName = "Farmer",
		desc = "Gather crops",
		learnMod = basicLearnMod,
		learnPowerDrainMod = basicPowerMod,
		preferedTask = "make_veg",
		taskSpeed = {
			make_grain = 2,
			make_veg = 2,
		},
		requiredPeripherals = {
		
		},
	},
    {
		name = "carpentry",
		humanName = "Carpentry",
		titleName = "Carpenter",
		desc = "Build with wood",
		learnMod = basicLearnMod,
		learnPowerDrainMod = basicPowerMod,
		taskSpeed = {
			make_wood = 2,
			build = 1.5,
		},
		requiredPeripherals = {
		
		},
	},
    -- intermediate skills
	{
		name = "masonry",
		humanName = "Masonry",
		titleName = "Mason",
		desc = "Build with stone",
		learnMod = interLearnMod,
		learnPowerDrainMod = interPowerMod,
		taskSpeed = {
			make_stone = 2,
			build = 1.5,
		},
		requiredPeripherals = {
		
		},
	},
    {
		name = "baking",
		humanName = "Baking",
		titleName = "Baker",
		desc = "Baking bread",
		learnMod = interLearnMod,
		learnPowerDrainMod = interPowerMod,
		taskSpeed = {
            make_bread = 2,
			cook = 1.5,
		},
		requiredPeripherals = {
		
		},
	},
    {
		name = "brewing",
		humanName = "Brewing",
		titleName = "Brewer",
		desc = "Brewing beer",
		learnMod = interLearnMod,
		learnPowerDrainMod = interPowerMod,
		taskSpeed = {
			make_beer = 2,
			cook = 1.5,
		},
		requiredPeripherals = {
		
		},
	},
    {
		name = "economics",
		humanName = "Economics",
		titleName = "Merchant",
		desc = "Gets better trade deals",
		learnMod = interLearnMod,
		learnPowerDrainMod = interPowerMod,
		taskSpeed = {
		},
		requiredPeripherals = {
		
		},
	},
    -- advanced skills
    {
		name = "programming",
		humanName = "Programming",
		titleName = "Coder",
		desc = "Maintaining laptop",
		learnMod = advLearnMod,
		learnPowerDrainMod = advPowerMod,
		taskSpeed = {
			upkeep_laptop = 2,
		},
		requiredPeripherals = {
            "monitor"
		},
	},
    {
		name = "music",
		humanName = "Music",
		titleName = "Musician",
		desc = "Plays in chapel",
		learnMod = advLearnMod,
		learnPowerDrainMod = advPowerMod,
		taskSpeed = {
			play_organ = 2,
		},
		requiredPeripherals = {
            "speakers"
		},
	},
    {
		name = "art",
		humanName = "Art",
		titleName = "Artist",
		desc = "Preserves culture",
		learnMod = advLearnMod,
		learnPowerDrainMod = advPowerMod,
		taskSpeed = {
		},
		requiredPeripherals = {
            "graphicscard"
		},
	},
}

return data