
local function ChopAction(station, room, monk, workData, dt)
	local boundReached = room.AddResource("progress", dt*0.6, 1)
	monk.ModifyFatigue(-0.04*dt)
	monk.ModifyFood(-0.06*dt)
	if boundReached then
		local pos = room.GetPosition()
		GetWorld().CreateFeature("stump", pos[1], pos[2])
		monk.SetResource("log", 1)
		room.Destroy(true)
		return true
	end
end

local data = {
	name = "tree",
	image = "tree.png",
	clickTask = "chop",
	clickTaskPrefers = true,
	drawOriginX = -0.08,
	drawOriginY = 1.2,
	width = 1,
	height = 1,
	stations = {
		{
			pos = {0.9, 0},
			taskType = "chop",
			PerformAction = ChopAction,
			doors = {
                {
                    entryPath = {{1, 0}}
                },
			},
		},
	}
}

return data
