
local function DoUpkeepLaptop(station, room, monk, workData, dt)

end


local function CheckEligible(station, room, monk, workData, dt)
	local skillDef, rank, progress, desiredChange  = monk.GetSkill()
	if (not (skillDef or desiredChange)) or (rank >= 2) then
		return false
	end
	
	-- Check peripherals
	return true
end

local function DoUseLaptop(station, room, monk, workData, dt)
	if not CheckEligible(station, room, monk, workData, dt) then
		return true
	end
	
	return monk.AddSkillProgress(0.05*dt, true)
end

local data = {
	name = "laptop",
	image = "laptoproom.png",
	clickTaskFunc = function (x, y)
		if y < 1.8 then
			return "upkeep_laptop"
		end
		return "use_laptop"
	end,
	width = 3,
	height = 4,
    drawOriginX = 0,
	drawOriginY = 1.5,
	stations = {
		{
			pos = {1.5, 0.3},
			taskType = "upkeep_laptop",
			PerformAction = DoUpkeepLaptop,
			doors = {
                {
                    entryPath = {{1,-1}, {1, 0.3}}
                },
                {
                    entryPath = {{-1,0}, {1, 0.3}}
                },
			},
		},
		{
			pos = {1, 2},
			taskType = "use_laptop",
			PerformAction = DoUseLaptop,
			AvailibleFunc = CheckEligible,
			doors = {
                {
                    entryPath = {{1,4}}
                },
			},
		},
	}
}

return data
