
local function CheckEligible(station, room, monk)
	local skillDef, progress = monk.GetSkill()
	if (not skillDef) or (progress == 1) then
		return false
	end
	
	local knowData = GetWorld.GetOrModifyKnowStatus()
	if not knowData.booksWritten[skillDef.name] then
		return
	end
	
	return true
end

local function DoUseLaptop(station, room, monk, workData, dt)
	if not CheckEligible(station, room, monk) then
		return true
	end
	
	local skillDef, progress = monk.GetSkill()
	return monk.AddSkillProgress(0.02*dt, true), skillDef.preferedTask
end

local function CheckWriteBook(station, room, monk)
	local skillDef, progress = monk.GetSkill()
	if not (skillDef and progress == 1) then
		return false
	end
	
	local knowData = GetWorld().GetOrModifyKnowStatus()
	if knowData.booksWritten[skillDef.name] then
		return false
	end
	
	return true
end

local function WriteBook(station, room, monk, workData, dt)
	if not CheckWriteBook(station, room, monk) then
		return true
	end
	local skillDef, progress = monk.GetSkill()
	local knowData = GetWorld().GetOrModifyKnowStatus()
	
	knowData.bookProgress[skillDef.name] = (knowData.bookProgress[skillDef.name] or 0) + (skillDef.transcribeMod or 1)*0.02*dt*monk.GetTaskMod("transcribe")
	
	if knowData.bookProgress[skillDef.name] >= 1 then
		knowData.bookProgress[skillDef.name] = 1
		knowData.booksWritten[skillDef.name] = true
		return true
	end
end

local data = {
	name = "library",
	humanName = "Library",
	buildDef = "library_build",
    desc = "Stores knowledge\nCost: 7 wood, 4 stone",
	image = "library_0.png",
	clickTaskFunc = function (x, y)
		if x < 2 then
			return "library_learn"
		end
		return "transcribe"
	end,
	drawOriginX = 0,
	drawOriginY = 2,
	width = 4,
	height = 3,
	demolishable = false,
	stations = {
		{
			pos = {1.27, 1.85},
			taskType = "transcribe",
			PerformAction = WriteBook,
			AvailibleFunc = CheckWriteBook,
			doors = {
                {
                    entryPath = {{1,4}}
                },
                {
                    entryPath = {{-1,2},{0,2},{1,2.4}}
                },
			},
		},
		{
			pos = {1.27, 1.85},
			taskType = "library_learn",
			PerformAction = DoUseLaptop,
			AvailibleFunc = CheckEligible,
			doors = {
                {
                    entryPath = {{1,4}}
                },
                {
                    entryPath = {{-1,2},{0,2},{1,2.4}}
                },
			},
		},
	}
}

return data

