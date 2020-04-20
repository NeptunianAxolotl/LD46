
local function DoUpkeepLaptop(station, room, monk, workData, dt)

end

local function DoUseLaptop(station, room, monk, workData, dt)

end

local data = {
	name = "laptop",
	image = "laptoproom.png",
	clickTaskFunc = function (x, y)
		if y < 1.8 then
			return "upkeep_laptop"
		end
		return "use_laptop"
	end,
	width = 3,
	height = 4,
    drawOriginX = 0,
	drawOriginY = 1.5,
	stations = {
		{
			pos = {1.5, 0.3},
			taskType = "upkeep_laptop",
			PerformAction = DoUpkeepLaptop,
			doors = {
                {
                    entryPath = {{1,-1}, {1, 0.3}}
                },
                {
                    entryPath = {{-1,0}, {1, 0.3}}
                },
			},
		},
		{
			pos = {1, 2},
			taskType = "use_laptop",
			PerformAction = DoUseLaptop,
			doors = {
                {
                    entryPath = {{1,4}}
                },
			},
		},
	}
}

return data
