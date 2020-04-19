
local function New(def, parent, stationsByUse)
	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	local parentPos = parent.GetPos()
	local pos       = UTIL.Add(def.pos, parent.GetPos())
	local reserved  = false
	
	local doorPosition = {}
	for i = 1, #def.doors do
		doorPosition[i] = UTIL.Add(parentPos, def.doors[i].pos)
	end

	init = nil
	--------------------------------------------------
	-- Locals
	--------------------------------------------------


	--------------------------------------------------
	-- Interface
	--------------------------------------------------
	local externalFuncs = {}

	function externalFuncs.Destroy()
		stationsByUse[def.taskType].Remove(externalFuncs.index)
		externalFuncs = nil
		parent = nil
		parentPos = nil
		doorPosition = nil
	end
	
	function externalFuncs.GetParent()
		return parent
	end
	
	function externalFuncs.GetTaskType()
		return def.taskType
	end
	
	function externalFuncs.GetDef()
		return def
	end
	
	--------------------------------------------------
	-- Doors and Pathing
	--------------------------------------------------
	
	function externalFuncs.Distance(x, y, stationDoor)
		if stationDoor then
			return UTIL.Dist(x, y, doorPosition[stationDoor][1], doorPosition[stationDoor][2])
		end
		return UTIL.Dist(x, y, pos[1], pos[2])
	end
	
	function externalFuncs.GetDoorPosition(stationDoor)
		return doorPosition[stationDoor]
	end
	
	function externalFuncs.GetRandomDoor()
		return math.floor(math.random() * #def.doors) + 1
	end
	
	function externalFuncs.GetClosestDoor(x, y)
		local closeIndex
		local closeDist
		for i = 1, #def.doors do
			local dist = externalFuncs.Distance(x, y, i)
			if (not closeDist) or (dist < closeDist) then
				closeIndex = i
				closeDist = dist
			end
		end
		
		return closeIndex
	end
	
	function externalFuncs.GetTransitionPosition(stationDoor, progress)
		local x, y, dir = def.doors[stationDoor].pathFunc(progress)
		return x + parentPos[1], y + parentPos[2], dir
	end
	
	function externalFuncs.GetPathLength(stationDoor)
		return def.doors[stationDoor].pathLength
	end
	
	--------------------------------------------------
	-- Action
	--------------------------------------------------
	
	function externalFuncs.PerformAction(monk, workData, dt)
		if not parent.IsRoomActive() then
			return true -- Stop action
		end
		local toRemove = def.PerformAction(externalFuncs, parent, monk, workData, dt)
		return toRemove
	end
	
	function externalFuncs.IsAvailible(monk)
		if reserved or (not parent.IsRoomActive()) then
			return false
		end
		
		if def.AvailibleFunc and (not def.AvailibleFunc(externalFuncs, parent, monk)) then
			return false
		end
		
		if def.requireResources then
			for i = 1, #def.requireResources do
				local data = def.requireResources[i]
				if parent.GetResourceMinusReserved(data.resType) < data.resCount then
					return false
				end
			end
		end
		
		
		return true
	end
	
	function externalFuncs.AddReservation()
		if not def.allowParallelUse then
			reserved = true
		end
		if def.requireResources then
			for i = 1, #def.requireResources do
				local data = def.requireResources[i]
				parent.ReserveResource(data.resType, data.resCount)
			end
		end
	end
	
	function externalFuncs.RemoveReservation()
		if not def.allowParallelUse then
			reserved = false
		end
		if def.requireResources then
			for i = 1, #def.requireResources do
				local data = def.requireResources[i]
				parent.ReserveResource(data.resType, -data.resCount)
			end
		end
	end
	
	--------------------------------------------------
	-- Finish Initialization
	--------------------------------------------------
	stationsByUse[def.taskType].Add(externalFuncs)
	
	return externalFuncs
end

return New
