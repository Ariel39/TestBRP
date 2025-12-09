local function BreakBodyPartBone(ply, bodyPart)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth

    local doNotBreak = {
        ["Head"] = true,
        ["Body"] = true
    }

    if doNotBreak[bodyPart] then return end

    bodyHealth[bodyPart].broken = true
end

function easzy.bodydamage.MakeBodyPartBleed(ply, bodyPart)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    local bodyHealth = ply.easzy.bodydamage.bodyHealth
    bodyHealth[bodyPart].bleeding = true
end

local function ApplyBulletInjuriesOnPlayer(ply, bodyPart, isDamageImportant)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    easzy.bodydamage.MakeBodyPartBleed(ply, bodyPart)
    if isDamageImportant then
        BreakBodyPartBone(ply, bodyPart)
    end
end

local function ApplyFallInjuriesOnPlayer(ply, isDamageImportant)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    BreakBodyPartBone(ply, "LeftLeg")
    BreakBodyPartBone(ply, "RightLeg")
    if isDamageImportant then
        easzy.bodydamage.MakeBodyPartBleed(ply, "LeftLeg")
        easzy.bodydamage.MakeBodyPartBleed(ply, "RightLeg")
    end
end

local function ApplySpreadInjuriesOnPlayer(ply, bodyPart, isDamageImportant)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    if isDamageImportant then
        easzy.bodydamage.MakeBodyPartBleed(ply, bodyPart)
        BreakBodyPartBone(ply, bodyPart)
    end
end

function easzy.bodydamage.ApplyInjuriesOnPlayer(ply, bodyPart, damageInfo)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end

    local damage = damageInfo:GetDamage()
    local isDamageImportant = damage > easzy.bodydamage.config.defaultBodyPartHealth/2

    if damageInfo:IsDamageType(DMG_FALL) then
        ApplyFallInjuriesOnPlayer(ply, isDamageImportant)
    elseif damageInfo:IsDamageType(DMG_BULLET) then
        ApplyBulletInjuriesOnPlayer(ply, bodyPart, isDamageImportant)
    elseif damageInfo:IsDamageType(DMG_BLAST) then
        ApplySpreadInjuriesOnPlayer(ply, bodyPart, isDamageImportant)
    elseif damageInfo:IsDamageType(DMG_VEHICLE) then
        ApplySpreadInjuriesOnPlayer(ply, bodyPart, isDamageImportant)
    end
end
