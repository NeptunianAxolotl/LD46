
local function DoBuild(station, room, monk, workData, dt)
	local boundReached = room.AddResource("progress", dt*0.2, 1)
	monk.ModifyFatigue(-0.04*dt)
	monk.ModifyFood(-0.06*dt)
	if boundReached then
		local pos = room.GetPosAndSize()
		GetWorld().CreateRoom("dorm", pos[1], pos[2])
		room.Destroy(true)
		return true
	end
end

local function DoBuildWood(station, room, monk, workData, dt)
	workData.timer = (workData.timer or 0) + 0.6*dt
	monk.ModifyFatigue(-0.05*dt)
	monk.ModifyFood(-0.05*dt)
	if workData.timer > 1 and room.GetResourceCount("reqWood") > 1 then
		room.AddResource("reqWood", -1)
		monk.SetResource(false, 0)
	end
end

local function CheckResources(station, room, monk)
	return room.GetResourceCount("reqWood") == 0 and room.GetResourceCount("reqStone") == 0
end

local data = {
	name = "dorm_build",
	buildDef = "dorm_build",
	image = "basic3x2.png",
	drawOriginX = -3/2,
	drawOriginY = 3/2,
	width = 3,
	height = 2,
	spawnResources = {
		{"reqWood", 3},
	},
	stations = {
		{
			pos = {1, 0.5},
			taskType = "build",
			PerformAction = DoBuild,
			AvailibleFunc = CheckResources,
			doors = {
                {
                    entryPath = {{1,-1}}
                },
                {
                    entryPath = {{1,2}}
                },
			},
		},
		{
			pos = {1, 0.5},
			taskType = "build",
			taskSubType = "wood",
			PerformAction = DoBuildWood,
			requireResources = {
				{
					resType = "reqWood",
					resCount = 1,
				}
			},
			doors = {
                {
                    entryPath = {{1,-1}}
                },
                {
                    entryPath = {{1,2}}
                },
			},
		},
	}
}

return data
