
local CONSTRUCTED_BUILDING = "bakery"
local BUILD_IMAGE = "bakery_partial.png"
local WIDTH = 3
local HEIGHT = 2

local WOOD_COST = 5
local STONE_COST = 3

local BUILD_TIME = 3

-- End Config

local function DoBuild(station, room, monk, workData, dt)
	local boundReached = room.AddResource("progress", dt/BUILD_TIME, 1)
	monk.ModifyFatigue(-0.04*dt)
	monk.ModifyFood(-0.06*dt)
	if boundReached then
		local pos = room.GetPosAndSize()
		GetWorld().CreateRoom(CONSTRUCTED_BUILDING, pos[1], pos[2])
		room.Destroy(true)
		return true
	end
end

local function DoBuildWood(station, room, monk, workData, dt)
	workData.timer = (workData.timer or 0) + 1.8*dt
	monk.ModifyFatigue(-0.05*dt)
	monk.ModifyFood(-0.05*dt)
	if workData.timer > 1 and room.GetResourceCount("reqWood") >= 1 then
		room.AddResource("reqWood", -1)
		monk.SetResource(false, 0)
		return true
	end
end

local function DoBuildStone(station, room, monk, workData, dt)
	workData.timer = (workData.timer or 0) + 1.8*dt
	monk.ModifyFatigue(-0.05*dt)
	monk.ModifyFood(-0.05*dt)
	if workData.timer > 1 and room.GetResourceCount("reqStone") >= 1 then
		room.AddResource("reqStone", -1)
		monk.SetResource(false, 0)
		return true
	end
end

local resourceCost = {}
if WOOD_COST > 0 then
	resourceCost[#resourceCost + 1] = {"reqWood", WOOD_COST}
end
if STONE_COST > 0 then
	resourceCost[#resourceCost + 1] = {"reqStone", STONE_COST}
end

local data = {
	name = CONSTRUCTED_BUILDING .. "_build",
	image = BUILD_IMAGE,
	clickTask = "build",
	clickTaskPrefers = true,
	drawOriginX = 0,
	drawOriginY = math.max(WIDTH, HEIGHT)/2,
	width = WIDTH,
	height = HEIGHT,
	spawnResources = resourceCost,
	stations = {
		{
			pos = {WIDTH/2 - 0.5, HEIGHT/2 - 0.5},
			taskType = "build",
			PerformAction = DoBuild,
			subgoalInheritRoom = true,
			allowParallelUse = true,
			doors = {
                {
                    entryPath = {{math.floor(WIDTH/2), -1}}
                },
                {
                    entryPath = {{math.floor(WIDTH/2), HEIGHT}}
                },
                {
                    entryPath = {{-1, math.floor(HEIGHT/2)}}
                },
                {
                    entryPath = {{WIDTH, math.floor(HEIGHT/2)}}
                },
			},
		},
		{
			pos = {WIDTH/2 - 0.5, HEIGHT/2 - 0.5},
			taskType = "add_wood",
			PerformAction = DoBuildWood,
			allowParallelUse = true,
			fetchResource = {"wood"},
			requireResources = {
				{
					resType = "reqWood",
					resCount = 1,
				}
			},
			doors = {
                {
                    entryPath = {{math.floor(WIDTH/2), -1}}
                },
                {
                    entryPath = {{math.floor(WIDTH/2), HEIGHT}}
                },
                {
                    entryPath = {{-1, math.floor(HEIGHT/2)}}
                },
                {
                    entryPath = {{WIDTH, math.floor(HEIGHT/2)}}
                },
			},
		},
		{
			pos = {WIDTH/2 - 0.5, HEIGHT/2 - 0.5},
			taskType = "add_stone",
			PerformAction = DoBuildStone,
			allowParallelUse = true,
			fetchResource = {"stone"},
			requireResources = {
				{
					resType = "reqStone",
					resCount = 1,
				}
			},
			doors = {
                {
                    entryPath = {{math.floor(WIDTH/2), -1}}
                },
                {
                    entryPath = {{math.floor(WIDTH/2), HEIGHT}}
                },
                {
                    entryPath = {{-1, math.floor(HEIGHT/2)}}
                },
                {
                    entryPath = {{WIDTH, math.floor(HEIGHT/2)}}
                },
			},
		},
	}
}

return data
