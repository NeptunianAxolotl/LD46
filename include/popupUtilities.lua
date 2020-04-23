
local function DrawVictory(world)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(DEFS.images.popup, 0, 0, 0, 1, 1, 0, 0, 0, 0)

	font.SetSize(0)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print("Success!", 560, 300)
	font.SetSize(2)
	love.graphics.print("Under your leadership, the monks\ntranscribed the sum total of human\nscience and culture from the ailing\nlaptop.", 480, 352)
	
	local victoryTime = world.GetVictoryTime() or 0
	local years = math.floor(victoryTime/60)
	local days = math.floor(365*(victoryTime - years*60)/60)
	
	love.graphics.print("You took " .. years .. " years and " .. days .. " days.", 500, 450)
	font.SetSize(3)
	if IsChallengeMode() then
		if GetDifficultyModeName() == "Impossible" then
			love.graphics.print("I have no idea how you just pulled that off", 490, 476)
		else
			love.graphics.print("Type 'impossible' to attempt the impossible", 487, 476)
		end
	else
		love.graphics.print("Type 'challenge' to restart into challenge mode", 478, 476)
	end
end

local function DrawDefeat(world)
	local _, starvation, nowhereToSleep = world.GetDefeat()
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(DEFS.images.popup, 0, 0, 0, 1, 1, 0, 0, 0, 0)

	font.SetSize(0)
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print("Defeat", 570, 300)
	font.SetSize(2)
	if starvation then
		love.graphics.print("Monks cannot live on faith alone.\nStarving or tired monks neglect\nall tasks besides seek food or rest,\nand the dining hall is out of food.", 480, 352)
	elseif nowhereToSleep then
		love.graphics.print("Monks cannot live on faith alone.\nStarving or tired monks neglect\nall tasks besides seek food or rest,\nand they have nowhere to sleep.", 480, 352)
	else
		love.graphics.print("Unable to supply sufficient power,\nthe monks let the laptop fall into\nhibernation. It has little chance of\nreaching the next information age.", 480, 352)
	end
	
	love.graphics.print("Press Ctrl+Shift+R to restart.", 502, 450)
end

local function Draw(world, interface)
	if world.GetDefeat() then
		DrawDefeat(world)
	elseif world.GetVictoryTime() then
		DrawVictory(world)
	end
end

return {
	Draw = Draw
}
