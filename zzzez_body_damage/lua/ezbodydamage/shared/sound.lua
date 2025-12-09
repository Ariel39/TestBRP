if CLIENT then
    easzy.bodydamage.sounds = easzy.bodydamage.sounds or {}

    local function PlaySound(soundPath)
        local localPlayer = LocalPlayer()
        local soundPatch = CreateSound(localPlayer, soundPath)
        soundPatch:Play()
        easzy.bodydamage.sounds[soundPath] = soundPatch
    end

    local function StopSound(soundPath)
        local localPlayer = LocalPlayer()
        local soundPatch = easzy.bodydamage.sounds[soundPath]
        soundPatch:Stop()
        easzy.bodydamage.sounds[soundPath] = nil
    end

    net.Receive("ezbodydamage_client_sound", function()
        local localPlayer = LocalPlayer()
        local soundPath = net.ReadString()
        local play = net.ReadBool()

        if play then
            if easzy.bodydamage.sounds[soundPath] then
                StopSound(soundPath)
            end
            PlaySound(soundPath)
        else
            StopSound(soundPath)
        end
    end)
else
    util.AddNetworkString("ezbodydamage_client_sound")

    function easzy.bodydamage.ClientSound(ply, soundPath, play)
        net.Start("ezbodydamage_client_sound")
        net.WriteString(soundPath)
        net.WriteBool(play)
        net.Send(ply)
    end
end
