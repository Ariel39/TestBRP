if CLIENT then
    hook.Add("HUDPaint", "ezbodydamage_effects_HUDPaint", function()
        local localPlayer = LocalPlayer()
        if not IsValid(localPlayer) then return end

        if not easzy.bodydamage.IsBodyHealthValid(localPlayer) then return end
        if localPlayer.easzy.bodydamage.isBeingTreated then return end
        if localPlayer.easzy.bodydamage.dead then return end

        -- Nothing by default
        surface.SetDrawColor(easzy.bodydamage.colors.transparent:Unpack())

        -- Blur and light blood when pain
        if easzy.bodydamage.IsTherePain(localPlayer) then
            surface.SetDrawColor(easzy.bodydamage.colors.transparentWhite:Unpack())
            if not easzy.bodydamage.config.painBlur then return end
            DrawMotionBlur(0.2, 0.8, 0.01)
        else
            if not easzy.bodydamage.config.painBlur then return end
            DrawMotionBlur(0, 0, 0)
        end

        -- Heavy blood when bleeding
        if easzy.bodydamage.IsBleeding(localPlayer) then
            surface.SetDrawColor(easzy.bodydamage.colors.white:Unpack())
        end

        if not easzy.bodydamage.config.blood then return end
        surface.SetMaterial(easzy.bodydamage.materials.blood)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end)

    local previousPos
    local smoothStopMovingFraction = 0
    local offsetVectortor = Vector(3, 2, 2)
    local offsetAnglele = Angle(3, 2, 2)
    hook.Add("CalcView", "ezbodydamage_shake_when_broken_leg_CalcView", function(ply, pos, angles, fov)
        if not easzy.bodydamage.IsLegBroken(ply) then return end
        if not easzy.bodydamage.config.limping then return end

        -- Compatibility with TPerson
        if TPerson and TPerson.IsActive() then return end

        -- Only shake when moving
        local currentPos = ply:GetPos()
        local moving = currentPos != previousPos
        previousPos = currentPos

        local curTime = CurTime()
        local fraction1 = math.abs((curTime * 1 % 2) - 1)
        local fraction2 = math.abs((curTime * 2 % 2) - 1)

        if moving then smoothStopMovingFraction = 0 end
        smoothStopMovingFraction = smoothStopMovingFraction < 0.95 and curTime % 1 or 1

        local newOrigin = LerpVector(fraction1, pos, pos - offsetVectortor)
        local newAngles = LerpAngle(fraction2, angles, angles - offsetAnglele)

        -- Smooth the end of the movement
        if not moving then
            newOrigin = LerpVector(smoothStopMovingFraction, newOrigin, pos)
            newAngles = LerpAngle(smoothStopMovingFraction, newAngles, angles)
        end

        local view = {
            origin = newOrigin,
            angles = newAngles,
            fov = fov,
            drawviewer = false,
        }

        return view
    end)
else
    -- Prevent carrying weapons
    local preventCarryingWeaponsPlayers = {}

    local function PreventCarryingWeapons(ply)
        ply:SelectWeapon(easzy.bodydamage.config.hands)
        preventCarryingWeaponsPlayers[ply] = true
    end

    local function AllowCarryingWeapons(ply)
        if not preventCarryingWeaponsPlayers[ply] then return end
        preventCarryingWeaponsPlayers[ply] = nil
    end

    hook.Add("PlayerSwitchWeapon", "ezbodydamage_prevent_carrying_weapons_PlayerSwitchWeapon", function(ply, oldWeapon, newWeapon)
        local newWeaponClass = newWeapon:GetClass()
        if not newWeaponClass then return end

        -- So the player can treat the broken bone
        if newWeaponClass == "ez_body_damage_splint" then return end

        return preventCarryingWeaponsPlayers[ply]
    end)

    -- Bleeding make body part lose health
    hook.Add("PlayerTick", "ezbodydamage_bleeding_PlayerTick", function(ply)
        if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end
        if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
        if ply.easzy.bodydamage.isBeingTreated then return end

        local curTime = CurTime()
        if ply.lastHealthDrop and curTime - ply.lastHealthDrop < 1 then return end
        ply.lastHealthDrop = curTime

        local needToSync = false

        local bodyHealth = ply.easzy.bodydamage.bodyHealth
        for bodyPart, bodyPartData in pairs(bodyHealth) do
            if not bodyPartData.bleeding then continue end
            if bodyPartData.health == 0 then continue end

            needToSync = true
            bodyPartData.health = math.max(bodyPartData.health - easzy.bodydamage.config.healthLostBySecondWhenBleeding, 0)
            if bodyPartData.health == 0 then
                local bodyPartParent = easzy.bodydamage.bodyPartsHierarchy[bodyPart].parent
                if not bodyPartParent then continue end

                easzy.bodydamage.MakeBodyPartBleed(ply, bodyPartParent)
            end
        end

        if not needToSync then return end

        easzy.bodydamage.UpdateAllHealth(ply)
    end)

    -- Update player symptoms depending of its body state
    function easzy.bodydamage.UpdateSymptoms(ply)
        if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
        local bodyHealth = ply.easzy.bodydamage.bodyHealth

        -- Prevent player form carrying weapons when an arm is broken
        if easzy.bodydamage.IsArmBroken(ply) and easzy.bodydamage.config.cantChangeWeapon then
            PreventCarryingWeapons(ply)
        else
            AllowCarryingWeapons(ply)
        end

        -- Slows down the player when he has a broken leg
        if easzy.bodydamage.IsLegBroken(ply) and easzy.bodydamage.config.walkingSpeed then
            GAMEMODE:SetPlayerSpeed(ply, 80, 80)
        else
            GAMEMODE:SetPlayerSpeed(ply, 160, 240)
        end
    end
end
