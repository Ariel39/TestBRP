local function IncreaseItemAmmos(ply, weaponClass, spawnedWeapon)
    if not easzy.bodydamage.bodyDamageItems[weaponClass] then return end

    local weapon
    if not ply:HasWeapon(weaponClass) then
        -- To counter the infinite loop of "PlayerCanPickupWeapon"
        ply.easzy.bodydamage.isGivingWeapon = true
        weapon = ply:Give(weaponClass, true)
        ply.easzy.bodydamage.isGivingWeapon = false

        -- Set default clip2 if the weapon is the first aid kit
        if weaponClass == "ez_body_damage_first_aid_kit" then
            weapon:SetClip2(easzy.bodydamage.config.maxHealthFirstAidKit)
        end
    else
        weapon = ply:GetWeapon(weaponClass)
    end

    local fromSpawnedWeapon = spawnedWeapon and IsValid(spawnedWeapon)
    local amount = fromSpawnedWeapon and spawnedWeapon:Getamount()

    -- If player already have one of the items, we just increase the number of ammo
    local quantity = fromSpawnedWeapon and amount * spawnedWeapon.clip1 or 1
    local remaining = weapon:AddAmmo(quantity)

    if not fromSpawnedWeapon and remaining > 0 then
        -- So it doesn't remove the weapon on the ground
        return false
    end

    -- System to change the ammo or remove the spawned weapon
    if not fromSpawnedWeapon then return end

    if remaining == 0 then
        spawnedWeapon:Remove()
    elseif amount > 1 then
        amount = amount - 1
        spawnedWeapon:Setamount(amount)
        -- Some ammo might get lost there (same in darkRP)
        spawnedWeapon.clip1 = math.floor(remaining / amount)
    else
        spawnedWeapon.clip1 = remaining
    end

    -- So it doesn't use the default system
    return true
end

hook.Add("PlayerPickupDarkRPWeapon", "ezbodydamage_add_ammo_if_already_owning_PlayerPickupDarkRPWeapon", function(ply, spawnedWeapon, weapon)
    local weaponClass = weapon:GetClass()
    if not weaponClass then return end

    return IncreaseItemAmmos(ply, weaponClass, spawnedWeapon)
end)

hook.Add("PlayerGiveSWEP", "ezbodydamage_add_ammo_if_already_owning_PlayerGiveSWEP", function(ply, weaponClass)
    IncreaseItemAmmos(ply, weaponClass)
end)

hook.Add("PlayerCanPickupWeapon", "ezbodydamage_add_ammo_if_already_owning_PlayerCanPickupWeapon", function(ply, weapon)
    local weaponClass = weapon:GetClass()
    if not weaponClass then return end

    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    if ply.easzy.bodydamage.isGivingWeapon then return end

    return IncreaseItemAmmos(ply, weaponClass)
end)
