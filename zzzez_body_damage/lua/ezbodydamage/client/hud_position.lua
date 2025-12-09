local isPositioningModeActive = false
local useCurrentView = false
local currentView
local positioningSpeed = easzy.bodydamage.RespY(1)

local function GetTotalHUDWidth()
    local calculatedBodyPartWidth = easzy.bodydamage.hudConfig.playerBodyWidth * easzy.bodydamage.hudConfig.size
    local totalHUDWidth = calculatedBodyPartWidth + easzy.bodydamage.hudConfig.spaceBetweenPlayerBodyAndIndicators
    return totalHUDWidth
end

local function GetTotalHUDHeight()
    local calculatedBodyPartHeight = easzy.bodydamage.hudConfig.playerBodyHeight * easzy.bodydamage.hudConfig.size
    local totalHUDHeight = calculatedBodyPartHeight
    return totalHUDHeight
end

local function LimitToScreen()
    local totalHUDWidth = GetTotalHUDWidth()
    local totalHUDHeight = GetTotalHUDHeight()
    local maxX = ScrW() - totalHUDWidth
    local maxY = ScrH() - totalHUDHeight

    if easzy.bodydamage.hudConfig.x < 0 then easzy.bodydamage.hudConfig.x = 0 end
    if easzy.bodydamage.hudConfig.y < 0 then easzy.bodydamage.hudConfig.y = 0 end
    if easzy.bodydamage.hudConfig.x > maxX then easzy.bodydamage.hudConfig.x = maxX end
    if easzy.bodydamage.hudConfig.y > maxY then easzy.bodydamage.hudConfig.y = maxY end
end

local sizeStep = 0.05
local maxSize = 0.4
local minSize = 0.2

-- Change HUD size
local lastClickHUDSize = 0
hook.Add("PlayerButtonDown", "ezbodydamage_hud_size_PlayerButtonDown", function(ply, key)
    if not isPositioningModeActive then return end
    if CurTime() - lastClickHUDSize < 0.1 then return end
    lastClickHUDSize = CurTime()

    if key == KEY_PAD_PLUS then
        easzy.bodydamage.hudConfig.size = easzy.bodydamage.hudConfig.size + sizeStep
    elseif key == KEY_PAD_MINUS then
        easzy.bodydamage.hudConfig.size = easzy.bodydamage.hudConfig.size - sizeStep
    end

    if easzy.bodydamage.hudConfig.size > maxSize then easzy.bodydamage.hudConfig.size = maxSize end
    if easzy.bodydamage.hudConfig.size < minSize then easzy.bodydamage.hudConfig.size = minSize end

    LimitToScreen()
end)

local function SwitchIndicatorsPosition()
    local verticalAlign = easzy.bodydamage.hudConfig.indicatorsVerticalAlign
    local horizontalAlign = easzy.bodydamage.hudConfig.indicatorsHorizontalAlign

    if verticalAlign == "top" and horizontalAlign == "left" then
        easzy.bodydamage.hudConfig.indicatorsHorizontalAlign = "right"
    elseif verticalAlign == "top" and horizontalAlign != "left" then
        easzy.bodydamage.hudConfig.indicatorsVerticalAlign = "bottom"
    elseif verticalAlign == "bottom" and horizontalAlign != "left" then
        easzy.bodydamage.hudConfig.indicatorsHorizontalAlign = "left"
    elseif verticalAlign == "bottom" and horizontalAlign == "left" then
        easzy.bodydamage.hudConfig.indicatorsVerticalAlign = "top"
    end
end

local function GetSwitchIndicatorsPositionKey()
    local keyString = easzy.bodydamage.config.switchIndicatorsPosition
    local keyStringLowered = string.lower(keyString)
    local keyNumber = input.GetKeyCode(keyStringLowered)
    return keyNumber
end

-- Switch indicators position
local lastClickSwitchIndicatorsPosition = 0
hook.Add("PlayerButtonDown", "ezbodydamage_switch_indicators_position_PlayerButtonDown", function(ply, key)
    if not isPositioningModeActive then return end
    if key != GetSwitchIndicatorsPositionKey() then return end
    if CurTime() - lastClickSwitchIndicatorsPosition < 0.2 then return end
    lastClickSwitchIndicatorsPosition = CurTime()

    SwitchIndicatorsPosition()
end)

local moveHUDKeys = {
    [IN_FORWARD] = true,
    [IN_BACK] = true,
    [IN_MOVELEFT] = true,
    [IN_MOVERIGHT] = true
}

local function GetKeyPressed(cmd)
    -- Needs to be pairs because numbers are not from 1 to #
    for key, _ in pairs(moveHUDKeys) do
        if cmd:KeyDown(key) then return key end
    end
end

local lastKeyPressed
local keyPressTime = CurTime()

