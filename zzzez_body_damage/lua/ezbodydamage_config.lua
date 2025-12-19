easzy = easzy or {}
easzy.bodydamage = easzy.bodydamage or {}
easzy.bodydamage.config = easzy.bodydamage.config or {}

local config = easzy.bodydamage.config

config.language = "en" -- "en", "fr"
config.hands = "keys" -- Your hands weapon

-- MEDIC NPC
config.NPCModel = "models/Kleiner.mdl"
config.textOverNPC = "Médic" -- Let it to "" if you don't want any text

-- HEALTH

-- Means that all the different parts of your body will have 100 health points
config.defaultBodyPartHealth = 100

-- Life points lost by the body part per second when it bleeds
config.healthLostBySecondWhenBleeding = 0.3

-- Allows the admin to respawn quickly
config.reviveCommand = "!revive" -- Let it to "" to disable

-- HUD
config.displayHUD = false
config.displayHealthOnHUD = true
config.delayToOpenMenu = 2 -- In seconds
config.freezeWhenOpeningMenu = false -- Whether the player is freezed or not when opening the menu

config.menuKey = "H" -- Key to open the menu with detailed view of body parts
config.positioningModeKey = "" -- Key to change the position of the HUD
config.switchIndicatorsPosition = "" -- Key to change the position of the icons

-- ITEMS

-- How many items a player can carry
config.maxStackSplint = 5
config.maxStackBandage = 5
config.maxStackPainkillers = 5
config.maxStackFirstAidKit = 5

-- Health points that can be regained with a first aid kit
config.maxHealthFirstAidKit = 200

-- The time it takes for a bone to repair itself after the use of a splint
config.boneRepairTime = 10 -- Set to 0 if instantaneous

-- Time during which the effects of pain will disappear
config.painkillersEffectTime = 30 -- Seconds

-- First aid kit
config.firstAidKitCanRevive = true
config.onlyMedicCanTreat = false
config.onlyMedicCanRevive = true

-- Allows players to treat/revive each other if there is no medic on the server
config.allPlayersCanTreatIfNoMedicOnline = true
config.allPlayersCanReviveIfNoMedicOnline = true

config.medics = {
    ["Paramédico"] = true
}

-- COMPLETE TREATMENT (NPC)

-- These values are used to calculate the total cost of treatment
config.minimumTreatmentPrice = 20 -- To pay even if nothing to treat
config.pricePerHealthPercent = 1
config.priceBrokenBone = 10
config.priceBleeding = 10
config.priceDead = 100

-- These values are used to calculate the total duration of treatment
config.minimumTreatmentTime = 5 -- To wait even if nothing to treat
config.timePerHealthPercent = 0.1
config.timeBrokenBone = 4
config.timeBleeding = 4
config.timeDead = 6

-- Time during which you will see the death screen and during which a medic can bring you back to life
config.deathScreen = true
config.waitingTimeBeforeRespawn = 180 -- Seconds
config.seeFlashesWhenDead = true

-- SYMPTOMS
config.blood = true -- Disables blood effect on screen corners
config.limping = true -- Disables camera movements when you have a broken leg
config.walkingSpeed = true -- Disables walking slower when a leg is broken
config.painBlur = true -- Deactivates blur when there is pain
config.cantChangeWeapon = false -- Deactivates the possibility of changing weapon when an arm is broken

-- KO SYSTEM
config.KODuration = 120 -- Seconds

-- List of weapons that can knock out with a blow to the head
config.KOWeapons = {
    ["weapon_crowbar"] = true,
}

-- List of respawn positions after a complete treatment (NPC)
-- Get you current position using "ez_body_damage_position" console command
config.respawnPositions = {
    Vector(7447.564453,5561.189453,288.031250)
    -- Vector(-1816.4331054688, -2544.4743652344, 20)
}
config.medicInspectionKey = "K" -- Tecla para inspeccionar pacientes
