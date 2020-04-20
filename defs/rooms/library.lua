
local data = {
	name = "library",
	humanName = "Library",
	buildDef = "library_build",
	image = "library_0.png",
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

