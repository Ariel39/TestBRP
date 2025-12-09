if CLIENT then
    hook.Add("HUDPaint", "ezbodydamage_complete_treatment_HUDPaint", function()
        local localPlayer = LocalPlayer()
        if not IsValid(localPlayer) then return end

        if not easzy.bodydamage.IsBodyHealthValid(localPlayer) then return end
        if not localPlayer.easzy.bodydamage.isBeingTreated then return end

        local scrW, scrH = ScrW(), ScrH()
        surface.SetDrawColor(easzy.bodydamage.colors.almostBlack:Unpack())
        surface.DrawRect(0, 0, scrW, scrH)

        draw.SimpleText(easzy.bodydamage.languages.youAreBeingTreated, "EZFont60", scrW/2, scrH * 1/8, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local identifier = "ezbodydamage_treatment_duration"
        local timeLeft = timer.TimeLeft(identifier)
        if not timeLeft then return end

        timeLeft = math.max(math.ceil(timeLeft), 0)
        draw.SimpleText(easzy.bodydamage.languages.waitAnother .. " " .. timeLeft .. " " .. easzy.bodydamage.languages.seconds, "EZFont30", scrW/2, scrH * 7/8, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end)

    local function DrawTreatmentScreen()
        local localPlayer = LocalPlayer()
        if not IsValid(localPlayer) then return end

        local identifier = "ezbodydamage_treatment_duration"
        local time = localPlayer.easzy.bodydamage.treatmentTime
        timer.Create(identifier, time, 1, function() end)

        if not easzy.bodydamage.isMenuActive then
            easzy.bodydamage.CreateMenu()
            -- Don't show the items when being treated
            easzy.bodydamage.menu.itemsPanel:Remove()
        end
    end

    local function RemoveTreatmentScreen()
        local localPlayer = LocalPlayer()
        if not IsValid(localPlayer) then return end

        if easzy.bodydamage.isMenuActive and not localPlayer.easzy.bodydamage.dead then
            easzy.bodydamage.RemoveMenu()
        end
    end

    net.Receive("ezbodydamage_treatment_screen", function()
        local localPlayer = LocalPlayer()
        if not IsValid(localPlayer) then return end

        local isBeingTreated = net.ReadBool()
        if isBeingTreated then
            DrawTreatmentScreen()
        else
            RemoveTreatmentScreen()
        end
    end)
else
    util.AddNetworkString("ezbodydamage_treatment_screen")

    local function ToggleTreatmentScreen(ply)
        net.Start("ezbodydamage_treatment_screen")
        net.WriteBool(ply.easzy.bodydamage.isBeingTreated)
        net.Send(ply)
    end

    local function GetBodyPartTreatmentCost(ply, bodyPartData)
        local cost = 0

        local lostHealth = easzy.bodydamage.config.defaultBodyPartHealth - bodyPartData.health
        local healthCost = lostHealth * easzy.bodydamage.config.pricePerHealthPercent
        cost = cost + healthCost

        if bodyPartData.broken and not bodyPartData.isBoneBeingRepaired then
            cost = cost + easzy.bodydamage.config.priceBrokenBone
        end

        if bodyPartData.bleeding then
            cost = cost + easzy.bodydamage.config.priceBleeding
        end

        if bodyPartData.heatlh == 0 then
            cost = cost + easzy.bodydamage.config.priceDead
        end

        return cost
    end

    local function GetBodyPartTreatmentTime(ply, bodyPartData)
        local time = 0

        local lostHealth = easzy.bodydamage.config.defaultBodyPartHealth - bodyPartData.health
        local healthTime = lostHealth * easzy.bodydamage.config.timePerHealthPercent
        time = time + healthTime

        if bodyPartData.broken and not bodyPartData.isBoneBeingRepaired then
            time = time + easzy.bodydamage.config.timeBrokenBone
        end

        if bodyPartData.bleeding then
            time = time + easzy.bodydamage.config.timeBleeding
        end

        if bodyPartData.heatlh == 0 then
            time = time + easzy.bodydamage.config.timeDead
        end

        return time
    end

    function easzy.bodydamage.UpdateCompleteTreatment(ply)
        if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
        local bodyHealth = ply.easzy.bodydamage.bodyHealth

        local cost = easzy.bodydamage.config.minimumTreatmentPrice or 0
        local time = easzy.bodydamage.config.minimumTreatmentTime or 0

        for _, bodyPartData in pairs(bodyHealth) do
            local bodyPartTreatmentCost = GetBodyPartTreatmentCost(ply, bodyPartData)
            cost = cost + bodyPartTreatmentCost

            local bodyPartTreatmentTime = GetBodyPartTreatmentTime(ply, bodyPartData)
            time = time + bodyPartTreatmentTime
        end

        cost = math.ceil(cost)

        ply.easzy.bodydamage.treatmentCost = cost
        ply.easzy.bodydamage.treatmentTime = time

        return cost, time
    end

    local function PayForCompleteTreatment(ply)
        local cost = easzy.bodydamage.UpdateCompleteTreatment(ply)

        if not ply:canAfford(cost) then
            DarkRP.notify(ply, 1, 4, easzy.bodydamage.languages.youCantAffordTreatment)
            return
        end
        ply:addMoney(-cost)

        return cost
    end

    local function TreatBodyPart(ply, bodyPart, bodyPartData)
        if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end

        local treatBone = bodyPartData.broken and not bodyPartData.isBoneBeingRepaired
        local treatBoneTime = easzy.bodydamage.config.timeBrokenBone
        if treatBone then
            easzy.bodydamage.ClientSound(ply, "easzy/ez_body_damage/splint.mp3", true)
            timer.Simple(treatBoneTime, function()
                easzy.bodydamage.TreatBrokenBone(ply, bodyPart, 0)
                TreatBodyPart(ply, bodyPart, bodyPartData)
            end)
            return
        end

        local treatBleeding = bodyPartData.bleeding
        local treatBleedingTime = treatBleeding and easzy.bodydamage.config.timeBleeding or 0
        if treatBleeding then
            easzy.bodydamage.ClientSound(ply, "easzy/ez_body_damage/bandage.mp3", true)
            timer.Simple(treatBleedingTime, function()
                easzy.bodydamage.TreatBleeding(ply, bodyPart)
                TreatBodyPart(ply, bodyPart, bodyPartData)
            end)
            return
        end

        local treatDead = bodyPartData.heatlh == 0
        local treatDeadTime = treatDead and easzy.bodydamage.config.timeDead or 0
        if treatDead then
            easzy.bodydamage.ClientSound(ply, "easzy/ez_body_damage/first_aid_kit.mp3", true)
            timer.Simple(treatDeadTime, function()
                easzy.bodydamage.SetBodyPartHealth(ply, bodyPart, 1)
                TreatBodyPart(ply, bodyPart, bodyPartData)
            end)
            return
        end

        local lostHealth = easzy.bodydamage.config.defaultBodyPartHealth - bodyPartData.health
        local treatHealth = lostHealth != 0
        local healthTime = lostHealth * easzy.bodydamage.config.timePerHealthPercent
        if treatHealth then
            easzy.bodydamage.ClientSound(ply, "easzy/ez_body_damage/first_aid_kit.mp3", true)
            local newHealth = bodyPartData.health
            local identifier = "ezbodydamage_health_" .. ply:SteamID64() .. "_" .. bodyPart
            local steps = 20
            timer.Create(identifier, healthTime/steps, steps, function()
                newHealth = math.min(math.ceil(newHealth + lostHealth/steps), easzy.bodydamage.config.defaultBodyPartHealth)
                easzy.bodydamage.SetBodyPartHealth(ply, bodyPart, newHealth)
            end)
            return
        end
    end

    local function DoCompleteTreatment(ply, i)
        if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
        local bodyHealth = ply.easzy.bodydamage.bodyHealth
        local bodyHealthKeys = table.GetKeys(bodyHealth)

        local i = i or 1
        if i > #bodyHealthKeys then return end

        local bodyPart = bodyHealthKeys[i]
        local bodyPartData = bodyHealth[bodyPart]
        local bodyPartTreatmentTime = GetBodyPartTreatmentTime(ply, bodyPartData)
        TreatBodyPart(ply, bodyPart, bodyPartData)

        -- Wait for the body part to be treated and treat the next one
        timer.Simple(bodyPartTreatmentTime, function()
            if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end
            DoCompleteTreatment(ply, i + 1)
        end)
    end

    local function SetPlayerTreatmentState(ply, treatmentState)
        ply:SetNoDraw(treatmentState)
        ply:SetNotSolid(treatmentState)
        ply:DrawWorldModel(not treatmentState)
        ply:Freeze(treatmentState)
        if treatmentState then
            ply:GodEnable()
        else
            ply:GodDisable()

            local respawnPositionsCount = #easzy.bodydamage.config.respawnPositions
            if respawnPositionsCount <= 0 then return end

            local respawnPosition = easzy.bodydamage.config.respawnPositions[math.random(respawnPositionsCount)]
            ply:SetPos(respawnPosition)
            ply:DropToFloor()
        end
    end

    local function PlayBip(ply)
        easzy.bodydamage.ClientSound(ply, "easzy/ez_body_damage/bip.mp3", true)
    end

    local function StartSoundLoop(ply)
        local identifier = "ezbodydamage_bip_sound_loop_" .. ply:SteamID64()
        if timer.Exists(identifier) then
            StopSoundLoop(ply)
        end

        PlayBip(ply)
        timer.Create(identifier, 60, 0, function()
            PlayBip(ply)
        end)
    end

    local function StopSoundLoop(ply)
        local identifier = "ezbodydamage_bip_sound_loop_" .. ply:SteamID64()
        if timer.Exists(identifier) then
            timer.Remove(identifier)
        end
        easzy.bodydamage.ClientSound(ply, "easzy/ez_body_damage/bip.mp3", false)
    end

    util.AddNetworkString("ezbodydamage_complete_treatment")

    net.Receive("ezbodydamage_complete_treatment", function(_, ply)
        if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end

        easzy.bodydamage.UpdateCompleteTreatment(ply)

        local cost = PayForCompleteTreatment(ply)
        if not cost then return end

        -- In order to start the black screen and set the player invisible and godmode
        ply.easzy.bodydamage.isBeingTreated = true
        easzy.bodydamage.SyncBodyDamage(ply)
        StartSoundLoop(ply)
        SetPlayerTreatmentState(ply, true)
        ToggleTreatmentScreen(ply)

        -- Start the complete treatment (timers and recursivity)
        DoCompleteTreatment(ply)

        -- Notify at the end of the treatment
        timer.Simple(ply.easzy.bodydamage.treatmentTime, function()
            DarkRP.notify(ply, 0, 4, easzy.bodydamage.languages.youWereTreatedFor .. " " .. easzy.bodydamage.FormatCurrency(cost))

            -- In order to stop the black screen and set the player not invisible and not godmode
            ply.easzy.bodydamage.isBeingTreated = false
            easzy.bodydamage.SyncBodyDamage(ply)
            StopSoundLoop(ply)
            SetPlayerTreatmentState(ply, false)
            ToggleTreatmentScreen(ply)
        end)
    end)

    concommand.Add("ez_body_damage_position", function(ply)
        local pos = ply:GetPos()
        MsgC(easzy.bodydamage.colors.green, easzy.bodydamage.languages.pasteInConfiguration .. "\n")
        MsgC(easzy.bodydamage.colors.green, "Vector(" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")" .. "\n")
    end)
end
