local playerBodyHUDInformations = {
    ["Head"] = {
        x = 82,
        y = 0,
        w = 115,
        h = 149
    },
    ["Body"] = {
        x = 57,
        y = 128,
        w = 181,
        h = 320
    },
    ["LeftArm"] = {
        x = 0,
        y = 160,
        w = 84,
        h = 323
    },
    ["RightArm"] = {
        x = 216,
        y = 158,
        w = 86,
        h = 323
    },
    ["LeftLeg"] = {
        x = 22,
        y = 429,
        w = 134,
        h = 371
    },
    ["RightLeg"] = {
        x = 138,
        y = 427,
        w = 152,
        h = 372
    }
}

local alphaHUD = 200
local deadBodyPartColor = Color(0, 0, 0, alphaHUD)
local function GetBodyPartColor(health)
    if not health then return end

    if health == 0 then
        return deadBodyPartColor
    end

    local healthPercentage = health/easzy.bodydamage.config.defaultBodyPartHealth
    local green = healthPercentage * 255
    local blue = healthPercentage * 255
    local bodyPartColor = Color(255, green, blue, alphaHUD)

    return bodyPartColor
end

local function GetBodyPartSize(bodyPart, size)
    local bodyPartWidth = playerBodyHUDInformations[bodyPart].w
    local bodyPartHeight = playerBodyHUDInformations[bodyPart].h

    local size = size or easzy.bodydamage.hudConfig.size
    local calculatedBodyPartWidth = math.ceil(bodyPartWidth * size)
    local calculatedBodyPartHeight = math.ceil(bodyPartHeight * size)

    return calculatedBodyPartWidth, calculatedBodyPartHeight
end

local function GetBodyPartPosition(bodyPart, size)
    local bodyPartX = playerBodyHUDInformations[bodyPart].x
    local bodyPartY = playerBodyHUDInformations[bodyPart].y

    local calculatedBodyPartX = math.ceil(bodyPartX * (size or easzy.bodydamage.hudConfig.size))
    local calculatedBodyPartY = math.ceil(bodyPartY * (size or easzy.bodydamage.hudConfig.size))

    return calculatedBodyPartX, calculatedBodyPartY
end

local function DrawBodyPart(bodyPart, bodyPartMaterial, x, y, size)
    local localPlayer = LocalPlayer()
    if not easzy.bodydamage.IsBodyHealthValid(localPlayer) then return end

    local bodyHealth = localPlayer.easzy.bodydamage.bodyHealth
    local bodyPartHealth = bodyHealth[bodyPart].health

    local bodyPartWidth, bodyPartHeight = GetBodyPartSize(bodyPart, size)
    local bodyPartX, bodyPartY = GetBodyPartPosition(bodyPart, size)

    local bodyPartColor = GetBodyPartColor(bodyPartHealth)
    if not bodyPartColor then return end

    local playerBodyX = x or (easzy.bodydamage.hudConfig.x + (easzy.bodydamage.hudConfig.indicatorsHorizontalAlign == "left" and easzy.bodydamage.hudConfig.spaceBetweenPlayerBodyAndIndicators or 0))
    local playerBodyY = y or easzy.bodydamage.hudConfig.y

	surface.SetDrawColor(bodyPartColor)
    surface.SetMaterial(bodyPartMaterial)
	surface.DrawTexturedRect(playerBodyX + bodyPartX, playerBodyY + bodyPartY, bodyPartWidth, bodyPartHeight)

    local bodyPartCenterX = playerBodyX + bodyPartX + bodyPartWidth/2
    local bodyPartCenterY = playerBodyY + bodyPartY + bodyPartHeight/2

    return bodyPartCenterX, bodyPartCenterY
end

function easzy.bodydamage.DrawPlayerBody(x, y, size)
    local bodyPartsMaterials = {
        ["Head"] = easzy.bodydamage.materials.playerBodyHead,
        ["Body"] = easzy.bodydamage.materials.playerBodyBody,
        ["LeftArm"] = easzy.bodydamage.materials.playerBodyLeftArm,
        ["RightArm"] = easzy.bodydamage.materials.playerBodyRightArm,
        ["LeftLeg"] = easzy.bodydamage.materials.playerBodyLeftLeg,
        ["RightLeg"] = easzy.bodydamage.materials.playerBodyRightLeg,
    }

    local bodyPartsPositions = {}
    for bodyPart, bodyPartMaterial in pairs(bodyPartsMaterials) do
        bodyPartsPositions[bodyPart] = {}
        bodyPartsPositions[bodyPart].x, bodyPartsPositions[bodyPart].y = DrawBodyPart(bodyPart, bodyPartMaterial, x, y, size)
    end

    return bodyPartsPositions
end

hook.Add("HUDPaint", "ezbodydamage_player_body_HUDPaint", function()
    local localPlayer = LocalPlayer()
    if easzy.bodydamage.isMenuActive then return end
    if not easzy.bodydamage.config.displayHUD then return end

    if not easzy.bodydamage.IsBodyHealthValid(localPlayer) then return end
    if localPlayer.easzy.bodydamage.isBeingTreated then return end
    if localPlayer.easzy.bodydamage.dead then return end

    easzy.bodydamage.DrawPlayerBody()
end)
