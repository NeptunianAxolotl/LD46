
local GetNewStation = require("station")
local goalUtilities = require("include/goalUtilities")

local function New(init, stationsByUse)
	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	local defName = init.defName
	local pos     = init.pos
	local def     = DEFS.roomDefNames[defName]

	local stations = {}

	init = nil
	
	local externalFuncs = {}
	
	--------------------------------------------------
	-- Locals
	--------------------------------------------------
	local resources = {}
	local reservedResources = {}
	local wantDestruction = false
	local roomDisabled = false

	local function CheckDestroy(monkList)
		if not goalUtilities.RemoveMonkRoomLinks(externalFuncs, monkList) then
			return false
		end
		
		for i = 1, #def.stations do
			stations[i].Destroy()
		end
		externalFuncs = nil
		stations = nil
		resources = nil
		reservedResources = nil
		return true
	end

	--------------------------------------------------
	-- Interface
	--------------------------------------------------

	function externalFuncs.GetPos()
		return pos
	end
	
	function externalFuncs.GetPosAndSize()
		return pos, def.width, def.height
	end
	
	function externalFuncs.Destroy(roomList, monkList)
		wantDestruction = true
	end
	
	function externalFuncs.IsRoomActive()
		return not (wantDestruction or roomDisabled)
	end
	
	--------------------------------------------------
	-- Resources
	--------------------------------------------------
	function externalFuncs.AddResource(resType, change, bound)
		resources[resType] = (resources[resType] or 0) + change
		if bound then
			if change > 0 and resources[resType] > bound then
				resources[resType] = bound
				return true
			end
			if change < 0 and resources[resType] < bound then
				resources[resType] = bound
				return true
			end
		end
	end
	
	function externalFuncs.GetResourceCount(resType)
		return resources[resType] or 0
	end
	
	function externalFuncs.GetResourceMinusReserved(resType)
		return (resources[resType] or 0) - (reservedResources[resType] or 0)
	end
	
	function externalFuncs.ReserveResource(resType, change)
		reservedResources[resType] = (reservedResources[resType] or 0) + change
	end
	
	--------------------------------------------------
	-- Drawing and Updates
	--------------------------------------------------
	
	function externalFuncs.UpdateRoom(dt, monkList)
		if wantDestruction and CheckDestroy(monkList) then
			return true -- Remove from roomList
		end
	end
	
	function externalFuncs.Draw(offsetX, offsetY)
		local x, y = pos[1]*GLOBAL.TILE_SIZE - offsetX, pos[2]*GLOBAL.TILE_SIZE - offsetY
		love.graphics.draw(def.image, x, y, 0, 1, 1, 0, 0, 0, 0)
		
		if def.DrawFunc then
			def.DrawFunc(externalFuncs, x, y)
		end
	end
	
	--------------------------------------------------
	-- Finish Initialization
	--------------------------------------------------
	for i = 1, #def.stations do
		stations[i] = GetNewStation(def.stations[i], externalFuncs, stationsByUse)
	end
	
	return externalFuncs
end

return New
