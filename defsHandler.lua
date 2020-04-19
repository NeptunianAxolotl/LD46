--------------------------------------------------
-- Config
--------------------------------------------------

local IMAGE_PATH = "images/"
local ROOM_PATH = "defs/rooms/"

local roomDefFiles = {
	"dorm",
	"dorm_build",
	"field",
	"dining",
	"woodpile",
	"tree",
}

--------------------------------------------------
-- Local Def Data
--------------------------------------------------

local defs = {
	roomDefs = {},
	roomDefNames = {},
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
                    if (#epath == 0) or (epath[#epath][1] ~= station.pos[1]) or (epath[#epath][1] ~= station.pos[2]) then
                        -- end at the station itself if we don't already
                        epath[#epath+1] = station.pos
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
                            if dTravelled >= stepLenCumu[m] and dTravelled <= stepLenCumu[m + 1] then
                                -- found the right step, find distance along it
                                local fracOfStep = (dTravelled - stepLenCumu[m]) / (stepLenCumu[m + 1] - stepLenCumu[m])
                                return (1-fracOfStep)*epath[m][1]+fracOfStep*epath[m+1][1], (1-fracOfStep)*epath[m][2]+fracOfStep*epath[m+1][2], stepAng[m] or 0
                            end
                        end
                        -- check for out of bounds
                        if dTravelled <= stepLenCumu[1] then
                            return epath[1][1], epath[1][2], stepAng[1] or 0
                        end
                        if dTravelled >= stepLenCumu[#epath] then
                            return epath[#epath][1], epath[#epath][2], stepAng[#epath-1] or 0
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

local function LoadMonk(filename)
	local monkDef = require(filename)
    monkDef.defaultImage = love.graphics.newImage(IMAGE_PATH .. monkDef.defaultImage)
    for k, v in pairs(monkDef.images) do
        local filename = v.file
        local nframes = v.frames
        local extension = v.ext
        if nframes == 0 then
            monkDef.images[k] = love.graphics.newImage(IMAGE_PATH .. filename .. extension)
        else
            error('Animation not yet supported')
        end
    end
	return monkDef
end

local function LoadStationTypes(filename)
	return require(filename)
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
	
	defs.monkDef = LoadMonk("defs/monk")
	defs.stationTypes = LoadStationTypes("defs/stationTypes")
	defs.images = LoadGlobalImages("defs/globalImages")
end

return defs
