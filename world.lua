IterableMap = require("include/IterableMap")
local drawUtilities = require("include/drawUtilities")

tradeUtilities = require("include/tradeUtilities")
laptopUtilities = require("include/laptopUtilities")
knowUtilities = require("include/knowledgeUtilites")
spawnUtilities = require("include/spawnUtilities")

musicUtilities = require("include/musicUtilities")

local Audio = require("audio")

local GetNewMonk = require("monk")
local GetNewRoom = require("room")
local GetNewFeature = require("feature")

local function GetNewWorld(startLayout)
	
	local monkList = IterableMap.New()
	local roomList = IterableMap.New()
	local featureList = IterableMap.New()
	local stationsByUse = {}
	
	for i = 1, #DEFS.stationTypes do
		stationsByUse[DEFS.stationTypes[i]] = IterableMap.New()
	end

	local tradeStatus = tradeUtilities.InitTradeStatus()
	local laptopStatus = laptopUtilities.InitLaptopStatus()
	local knowStatus = knowUtilities.InitKnowStatus()
	local spawnStatus = spawnUtilities.InitSpawnStatus()

	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	for i = 1, #startLayout.monks do
		monkList.Add(GetNewMonk(startLayout.monks[i]))
	end
	for i = 1, #startLayout.rooms do
		roomList.Add(GetNewRoom(startLayout.rooms[i], stationsByUse))
	end
	for i = 1, #startLayout.features do
		featureList.Add(GetNewFeature(startLayout.features[i]))
	end
	
	tradeUtilities.AddTradingPost(tradeStatus, roomList)
	laptopUtilities.AddLaptop(laptopStatus, roomList)
    
    musicUtilities.InitialiseMusic()
	
	local paused = false
	local totalGameTime = 0
	local victoryTime = false
	local defeat = false
	
	local externalFuncs = {}
	
	--------------------------------------------------
	-- Locals
	--------------------------------------------------

	local function UpdateWorld(dt)
		roomList.ApplySelf("UpdateRoom", dt, monkList)
		featureList.ApplySelf("UpdateFeature", dt)
		monkList.ApplySelf("UpdateMonk", dt, roomList, stationsByUse)
		
		knowUtilities.CheckVictory(knowStatus, externalFuncs)
		laptopUtilities.CheckDefeat(laptopStatus, externalFuncs)
		
        musicUtilities.CheckMusicChange("background")
        Audio.Update(dt)
	end

	--------------------------------------------------
	-- Victory and Defeat
	--------------------------------------------------

	function externalFuncs.DeclareVictory()
		if defeat or victoryTime then
			return
		end
		victoryTime = totalGameTime
	end
	
	function externalFuncs.DeclareDefeat()
		if defeat or victoryTime then
			return
		end
		defeat = true
	end
	
	function externalFuncs.GetVictoryTime()
		return victoryTime
	end

	function externalFuncs.GetDefeat()
		return defeat
	end

	--------------------------------------------------
	-- Messing with the world
	--------------------------------------------------
	
	function externalFuncs.SetPaused(newPaused)
		paused = newPaused
	end
	
	function externalFuncs.GetPaused()
		return paused
	end
	
	function externalFuncs.GetBuildOptions()
		return DEFS.buildOptions
	end
	
    function externalFuncs.GetOrModifyLaptopStatus()
        return laptopStatus
    end
    
	function externalFuncs.GetOrModifyTradeStatus()
		return tradeStatus
	end
	
	function externalFuncs.GetOrModifyKnowStatus()
		return knowStatus
	end
	
	function externalFuncs.GetOrModifySpawnStatus()
		return spawnStatus
	end
	
	--------------------------------------------------
	-- Creation
	--------------------------------------------------

	function externalFuncs.CreateRoom(defName, px, py)
		local initData = {
			defName = defName,
			pos = {px, py},
		}
		local newRoom = GetNewRoom(initData, stationsByUse)
		roomList.Add(newRoom)
		monkList.ApplySelf("CheckRepath", px, py, DEFS.roomDefNames[defName].width, DEFS.roomDefNames[defName].height)
		return newRoom
	end

	function externalFuncs.CreateMonk(px, py)
		local initData = {
			pos = {px, py},
		}
		local newMonk = GetNewMonk(initData)
		monkList.Add(newMonk)
		return newMonk
	end

	function externalFuncs.CreateFeature(defName, px, py)
		local initData = {
			defName = defName,
			pos = {px, py},
		}
		local newFeature = GetNewFeature(initData)
		featureList.Add(newFeature)
		return newFeature
	end

	--------------------------------------------------
	-- Data
	--------------------------------------------------
	function externalFuncs.GetRoomList()
		return roomList
	end

	function externalFuncs.GetMonkList()
		return monkList
	end

	function externalFuncs.Update(dt)
		if paused then
			return
		end
		totalGameTime = totalGameTime + dt*40
		UpdateWorld(dt*40)
	end

	function externalFuncs.DrawWorld(interface, dt)
		love.graphics.setColor(1, 1, 1)
		--draw
		drawUtilities.DrawGrass(interface)
		love.graphics.setColor(1, 1, 1)
		
		if paused then
			dt = 0
		end
		
		featureList.ApplySelf("Draw", interface, dt)
		roomList.ApplySelf("Draw", interface, dt)
		monkList.ApplySelf("Draw", interface, dt)
		roomList.ApplySelf("DrawPost", interface, dt)
		monkList.ApplySelf("DrawPost", interface, dt)
	end
	
	return externalFuncs
end

return GetNewWorld
