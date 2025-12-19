if CLIENT then
    hook.Add("InitPostEntity", "ezbodydamage_sync_body_damage_InitPostEntity", function()
        net.Start("ezbodydamage_initialize_body_health")
        net.SendToServer()
    end)
else
    local bodyHealth = {
        ["Head"] = {
            health = easzy.bodydamage.config.defaultBodyPartHealth,
            broken = false,
            isBoneBeingRepaired = false,
            bleeding = false,
        },
        ["Body"] = {
            health = easzy.bodydamage.config.defaultBodyPartHealth,
            broken = false,
            isBoneBeingRepaired = false,
            bleeding = false,
        },
        ["LeftArm"] = {
            health = easzy.bodydamage.config.defaultBodyPartHealth,
            broken = false,
            isBoneBeingRepaired = false,
            bleeding = false,
        },
        ["RightArm"] = {
            health = easzy.bodydamage.config.defaultBodyPartHealth,
            broken = false,
            isBoneBeingRepaired = false,
            bleeding = false,
        },
        ["LeftLeg"] = {
            health = easzy.bodydamage.config.defaultBodyPartHealth,
            broken = false,
            isBoneBeingRepaired = false,
            bleeding = false,
        },
        ["RightLeg"] = {
            health = easzy.bodydamage.config.defaultBodyPartHealth,
            broken = false,
            isBoneBeingRepaired = false,
            bleeding = false,
        }
    }

    local function InitializeBodyHealth(ply)
        ply.easzy = ply.easzy or {}
        ply.easzy.bodydamage = ply.easzy.bodydamage or {}
        ply.easzy.bodydamage.bodyHealth = table.Copy(bodyHealth)
        ply.easzy.bodydamage.treatmentCost = 0
        ply.easzy.bodydamage.treatmentTime = 0
        ply.easzy.bodydamage.isBeingTreated = false
        ply.easzy.bodydamage.dead = false
        ply.easzy.bodydamage.pain = false
        ply.easzy.bodydamage.painkillers = false
    end

    function easzy.bodydamage.UpdateAllHealth(ply, damageInfo)
        -- Update player heath, symptoms, treatment cost and sync body damage after the treatment
        easzy.bodydamage.UpdatePlayerHealth(ply, damageInfo)
        easzy.bodydamage.UpdateSymptoms(ply)
        easzy.bodydamage.UpdatePain(ply)
        easzy.bodydamage.UpdateCompleteTreatment(ply)
        easzy.bodydamage.SyncBodyDamage(ply)
    end

    function easzy.bodydamage.ResetBodyHealth(ply)
        InitializeBodyHealth(ply)
        easzy.bodydamage.UpdateAllHealth(ply)
    end

    hook.Add("PlayerInitialSpawn", "ezbodydamage_initialize_body_health_PlayerInitialSpawn", function(ply)
        easzy.bodydamage.ResetBodyHealth(ply)
        ply.easzy.bodydamage.isInitialSpawn = true
    end)

    util.AddNetworkString("ezbodydamage_initialize_body_health")

    net.Receive("ezbodydamage_initialize_body_health", function(_, ply)
        if not ply.easzy.bodydamage.isInitialSpawn then return end
        easzy.bodydamage.SyncBodyDamage(ply)
        ply.easzy.bodydamage.isInitialSpawn = false
    end)

    hook.Add("PlayerSpawn", "ezbodydamage_initialize_body_health_PlayerSpawn", function(ply)
        -- When revived by an other player
        if easzy.bodydamage.IsBodyHealthValid(ply) and ply.easzy.bodydamage.dontResetBodyHealth then
            ply.easzy.bodydamage.dontResetBodyHealth = false
            return
        end
        easzy.bodydamage.ResetBodyHealth(ply)
    end)
end
