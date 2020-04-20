
local function DrawVictory(world)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(DEFS.images.popup, 0, 0, 0, 1, 1, 0, 0, 0, 0)

	font.SetSize(0)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print("Success!", 560, 300)
	font.SetSize(2)
	love.graphics.print("Under your leadership, the monks\ntranscribed the sum total of human\nscience and culture from the ailing\nlaptop.", 480, 352)
	
	local victoryTime = world.GetVictoryTime()
	local years = math.floor(victoryTime/60)
	local days = math.floor(365*(victoryTime - years*60)/60)
	
	love.graphics.print("You took " .. years .. " years and " .. days .. " days.", 500, 455)
end

local function DrawDefeat()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(DEFS.images.popup, 0, 0, 0, 1, 1, 0, 0, 0, 0)

	font.SetSize(0)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print("Defeat", 570, 300)
	font.SetSize(2)
	love.graphics.print("Unable to supply sufficient power,\nthe monks let the laptop fall into\nhibernation. It has little chance of\nreaching the next information age.", 480, 352)
	
	love.graphics.print("Press Ctrl+Shift+R to restart.", 502, 455)
end

local function Draw(world, interface)
	if world.GetDefeat() then
		DrawDefeat()
	elseif world.GetVictoryTime() then
		DrawVictory(world)
	end
end

return {
	Draw = Draw
}
