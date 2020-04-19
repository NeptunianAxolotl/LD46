
local data = {
	name = "stump",
	image = "trees/strump.png",
	width = 1,
	height = 1,
	drawOriginX = -0.08,
	drawOriginY = 1.2,
}

function data.InitFunc()
	return {
		spawnTime = 25 + 15*math.random(),
		checkTime = 10 + 3*math.random(),
	}
end

local function PosFree(externalFuncs, checkMonks)
	local treePos = externalFuncs.GetPosition()
	
	local roomList = GetWorld().GetRoomList()
	for _, room in roomList.Iterator() do
		local pos, width, height = room.GetPosAndSize()
		if UTIL.PosInRectangle(pos[1] - 1, pos[2] - 1, width + 2, height + 2, treePos[1], treePos[2]) then
			return false
		end
	end
	
	if checkMonks then
		local monkList = GetWorld().GetMonkList()
		for _, monk in monkList.Iterator() do
			local pos, movingToPos = monk.GetPosition()
			if (treePos[1] == pos[1] and treePos[1] == pos[2]) or (movingToPos and (treePos[1] == movingToPos[1] and treePos[1] == movingToPos[2])) then
				return false, true
			end
		end
	end
	return true
end

function data.UpdateFunc(externalFuncs, updateData, dt)
	updateData.spawnTime = updateData.spawnTime - dt
	updateData.checkTime = updateData.checkTime - dt
	if updateData.checkTime < 0 then
		local posFree, tryAgain = PosFree(externalFuncs)
		if not posFree then
			return true -- Remove feature
		end
		updateData.checkTime = 10 + 3*math.random()
	end
	
	if updateData.spawnTime < 0 then
		local posFree, tryAgain = PosFree(externalFuncs, true)
		if posFree then
			local pos = externalFuncs.GetPosition()
			GetWorld().CreateRoom("tree", pos[1], pos[2])
			externalFuncs.Destroy(true)
			return true -- Remove feature
		elseif tryAgain then
			updateData.spawnTime = 8 + 7*math.random()
			return false
		end
		return true -- Remove feature
	end
end

return data
