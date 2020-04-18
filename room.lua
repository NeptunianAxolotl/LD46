


local function New(init)
	local defName
	local pos

	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	defName = init.defName
	pos     = init.pos
	def     = defs.roomDefNames[defName]

	init = nil
	--------------------------------------------------
	-- Locals
	--------------------------------------------------


	--------------------------------------------------
	-- Interface
	--------------------------------------------------
	local externalFunc = {}

	function externalFunc.Draw(offsetX, offsetY)
		love.graphics.draw(def.image, pos[1]*GLOBAL.TILE_SIZE - offsetX, pos[2]*GLOBAL.TILE_SIZE - offsetY, 0, 1, 1, 0, 0, 0, 0)
	end
	
	return externalFunc
end

return New
