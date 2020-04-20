

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
        walk_N = {file="monk/monk_stand_n.png",width=640,duration=0.7},
        walk_S = {file="monk/monk_stand_s.png",width=640,duration=0.7},
        walk_E = {file="monk/monk_walk_e.png",width=640,duration=0.7},
        walk_W = {file="monk/monk_walk_w.png",width=640,duration=0.7},
        walk_NE = {file="monk/monk_walk_ne.png",width=640,duration=0.7},
        walk_NW = {file="monk/monk_walk_nw.png",width=640,duration=0.7},
        walk_SE = {file="monk/monk_walk_se.png",width=640,duration=0.7},
        walk_SW = {file="monk/monk_walk_sw.png",width=640,duration=0.7},
        
        -- chopping animations
        chop_E = {file="monk/monk_chop_e.png",width=640,duration=0.7},
    },
	drawOriginX = 0.13,
	drawOriginY = 1.25,
}

local standlookup = {data.images.stand_NE,data.images.stand_E,data.images.stand_SE,data.images.stand_S,data.images.stand_SW,data.images.stand_W,data.images.stand_NW,data.images.stand_N}
local walklookup = {data.images.walk_NE,data.images.walk_E,data.images.walk_SE,data.images.walk_S,data.images.walk_SW,data.images.walk_W,data.images.walk_NW,data.images.walk_N}

function data.GetStandAnim(direction)
	return standlookup[direction]
end

function data.GetWalkAnim(direction)
	return walklookup[direction]
end

return data
