local function StopKO(ply)
    if ply.IsKO then
        easzy.bodydamage.ToggleKO(ply)
    end
end

function easzy.bodydamage.ToggleKO(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    local timerName = ply:EntIndex() .. "KOExploit"

    if ply.IsKO and IsValid(ply.KORagdoll) then
        local ragdoll = ply.KORagdoll
        ragdoll:Remove()
        ragdoll.OwnerINT = 0

        if not ply:Alive() then return end

        -- So it stay with the same amount of HP
        ply.easzy.bodydamage.dontResetBodyHealth = true

        ply:SetParent()
        local frozen = ply:IsFrozen()
        ply.OldHunger = ply:getDarkRPVar("Energy")
        local health = ply:Health()
        local armor = ply:Armor()
        ply:Spawn()
        ply:SetHealth(health)
        ply:SetArmor(armor)
        ply:SetPos(ragdoll:GetPos())
        local model = ragdoll:GetModel()
        -- TEMPORARY WORKAROUND
        if string.lower(model) == "models/humans/corpse1.mdl" then
            model = "models/ply/corpse1.mdl"
        end
        ply:SetModel(model)
        ply:SetAngles(Angle(0, ragdoll:GetPhysicsObjectNum(10) and ragdoll:GetPhysicsObjectNum(10):GetAngles().Yaw or 0, 0))
        ply:UnSpectate()
        ply:StripWeapons()
        if ply.WeaponsForKO and ply:GetTable().BeforeKOTeam == ply:Team() then
            ply:RemoveAllAmmo()
            for _, weapon in ipairs(ply.WeaponsForKO) do
                local wep = ply:Give(weapon[1])
                if not IsValid(wep) then continue end

                ply:GiveAmmo(weapon[2], weapon[3], true)
                ply:GiveAmmo(weapon[4], weapon[5], true)

                wep:SetClip1(weapon[6])
                wep:SetClip2(weapon[7])

            end
            local cl_defaultweapon = ply:GetInfo("cl_defaultweapon")
            if ply:HasWeapon(cl_defaultweapon) then
                ply:SelectWeapon(cl_defaultweapon)
            end
            ply:GetTable().BeforeKOTeam = nil
            ply.WeaponsForKO = nil
        else
            gamemode.Call("PlayerLoadout", ply)
        end

        if frozen then
            ply:UnLock()
            ply:Lock()
        end

        if ply.blackScreen then
            ply.blackScreen = false
            SendUserMessage("blackScreen", ply, false)
        end

        ply.IsKO = false
        if ply:getDarkRPVar("Energy") then
            ply:setSelfDarkRPVar("Energy", ply.OldHunger)
            ply.OldHunger = nil
        end

        if ply:isArrested() then
            GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.arrestspeed, GAMEMODE.Config.arrestspeed)
        end
        timer.Remove(timerName)
    else
        -- Anti exploit
        if IsValid(ply:GetObserverTarget()) then return "" end
        for _, ent in ipairs(ents.FindInSphere(ply:GetPos(), 30)) do
            if ent:GetClass() == "func_door" then return end
        end

        if not ply:isArrested() then
            ply.WeaponsForKO = {}
            for k, weapon in ipairs(ply:GetWeapons()) do
                ply.WeaponsForKO[k] = {weapon:GetClass(), ply:GetAmmoCount(weapon:GetPrimaryAmmoType()),
                weapon:GetPrimaryAmmoType(), ply:GetAmmoCount(weapon:GetSecondaryAmmoType()), weapon:GetSecondaryAmmoType(),
                weapon:Clip1(), weapon:Clip2()}
                --[[{class, ammocount primary, type primary, ammo count secondary, type secondary, clip primary, clip secondary]]
            end
        end
        local ragdoll = ents.Create("prop_ragdoll")
        ragdoll:SetPos(ply:GetPos())
        ragdoll:SetAngles(Angle(0,ply:GetAngles().Yaw,0))
        local model = ply:GetModel()
        -- Temporary workaround
        if string.lower(model) == "models/ply/corpse1.mdl" then
            model = "models/Humans/corpse1.mdl"
        end
        ragdoll:SetModel(model)
        ragdoll:Spawn()
        ragdoll:Activate()
        ragdoll:SetVelocity(ply:GetVelocity())
        ragdoll.OwnerINT = ply:EntIndex()
        ragdoll.PhysgunPickup = false
        ragdoll.CanTool = false
        ragdoll.onArrestStickUsed = fp{onRagdollArrested, ply}
        ply:StripWeapons()
        ply:Spectate(OBS_MODE_CHASE)
        ply:SpectateEntity(ragdoll)
        ply.KORagdoll = ragdoll
        ply.KnockoutTimer = CurTime()
        ply:GetTable().BeforeKOTeam = ply:Team()
        ply:SetMoveType(MOVETYPE_NONE) -- Required for parenting to work properly
        ply:SetParent(ragdoll)
        ragdoll:CPPISetOwner(ply)

        if not ply.blackScreen then
            ply.blackScreen = true
            SendUserMessage("blackScreen", ply, true)
        end

        ply.IsKO = true

        timer.Create(timerName, 0.3, 0, function()
            if not IsValid(ply) then timer.Remove(timerName) return end

            if ply:GetObserverTarget() ~= ragdoll then
                if IsValid(ragdoll) then
                    ragdoll:Remove()
                end
                StopKO(ply)
            end
        end)
    end

    return ""
end

hook.Add("EntityTakeDamage", "ezbodydamage_ko_EntityTakeDamage", function(ply, damageInfo)
	if not IsValid(ply) or not ply:IsPlayer() then return end

    -- The player should not take KO when being treated of in God Mode
    if ply.easzy.bodydamage.isBeingTreated or ply:HasGodMode() then return end

    local bodyPart = easzy.bodydamage.GetDamageBodyPart(ply, damageInfo) or "Body"

    local attacker = damageInfo:GetAttacker()
    if not IsValid(attacker) or not attacker:IsPlayer() or not attacker:Alive() then return end

    local weapon = attacker:GetActiveWeapon()
    if not IsValid(weapon) then return end

    local weaponClass = weapon:GetClass()
    if not weaponClass then return end

    if bodyPart == "Head" and easzy.bodydamage.config.KOWeapons[weaponClass] then
        easzy.bodydamage.ToggleKO(ply)
        timer.Simple(easzy.bodydamage.config.KODuration, function()
            StopKO(ply)
        end)
    end
end)
