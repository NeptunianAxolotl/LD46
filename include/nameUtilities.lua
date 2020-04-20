local function GetRandomUniqueName(usedNames)
	local nameCount = #DEFS.nameList
	
	for i = 1, 100 do
		local index = math.floor(math.random()*nameCount) + 1
		if index and DEFS.nameList[index] and not usedNames[index] then
			usedNames[index] = true
			return DEFS.nameList[index]
		end
	end
	return "John Smith"
end

return {
	GetRandomUniqueName = GetRandomUniqueName,
}
