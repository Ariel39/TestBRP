function easzy.bodydamage.UpdatePain(ply)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end

    local pain = false

    if easzy.bodydamage.IsBoneBroken(ply) then pain = true end
    if easzy.bodydamage.IsHealthUnder(ply, easzy.bodydamage.config.defaultBodyPartHealth/2) then pain = true end

    ply.easzy.bodydamage.pain = pain
end
