function easzy.bodydamage.Respawn(ply)
    local identifier = "ezbodydamage_dead_wait_time_" .. ply:SteamID64()
    local timerExists = timer.Exists(identifier)
    if timerExists then timer.Remove(identifier) end

    local ragdoll = ply.DeathRagdoll
    if not ply.easzy.bodydamage.dead or not IsValid(ragdoll) then
        ply:Spawn()
        return
    end

    ply:SetParent()
    local frozen = ply:IsFrozen()
    ply.OldHunger = ply:getDarkRPVar("Energy")
    local health = ply:Health()
    local armor = ply:Armor()
    ply:Spawn()
    ply:SetHealth(health)
    ply:SetArmor(armor)
    ply:SetPos(ragdoll:GetPos())
    ply:SetModel(ragdoll:GetModel())
    ply:SetAngles(Angle(0, ragdoll:GetPhysicsObjectNum(10) and ragdoll:GetPhysicsObjectNum(10):GetAngles().Yaw or 0, 0))
    ply:UnSpectate()
    ply:StripWeapons()
    ragdoll:Remove()
    ragdoll.OwnerINT = 0
    if ply.WeaponsForDeath and ply:GetTable().BeforeDeathTeam == ply:Team() then
        ply:RemoveAllAmmo()
        for _, weapon in ipairs(ply.WeaponsForDeath) do
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
        ply:GetTable().BeforeDeathTeam = nil
        ply.WeaponsForDeath = nil
    else
        gamemode.Call("PlayerLoadout", ply)
    end

    if frozen then
        ply:UnLock()
        ply:Lock()
    end

    if ply:getDarkRPVar("Energy") then
        ply:setSelfDarkRPVar("Energy", ply.OldHunger)
        ply.OldHunger = nil
    end

    if ply:isArrested() then
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.arrestspeed, GAMEMODE.Config.arrestspeed)
    end
end

function easzy.bodydamage.RemoveDeathRagdoll(ply)
    if IsValid(ply.DeathRagdoll) then
        ply.DeathRagdoll:Remove()
        ply.DeathRagdoll = nil
        ply:UnSpectate()
        ply:SetParent()
    end
end

function easzy.bodydamage.CreateDeathRagdoll(ply)
    if not ply:isArrested() then
        ply.WeaponsForDeath = {}
        for k, weapon in ipairs(ply:GetWeapons()) do
            ply.WeaponsForDeath[k] = {weapon:GetClass(), ply:GetAmmoCount(weapon:GetPrimaryAmmoType()),
            weapon:GetPrimaryAmmoType(), ply:GetAmmoCount(weapon:GetSecondaryAmmoType()), weapon:GetSecondaryAmmoType(),
            weapon:Clip1(), weapon:Clip2()}
            --[[{class, ammocount primary, type primary, ammo count secondary, type secondary, clip primary, clip secondary]]
        end
    end
    local ragdoll = ents.Create("prop_ragdoll")
    ragdoll:SetPos(ply:GetPos())
    ragdoll:SetAngles(ply:GetAngles())
    ragdoll:SetModel(ply:GetModel())
    ragdoll:Spawn()
    ragdoll:Activate()
    ragdoll:SetVelocity(ply:GetVelocity())
    if ragdoll.SetDeathRagdoll then
        ragdoll:SetDeathRagdoll(true)
    end
    ragdoll.OwnerINT = ply:EntIndex()
    ragdoll.PhysgunPickup = false
    ragdoll.CanTool = false
    ragdoll.onArrestStickUsed = fp{onRagdollArrested, ply}
    ply:StripWeapons()
    ply:Spectate(OBS_MODE_CHASE)
    ply:SpectateEntity(ragdoll)
    ply.DeathRagdoll = ragdoll
    ply:GetTable().BeforeDeathTeam = ply:Team()
    ply:SetMoveType(MOVETYPE_NONE) -- Required for parenting to work properly
    ply:SetParent(ragdoll)
    ragdoll:CPPISetOwner(ply)
    ragdoll:SetOwner(ply)

    return ragdoll
end

hook.Add("PlayerSpawn", "ezbodydamage_remove_ragdoll_PlayerSpawn", function(ply)
    easzy.bodydamage.RemoveDeathRagdoll(ply)
end)

hook.Add("PostPlayerDeath", "ezbodydamage_remove_ragdoll_PostPlayerDeath", function(ply)
    local ragdoll = ply:GetRagdollEntity()
    if IsValid(ragdoll) then
        ragdoll:Remove()
    end
    if easzy.bodydamage.dontShowDeathScreen[ply] then
        easzy.bodydamage.dontShowDeathScreen[ply] = nil
        return
    end
    easzy.bodydamage.RemoveDeathRagdoll(ply)
    easzy.bodydamage.CreateDeathRagdoll(ply)
end)

hook.Add("PlayerSay", "ezbodydamage_revive_PlayerSay", function(ply, text)
    if easzy.bodydamage.config.reviveCommand != "" and text == easzy.bodydamage.config.reviveCommand and ply:IsAdmin() then
        easzy.bodydamage.ResetBodyHealth(ply)
        easzy.bodydamage.Respawn(ply)
    end
end)
