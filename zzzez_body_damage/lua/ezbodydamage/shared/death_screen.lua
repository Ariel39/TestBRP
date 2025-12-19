if CLIENT then
    -- Flash effects
    local flashWidth = easzy.bodydamage.RespY(1024)
    local flashHeight = easzy.bodydamage.RespY(1024)

    local flashPositions
    local function CalculateFlashPositions()
        local scrW, scrH = ScrW(), ScrH()
        flashPositions = {
            [1] = {x = -flashWidth/2, y = -flashHeight/2},
            [2] = {x = -flashWidth/2, y = scrH - flashHeight/2},
            [3] = {x = scrW - flashWidth/2, y = -flashHeight/2},
            [4] = {x = scrW - flashWidth/2, y = scrH - flashHeight/2}
        }
    end
    CalculateFlashPositions()

    hook.Add("OnScreenSizeChanged", "ezbodydamage_calculate_flash_positions_OnScreenSizeChanged", function()
        CalculateFlashPositions()
    end)

    local function GetFlashPos()
        local pos = flashPositions[math.random(#flashPositions)]
        return pos.x, pos.y
    end

    local flashTime = 2
    local flashX
    local flashY
    local lastFlash = 0
    hook.Add("HUDPaint", "ezbodydamage_death_screen_HUDPaint", function()
        local localPlayer = LocalPlayer()
        if not IsValid(localPlayer) then return end

        if not easzy.bodydamage.IsBodyHealthValid(localPlayer) then return end
        if not localPlayer.easzy.bodydamage.dead then return end
        if not easzy.bodydamage.config.deathScreen then return end

        local scrW, scrH = ScrW(), ScrH()
        surface.SetDrawColor(easzy.bodydamage.colors.almostBlack:Unpack())
        surface.DrawRect(0, 0, scrW, scrH)

        -- Flash effects
        if easzy.bodydamage.config.seeFlashesWhenDead then
            local lastFlashDifference = CurTime() - lastFlash
            if lastFlashDifference > flashTime then
                flashX, flashY = GetFlashPos()
                lastFlash = CurTime()
            end

            local alpha = math.min(lastFlashDifference / flashTime, 1 - lastFlashDifference / flashTime) * 50

            surface.SetDrawColor(255, 255, 255, alpha)
            surface.SetMaterial(easzy.bodydamage.materials.flash)
            surface.DrawTexturedRect(flashX, flashY, flashWidth, flashHeight)
        end

        -- Texts
        draw.SimpleText(easzy.bodydamage.languages.youAreDead, "EZFont60", scrW/2, scrH * 1/8, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local identifier = "ezbodydamage_dead_wait_time"
        local timeLeft = timer.TimeLeft(identifier)
        local text
        if timeLeft then
            timeLeft = math.max(math.ceil(timeLeft), 0)
            text = easzy.bodydamage.languages.waitAnother .. " " .. timeLeft .. " " .. easzy.bodydamage.languages.seconds
        else
            text = easzy.bodydamage.languages.pressToRespawn
        end

        draw.SimpleText(text, "EZFont30", scrW/2, scrH * 7/8, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end)

    local function DrawDeathScreen()
        local time = easzy.bodydamage.config.waitingTimeBeforeRespawn
        local identifier = "ezbodydamage_dead_wait_time"
        timer.Create(identifier, time, 1, function() end)

        if not easzy.bodydamage.isMenuActive then
            easzy.bodydamage.CreateMenu()
            -- Don't show the items when being treated
            easzy.bodydamage.menu.itemsPanel:Remove()
        end
    end

    local function RemoveDeathScreen()
        local localPlayer = LocalPlayer()
        if not IsValid(localPlayer) then return end

        if easzy.bodydamage.isMenuActive and not localPlayer.easzy.bodydamage.isBeingTreated then
            easzy.bodydamage.RemoveMenu()
        end
    end

    net.Receive("ezbodydamage_death_screen", function()
        local localPlayer = LocalPlayer()
        if not IsValid(localPlayer) then return end

        local alive = net.ReadBool()
        if not alive then
            DrawDeathScreen()
        else
            RemoveDeathScreen()
        end
    end)
else
    util.AddNetworkString("ezbodydamage_death_screen")

    local function ToggleDeathScreen(ply)
        net.Start("ezbodydamage_death_screen")
        net.WriteBool(ply:Alive())
        net.Send(ply)
    end

    local function WaitForMedic(ply)
        local identifier = "ezbodydamage_dead_wait_time_" .. ply:SteamID64()
        local time = easzy.bodydamage.config.waitingTimeBeforeRespawn
        timer.Create(identifier, time, 1, function() end)
    end

    easzy.bodydamage.dontShowDeathScreen = {}
    hook.Add("PlayerChangedTeam", "ezbodydamage_death_screen_PlayerChangedTeam", function(ply, oldTeam, newTeam)
        if not GAMEMODE.Config.norespawn then
            easzy.bodydamage.dontShowDeathScreen[ply] = true
        end
    end)

    hook.Add("PostPlayerDeath", "ezbodydamage_death_screen_PostPlayerDeath", function(ply)
        if not easzy.bodydamage.IsBodyHealthValid(ply) then return end

        ply.easzy.bodydamage.dead = true
        ply.easzy.bodydamage.isBeingTreated = false
        easzy.bodydamage.SyncBodyDamage(ply)

        if not easzy.bodydamage.config.deathScreen then return end
        if easzy.bodydamage.dontShowDeathScreen[ply] then
            easzy.bodydamage.dontShowDeathScreen[ply] = nil
            return
        end
        WaitForMedic(ply)
        ToggleDeathScreen(ply)
    end)

    hook.Add("PlayerSpawn", "ezbodydamage_death_screen_PlayerSpawn", function(ply)
        if not easzy.bodydamage.IsBodyHealthValid(ply) then return end

        ply.easzy.bodydamage.dead = false
        ply.easzy.bodydamage.isBeingTreated = false
        easzy.bodydamage.SyncBodyDamage(ply)

        if not easzy.bodydamage.config.deathScreen then return end
        if easzy.bodydamage.dontShowDeathScreen[ply] then
            easzy.bodydamage.dontShowDeathScreen[ply] = nil
        end
        ToggleDeathScreen(ply)
    end)

    hook.Add("PlayerDeathThink", "ezbodydamage_wait_for_medic_PlayerDeathThink", function(ply)
        if not easzy.bodydamage.config.deathScreen then return end

        local identifier = "ezbodydamage_dead_wait_time_" .. ply:SteamID64()
        local timerExists = timer.Exists(identifier)

        if timerExists then
            return false
        end
    end)
end
