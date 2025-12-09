-- Categorie
DarkRP.createCategory{
    name = "Easzy's Body Damage",
    categorises = "weapons",
    startExpanded = true,
    color = Color(200, 0, 0, 255),
    canSee = function() return true end,
    sortOrder = 90,
}

-- Items
DarkRP.createShipment("Bandage", {
    model = "models/easzy/ez_body_damage/bandage/w_bandage.mdl",
    entity = "ez_body_damage_bandage",
    price = 0,
    amount = 10,
    separate = true,
    pricesep = 5,
    noship = true,
    clip1 = 1,
    spareammo = 0,
    -- allowed = {TEAM_CITIZEN},
    category = "Easzy's Body Damage",
})

DarkRP.createShipment("First aid kit", {
    model = "models/easzy/ez_body_damage/first_aid_kit/w_first_aid_kit.mdl",
    entity = "ez_body_damage_first_aid_kit",
    price = 0,
    amount = 10,
    separate = true,
    pricesep = 50,
    noship = true,
    clip1 = 1,
    clip2 = easzy.bodydamage.config.maxHealthFirstAidKit,
    spareammo = 0,
    -- allowed = {TEAM_CITIZEN},
    category = "Easzy's Body Damage",
})

DarkRP.createShipment("Painkillers", {
    model = "models/easzy/ez_body_damage/painkillers/w_painkillers.mdl",
    entity = "ez_body_damage_painkillers",
    price = 0,
    amount = 10,
    separate = true,
    pricesep = 10,
    noship = true,
    clip1 = 1,
    spareammo = 0,
    -- allowed = {TEAM_CITIZEN},
    category = "Easzy's Body Damage",
})

DarkRP.createShipment("Splint", {
    model = "models/easzy/ez_body_damage/splint/w_splint.mdl",
    entity = "ez_body_damage_splint",
    price = 0,
    amount = 10,
    separate = true,
    pricesep = 15,
    noship = true,
    clip1 = 1,
    spareammo = 0,
    -- allowed = {TEAM_CITIZEN},
    category = "Easzy's Body Damage",
})
