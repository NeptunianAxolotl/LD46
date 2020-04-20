
local grassColor = {}
local grassType = {}

local function DrawGrass(interface)
	local worldX, worldY = interface.ScreenToWorld(-80, -80, true)
	local originX, originY = interface.WorldToScreen(worldX, worldY, 0, 0.5)
	
	local goUp = true
	while originX < 1320 do
		local tempWorldX = worldX
		local tempWorldY = worldY
		for y = originY, 868, GLOBAL.TILE_SIZE do
			if not (grassColor[tempWorldX] and grassColor[tempWorldX][tempWorldY]) then
				grassColor[tempWorldX] = grassColor[tempWorldX] or {}
				grassColor[tempWorldX][tempWorldY] = {0.92 + 0.08*math.random(), 0.92 + 0.08*math.random(), 0.92 + 0.08*math.random()}
			end
			if not (grassType[tempWorldX] and grassType[tempWorldX][tempWorldY]) then
				grassType[tempWorldX] = grassType[tempWorldX] or {}
				grassType[tempWorldX][tempWorldY] = DEFS.images["grass" .. (math.floor(4*(math.random()^2)) + 1)] or DEFS.images.grass1
			end
			
			love.graphics.setColor(grassColor[tempWorldX][tempWorldY])
			love.graphics.draw(grassType[tempWorldX][tempWorldY], originX, y, 0, 1, 1, 0, 0, 0, 0)
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
