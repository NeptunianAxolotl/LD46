
local function ChopAction(station, room, monk, workData, dt)
	local boundReached = room.AddResource("progress", dt*0.2, 1)
	monk.ModifyFatigue(-0.04*dt)
	monk.ModifyFood(-0.06*dt)
	if boundReached then
		monk.SetResource("log", 1)
		room.Destroy(true)
		return true
	end
end

local data = {
	name = "tree",
	image = "tree.png",
	drawOriginX = -0.1,
	drawOriginY = 0.8,
	width = 1,
	height = 1,
	stations = {
		{
			pos = {1, 0},
			taskType = "chop",
			PerformAction = ChopAction,
			doors = {
                {
                    entryPath = {}
                },
			},
		},
	}
}

return data
