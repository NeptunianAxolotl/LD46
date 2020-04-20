audioSystem = require("audio")

local currentMusicPlaying = nil

local function InitialiseMusic()
    currentMusicPlaying = nil
    audioSystem.playSound("background", "background", false, 3, 0, true)
    audioSystem.stopSound("background")
end

local function CheckMusicChange(desiredMusic) 
    if currentMusicPlaying ~= desiredMusic then
        audioSystem.stopSound("background")
    
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