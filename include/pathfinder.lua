
local cMoves = {{1,0},{0,1},{-1,0},{0,-1}}
local dMoves = {{1,1},{-1,1},{-1,-1},{1,-1}}

local function Unskew(start,skewed,cdir,ddir)
    return {start[1] + skewed[1] * cdir[1] + skewed[2] * ddir[1], start[2] + skewed[1] * cdir[2] + skewed[2] * ddir[2]}
end

local function isCollision(position, roomList)
    return false
end

local function MoveLegal(position,direction,roomList)
    if direction[1] ~= 0 then
        if isCollision({position[1]+direction[1],position[2]},roomList) then return false end
        if direction[2] ~= 0 then
            if isCollision({position[1]+direction[1],position[2]+direction[2]},roomList) then return false end
        end
    end
    if direction[2] ~= 0 then
        if isCollision({position[1],position[2]+direction[2]},roomList) then return false end
    end
    return true
end

local function FindPath(start, goal, roomList)
    
    local reversepath = {}
    
    if UTIL.Dist(start[1],start[2],goal[1],goal[2]) > 0.9 then

        local moveangle = UTIL.Angle(goal[1]-start[1],goal[2]-start[2])
        -- cardinal directions: 1 = east, 2 = south, 3 = west, 4 = north
        local cdir = math.floor((moveangle + math.pi/4) / (math.pi/2)) + 1
        if cdir == 5 then cdir = 1 end
        -- diagonal directions: 1 = southeast, 2 = southwest, 3 = northwest, 4 = northeast
        local ddir = math.floor(moveangle / (math.pi/2)) + 1
        
        local cmove = cMoves[cdir]
        local dmove = dMoves[ddir]
        
        local xdist = math.abs(goal[1]-start[1])
        local ydist = math.abs(goal[2]-start[2])
        local ddist = math.min(xdist,ydist)
        local cdist = math.max(xdist,ydist) - ddist
        local cwindow = {0,cdist}
        local dwindow = {0,ddist}
        
        -- skewmatrix reorients and skews the space so that cmove is in the positive x-direction and dmove is in the positive y-direction
        -- so legal moves are in the directions 
        --  {0,-1}  {1,-1}  {2,-1}        
        --  {-1,0}  origin  {1,0}
        --  {-2,1}  {-1,1}  {0,1}
        -- with {1,0} and {0,1} tending to be in the direction of the goal.
        local skewmatrix = {}
        skewmatrix[0] = {}
        skewmatrix[0][0] = {dist=0,movetohere=nil}

        -- search the potentially ideal paths first
        local goalfound = false
        local stack = {{0,0}}
        while #stack > 0 do

            local currI = #stack;
            local currc = stack[#stack][1]
            local currd = stack[#stack][2]
            
            local cardLegal = false
            if currc < cdist then
                if not skewmatrix[currc+1] then skewmatrix[currc+1] = {} end
                if not skewmatrix[currc+1][currd] then
                    if MoveLegal(Unskew(start,stack[currI],cmove,dmove),cmove,roomList) then
                        cardLegal = true
                        skewmatrix[currc+1][currd] = {dist=skewmatrix[currc][currd].dist+1,movetohere={1,0}}
                        if currc+1 == cdist and currd == ddist then goalfound = true end
                    else
                        skewmatrix[currc+1][currd] = {dist=1000000,movetohere=nil}
                    end
                end
            end
            
            local diagLegal = false
            if currd < ddist then
                if MoveLegal(Unskew(start,stack[currI],cmove,dmove),dmove,roomList) then
                    diagLegal = true
                    skewmatrix[currc][currd+1] = {dist=skewmatrix[currc][currd].dist+math.sqrt(2),movetohere={0,1}}
                    if currc == cdist and currd+1 == ddist then goalfound = true end
                else
                    skewmatrix[currc][currd+1] = {dist=1000000,movetohere=nil}
                end
            end
            
            if goalfound then
                stack = {}
            else
                -- try to stick the worse move on the stack first
                if (cdist - stack[currI][1] > ddist - stack[currI][2]) then
                    if diagLegal then stack[#stack+1] = UTIL.Add(stack[currI],{0,1}) end
                    if cardLegal then stack[#stack+1] = UTIL.Add(stack[currI],{1,0}) end
                else    
                    if diagLegal then stack[#stack+1] = UTIL.Add(stack[currI],{0,1}) end
                    if cardLegal then stack[#stack+1] = UTIL.Add(stack[currI],{1,0}) end
                end
            end
        end
        
        if goalfound then
            currskew = {cdist,ddist}
            mth = skewmatrix[currskew[1]][currskew[2]].movetohere
            while mth do
                reversepath[#reversepath+1] = {Unskew(start,currskew,cmove,dmove),(mth[1] == -2 or mth[1] == 0 or mth[1] == 2)}
                currskew[1] = currskew[1] - mth[1]
                currskew[2] = currskew[2] - mth[2]
                mth = skewmatrix[currskew[1]][currskew[2]].movetohere
            end
        else
            print('No path found!')
        end
    end
    
    -- local current = {start[1],start[2]}
    -- while UTIL.Dist(current[1],current[2],goal[1],goal[2]) > 0.9 and #path < 200 do
        -- local xdist = math.abs(current[1]-goal[1])
        -- local ydist = math.abs(current[2]-goal[2])
        -- -- do we want to move in the cardinal or diagonal direction
        -- local cardDominant = math.max(xdist,ydist) > 2*math.min(xdist,ydist)
        -- if cardDominant then
            -- current = UTIL.Add(current, cMoves[cdir]);
            -- path[#path+1] = {current,false}
        -- else
            -- current = UTIL.Add(current, dMoves[ddir]);
            -- path[#path+1] = {current,true}
        -- end
    -- end
    
	local popCount = #reversepath+1
	local externalFuncs = {}
	
	function externalFuncs.GetNextNode()
        popCount = popCount - 1
        if popCount > 0 then
            return reversepath[popCount][1],reversepath[popCount][2]
        end
		return false, false
	end
    
	
	return externalFuncs
end

return FindPath
