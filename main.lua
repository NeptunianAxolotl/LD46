
DEFS = require("defsHandler")
GLOBAL = require("globals")
UTIL = require("include/util")

local GetNewWorld = require("world")

--------------------------------------------------
-- Input
--------------------------------------------------

local world

--------------------------------------------------
-- Input
--------------------------------------------------

function love.mousemoved(x, y, dx, dy, istouch )
end

function love.mousereleased(x, y, button, istouch, presses)
end

function love.keypressed(key, scancode, isRepeat)
end

local function MouseHitFunc(fixture)
	return true
end

function love.mousepressed(x, y, button, istouch, presses)
end

--------------------------------------------------
-- Update
--------------------------------------------------

function love.update(dt)
	world.Update(dt)
end

--------------------------------------------------
-- Draw
--------------------------------------------------

function love.draw()
	world.DrawWorld(0, 0)
end

--------------------------------------------------
-- Loading
--------------------------------------------------

function love.load()
	love.graphics.setBackgroundColor(0.3, 0.5, 0.1)
	math.randomseed(os.clock())
	DEFS.Load()
	world = GetNewWorld(require("startLayout"))
end