-- Enable moving HUD and disable moving player when positioning mode is active
hook.Add("CreateMove", "ezbodydamage_move_hud_CreateMove", function(cmd)
    if not isPositioningModeActive then return end

    local key = GetKeyPressed(cmd)
    if not key then return end

    if key != lastKeyPressed then
        lastKeyPressed = key
        keyPressTime = CurTime()
    end

    local keyIsHold = (key == lastKeyPressed) and (CurTime() - keyPressTime > 1)
    local calculatedPositioningSpeed = keyIsHold and positioningSpeed * 4 or positioningSpeed

    if cmd:KeyDown(IN_FORWARD) then
        easzy.bodydamage.hudConfig.y = easzy.bodydamage.hudConfig.y - calculatedPositioningSpeed
    elseif cmd:KeyDown(IN_BACK) then
        easzy.bodydamage.hudConfig.y = easzy.bodydamage.hudConfig.y + calculatedPositioningSpeed
    elseif cmd:KeyDown(IN_MOVELEFT) then
        easzy.bodydamage.hudConfig.x = easzy.bodydamage.hudConfig.x - calculatedPositioningSpeed
    elseif cmd:KeyDown(IN_MOVERIGHT) then
        easzy.bodydamage.hudConfig.x = easzy.bodydamage.hudConfig.x + calculatedPositioningSpeed
    else
        keyPressTime = keyPressTime
        return
    end

    LimitToScreen()

    cmd:ClearMovement()
end)

local function GetPositioningModeKey()
    local keyString = easzy.bodydamage.config.positioningModeKey
    local keyStringLowered = string.lower(keyString)
    local keyNumber = input.GetKeyCode(keyStringLowered)
    return keyNumber
end

-- Activates HUD positioning mode
local lastClickPositioningMode = 0
hook.Add("PlayerButtonDown", "ezbodydamage_toggle_positioning_mode_PlayerButtonDown", function(ply, key)
    if key != GetPositioningModeKey() then return end
    if CurTime() - lastClickPositioningMode < 0.2 then return end
    lastClickPositioningMode = CurTime()
    isPositioningModeActive = not isPositioningModeActive
    if not isPositioningModeActive then
        easzy.bodydamage.SaveHUDPositionData()
    end
end)

local function DrawArrows()
    local totalHUDWidth = GetTotalHUDWidth()
    local totalHUDHeight = GetTotalHUDHeight()

    draw.SimpleText("▲", "EZFont30", easzy.bodydamage.hudConfig.x + totalHUDWidth/2, easzy.bodydamage.hudConfig.y - easzy.bodydamage.hudConfig.positioningModeArrowsMargin, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("▼", "EZFont30", easzy.bodydamage.hudConfig.x + totalHUDWidth/2, easzy.bodydamage.hudConfig.y + totalHUDHeight + easzy.bodydamage.hudConfig.positioningModeArrowsMargin, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("◄", "EZFont30", easzy.bodydamage.hudConfig.x - easzy.bodydamage.hudConfig.positioningModeArrowsMargin, easzy.bodydamage.hudConfig.y + totalHUDHeight/2, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("►", "EZFont30", easzy.bodydamage.hudConfig.x + totalHUDWidth + easzy.bodydamage.hudConfig.positioningModeArrowsMargin, easzy.bodydamage.hudConfig.y + totalHUDHeight/2, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local textsY = easzy.bodydamage.hudConfig.y + totalHUDHeight + easzy.bodydamage.hudConfig.positioningModeArrowsMargin*2
    local textsMargin = easzy.bodydamage.RespY(20)
    local texts = {
        easzy.bodydamage.languages.press .. " " .. easzy.bodydamage.config.switchIndicatorsPosition .. " " .. easzy.bodydamage.languages.switchIndicatorsPosition,
        easzy.bodydamage.languages.pressToIncreaseSize,
        easzy.bodydamage.languages.pressToLowerSize,
        easzy.bodydamage.languages.press .. " " .. easzy.bodydamage.config.positioningModeKey .. " " .. easzy.bodydamage.languages.validateYourModification
    }
    for _, text in ipairs(texts) do
        draw.SimpleText(text, "EZFont16", easzy.bodydamage.hudConfig.x + totalHUDWidth/2, textsY, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        textsY = textsY + textsMargin
    end
end

local function ShowPositioningModeKey()
    local totalHUDWidth = GetTotalHUDWidth()
    local totalHUDHeight = GetTotalHUDHeight()

    local text = easzy.bodydamage.languages.press .. " " .. easzy.bodydamage.config.positioningModeKey .. " " .. easzy.bodydamage.languages.modifyBodyDamageHUD
    local textY = easzy.bodydamage.hudConfig.y + totalHUDHeight + easzy.bodydamage.hudConfig.positioningModeArrowsMargin
    draw.SimpleText(text, "EZFont16", easzy.bodydamage.hudConfig.x + totalHUDWidth/2, textY, easzy.bodydamage.colors.red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local ShowPositioningModeKeyTime
hook.Add("HUDPaint", "ezbodydamage_positioning_mode_HUDPaint", function()
    local localPlayer = LocalPlayer()
    if easzy.bodydamage.isMenuActive then return end
    if not easzy.bodydamage.config.displayHUD then return end

    if not easzy.bodydamage.IsBodyHealthValid(localPlayer) then return end
    if localPlayer.easzy.bodydamage.isBeingTreated then return end
    if localPlayer.easzy.bodydamage.dead then return end

    if not ShowPositioningModeKeyTime then
        ShowPositioningModeKeyTime = CurTime()
    end

    if isPositioningModeActive then
        DrawArrows()
    else
        if CurTime() - ShowPositioningModeKeyTime < 20 then
            ShowPositioningModeKey()
        end
    end
end)
