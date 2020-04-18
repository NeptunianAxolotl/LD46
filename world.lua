local IterableMap = require("include/IterableMap")
local GetNewRoom = require("room")

local function GetNewWorld(startLayout)
	
	local roomList = IterableMap.New()
	local monkList = IterableMap.New()

	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	for i = 1, #startLayout.monks do

	end
	for i = 1, #startLayout.rooms do
		roomList.Add(GetNewRoom(startLayout.rooms[i]))
	end

	--------------------------------------------------
	-- Locals
	--------------------------------------------------


	--------------------------------------------------
	-- Interface
	--------------------------------------------------
	local externalFunc = {}

	function externalFunc.GetRoomList()
		return roomList
	end

	function externalFunc.GetMonkList()
		return monkList
	end

	function externalFunc.DrawWorld(offsetX, offsetY)
		roomList.ApplySelf("Draw", offsetX, offsetY)
	end
	
	return externalFunc
end

return GetNewWorld