
local function DrawSupply(self, drawX, drawY)
	font.SetSize(1)
	--local text = love.graphics.newText(font.GetFont(), text)
	love.graphics.setColor(1, 1, 1)
	love.graphics.print(math.floor(self.GetResourceCount("bread")*10)/10, drawX + 1*GLOBAL.TILE_SIZE, drawY + 1.7*GLOBAL.TILE_SIZE)
	love.graphics.setColor(1, 1, 1)
end

local data = {
	name = "bakery",
	humanName = "Bakery",
	buildDef = "bakery_build",
	image = "bakery.png",
	clickTask = "make_bread",
	drawOriginX = 0,
	drawOriginY = 1.5,
	width = 3,
	height = 2,
    DrawFunc = DrawSupply,
	stations = {
	}
}

return data

