--IterableMap = require("include/IterableMap")

local externalFunc = {}

local sounds = IterableMap.New()

function externalFunc.load ()
end

local volMult = {
    background = 0.1,
    chapel = 0.2,
}

function addSource(name, id)
    if name == "background" then
        return love.audio.newSource("sounds/music/background_voiced.wav", "static")
    elseif name == "chapel" then
        return love.audio.newSource("sounds/music/chapel.wav", "static")
    end
end

function externalFunc.playSound(name, id, noLoop, fadeRate, delay, silent)
    local soundData = sounds.Get(id)
    if not soundData then
        soundData = {
            name = name,
            want = silent and 0 or 1,
            have = 0,
            source = addSource(name, id),
            fadeRate = fadeRate,
            delay = delay,
        }
        soundData.source:setLooping(not noLoop)
        sounds.Add(id, soundData)
    end

    soundData.want = 1
    soundData.delay = delay
    if not soundData.delay then
        love.audio.play(soundData.source)
    end
end

function externalFunc.Update(dt)
    for _, soundData in sounds.Iterator() do
        if soundData.delay then
            soundData.delay = soundData.delay - dt
            if soundData.delay < 0 then
                soundData.delay = false
                if soundData.want > 0 then
                    love.audio.play(soundData.source)
                end
            end
        else
            if soundData.want > soundData.have then
                soundData.have = soundData.have + (soundData.fadeRate or 10)*dt
                if soundData.have > soundData.want then
                    soundData.have = soundData.want
                end
                soundData.source:setVolume(soundData.have*volMult[soundData.name])
            end

            if soundData.want < soundData.have then
                soundData.have = soundData.have - (soundData.fadeRate or 10)*dt
                if soundData.have < soundData.want then
                    soundData.have = soundData.want
                end
                soundData.source:setVolume(soundData.have*volMult[soundData.name])
            end
        end
    end
end

function externalFunc.stopSound(id, death)
    local soundData = sounds.Get(id)
    if not soundData then
        return
    end
    soundData.want = 0
    if death then
        soundData.source:stop()
    end
end

function externalFunc.reset()
    for _, soundData in sounds.Iterator() do
        soundData.source:stop()
    end
    sounds = IterableMap.New()
end

return externalFunc
