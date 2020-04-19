local IterableMap = require("include/IterableMap")

local GetNewMonk = require("monk")
local GetNewRoom = require("room")

local function GetNewWorld(startLayout)
	
	local monkList = IterableMap.New()
	local roomList = IterableMap.New()
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

	--------------------------------------------------
	-- Locals
	--------------------------------------------------

	local function UpdateWorld(dt)
		roomList.ApplySelf("UpdateRoom", dt, monkList)
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
		roomList.Add(GetNewRoom(initData, stationsByUse))
		monkList.ApplySelf("CheckRepath", px, py, DEFS.roomDefNames[defName].width, DEFS.roomDefNames[defName].height)
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

	function externalFuncs.DrawWorld(interface)
		love.graphics.setColor(1, 1, 1)
		roomList.ApplySelf("Draw", interface)
		monkList.ApplySelf("Draw", interface)
		monkList.ApplySelf("DrawPost", interface)
	end
	
	return externalFuncs
end

return GetNewWorld
