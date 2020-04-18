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

local defs = {
	roomDefs = {},
	roomDefNames = {},
	stationTypes = {},
}

--------------------------------------------------
-- Loading Functions
--------------------------------------------------

local function LoadRoom(filename)
	local roomDef = require(ROOM_PATH .. filename)
	roomDef.image = love.graphics.newImage(IMAGE_PATH .. roomDef.image)
	return roomDef
end

local function LoadMonk(filename)
	local monkDef = require(filename)
	monkDef.image = love.graphics.newImage(IMAGE_PATH .. monkDef.image)
	return monkDef
end

local function LoadStationTypes(filename)
	return require(filename)
end

--------------------------------------------------
-- Load
--------------------------------------------------

function defs.Load()
	for i = 1, #roomDefFiles do
		defs.roomDefs[i] = LoadRoom(roomDefFiles[i])
		defs.roomDefNames[defs.roomDefs[i].name] = defs.roomDefs[i]
	end
	
	defs.monkDef = LoadMonk("defs/monk")
	defs.stationTypes = LoadStationTypes("defs/stationTypes")
end

return defs
