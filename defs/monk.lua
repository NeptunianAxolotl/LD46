

local data = {
	name = "monk",
	image = "guy.png",
    defaultImage = "monk/monk_stand_se.png",
    images = {
        -- standing animations
        stand_N = {file="monk/monk_stand_n.png",width=640,duration=100},
        stand_S = {file="monk/monk_stand_s.png",width=640,duration=100},
        stand_E = {file="monk/monk_stand_e.png",width=640,duration=100},
        stand_W = {file="monk/monk_stand_w.png",width=640,duration=100},
        stand_NE = {file="monk/monk_stand_ne.png",width=640,duration=100},
        stand_NW = {file="monk/monk_stand_nw.png",width=640,duration=100},
        stand_SE = {file="monk/monk_stand_se.png",width=640,duration=100},
        stand_SW = {file="monk/monk_stand_sw.png",width=640,duration=100},
        
        -- walking animations
        walk_N = {file="monk/monk_walk_n.png",width=640,duration=0.4},
        walk_S = {file="monk/monk_walk_s.png",width=640,duration=0.4},
        walk_E = {file="monk/monk_walk_e.png",width=640,duration=0.4},
        walk_W = {file="monk/monk_walk_w.png",width=640,duration=0.4},
        walk_NE = {file="monk/monk_walk_ne.png",width=640,duration=0.4},
        walk_NW = {file="monk/monk_walk_nw.png",width=640,duration=0.4},
        walk_SE = {file="monk/monk_walk_se.png",width=640,duration=0.4},
        walk_SW = {file="monk/monk_walk_sw.png",width=640,duration=0.4},
        
        -- chopping animations
        chop_E = {file="monk/monk_chop_e.png",width=640,duration=0.7},
        
        -- cooking animations 
        cook_NE = {file="monk/monk_cook_ne.png",width=640,duration=0.7},
        cook_NW = {file="monk/monk_cook_nw.png",width=640,duration=0.7},
        
        -- make grain animations
        grain_NE = {file="monk/monk_make_grain_ne.png",width=640,duration=0.7},
        
        -- sleep animations
        sleep_NE = {file="monk/monk_sleep_ne.png",width=640,yoffset = GLOBAL.TILE_SIZE * 0.5,duration=0.7},
        sleep_NW = {file="monk/monk_sleep_nw.png",width=640,yoffset = GLOBAL.TILE_SIZE * 0.5,duration=0.7},
        
        -- bake animations
        bake_NW = {file="monk/monk_bake_nw.png",width=640,duration=0.7},
        
        -- bike animation
        bike_NE = {file="monk/monk_bike_ne.png",width=640,duration=0.7},
        
        -- brew animations
        brew_NE = {file="monk/monk_brew_ne.png",width=640,duration=0.7},
        brew_NW = {file="monk/monk_brew_nw.png",width=640,duration=0.7},
        
        -- comp animations
        comp_NW = {file="monk/monk_comp_nw.png",width=640,duration=0.7},
        
        -- eating animations
        eat_SE = {file="monk/monk_eating_se.png",width=640,duration=0.7},
        
        -- stone animations
        stone_E = {file="monk/monk_stone_e.png",width=640,duration=0.7},
    },
	drawOriginX = 0,
	drawOriginY = 1.05,
}

local standlookup = {data.images.stand_NE,data.images.stand_E,data.images.stand_SE,data.images.stand_S,data.images.stand_SW,data.images.stand_W,data.images.stand_NW,data.images.stand_N}
local walklookup = {data.images.walk_NE,data.images.walk_E,data.images.walk_SE,data.images.walk_S,data.images.walk_SW,data.images.walk_W,data.images.walk_NW,data.images.walk_N}
local cooklookup = {data.images.cook_NE,nil,nil,nil,nil,nil,data.images.cook_NW,nil}
local sleeplookup = {data.images.sleep_NE,nil,nil,nil,nil,nil,data.images.sleep_NW,nil}
local brewlookup = {data.images.brew_NE,nil,nil,nil,nil,nil,data.images.brew_NW,nil}
local eatlookup = {nil,nil,data.images.eat_SE,nil,nil,nil,nil,nil}

function data.GetStandAnim(direction)
	return standlookup[direction]
end

function data.GetWalkAnim(direction)
	return walklookup[direction]
end

function data.GetChopAnim(direction)
    return data.images.chop_E
end

function data.GetMakeGrainAnim(direction)
    return data.images.grain_NE
end

function data.GetBakeAnim(direction)
    return data.images.bake_NW
end

function data.GetBikeAnim(direction)
    return data.images.bike_NE
end

function data.GetCompAnim(direction)
    return data.images.comp_NW
end

function data.GetStoneAnim(direction)
    return data.images.stone_E
end

function data.GetBrewAnim(direction)
    return brewlookup[direction] or standlookup[direction]
end

function data.GetSleepAnim(direction)
    return sleeplookup[direction] or standlookup[direction]
end

function data.GetCookAnim(direction)
    return cooklookup[direction] or standlookup[direction]
end

function data.GetEatAnim(direction)
    return eatlookup[direction] or standlookup[direction]
end

return data
