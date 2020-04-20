local IterableMap = require("include/IterableMap")
local drawUtilities = require("include/drawUtilities")

tradeUtilities = require("include/tradeUtilities")
laptopUtilities = require("include/laptopUtilities")

local GetNewMonk = require("monk")
local GetNewRoom = require("room")
local GetNewFeature = require("feature")

local function GetNewWorld(startLayout)
	
	local monkList = IterableMap.New()
	local roomList = IterableMap.New()
	local featureList = IterableMap.New()
	local stationsByUse = {}
	
	for i = 1, #DEFS.stationTypes do
		stationsByUse[DEFS.stationTypes[i]] = IterableMap.New()
	end

	local tradeStatus = tradeUtilities.InitTradeStatus()
    local laptopStatus = laptopUtilities.InitLaptopStatus()

	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	for i = 1, #startLayout.monks do
		monkList.Add(GetNewMonk(startLayout.monks[i]))
	end
	for i = 1, #startLayout.rooms do
		roomList.Add(GetNewRoom(startLayout.rooms[i], stationsByUse))
	end
	for i = 1, #startLayout.features do
		featureList.Add(GetNewFeature(startLayout.features[i]))
	end
	
	tradeUtilities.AddTradingPost(tradeStatus, roomList)
	
	local paused = false
	
	--------------------------------------------------
	-- Locals
	--------------------------------------------------

	local function UpdateWorld(dt)
		roomList.ApplySelf("UpdateRoom", dt, monkList)
		featureList.ApplySelf("UpdateFeature", dt)
		monkList.ApplySelf("UpdateMonk", dt, roomList, stationsByUse)
	end

	--------------------------------------------------
	-- Messing with the world
	--------------------------------------------------
	local externalFuncs = {}
	
	function externalFuncs.SetPaused(newPaused)
		paused = newPaused
	end
	
	function externalFuncs.GetPaused()
		return paused
	end
	
	function externalFuncs.GetBuildOptions()
		return DEFS.buildOptions
	end
	
    function externalFuncs.GetOrModifyLaptopStatus()
        return laptopStatus
    end
    
	function externalFuncs.GetOrModifyTradeStatus()
		return tradeStatus
	end
	
	--------------------------------------------------
	-- Creation
	--------------------------------------------------

	function externalFuncs.CreateRoom(defName, px, py)
		local initData = {
			defName = defName,
			pos = {px, py},
		}
		local newRoom = GetNewRoom(initData, stationsByUse)
		roomList.Add(newRoom)
		monkList.ApplySelf("CheckRepath", px, py, DEFS.roomDefNames[defName].width, DEFS.roomDefNames[defName].height)
		return newRoom
	end

	function externalFuncs.CreateFeature(defName, px, py)
		local initData = {
			defName = defName,
			pos = {px, py},
		}
		local newFeature = GetNewFeature(initData)
		featureList.Add(newFeature)
		return newFeature
	end

	--------------------------------------------------
	-- Data
	--------------------------------------------------
	function externalFuncs.GetRoomList()
		return roomList
	end

	function externalFuncs.GetMonkList()
		return monkList
	end

	function externalFuncs.Update(dt)
		if paused then
			return
		end
		UpdateWorld(dt)
	end

	function externalFuncs.DrawWorld(interface, dt)
		love.graphics.setColor(1, 1, 1)
		--draw
		drawUtilities.DrawGrass(interface)
		love.graphics.setColor(1, 1, 1)
		
		if paused then
			dt = 0
		end
		
		featureList.ApplySelf("Draw", interface, dt)
		roomList.ApplySelf("Draw", interface, dt)
		monkList.ApplySelf("Draw", interface, dt)
		roomList.ApplySelf("DrawPost", interface, dt)
		monkList.ApplySelf("DrawPost", interface, dt)
	end
	
	return externalFuncs
end

return GetNewWorld
