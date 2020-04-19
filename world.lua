local IterableMap = require("include/IterableMap")

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

	--------------------------------------------------
	-- Locals
	--------------------------------------------------

	local function UpdateWorld(dt)
		roomList.ApplySelf("UpdateRoom", dt, monkList)
		featureList.ApplySelf("UpdateFeature", dt)
		monkList.ApplySelf("UpdateMonk", dt, roomList, stationsByUse)
	end

	--------------------------------------------------
	-- Interface
	--------------------------------------------------
	local externalFuncs = {}

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

	function externalFuncs.GetRoomList()
		return roomList
	end

	function externalFuncs.GetMonkList()
		return monkList
	end

	function externalFuncs.Update(dt)
		UpdateWorld(dt)
	end

	function externalFuncs.DrawWorld(interface, dt)
		love.graphics.setColor(1, 1, 1)
		--draw
		featureList.ApplySelf("Draw", interface, dt)
		roomList.ApplySelf("Draw", interface, dt)
		monkList.ApplySelf("Draw", interface, dt)
		roomList.ApplySelf("DrawPost", interface, dt)
		monkList.ApplySelf("DrawPost", interface, dt)
	end
	
	return externalFuncs
end

return GetNewWorld
