
local function New(init)
	--------------------------------------------------
	-- Initialization
	--------------------------------------------------
	local defName = init.defName
	local pos     = init.pos
	local def     = DEFS.featureDefNames[defName]
	
	init = nil
	
	local externalFuncs = {}
	
	--------------------------------------------------
	-- Locals
	--------------------------------------------------
	local wantDestruction = false
	local hidden = false

	local updateData = def.InitFunc and def.InitFunc()

	--------------------------------------------------
	-- Interface
	--------------------------------------------------

	function externalFuncs.GetPos()
		return pos
	end

	function externalFuncs.GetPos()
		return pos
	end
	
	function externalFuncs.Destroy(hideImmediately)
		wantDestruction = true
		if hideImmediately then
			hidden = true
		end
	end
	
	--------------------------------------------------
	-- Drawing and Updates
	--------------------------------------------------
	
	function externalFuncs.UpdateFeature(dt)
		if wantDestruction then
			return true -- Remove from featureList
		end
		if def.UpdateFunc then
			return def.UpdateFunc(externalFuncs, updateData, dt)
		end
	end
	
	function externalFuncs.Draw(interface)
		if hidden then
			return
		end

		local x, y = interface.WorldToScreen(pos[1], pos[2], def.drawOriginX, def.drawOriginY)
		love.graphics.draw(def.image, x, y, 0, 1, 1, 0, 0, 0, 0)
		
		if def.DrawFunc then
			def.DrawFunc(externalFuncs, x, y)
		end
	end
	
	--------------------------------------------------
	-- Finish Initialization
	--------------------------------------------------
	
	return externalFuncs
end

return New
