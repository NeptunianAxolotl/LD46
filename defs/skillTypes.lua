
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
		--preferedTask = "make_veg",
		taskSpeed = {
			make_grain = 2.8,
			make_veg = 2,
		},
		requiredPeripherals = {
		
		},
        bookTitle = "Good Eats, Roots And Leaves"
	},
    {
		name = "carpentry",
		humanName = "Carpentry",
		titleName = "Carpenter",
		desc = "Build with wood",
		--preferedTask = "make_wood",
		learnMod = basicLearnMod,
		learnPowerDrainMod = basicPowerMod,
		taskSpeed = {
			make_wood = 3,
			build = 1.5,
		},
		requiredPeripherals = {
		
		},
        bookTitle = "The Compleat Guide to Chopping"
	},
    -- intermediate skills
	{
		name = "masonry",
		humanName = "Masonry",
		titleName = "Mason",
		desc = "Build with stone",
		--preferedTask = "make_stone",
		learnMod = interLearnMod,
		learnPowerDrainMod = interPowerMod,
		taskSpeed = {
			make_stone = 3,
			build = 1.5,
		},
		requiredPeripherals = {
		
		},
        bookTitle = "Piling Higher and Deeper"
	},
    {
		name = "baking",
		humanName = "Baking",
		titleName = "Baker",
		desc = "Baking bread",
		--preferedTask = "make_bread",
		learnMod = interLearnMod,
		learnPowerDrainMod = interPowerMod,
		taskSpeed = {
            make_bread = 2.5,
			cook = 1.5,
		},
		requiredPeripherals = {
		
		},
        bookTitle = "Feeding Ungrateful Sods"
	},
    {
		name = "brewing",
		humanName = "Brewing",
		titleName = "Brewer",
		desc = "Brewing beer",
		--preferedTask = "make_beer",
		learnMod = interLearnMod,
		learnPowerDrainMod = interPowerMod,
		taskSpeed = {
			make_beer = 2.5,
			cook = 1.5,
		},
		requiredPeripherals = {
		
		},
        bookTitle = "Home Brewery for Abstinents"
	},
    {
		name = "economics",
		humanName = "Economics",
		titleName = "Merchant",
		desc = "Gets better trade deals",
		learnMod = interLearnMod,
		--preferedTask = "trade",
		learnPowerDrainMod = interPowerMod,
		taskSpeed = {
		},
		requiredPeripherals = {
		
		},
        bookTitle = "Price Gouging in Antiques Markets"
	},
    -- advanced skills
    {
		name = "programming",
		humanName = "Programming",
		titleName = "Coder",
		desc = "Managing batteries. Requires a monitor.",
		learnMod = advLearnMod,
		--preferedTask = "upkeep_laptop",
		learnPowerDrainMod = advPowerMod,
		taskSpeed = {
			upkeep_laptop = 2,
			charge_battery = 2,
		},
		requiredPeripherals = {
            "monitor"
		},
        bookTitle = "Y2K-Compliant Coding"
	},
    {
		name = "music",
		humanName = "Music",
		titleName = "Musician",
		desc = "Plays in chapel. Requires speakers.",
		--preferedTask = "play_organ",
		learnMod = advLearnMod,
		learnPowerDrainMod = advPowerMod,
		taskSpeed = {
			play_organ = 4,
		},
		requiredPeripherals = {
            "speakers"
		},
        bookTitle = "The Siren's Call (Organ, D minor)"
	},
    {
		name = "art",
		humanName = "Art",
		titleName = "Artist",
		desc = "Preserves culture. Requires a graphics card.",
		learnMod = advLearnMod,
		learnPowerDrainMod = advPowerMod,
		taskSpeed = {
		},
		requiredPeripherals = {
            "graphicscard"
		},
        bookTitle = "A Short History of Game Design"
	},
}

return data