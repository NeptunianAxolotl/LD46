audioSystem = require("audio")

local currentMusicPlaying = nil

local function InitialiseMusic()
    audioSystem.playSound("background", "background", false, 3, 0, true)
    audioSystem.stopSound("background")
    audioSystem.playSound("chapel", "chapel", false, 3, 0, true)
    audioSystem.stopSound("chapel")
    audioSystem.playSound("laptophymn", "laptophymn", false, 3, 0,  true)
    audioSystem.stopSound("laptophymn")
end

local function CheckMusicChange(desiredMusic) 
    if currentMusicPlaying ~= desiredMusic then
        audioSystem.stopSound("background")
        audioSystem.stopSound("chapel")
        audioSystem.stopSound("laptophymn")
    
        currentMusicPlaying = desiredMusic
        if desiredMusic then
            audioSystem.playSound(desiredMusic, desiredMusic, false, 3)
        end
    end
end 

return {
    InitialiseMusic = InitialiseMusic,
    CheckMusicChange = CheckMusicChange,
}