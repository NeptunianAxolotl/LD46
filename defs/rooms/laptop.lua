

local data = {
	name = "laptop",
	image = "laptoproom.png",
	clickTaskFunc = function (x, y)
		if y < 1.5 then
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
			pos = {0, 1},
			taskType = "upkeep_laptop",
			doors = {
                {
                    entryPath = {{-1,1}}
                },
			},
		},
		{
			pos = {1, 0},
			taskType = "use_laptop",
			doors = {
                {
                    entryPath = {{1,-1}}
                },
			},
		},
	}
}

return data
