
local function New(init)
	local hunger = 0
	local fatigue = 0
	
	local station = nil
	local stationDoor = nil
	local taskType = "sleep"

	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	local def       = DEFS.monkDef
	local pos       = init.pos
	local direction = math.random()

	init = nil
	--------------------------------------------------
	-- Locals
	--------------------------------------------------


	--------------------------------------------------
	-- Interface
	--------------------------------------------------
	local externalFuncs = {}

	function externalFuncs.Update()
		
	end

	function externalFuncs.Draw(offsetX, offsetY)
		love.graphics.draw(def.image, pos[1]*GLOBAL.TILE_SIZE - offsetX, pos[2]*GLOBAL.TILE_SIZE - offsetY, direction, 1, 1, 0, 0, 0, 0)
	end
	
	return externalFuncs
end

return New
