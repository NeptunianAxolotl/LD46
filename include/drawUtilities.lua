
local grassColor = {}

local function DrawGrass(interface)
	local worldX, worldY = interface.ScreenToWorld(-80, -80, true)
	local originX, originY = interface.WorldToScreen(worldX, worldY, 0, 0.5)
	
	local goUp = true
	while originX < 1124 do
		local tempWorldX = worldX
		local tempWorldY = worldY
		for y = originY, 868, GLOBAL.TILE_SIZE do
			if not (grassColor[tempWorldX] and grassColor[tempWorldX][tempWorldY]) then
				grassColor[tempWorldX] = grassColor[tempWorldX] or {}
				grassColor[tempWorldX][tempWorldY] = {0.88 + 0.12*math.random(), 0.88 + 0.12*math.random(), 0.88 + 0.12*math.random()}
			end
			
			love.graphics.setColor(grassColor[tempWorldX][tempWorldY])
			love.graphics.draw(DEFS.images.grass, originX, y, 0, 1, 1, 0, 0, 0, 0)
			tempWorldX = tempWorldX - 1
			tempWorldY = tempWorldY + 1
		end
		
		originX = originX + GLOBAL.TILE_SIZE*0.5
		if goUp then
			originY = originY - GLOBAL.TILE_SIZE*0.5
			worldX = worldX + 1
		else
			originY = originY + GLOBAL.TILE_SIZE*0.5
			worldY = worldY + 1
		end
		goUp = not goUp
	end
end

return {
	DrawGrass = DrawGrass,
}
