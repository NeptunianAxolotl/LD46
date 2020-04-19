-- Priority queue copied from https://github.com/ZeroK-RTS/Zero-K/blob/97ecdcf78464bdcf21385d454f99321b9e42168d/LuaRules/Gadgets/astar.lua
-- by Quantum, GPL v2 or later 
local function NewPriorityQueue()
  local heap = {} -- binary heap
  local priorities = {}
  local heapCount = 0

  function heap.Insert(currentKey, currentPriority, currentPosition)
    if not currentPosition then -- we are inserting a new item, as opposed to changing the f value of an item already in the heap
      currentPosition = heapCount + 1
      heapCount = heapCount + 1
    end
    priorities[currentKey] = currentPriority
    heap[currentPosition] = currentKey
    while true do
      local parentPosition = math.floor(currentPosition/2)
      if parentPosition == 1 then
        break
      end
      local parentKey = heap[parentPosition]
      if parentKey and priorities[parentKey] > currentPriority then -- swap parent and current node
        heap[parentPosition] = currentKey
        heap[currentPosition] = parentKey
        currentPosition = parentPosition
      else
        break
      end
    end
  end

  function heap.UpdateNode(currentKey, currentPriority)
    for position=1, heapCount do
      local id = heap[position]
      if id == currentKey then
        heap.Insert(currentKey, currentPriority, position)
        break
      end
    end
  end
  
  function heap.Pop()
    local ret = heap[1]
    if not ret then
      error "queue is empty"
    end
    heap[1] = heap[heapCount]
    heap[heapCount] = nil
    heapCount = heapCount - 1
    local currentPosition = 1
    while true do
      local currentKey = heap[currentPosition]
      local currentPriority = priorities[currentKey]
      local child1Position = currentPosition*2
      local child1Key = heap[child1Position]
      if not child1Key then
        break
      end
      local child2Position = currentPosition*2 + 1
      local child2Key = heap[child2Position]
      if not child2Key then
        break
      end
      local child1F = priorities[child1Key]
      local child2F = priorities[child2Key]
      if currentPriority < child1F and currentPriority < child2F then
        break
      elseif child1F < child2F then
        heap[child1Position] = currentKey
        heap[currentPosition] = child1Key
        currentPosition = child1Position
      else
        heap[child2Position] = currentKey
        heap[currentPosition] = child2Key
        currentPosition = child2Position
      end
    end
    return ret, priorities[ret]
  end
  return heap
end

local cMoves = {{1,0},{0,1},{-1,0},{0,-1}}
local dMoves = {{1,1},{-1,1},{-1,-1},{1,-1}}
local allSkewMoves = {{1,0},{0,1},{2,-1},{-1,1},{1,-1},{-2,1},{0,-1},{-1,0}}
local MAXITERCOUNT = 9000

local function distanceEstimate(v1,v2)
    local x = math.abs(v1[1]-v2[1])
    local y = math.abs(v1[2]-v2[2])
    return math.min(x,y) * (math.sqrt(2)) + (math.max(x,y) - math.min(x,y))
end

local function Unskew(start,skewed,cdir,ddir)
    return {start[1] + skewed[1] * cdir[1] + skewed[2] * ddir[1], start[2] + skewed[1] * cdir[2] + skewed[2] * ddir[2]}
end

local function isCollision(position, roomList)
    for _, room in roomList.Iterator() do
        local rpos, w, h = room.GetPosAndSize()
        if (position[1] >= rpos[1] and position[2] >= rpos[2] and position[1] < rpos[1] + w and position[2] < rpos[2] + h) then 
            return true 
        end
    end
    return false
end

-- first return: legal from this direction
-- second return: could possibly be legal ever
local function MoveLegal(position,direction,roomList)
    --print('MoveLegal called for position ' .. position[1] .. ';' .. position[2] .. ' and direction ' .. direction[1] .. ';' .. direction[2])
    if direction[1] == 0 and direction[2] ~= 0 then
        if isCollision({position[1],position[2]+direction[2]},roomList) then 
            return false, false
        end
    end
    if direction[2] == 0 and direction[1] ~= 0 then
        if isCollision({position[1]+direction[1],position[2]},roomList) then 
            return false, false
        end
    end
    if direction[1] ~= 0 and direction[2] ~= 0 then
        if isCollision({position[1]+direction[1],position[2]+direction[2]},roomList) then 
            return false, false
        end
        if isCollision({position[1],position[2]+direction[2]},roomList) then 
            return false, true
        end
        if isCollision({position[1]+direction[1],position[2]},roomList) then 
            return false, true
        end
    end
    --print('Returned true')
    return true, true
end

