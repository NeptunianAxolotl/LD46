
local GetNewStation = require("station")

local function New(init, stationsByUse)
	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	local defName = init.defName
	local pos     = init.pos
	local def     = DEFS.roomDefNames[defName]

	local stations = {}

	init = nil
	--------------------------------------------------
	-- Locals
	--------------------------------------------------


	--------------------------------------------------
	-- Interface
	--------------------------------------------------
	local externalFuncs = {}

	function externalFuncs.GetPos()
		return pos
	end
	
	function externalFuncs.GetPosAndWidth()
		return pos, def.width
	end
	
	function externalFuncs.Draw(offsetX, offsetY)
		love.graphics.draw(def.image, pos[1]*GLOBAL.TILE_SIZE - offsetX, pos[2]*GLOBAL.TILE_SIZE - offsetY, 0, 1, 1, 0, 0, 0, 0)
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
