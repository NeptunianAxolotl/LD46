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
		monkList.ApplySelf("UpdateMonk", dt, roomList, stationsByUse)
	end

	--------------------------------------------------
	-- Interface
	--------------------------------------------------
	local externalFuncs = {}

	function externalFuncs.GetRoomList()
		return roomList
	end

	function externalFuncs.GetMonkList()
		return monkList
	end

	function externalFuncs.Update(dt)
		UpdateWorld(dt*10)
	end

	function externalFuncs.DrawWorld(offsetX, offsetY)
		love.graphics.setColor(1, 1, 1)
		roomList.ApplySelf("Draw", offsetX, offsetY)
		monkList.ApplySelf("Draw", offsetX, offsetY)
		monkList.ApplySelf("DrawPost", offsetX, offsetY)
	end
	
	return externalFuncs
end

return GetNewWorld
