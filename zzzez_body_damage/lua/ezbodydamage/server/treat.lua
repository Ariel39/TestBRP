local function BodyPartIsInThisState(bodyPartData, state)
    if state == "broken" and (not bodyPartData.broken or bodyPartData.health == 0 or bodyPartData.isBoneBeingRepaired) then return
    elseif state == "bleeding" and (not bodyPartData.bleeding or bodyPartData.health == 0) then return
    elseif bodyPartData.health == easzy.bodydamage.config.defaultBodyPartHealth then return
    end
    return true
end

function easzy.bodydamage.GetMostInjuredBodyPart(ply, state)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth

    local mostInJuredBodyPart
    local mostInjuredBodyPartHealth

    for bodyPart, bodyPartData in pairs(bodyHealth) do
        if mostInjuredBodyPartHealth and bodyPartData.health > mostInjuredBodyPartHealth then continue end
        if not BodyPartIsInThisState(bodyPartData, state) then continue end
        mostInJuredBodyPart = bodyPart
        mostInjuredBodyPartHealth = bodyPartData.health
    end

    return mostInJuredBodyPart, mostInjuredBodyPartHealth
end

function easzy.bodydamage.TreatBrokenBone(ply, bodyPart, time)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth

    local bodyPartData = bodyHealth[bodyPart]
    if bodyPartData.isBoneBeingRepaired then return end

    local identifier = "ezbodydamage_treat_broken_bone_timer_" .. ply:SteamID64() .. "_" .. bodyPart
    if timer.Exists(identifier) then return end

    local time = time or easzy.bodydamage.config.boneRepairTime

    bodyPartData.isBoneBeingRepaired = true
    timer.Create(identifier, time, 1, function()
        bodyPartData.broken = false
        bodyPartData.isBoneBeingRepaired = false
        easzy.bodydamage.UpdateAllHealth(ply)
    end)

    easzy.bodydamage.UpdateAllHealth(ply)
end

function easzy.bodydamage.TreatBleeding(ply, bodyPart)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth
    bodyHealth[bodyPart].bleeding = false
    easzy.bodydamage.UpdateAllHealth(ply)
end

function easzy.bodydamage.SetBodyPartHealth(ply, bodyPart, health)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth
    bodyHealth[bodyPart].health = health
    easzy.bodydamage.UpdateAllHealth(ply)
end

function easzy.bodydamage.HealthBodyPart(ply, bodyPart, clip2)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth

    easzy.bodydamage.TreatBrokenBone(ply, bodyPart)
    easzy.bodydamage.TreatBleeding(ply, bodyPart)

    -- Calculate max health recovery of the first aid kit
    local currentHealth = bodyHealth[bodyPart].health
    local fullHealthRecovery = easzy.bodydamage.config.defaultBodyPartHealth - bodyHealth[bodyPart].health
    local healthRecovery = clip2 > fullHealthRecovery and fullHealthRecovery or clip2
    local remaining = clip2 - healthRecovery
    local newHealth = currentHealth + healthRecovery
    easzy.bodydamage.SetBodyPartHealth(ply, bodyPart, newHealth)

    easzy.bodydamage.UpdateAllHealth(ply)

    return remaining
end

function easzy.bodydamage.ApplyPainKillers(ply)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    if ply.easzy.bodydamage.painkillers then return end

    ply.easzy.bodydamage.painkillers = true

    timer.Simple(easzy.bodydamage.config.painkillersEffectTime, function()
        easzy.bodydamage.UpdatePain(ply)
        ply.easzy.bodydamage.painkillers = false
        easzy.bodydamage.UpdateAllHealth(ply)
    end)

    easzy.bodydamage.UpdateAllHealth(ply)
end

local function UseItemOnBodyPart(ply, bodyPart, itemClass)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth

    local bodyPartData = bodyHealth[bodyPart]
    if not bodyPartData then return end

    local state = (itemClass == "ez_body_damage_splint" and "broken") or
        (itemClass == "ez_body_damage_bandage" and "bleeding") or
        (itemClass == "ez_body_damage_first_aid_kit" and "")

    -- So if another itemClass is given it will not pass through BodyPartIsInThisState
    if not state then return end

    if not BodyPartIsInThisState(bodyPartData, state) then return end
    if not ply:HasWeapon(itemClass) then return end

    local item = ply:GetWeapon(itemClass)
    ply:SelectWeapon(itemClass)

    -- In order to defer from the deploy animation
    timer.Simple(0, function()
        item:PrimaryAttack(bodyPart)
    end)
end

util.AddNetworkString("ezbodydamage_use_item_on_body_part")

net.Receive("ezbodydamage_use_item_on_body_part", function(_, ply)
    local bodyPart = net.ReadString()
    local itemClass = net.ReadString()

    UseItemOnBodyPart(ply, bodyPart, itemClass)
end)
