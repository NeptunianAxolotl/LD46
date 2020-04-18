

local Shadows = require("shadows")
local LightWorld = require("shadows.LightWorld")
local Light = require("shadows.Light")
local Body = require("shadows.Body")
local PolygonShadow = require("shadows.ShadowShapes.PolygonShadow")
local CircleShadow = require("shadows.ShadowShapes.CircleShadow")

-- Create a light world
newLightWorld = LightWorld:new()

-- Create a light on the light world, with radius 300
newLight = Light:new(newLightWorld, 300)

-- Set the light's color to white
newLight:SetColor(255, 255, 255, 255)

-- Set the light's position
newLight:SetPosition(400, 400)

-- Create a body
newBody = Body:new(newLightWorld)

-- Set the body's position and rotation
newBody:SetPosition(300, 300)
newBody:SetAngle(-15)

-- Create a polygon shape on the body with the given points
PolygonShadow:new(newBody, -10, -10, 10, -10, 10, 10, -10, 10)

-- Create a circle shape on the body at (-30, -30) with radius 16
CircleShadow:new(newBody, -30, -30, 16)

-- Create a second body
newBody2 = Body:new(newLightWorld)

-- Set the second body's position
newBody2:SetPosition(350, 350)

-- Add a polygon shape to the second body
PolygonShadow:new(newBody2, -20, -20, 20, -20, 20, 20, -20, 20)

function love.draw()
	-- Clear the screen
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())

	-- Draw the light world with white color
	newLightWorld:Draw()
end

function love.update()
	-- Move the light to the mouse position with altitude 1.1
	newLight:SetPosition(love.mouse.getX(), love.mouse.getY(), 1.1)
	
	-- Recalculate the light world
	newLightWorld:Update()
end

function love.mousepressed()
	-- Create a new light with radius 300
	newLight = Light:new(newLightWorld, 300)

	-- Set the light's color randomly
	newLight:SetColor(math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255))
end

