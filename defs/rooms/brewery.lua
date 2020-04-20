
local function DrawSupply(self, drawX, drawY)
	font.SetSize(1)
	--local text = love.graphics.newText(font.GetFont(), text)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(math.floor(self.GetResourceCount("beer")), drawX + 1.35*GLOBAL.TILE_SIZE, drawY + 0.4*GLOBAL.TILE_SIZE)
	
	love.graphics.setColor(1, 1, 1)
end

local data = {
	name = "brewery",
	image = "brewery.png",
	clickTask = "make_beer",
	drawOriginX = 0,
	drawOriginY = 1.5,
	width = 3,
	height = 3,
	DrawFunc = DrawSupply,
	spawnResources = {
		{"beer", 20},
	},
	stations = {
	}
}

return data

