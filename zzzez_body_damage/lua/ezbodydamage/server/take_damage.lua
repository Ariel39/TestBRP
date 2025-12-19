local function GetClosestBoneToPosition(ply, position, bone, distance)
    local childBones = ply:GetChildBones(bone)
    local closestBone = bone
    local smallestDistance = distance or math.huge
    for parentBone, childBone in ipairs(childBones) do
        local childBoneName = ply:GetBoneName(childBone)
        if not string.StartWith(childBoneName, "ValveBiped.Bip01") then continue end
        local childBonePosition, _ = ply:GetBonePosition(childBone)
        local childBoneDistance = position:DistToSqr(childBonePosition)
        if childBoneDistance < smallestDistance then
            closestBone = childBone
            smallestDistance = smallestDistance
        end

        local childClosestBone, childClosestBoneDistance = GetClosestBoneToPosition(ply, position, childBone, childBoneDistance)
        if childClosestBoneDistance < smallestDistance then
            closestBone = childClosestBone
            smallestDistance = childClosestBoneDistance
        end
    end
    return closestBone, smallestDistance
end

function easzy.bodydamage.GetDamageBodyPart(ply, damageInfo)
    local rootBone = ply:LookupBone("ValveBiped.Bip01_Pelvis")
    if not rootBone then return end

    local damagePosition = damageInfo:GetDamagePosition()
    if not damagePosition then return end

    local closestBone, distance = GetClosestBoneToPosition(ply, damagePosition, rootBone)
    if not closestBone then return end

    local closestBoneName = ply:GetBoneName(closestBone)
    local closestBoneBodyPart = easzy.bodydamage.boneBodyPart[closestBoneName]

    return closestBoneBodyPart
end

local function ApplyDamageOnBodyPart(ply, bodyPart, damage)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth
    local newBodyPartHealth = math.max(bodyHealth[bodyPart].health - damage, 0)
    bodyHealth[bodyPart].health = newBodyPartHealth
end

local function ApplySpreadDamageOnPlayer(ply, bodyPart, damage)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth

    ApplyDamageOnBodyPart(ply, bodyPart, damage)

    -- Apply half of the damage on the parent of the body part
    local bodyPartParent = easzy.bodydamage.bodyPartsHierarchy[bodyPart].parent
    if bodyPartParent then
        ApplyDamageOnBodyPart(ply, bodyPartParent, damage/2)
    end

    -- Apply half of the damage on all the children of the body part
    local bodyPartChildren = easzy.bodydamage.bodyPartsHierarchy[bodyPart].children
    if not bodyPartChildren then return end
    for _, bodyPartChild in ipairs(bodyPartChildren) do
        ApplyDamageOnBodyPart(ply, bodyPartChild, damage/2)
    end
end

local function ApplyFallDamageOnPlayer(ply, damage)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth

    ApplyDamageOnBodyPart(ply, "LeftLeg", 2*damage)
    ApplyDamageOnBodyPart(ply, "RightLeg", 2*damage)
    ApplyDamageOnBodyPart(ply, "Body", damage)
end

local function ApplyDamageOnPlayer(ply, bodyPart, damageInfo)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth

    -- If a body part is dead then apply the damage to the parent part
    if bodyHealth[bodyPart].health == 0 then
        local bodyPartParent = easzy.bodydamage.bodyPartsHierarchy[bodyPart].parent
        if not bodyPartParent then return end
        bodyPart = bodyPartParent
    end

    local damage = damageInfo:GetDamage()
    if bodyPart == "Head" then
        damage = 2*damage
    end

    if damageInfo:IsDamageType(DMG_FALL) then
        ApplyFallDamageOnPlayer(ply, damage)
    elseif damageInfo:IsDamageType(DMG_BLAST) then
        ApplySpreadDamageOnPlayer(ply, bodyPart, damage)
    elseif damageInfo:IsDamageType(DMG_VEHICLE) then
        ApplySpreadDamageOnPlayer(ply, bodyPart, damage)
    elseif damageInfo:IsDamageType(DMG_BURN) then
        ApplySpreadDamageOnPlayer(ply, "Body", damage)
    elseif damageInfo:IsDamageType(DMG_DROWN) then
        ApplyDamageOnBodyPart(ply, "Head", damage)
    else
        ApplyDamageOnBodyPart(ply, bodyPart, damage)
    end
end

local function GetNewHealth(ply)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth
    local bodyHealthHead = bodyHealth["Head"].health
    local bodyHealthBody = bodyHealth["Body"].health

    -- Global health is the mean of the body health and the head health
    -- local newHealth = (bodyHealthHead + bodyHealthBody)/2

    -- Global health is the min between the body health and the head health
    local newHealth = math.min(bodyHealthHead, bodyHealthBody)

    if bodyHealthHead == 0 or bodyHealthBody == 0 then
        newHealth = 0
    end

    return math.floor(newHealth)
end

function easzy.bodydamage.UpdatePlayerHealth(ply, damageInfo)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    if not IsValid(ply) or not ply:IsPlayer() then return end

    local bodyHealth = ply.easzy.bodydamage.bodyHealth
    local bodyHealthHead = bodyHealth["Head"]
    local bodyHealthBody = bodyHealth["Body"]

    local currentHealth = ply:Health()
    local newHealth = GetNewHealth(ply)

    if currentHealth != 0 and newHealth <= 0 then
        if ply.IsKO then
            easzy.bodydamage.ToggleKO(ply)
            ply:Kill()
            return
        end
        if damageInfo then
            damageInfo:SetDamage(currentHealth + 1)
        else
            ply:Kill()
        end
    end
    ply:SetHealth(newHealth)
end

hook.Add("EntityTakeDamage", "ezbodydamage_take_damage_EntityTakeDamage", function(ply, damageInfo)
    if ply:IsRagdoll() then
        local ragdoll = ply
        ply = player.GetAll()[ragdoll.OwnerINT]
    end

    if not IsValid(ply) or not ply:IsPlayer() then return end

    -- The player should not take damage when being treated or in God Mode
    if ply.easzy.bodydamage.isBeingTreated or ply:HasGodMode() then
        damageInfo:SetDamage(0)
        return
    end

    local bodyPart = easzy.bodydamage.GetDamageBodyPart(ply, damageInfo) or "Body"

    ApplyDamageOnPlayer(ply, bodyPart, damageInfo)

    easzy.bodydamage.ApplyInjuriesOnPlayer(ply, bodyPart, damageInfo)

    easzy.bodydamage.UpdateAllHealth(ply, damageInfo)

    damageInfo:SetDamage(0)
end)
