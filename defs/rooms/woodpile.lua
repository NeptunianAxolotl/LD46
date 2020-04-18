
local function CollectAction(room, monk, workData, dt)

end

local data = {
	name = "woodpile",
	image = "woodPile.png",
	width = 2,
	height = 1,
	resources = {},
	stations = {
	}
}

for i = 1, #data.stations do
	local station = data.stations[i]
	for j = 1, #station.doors do
		local x, y = station.doors[j].pathFunc(0)
		station.doors[j].pos = {x, y}
	end
end

return data
