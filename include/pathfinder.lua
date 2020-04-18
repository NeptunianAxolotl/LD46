
local cMoves = {{1,0},{0,1},{-1,0},{0,-1}}
local dMoves = {{1,1},{-1,1},{-1,-1},{1,-1}}

local function FindPath(start, goal, roomList)
    
    local path = {}
    
    local moveangle = UTIL.Angle(goal[1]-start[1],goal[2]-start[2])
    -- cardinal directions: 1 = east, 2 = south, 3 = west, 4 = north
    local cdir = math.floor((moveangle + math.pi/4) / (math.pi/2)) + 1
    -- diagonal directions: 1 = southeast, 2 = southwest, 3 = northwest, 4 = northeast
    local ddir = math.floor(moveangle / (math.pi/2)) + 1
    
    local current = {start[1],start[2]}
    
    while UTIL.Dist(current[1],current[2],goal[1],goal[2]) > 0.9 and #path < 200 do
        local xdist = math.abs(current[1]-goal[1])
        local ydist = math.abs(current[2]-goal[2])
        -- do we want to move in the cardinal or diagonal direction
        local cardDominant = math.max(xdist,ydist) > 2*math.min(xdist,ydist)
        if cardDominant then
            current = UTIL.Add(current, cMoves[cdir]);
            path[#path+1] = {current,false}
        else
            current = UTIL.Add(current, dMoves[ddir]);
            path[#path+1] = {current,true}
        end
    end
    
	local popCount = 0
	local externalFuncs = {}
	
	function externalFuncs.GetNextNode()
        if popCount < #path then
            popCount = popCount + 1
            return path[popCount][1],path[popCount][2]
        end
		return false, false
	end
    
	
	return externalFuncs
end

return FindPath
