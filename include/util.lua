--------------------------------------------------
-- Vector funcs
--------------------------------------------------

local function AbsVal(x, y)
	return math.sqrt(x*x + y*y)
end

local function Dist(x1, y1, x2, y2)
	return AbsVal(x1 - x2, y1 - y2)
end

local function intersection (x1, y1, x2, y2, x3, y3, x4, y4)
  local d = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
  local a = x1 * y2 - y1 * x2
  local b = x3 * y4 - y3 * x4
  local x = (a * (x3 - x4) - (x1 - x2) * b) / d
  local y = (a * (y3 - y4) - (y1 - y2) * b) / d
  return x, y
end

local function getAngles(self, sourceX, sourceY)
    local angles = {}
    
    for i = 1, #self / 2 do
        angles[#angles + 1] = math.atan2(sourceY - self[2 * i], sourceX - self[(2 * i) - 1])
    end
    
    return angles
end

local function RotateVector(x, y, angle)
	return x*math.cos(angle) - y*math.sin(angle), x*math.sin(angle) + y*math.cos(angle)
end

local function Angle(x, z)
	if x == 0 and z == 0 then
		return 0
	end
	local mult = 1/AbsVal(x, z)
	x, z = x*mult, z*mult
	if z > 0 then
		return math.acos(x)
	elseif z < 0 then
		return 2*math.pi - math.acos(x)
	elseif x < 0 then
		return math.pi
	end
	-- x < 0
	return 0
end

local function ToCart(dir, rad)
	return rad*math.cos(dir), rad*math.sin(dir)
end

local function Add(v1, v2)
	return {v1[1] + v2[1], v1[2] + v2[2]}
end

local function IntersectingRectangles(x1, y1, w1, h1, x2, y2, w2, h2)
	return ((x1 + w1 >= x2 and x1 <= x2) or (x2 + w2 >= x1 and x2 <= x1)) and ((y1 + h1 >= y2 and y1 <= y2) or (y2 + h2 >= y1 and y2 <= y1))
end

local function PosInRectangle(x1, y1, w1, h1, x2, y2)
	return (x1 + w1 > x2 and x1 <= x2) and (y1 + h1 > y2 and y1 <= y2)
end

local function DirectionToCardinal(direction)
	return math.floor((direction + math.pi/8) / (math.pi/4)) % 8 + 1
end

--------------------------------------------------
--------------------------------------------------

return {
	Add = Add,
	AbsVal = AbsVal,
	Dist = Dist,
	RotateVector = RotateVector,
	Angle = Angle,
	ToCart = ToCart,
	IntersectingRectangles = IntersectingRectangles,
	PosInRectangle = PosInRectangle,
	DirectionToCardinal = DirectionToCardinal,
}
