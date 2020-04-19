
local data = {
	name = "stump",
	image = "stump.png",
	drawOriginX = -0.08,
	drawOriginY = 1.2,
}

function data.InitFunc()
	return {
		spawnTime = 29 + 28*math.random(),
	}
end

local function PosFree()
	local treePos = externalFuncs.GetPos()
	
	local roomList = GetWorld().GetRoomList()
	for _, room in roomList.Iterator() do
		local pos, width, height = room.GetPosAndSize()
		if UTIL.PosInRectangle(pos[1], pos[2], width, height, treePos[1], treePos[2]) then
			return false
		end
	end
	
	local monkList = GetWorld().GetMonkList()
	for _, monk in monkList.Iterator() do
		local pos, movingToPos = monk.GetPosition()
		if (treePos[1] == pos[1] and treePos[1] == pos[2]) or (movingToPos and (treePos[1] == movingToPos[1] and treePos[1] == movingToPos[2])) then
			return false
		end
	end
	return true
end

function data.UpdateFunc(externalFuncs, updateData, dt)
	updateData.spawnTime = updateData.spawnTime - dt
	if updateData.spawnTime < 0 then
		if PosFree() then
			
			return true
		else
			updateData.spawnTime + 3 + 5*math.random()
		end
	end
end

return data
