
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
	if workData.timer > 1 and room.GetResourceCount("reqWood") >= 1 then
		room.AddResource("reqWood", -1)
		monk.SetResource(false, 0)
		return true
	end
end

local data = {
	name = "dorm_build",
	buildDef = "dorm_build",
	image = "basic3x2.png",
	clickTask = "build",
	clickTaskRequires = true,
	drawOriginX = 0,
	drawOriginY = 1.5,
	width = 3,
	height = 2,
	spawnResources = {
		{"reqWood", 2},
	},
	stations = {
		{
			pos = {1, 0.5},
			taskType = "build",
			PerformAction = DoBuild,
			subgoalInheritRoom = true,
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
			taskType = "add_wood",
			PerformAction = DoBuildWood,
			allowParallelUse = true,
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
