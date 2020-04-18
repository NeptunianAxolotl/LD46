--------------------------------------------------
-- Config
--------------------------------------------------

local IMAGE_PATH = "images/"
local ROOM_PATH = "defs/rooms/"

local roomDefFiles = {
	"dorm",
}

--------------------------------------------------
-- Local Def Data
--------------------------------------------------

roomDefs = {}
roomDefNames = {}

--------------------------------------------------
-- Loading Functions
--------------------------------------------------

local function LoadRoom(filename)
	local roomDef = require(ROOM_PATH .. filename)
	roomDef.image = love.graphics.newImage(IMAGE_PATH .. roomDef.image)
	return roomDef
end

--------------------------------------------------
-- Load
--------------------------------------------------

local function Load()

	for i = 1, #roomDefFiles do
		roomDefs[i] = LoadRoom(roomDefFiles[i])
		roomDefNames[roomDefs[i].name] = roomDefs[i]
	end
end


return {
	Load = Load,
	roomDefs = roomDefs,
	roomDefNames = roomDefNames,
}
