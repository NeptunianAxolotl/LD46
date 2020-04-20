
local data = {
	name = "library",
	image = "library_empty.png",
	clickTaskFunc = function (x, y)
		if x < 2 then
			return "library_learn"
		end
		return "transcribe"
	end,
	drawOriginX = 0,
	drawOriginY = 2,
	width = 4,
	height = 3,
	stations = {
	}
}

return data

