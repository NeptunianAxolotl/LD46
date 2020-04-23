
DEFS = require("defsHandler")
GLOBAL = require("globals")
UTIL = require("include/util")

font = require("include/font")

local GetNewWorld = require("world")
local GetNewInterface = require("interface")

--------------------------------------------------
-- Handlers
--------------------------------------------------

local world
local interface

function GetWorld()
	return world
end

--------------------------------------------------
-- Input
--------------------------------------------------

function love.mousemoved(x, y, dx, dy, istouch)
	interface.MouseMoved(x, y, dx, dy, istouch)
end

function love.mousepressed(x, y, button, istouch, presses)
	interface.MousePressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
	interface.MouseReleased(x, y, button, istouch, presses)
end

function love.keypressed(key, scancode, isRepeat)
	interface.KeyPressed(key, scancode, isRepeat)
end


--------------------------------------------------
-- Update
--------------------------------------------------
local lastDt = 0
function love.update(dt)
	if dt > 0.05 then
		dt = 0.05
	end
	lastDt = dt
	world.Update(dt)
	interface.UpdateInterface(dt)
end

--------------------------------------------------
-- Draw
--------------------------------------------------

function love.draw()
	world.DrawWorld(interface, lastDt)
	interface.DrawInterface()
end

--------------------------------------------------
-- Loading
--------------------------------------------------

function RestartGame()
	-- There are probably circular pointers that make this
	-- leak memory massively.
	world = GetNewWorld(require("startLayout"))
	interface = GetNewInterface(world)
end

function love.load()
	love.graphics.setBackgroundColor(0.3, 0.5, 0.1)
	math.randomseed(os.clock())
	DEFS.Load()
	world = GetNewWorld(require("startLayout"))
	interface = GetNewInterface(world)
end

--------------------------------------------------
-- Challenge Mode
--------------------------------------------------

-- Needs to survive restart
local challengeMode = false 
local difficultyDrainMult = 1
local difficultyModeName = ""

function GetDifficultyModeName()
	return difficultyModeName
end

function IsChallengeMode()
	return challengeMode
end

function GetDifficultyDrainMult()
	return difficultyDrainMult
end

function EnableChallengeMode()
	challengeMode = true
	difficultyModeName = "Challenge"
	difficultyDrainMult = GLOBAL.CHALLENGE_DRAIN_MULT
	RestartGame()
end

function EnableImpossibleMode()
	challengeMode = true
	difficultyModeName = "Impossible"
	difficultyDrainMult = GLOBAL.IMPOSSIBLE_DRAIN_MULT
	RestartGame()
end
