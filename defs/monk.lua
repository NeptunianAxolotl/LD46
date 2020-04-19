

local data = {
	name = "monk",
	image = "guy.png",
    defaultImage = "monk/Monk S.png",
    images = {
        -- standing animations
        stand_N = {file="monk/Monk N.png",width=640,duration=100},
        stand_S = {file="monk/Monk S.png",width=640,duration=100},
        stand_E = {file="monk/Monk E.png",width=640,duration=100},
        stand_W = {file="monk/Monk W.png",width=640,duration=100},
        stand_NE = {file="monk/Monk NE.png",width=640,duration=100},
        stand_NW = {file="monk/Monk NW.png",width=640,duration=100},
        stand_SE = {file="monk/Monk SE.png",width=640,duration=100},
        stand_SW = {file="monk/Monk SW.png",width=640,duration=100},
        
        -- walking animations
        walk_N = {file="monk/Monk N.png",width=640,duration=100},
        walk_S = {file="monk/Monk S.png",width=640,duration=100},
        walk_E = {file="monk/Monk E.png",width=640,duration=100},
        walk_W = {file="monk/Monk W.png",width=640,duration=100},
        walk_NE = {file="monk/Monk NE.png",width=640,duration=100},
        walk_NW = {file="monk/Monk NW.png",width=640,duration=100},
        walk_SE = {file="monk/Monk SE walk.png",width=640,duration=0.7},
        walk_SW = {file="monk/Monk SW.png",width=640,duration=100},
        
        -- chopping animations
        chop_E = {file="monk/Monk E chop.png",width=640,duration=0.7},
    },
	drawOriginX = 0.13,
	drawOriginY = 1.25,
}

return data
