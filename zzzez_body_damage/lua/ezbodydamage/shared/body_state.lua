function easzy.bodydamage.IsHealthUnder(ply, health)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth

    for _, bodyPartData in pairs(bodyHealth) do
        if bodyPartData.health < health then
            return true
        end
    end

    return false
end

function easzy.bodydamage.IsBoneBroken(ply)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth

    for bodyPart, bodyPartData in pairs(bodyHealth) do
        if bodyPartData.broken and not bodyPartData.isBoneBeingRepaired then
            return true
        end
    end

    return false
end

function easzy.bodydamage.IsLegBroken(ply)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth

    local leftLeg = bodyHealth["LeftLeg"]
    if not leftLeg then return end

    local rightLeg = bodyHealth["RightLeg"]
    if not rightLeg then return end

    local leftLegBroken = (leftLeg.broken or leftLeg.health == 0) and not leftLeg.isBoneBeingRepaired
    local rightLegBroken = (rightLeg.broken or rightLeg.health == 0) and not rightLeg.isBoneBeingRepaired
    return (leftLegBroken or rightLegBroken)
end

function easzy.bodydamage.IsArmBroken(ply)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth

    local leftArm = bodyHealth["LeftArm"]
    if not leftArm then return end

    local rightArm = bodyHealth["RightArm"]
    if not rightArm then return end

    local leftArmBroken = (leftArm.broken or leftArm.health == 0) and not leftArm.isBoneBeingRepaired
    local rightArmBroken = (rightArm.broken or rightArm.health == 0) and not rightArm.isBoneBeingRepaired
    return (leftArmBroken or rightArmBroken)
end

function easzy.bodydamage.IsBleeding(ply)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth

    for _, bodyPartData in pairs(bodyHealth) do
        if bodyPartData.bleeding then
            return true
        end
    end

    return false
end

function easzy.bodydamage.IsTherePain(ply)
    return ply.easzy.bodydamage.pain and not ply.easzy.bodydamage.painkillers
end

function easzy.bodydamage.IsTherePainKillers(ply)
    return ply.easzy.bodydamage.painkillers
end
