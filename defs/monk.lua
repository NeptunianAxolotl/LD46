

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
        walk_N = {file="monk/monk_stand_n.png",width=640,duration=100},
        walk_S = {file="monk/monk_stand_s.png",width=640,duration=100},
        walk_E = {file="monk/monk_stand_e.png",width=640,duration=100},
        walk_W = {file="monk/monk_stand_w.png",width=640,duration=100},
        walk_NE = {file="monk/monk_stand_ne.png",width=640,duration=100},
        walk_NW = {file="monk/monk_stand_nw.png",width=640,duration=100},
        walk_SE = {file="monk/monk_walk_se.png",width=640,duration=0.7},
        walk_SW = {file="monk/monk_walk_sw.png",width=640,duration=0.7},
        
        -- chopping animations
        chop_E = {file="monk/monk_chop_e.png",width=640,duration=0.7},
    },
	drawOriginX = 0.13,
	drawOriginY = 1.25,
}

return data
