--------------------------------------------------
-- Config
--------------------------------------------------

local IMAGE_PATH    = "images/"
local ROOM_PATH     = "defs/rooms/"
local FEATURE_PATH  = "defs/features/"

local roomDefFiles = {
	"dorm",
	"dorm_build",
	"field",
	"dining",
	"woodpile",
	"tree",
	"garden",
	"laptop",
	"library",
	"dorm_small",
	"chapel",
	"bakery",
	"brewery",
	"trade",
	"bike",
	"quarry",
}

local featureDefFiles = {
	"stump",
}

--------------------------------------------------
-- Local Def Data
--------------------------------------------------

local defs = {
	roomDefs = {},
	roomDefNames = {},
	featureDefs = {},
	featureDefNames = {},
	stationTypes = {},
}

--------------------------------------------------
-- Loading Functions
--------------------------------------------------

local function LoadRoom(filename)
	local roomDef = require(ROOM_PATH .. filename)
	roomDef.image = love.graphics.newImage(IMAGE_PATH .. roomDef.image)
	
	-- Calculate station positions.
	for i = 1, #roomDef.stations do
		local station = roomDef.stations[i]
		for j = 1, #station.doors do
            local door = station.doors[j]
            if not (door.pathFunc and door.pathLength) then
                if door.entryPath then
                    local epath = door.entryPath
                    
                    if #epath == 0 then
                        epath[1] = station.pos
                    end
                    
                    if (not door.teleportToStation and ((epath[#epath][1] ~= station.pos[1]) or (epath[#epath][2] ~= station.pos[2]))) then
                        -- end at the station itself if we don't want to teleport
                        epath[#epath+1] = station.pos
                    end
                    
                    if #epath == 1 then
                        return epath[1][1], epath[1][2], 0
                    end
                    
                    local stepLenCumu = {}
                    local stepAng = {}
                    stepLenCumu[1] = 0
                    for k = 1, #epath - 1 do
                        stepLenCumu[k + 1] = stepLenCumu[k] + UTIL.Dist(epath[k][1],epath[k][2],epath[k+1][1],epath[k+1][2])
                        stepAng[k] = UTIL.Angle(epath[k+1][1] - epath[k][1],epath[k+1][2] - epath[k][2])
                    end
                    door.pathLength = stepLenCumu[#epath]
                    
                    door.pathFunc = function (progress)
                        local dTravelled = progress * door.pathLength
                        for m = 1, #epath - 1 do
                            if dTravelled >= stepLenCumu[m] and dTravelled < stepLenCumu[m + 1] then
                                -- found the right step, find distance along it
                                local fracOfStep = (dTravelled - stepLenCumu[m]) / (stepLenCumu[m + 1] - stepLenCumu[m])
                                return (1-fracOfStep)*epath[m][1]+fracOfStep*epath[m+1][1], (1-fracOfStep)*epath[m][2]+fracOfStep*epath[m+1][2], stepAng[m] or 0
                            end
                        end
                        -- check for out of bounds negative
                        if dTravelled < stepLenCumu[1] then
                            return epath[1][1], epath[1][2], stepAng[1] or 0
                        end
                        -- check if we have arrived at the destination
                        if dTravelled >= stepLenCumu[#epath] then
                            local angle = (station.overrideDir or stepAng[#epath-1]) or 0
                            if door.teleportToStation then
                                return station.pos[1], station.pos[2], angle or 0
                            else
                                return epath[#epath][1], epath[#epath][2], angle or 0
                            end
                        end
                        print(progress)
                        print(dTravelled)
                        error('Error in calculated pathFunc ' .. roomDef.name)
                    end
                else
                    error('Neither pathFunc+pathLength nor entryPath defined for room ' .. roomdef.name .. ' station ' .. i .. ' door ' .. j )
                end
            end
            if (door.pathFunc and door.pathLength) then
                local x, y = door.pathFunc(0)
                door.pos = {x, y}
            else
               error('pathFunc+pathLength not correctly evaluated for room ' .. roomdef.name .. ' station ' .. i .. ' door ' .. j )
            end
		end
	end
	
	return roomDef
end

local function LoadFeature(filename)
	local featureDef = require(FEATURE_PATH .. filename)
	featureDef.image = love.graphics.newImage(IMAGE_PATH .. featureDef.image)
	return featureDef
end

local function LoadMonk(filename)
	local monkDef = require(filename)
    monkDef.defaultImage = love.graphics.newImage(IMAGE_PATH .. monkDef.defaultImage)
    for k, v in pairs(monkDef.images) do
        v.spriteSheet = love.graphics.newImage(IMAGE_PATH .. v.file)
        -- print(IMAGE_PATH .. v.file)
        -- print(v.spriteSheet)
        -- print(v.spriteSheet:getHeight())
        -- print(v.spriteSheet:getDimensions())
        v.quads = {}
        for x = 0, v.spriteSheet:getWidth() - v.width, v.width do
            --print(x)
            table.insert(v.quads, love.graphics.newQuad(x, 0, v.width, v.spriteSheet:getHeight(), v.spriteSheet:getDimensions()))
        end
    end
	return monkDef
end

local function LoadStationTypes(filename)
	local data = require(filename)
	return data[1], data[2], data[3]
end

local function LoadSkillTypes(filename)
	local skillList = require(filename)
	local skillMap = {}
	for i = 1, #skillList do
		skillMap[skillList[i].name] = skillList[i]
	end
	
	return skillList, skillMap
end

local function LoadGlobalImages(filename)
	local images = require(filename)
	local imageMap = {}
	for i = 1, #images do
		imageMap[images[i][1]] = love.graphics.newImage(IMAGE_PATH .. images[i][2])
	end
	return imageMap
end

--------------------------------------------------
-- Load
--------------------------------------------------

function defs.Load()
	for i = 1, #roomDefFiles do
		defs.roomDefs[i] = LoadRoom(roomDefFiles[i])
		defs.roomDefNames[defs.roomDefs[i].name] = defs.roomDefs[i]
	end
	
	for i = 1, #featureDefFiles do
		defs.featureDefs[i] = LoadFeature(featureDefFiles[i])
		defs.featureDefNames[defs.featureDefs[i].name] = defs.featureDefs[i]
	end
	
	
	defs.monkDef = LoadMonk("defs/monk")
	defs.stationTypes, defs.stationTypeNames, defs.taskSubgoal = LoadStationTypes("defs/stationTypes")
	defs.images = LoadGlobalImages("defs/globalImages")
	
	defs.skillDefs, defs.skillDefNames = LoadSkillTypes("defs/skillTypes")
	
	defs.nameList = require("defs/nameList")
end

return defs
