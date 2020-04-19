
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
	
	local resources = {}
	if def.spawnResources then
		for i = 1, #def.spawnResources do
			local res = def.spawnResources[i]
			resources[res[1]] = res[2]
		end
	end
	
	--------------------------------------------------
	-- Locals
	--------------------------------------------------
	local reservedResources = {}
	local wantDestruction = false
	local hidden = false
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
	
	function externalFuncs.Destroy(hideImmediately)
		wantDestruction = true
		if hideImmediately then
			hidden = true
		end
	end
	
	function externalFuncs.HitTest()
		return not wantDestruction
	end
	
	function externalFuncs.IsRoomActive()
		return not (wantDestruction or roomDisabled)
	end
	
	function externalFuncs.GetDef()
		return def
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
		if def.UpdateFunc then
			def.UpdateFunc(externalFuncs, dt)
		end
	end
	
	function externalFuncs.Draw(interface)
		if hidden then
			return
		end

		local x, y = interface.WorldToScreen(pos[1], pos[2], def.drawOriginX, def.drawOriginY)
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
