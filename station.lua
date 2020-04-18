
local function New(def, parent, stationsByUse)
	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	local pos     = UTIL.Add(def.pos, parent.GetPos())


	init = nil
	--------------------------------------------------
	-- Locals
	--------------------------------------------------


	--------------------------------------------------
	-- Interface
	--------------------------------------------------
	local externalFuncs = {}

	function externalFuncs.Distance(x, y)
		return math.abs(x - pos[1]) +  math.abs(y - pos[2])
	end
	
	--------------------------------------------------
	-- Finish Initialization
	--------------------------------------------------
	stationsByUse[def.typeName].Add(externalFuncs)
	
	return externalFuncs
end

return New
