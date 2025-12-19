local function HeartPaint(x, y)
    local localPlayer = LocalPlayer()
    local health = (localPlayer:Health()/easzy.bodydamage.config.defaultBodyPartHealth)*easzy.bodydamage.config.defaultBodyPartHealth
    draw.SimpleText(health .. "%", "EZFont16", x + easzy.bodydamage.hudConfig.iconSize/2, y + easzy.bodydamage.hudConfig.iconSize/2, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local indicators = {
    [1] = {
        material = easzy.bodydamage.materials.heart,
        display = function() return easzy.bodydamage.config.displayHealthOnHUD end,
        paint = HeartPaint
    },
    [2] = {
        material = easzy.bodydamage.materials.brokenBone,
        display = easzy.bodydamage.IsBoneBroken
    },
    [3] = {
        material = easzy.bodydamage.materials.bleeding,
        display = easzy.bodydamage.IsBleeding
    },
    [4] = {
        material = easzy.bodydamage.materials.pain,
        display = easzy.bodydamage.IsTherePain
    },
    [5] = {
        material = easzy.bodydamage.materials.painkillers,
        display = easzy.bodydamage.IsTherePainKillers
    },
}

local function GetTotalIndicatorsHeight()
    local totalHeight = 0
    local localPlayer = LocalPlayer()

    for _, indicatorData in pairs(indicators) do
        if not indicatorData.display(localPlayer) then continue end
        totalHeight = totalHeight + easzy.bodydamage.hudConfig.iconSize + easzy.bodydamage.hudConfig.indicatorsVerticalMargin
    end

    return totalHeight
end

local function DrawIndicators(newPlayerBodyX, newPlayerBodyY, newPlayerBodyWidth)
    local localPlayer = LocalPlayer()
    if not easzy.bodydamage.IsBodyHealthValid(localPlayer) then return end
    local bodyHealth = localPlayer.easzy.bodydamage.bodyHealth

    local calculatedPlayerBodyWidth = easzy.bodydamage.hudConfig.playerBodyWidth * easzy.bodydamage.hudConfig.size
    local calculatedPlayerBodyHeight = easzy.bodydamage.hudConfig.playerBodyHeight * easzy.bodydamage.hudConfig.size

    local totalIndicatorsHeight = GetTotalIndicatorsHeight()
    local indicatorsX = easzy.bodydamage.hudConfig.x + (easzy.bodydamage.hudConfig.indicatorsHorizontalAlign == "left" and 0 or calculatedPlayerBodyWidth + easzy.bodydamage.hudConfig.spaceBetweenPlayerBodyAndIndicators - easzy.bodydamage.hudConfig.iconSize)
    local indicatorsY = easzy.bodydamage.hudConfig.y + (easzy.bodydamage.hudConfig.indicatorsVerticalAlign == "top" and 0 or calculatedPlayerBodyHeight - totalIndicatorsHeight)

    for _, indicatorData in ipairs(indicators) do
        if not indicatorData.display(localPlayer) then continue end

        draw.RoundedBox(easzy.bodydamage.RespY(4), indicatorsX, indicatorsY, easzy.bodydamage.hudConfig.iconSize, easzy.bodydamage.hudConfig.iconSize, easzy.bodydamage.colors.almostBlack)

        surface.SetDrawColor(easzy.bodydamage.colors.white:Unpack())
        surface.SetMaterial(indicatorData.material)
        surface.DrawTexturedRect(indicatorsX, indicatorsY, easzy.bodydamage.hudConfig.iconSize, easzy.bodydamage.hudConfig.iconSize)

        if indicatorData.paint then indicatorData.paint(indicatorsX, indicatorsY) end
        indicatorsY = indicatorsY + easzy.bodydamage.hudConfig.iconSize + easzy.bodydamage.hudConfig.indicatorsVerticalMargin
    end
end

hook.Add("HUDPaint", "ezbodydamage_indicators_HUDPaint", function()
    local localPlayer = LocalPlayer()
    if easzy.bodydamage.isMenuActive then return end
    if not easzy.bodydamage.config.displayHUD then return end

    if not easzy.bodydamage.IsBodyHealthValid(localPlayer) then return end
    if localPlayer.easzy.bodydamage.isBeingTreated then return end
    if localPlayer.easzy.bodydamage.dead then return end

    DrawIndicators(newPlayerBodyX, newPlayerBodyY, newPlayerBodyWidth)
end)