local function FindPath(start, goal, roomList)
    start = {math.floor(start[1] + 0.5), math.floor(start[2] + 0.5)}
    goal = {math.floor(goal[1] + 0.5), math.floor(goal[2] + 0.5)}
    --print('Start FindPath')
    --print('------------------------------------------------------')
    
    local reversepath = {}
    
    if isCollision(goal,roomList) then
        print('WARNING: Pathfinder target is inside an obstacle at ' .. goal[1] .. ';' .. goal[2])
    elseif UTIL.Dist(start[1],start[2],goal[1],goal[2]) > 0.9 then

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
        local openHeap = NewPriorityQueue()
        local idToSkew = {}
        
        local skewmatrix = {}
        skewmatrix[0] = {}
        skewmatrix[0][0] = {dist=0,movetohere=nil,heapid=#idToSkew}
        
        local goalfound = false
        local basicsearch = true

        local stack = {{0,0}}
        --idToSkew[#idToSkew+1] = {0,0}
        --openHeap.Insert(#idToSkew, distanceEstimate(start,goal))
        --local stack = {}
        local itercount = 0
        
        while (itercount < MAXITERCOUNT) and not goalfound and (#stack > 0 or openHeap[1]) do
            
            itercount = itercount + 1
            local currc = 0
            local currd = 0
            if basicsearch and #stack > 0 then
                currc = stack[#stack][1]
                currd = stack[#stack][2]
                stack[#stack] = nil
            else
                basicsearch = false
                local currentNode = openHeap.Pop()
                currc = idToSkew[currentNode][1]
                currd = idToSkew[currentNode][2]
            end
            
            local realpos = Unskew(start,{currc,currd},cmove,dmove)
            -- print('Searching from: ' .. realpos[1] .. ';' .. realpos[2])
            -- print('Current state of basic stack:')
            -- for m = 1, #stack do
                -- print(stack[m][1] .. ';' .. stack[m][2])
            -- end
            
            -- check moving in positive cardinal direction (c)
            local cardBasicLegal = false
            
            if not skewmatrix[currc+1] then skewmatrix[currc+1] = {} end
            if (not skewmatrix[currc+1][currd]) or (skewmatrix[currc+1][currd].dist < math.huge and skewmatrix[currc+1][currd].dist > skewmatrix[currc][currd].dist+1) then
                -- if we haven't explored this square, or our previous exploration shows it might be free BUT our previous path was worse than we would be now
                local nowLegal, everLegal = MoveLegal(Unskew(start,{currc,currd},cmove,dmove),cmove,roomList)
                if everLegal then
                    if nowLegal then
                        if basicsearch and currc < cdist then 
                            cardBasicLegal = true -- add to our stack now, it can't be bad
                            skewmatrix[currc+1][currd] = {dist=skewmatrix[currc][currd].dist+1,movetohere={1,0},heapid=nil}
                        else
                            local tentativeDistance = skewmatrix[currc][currd].dist + 1 + distanceEstimate(Unskew(start,{currc+1,currd},cmove,dmove),goal)
                            if not skewmatrix[currc+1][currd] then
                                idToSkew[#idToSkew+1] = {currc+1,currd}
                                openHeap.Insert(#idToSkew, tentativeDistance)
                                skewmatrix[currc+1][currd] = {dist=skewmatrix[currc][currd].dist+1,movetohere={1,0},heapid=#idToSkew}
                            elseif tentativeDistance < skewmatrix[currc+1][currd].dist then
                                openHeap.UpdateNode(skewmatrix[currc+1][currd].heapid, tentativeDistance)
                                skewmatrix[currc+1][currd].dist = skewmatrix[currc][currd].dist+1
                                skewmatrix[currc+1][currd].movetohere = {1,0}
                            end
                        end
                        if currc+1 == cdist and currd == ddist then goalfound = true end
                    end
                else
                    -- this square is blocked and will never be legal
                    skewmatrix[currc+1][currd] = {dist=math.huge,movetohere=nil,heapid=nil}
                end
            end
            
            -- check moving in positive diagonal direction (d)
            local diagBasicLegal = false
            if (not skewmatrix[currc][currd+1]) or (skewmatrix[currc][currd+1].dist < math.huge and skewmatrix[currc][currd+1].dist > skewmatrix[currc][currd].dist+math.sqrt(2)) then
                -- if we haven't explored this square, or our previous exploration shows it might be free BUT our previous path was worse than we would be now
                local nowLegal, everLegal = MoveLegal(Unskew(start,{currc,currd},cmove,dmove),dmove,roomList)
                if everLegal then
                    if nowLegal then
                        if basicsearch and currd < ddist then
                            diagBasicLegal = true -- add to our stack now, it can't be bad
                            skewmatrix[currc][currd+1] = {dist=skewmatrix[currc][currd].dist+math.sqrt(2),movetohere={0,1},heapid=nil}
                        else
                            local tentativeDistance = skewmatrix[currc][currd].dist + math.sqrt(2) + distanceEstimate(Unskew(start,{currc,currd+1},cmove,dmove),goal)
                            if not skewmatrix[currc][currd+1] then
                                idToSkew[#idToSkew+1] = {currc,currd+1}
                                openHeap.Insert(#idToSkew, tentativeDistance)
                                skewmatrix[currc][currd+1] = {dist=skewmatrix[currc][currd].dist+math.sqrt(2),movetohere={0,1},heapid=#idToSkew}
                            elseif tentativeDistance < skewmatrix[currc+1][currd].dist then
                                openHeap.UpdateNode(skewmatrix[currc][currd+1].heapid, tentativeDistance)
                                skewmatrix[currc][currd+1].dist = skewmatrix[currc][currd].dist+math.sqrt(2)
                                skewmatrix[currc][currd+1].movetohere = {0,1}
                            end
                        end
                        if currc == cdist and currd+1 == ddist then goalfound = true end
                    end
                else
                    -- this square is blocked and will never be legal
                    skewmatrix[currc][currd+1] = {dist=math.huge,movetohere=nil,heapid=nil}
                end
            end
            
            -- populate skewmatrix in other directions for a*-like search
            for i = 3, #allSkewMoves do
                local newc = currc+allSkewMoves[i][1]
                if not skewmatrix[newc] then skewmatrix[newc] = {} end
                local newd = currd+allSkewMoves[i][2]
                local moredist = (allSkewMoves[i][1] == 2 or allSkewMoves[i][1] == 0 or allSkewMoves[i][1] == -2) and math.sqrt(2) or 1
                if not skewmatrix[newc][newd] or (skewmatrix[newc][newd].dist < math.huge and skewmatrix[newc][newd].dist > skewmatrix[currc][currd].dist + moredist) then
                    -- if we haven't explored this square, or our previous exploration shows it might be free BUT our previous path was worse than we would be now
                    local nowLegal, everLegal = MoveLegal(Unskew(start,{currc,currd},cmove,dmove),Unskew({0,0},allSkewMoves[i],cmove,dmove),roomList)
                    if everLegal then
                        if nowLegal then
                            local tentativeDistance = skewmatrix[currc][currd].dist + moredist + distanceEstimate(Unskew(start,{newc,newd},cmove,dmove),goal)
                            if not skewmatrix[newc][newd] then
                                idToSkew[#idToSkew+1] = {newc,newd}
                                openHeap.Insert(#idToSkew, tentativeDistance)
                                skewmatrix[newc][newd] = {dist=skewmatrix[currc][currd].dist+moredist,movetohere=allSkewMoves[i],heapid=#idToSkew}
                            elseif tentativeDistance < skewmatrix[newc][newd].dist then
                                openHeap.UpdateNode(skewmatrix[newc][newd].heapid, tentativeDistance)
                                skewmatrix[newc][newd].dist = skewmatrix[currc][currd].dist+math.sqrt(2)
                                skewmatrix[newc][newd].movetohere = allSkewMoves[i]
                            end
                            if newc == cdist and newd == ddist then goalfound = true end
                        end
                    else
                        -- this square is blocked and will never be legal
                        skewmatrix[newc][newd] = {dist=math.huge,movetohere=nil,heapid=nil}
                    end
                end
            end
            
            --print(cardBasicLegal)
            --print(diagBasicLegal)
            
            if goalfound then
                stack = {}
                openHeap = {}
            else
                -- try to stick the less flexible move on the stack first so we check it later
                if (cdist - currc > ddist - currd) then
                    if diagBasicLegal then stack[#stack+1] = UTIL.Add({currc,currd},{0,1}) end
                    if cardBasicLegal then stack[#stack+1] = UTIL.Add({currc,currd},{1,0}) end
                else    
                    if diagBasicLegal then stack[#stack+1] = UTIL.Add({currc,currd},{0,1}) end
                    if cardBasicLegal then stack[#stack+1] = UTIL.Add({currc,currd},{1,0}) end
                end
            end
        end
        
        if itercount >= MAXITERCOUNT then
            print('WARNING: Pathfinder exceeded maximum search depth!')
        end
        
        if goalfound then
            local currskew = {cdist,ddist}
            local mth = skewmatrix[currskew[1]][currskew[2]].movetohere
            while mth do
                reversepath[#reversepath+1] = {Unskew(start,currskew,cmove,dmove),(mth[1] == -2 or mth[1] == 0 or mth[1] == 2)}
                currskew[1] = currskew[1] - mth[1]
                currskew[2] = currskew[2] - mth[2]
                mth = skewmatrix[currskew[1]][currskew[2]].movetohere
            end
        else
            print('WARNING: No path found!')
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
