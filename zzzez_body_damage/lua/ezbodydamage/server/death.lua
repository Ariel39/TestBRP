-- ========================================
-- DEATH.LUA - VERSIÓN SIN RAGDOLLS
-- Compatible con mods de animaciones de muerte
-- ========================================

function easzy.bodydamage.Respawn(ply)
    local identifier = "ezbodydamage_dead_wait_time_" .. ply:SteamID64()
    local timerExists = timer.Exists(identifier)
    if timerExists then timer.Remove(identifier) end

    if not ply.easzy.bodydamage.dead then
        ply:Spawn()
        return
    end

    -- Obtener el ragdoll del mod de animaciones (si existe)
    local ragdoll = ply:GetRagdollEntity()
    
    -- Guardar estado antes de respawn
    local frozen = ply:IsFrozen()
    ply.OldHunger = ply:getDarkRPVar("Energy")
    local health = ply:Health()
    local armor = ply:Armor()
    
    -- Respawn del jugador
    ply:Spawn()
    ply:SetHealth(health)
    ply:SetArmor(armor)
    
    -- Posicionar en la ubicación del ragdoll si existe
    if IsValid(ragdoll) then
        ply:SetPos(ragdoll:GetPos())
        ply:SetModel(ragdoll:GetModel())
        
        -- Obtener rotación del torso del ragdoll
        local pelvisBone = ragdoll:GetPhysicsObjectNum(10)
        if pelvisBone then
            ply:SetAngles(Angle(0, pelvisBone:GetAngles().Yaw, 0))
        end
    end
    
    -- Limpiar estado de spectate
    ply:UnSpectate()
    ply:StripWeapons()
    
    -- Restaurar armas si las tenía
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

    -- Restaurar estado de congelado
    if frozen then
        ply:UnLock()
        ply:Lock()
    end

    -- Restaurar hambre
    if ply:getDarkRPVar("Energy") then
        ply:setSelfDarkRPVar("Energy", ply.OldHunger)
        ply.OldHunger = nil
    end

    -- Restaurar velocidad si está arrestado
    if ply:isArrested() then
        GAMEMODE:SetPlayerSpeed(ply, GAMEMODE.Config.arrestspeed, GAMEMODE.Config.arrestspeed)
    end
end

-- ========================================
-- HOOKS DE MUERTE
-- ========================================

easzy.bodydamage.dontShowDeathScreen = {}

hook.Add("PlayerChangedTeam", "ezbodydamage_death_screen_PlayerChangedTeam", function(ply, oldTeam, newTeam)
    if not GAMEMODE.Config.norespawn then
        easzy.bodydamage.dontShowDeathScreen[ply] = true
    end
end)

hook.Add("PostPlayerDeath", "ezbodydamage_handle_death_PostPlayerDeath", function(ply)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end

    -- Guardar armas si no está arrestado
    if not ply:isArrested() then
        ply.WeaponsForDeath = {}
        for k, weapon in ipairs(ply:GetWeapons()) do
            ply.WeaponsForDeath[k] = {
                weapon:GetClass(), 
                ply:GetAmmoCount(weapon:GetPrimaryAmmoType()),
                weapon:GetPrimaryAmmoType(), 
                ply:GetAmmoCount(weapon:GetSecondaryAmmoType()), 
                weapon:GetSecondaryAmmoType(),
                weapon:Clip1(), 
                weapon:Clip2()
            }
        end
    end
    
    -- Guardar equipo actual
    ply:GetTable().BeforeDeathTeam = ply:Team()
    
    -- Marcar como muerto
    ply.easzy.bodydamage.dead = true
    ply.easzy.bodydamage.isBeingTreated = false
    easzy.bodydamage.SyncBodyDamage(ply)

    -- Nota: El ragdoll lo crea el mod de animaciones, no lo tocamos
    print("[EZ Body Damage] Player " .. ply:Name() .. " died - using external ragdoll system")
end)

hook.Add("PlayerSpawn", "ezbodydamage_handle_spawn_PlayerSpawn", function(ply)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end

    ply.easzy.bodydamage.dead = false
    ply.easzy.bodydamage.isBeingTreated = false
    easzy.bodydamage.SyncBodyDamage(ply)

    if easzy.bodydamage.dontShowDeathScreen[ply] then
        easzy.bodydamage.dontShowDeathScreen[ply] = nil
    end
    
    print("[EZ Body Damage] Player " .. ply:Name() .. " spawned")
end)

hook.Add("PlayerDeathThink", "ezbodydamage_wait_for_medic_PlayerDeathThink", function(ply)
    if not easzy.bodydamage.config.deathScreen then return end

    local identifier = "ezbodydamage_dead_wait_time_" .. ply:SteamID64()
    local timerExists = timer.Exists(identifier)

    if timerExists then
        return false -- Bloquear respawn mientras el timer existe
    end
end)

-- Comando de admin para revivir
hook.Add("PlayerSay", "ezbodydamage_revive_PlayerSay", function(ply, text)
    if easzy.bodydamage.config.reviveCommand != "" and text == easzy.bodydamage.config.reviveCommand and ply:IsAdmin() then
        easzy.bodydamage.ResetBodyHealth(ply)
        easzy.bodydamage.Respawn(ply)
    end
end)

-- ========================================
-- FUNCIONES DE UTILIDAD
-- ========================================

-- Obtener el jugador propietario de un ragdoll
function easzy.bodydamage.GetRagdollOwner(ragdoll)
    if not IsValid(ragdoll) then return nil end
    
    -- Intentar varios métodos de obtener el owner
    
    -- Método 1: OwnerINT (usado por algunos mods)
    if ragdoll.OwnerINT then
        local owner = player.GetAll()[ragdoll.OwnerINT]
        if IsValid(owner) then return owner end
    end
    
    -- Método 2: CPPI Owner
    local owner = ragdoll:CPPIGetOwner()
    if IsValid(owner) and owner:IsPlayer() then return owner end
    
    -- Método 3: GetOwner nativo
    local owner = ragdoll:GetOwner()
    if IsValid(owner) and owner:IsPlayer() then return owner end
    
    -- Método 4: Buscar jugador muerto cercano
    for _, ply in ipairs(player.GetAll()) do
        if not ply:Alive() and ply:GetPos():Distance(ragdoll:GetPos()) < 100 then
            return ply
        end
    end
    
    return nil
end

print("[EZ Body Damage] Death system loaded - External ragdoll mode")