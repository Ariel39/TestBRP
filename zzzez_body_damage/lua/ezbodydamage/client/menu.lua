easzy.bodydamage.isMenuActive = false

function easzy.bodydamage.CreateMenu()
    local menuPanelX = easzy.bodydamage.RespX(400)
    local menuPanelY = easzy.bodydamage.RespY(500)
    local itemsPanelY = easzy.bodydamage.RespY(100)
    local menuPanelOnlyY = menuPanelY - itemsPanelY

    local itemsPanelTopPadding = easzy.bodydamage.RespY(40)
    local itemSize = itemsPanelY - itemsPanelTopPadding
    local itemSize = 1.2 * itemSize -- To make it wider than height

    local playerBodySize = menuPanelOnlyY/easzy.bodydamage.hudConfig.playerBodyHeight
    local playerBodyX = (menuPanelX - easzy.bodydamage.hudConfig.playerBodyWidth * playerBodySize)/2

    local bodyPartsPositions

    local menuPanel = vgui.Create("DPanel")
    menuPanel:SetSize(menuPanelX, menuPanelY)
    menuPanel:Center()
    menuPanel:MakePopup()
    menuPanel:SetKeyBoardInputEnabled(false)

    -- Indicators
    menuPanel.indicators = {}

    local indicatorWidth = menuPanelX/5
    local indicatorHeight = menuPanelOnlyY/6
    local indicatorsInformations = {
        ["Head"] = {
            x = 0,
            y = 0
        },
        ["LeftArm"] = {
            x = 0,
            y = (menuPanelOnlyY - indicatorHeight)/2
        },
        ["LeftLeg"] = {
            x = 0,
            y = menuPanelOnlyY - indicatorHeight
        },
        ["Body"] = {
            x = menuPanelX - indicatorWidth,
            y = 0
        },
        ["RightArm"] = {
            x = menuPanelX - indicatorWidth,
            y = (menuPanelOnlyY - indicatorHeight)/2
        },
        ["RightLeg"] = {
            x = menuPanelX - indicatorWidth,
            y = menuPanelOnlyY - indicatorHeight
        }
    }

    -- Draw player body and indicators
    menuPanel.Paint = function(s, w, h)
        local bodyPartsPositions = easzy.bodydamage.DrawPlayerBody(playerBodyX, 0, playerBodySize)

        for bodyPart, indicatorData in pairs(indicatorsInformations) do
            -- Draw lines in all cases
            local lineStartX = indicatorData.x + indicatorWidth/2
            local lineStartY = indicatorData.y + indicatorHeight * 4/5
            surface.SetDrawColor(easzy.bodydamage.colors.transparentWhite:Unpack())
            surface.DrawLine(lineStartX, lineStartY, bodyPartsPositions[bodyPart].x, bodyPartsPositions[bodyPart].y)

            if menuPanel.indicators[bodyPart] then continue end

            -- Create indicators panels only if not already exists
            local indicator = vgui.Create("EZBodyDamageIndicator", menuPanel)
            indicator:SetPos(indicatorData.x, indicatorData.y)
            indicator:SetSize(indicatorWidth, indicatorHeight)
            indicator:SetBodyPart(bodyPart)

            menuPanel.indicators[bodyPart] = indicator
        end
    end

    -- Items
    menuPanel.items = {}

    local itemsCount = 0
    local itemsPanel = vgui.Create("DPanel", menuPanel)
    itemsPanel:SetTall(itemsPanelY)
    itemsPanel:Dock(BOTTOM)
    itemsPanel.Paint = function(s, w, h)
        -- Add one icon per item
        for itemClass, _ in pairs(easzy.bodydamage.bodyDamageItems) do
            if menuPanel.items[itemClass] then continue end

            local localPlayer = LocalPlayer()
            if not localPlayer:HasWeapon(itemClass) then continue end

            local weapon = localPlayer:GetWeapon(itemClass)
            if not IsValid(weapon) then continue end

            local item = vgui.Create("EZBodyDamageItem", itemsPanel)
            item:SetWide(itemSize)
            item:Dock(LEFT)
            item:SetModel(weapon:GetModel())
            item:SetClass(itemClass)
            item.Think = function(s)
                if not IsValid(weapon) then
                    s:Remove()
                    menuPanel.items[itemClass] = nil
                    itemsCount = itemsCount - 1
                    return
                end
                s:SetText(weapon:Clip1())
            end

            menuPanel.items[itemClass] = item
            itemsCount = itemsCount + 1
       end

        local totalItemsWidth = itemsCount * itemSize
        local itemsPanelSidePadding = (menuPanelX - totalItemsWidth)/2
        itemsPanel:DockPadding(itemsPanelSidePadding, itemsPanelTopPadding, itemsPanelSidePadding, 0)
    end
    menuPanel.itemsPanel = itemsPanel

    easzy.bodydamage.menu = menuPanel
    easzy.bodydamage.isMenuActive = true
end

function easzy.bodydamage.RemoveMenu()
    if IsValid(easzy.bodydamage.menu) then
        easzy.bodydamage.menu:Remove()
        easzy.bodydamage.isMenuActive = false
    end
end

local function GetMenuKey()
    local keyString = easzy.bodydamage.config.menuKey
    local keyStringLowered = string.lower(keyString)
    local keyNumber = input.GetKeyCode(keyStringLowered)
    return keyNumber
end

-- Open the body damage menu
local lastClickMenu = 0
local isOpening = false
hook.Add("PlayerButtonDown", "ezbodydamage_open_menu_PlayerButtonDown", function(ply, key)
    if not easzy.bodydamage.IsBodyHealthValid(ply) then return end
    if ply.easzy.bodydamage.isBeingTreated then return end
    if ply.easzy.bodydamage.dead then return end
    if key != GetMenuKey() then return end
    if CurTime() - lastClickMenu < 0.2 or isOpening then return end
    lastClickMenu = CurTime()

    if easzy.bodydamage.isMenuActive then
        easzy.bodydamage.RemoveMenu()
    else
        isOpening = true
        timer.Simple(easzy.bodydamage.config.delayToOpenMenu, function()
            if not isOpening then return end
            isOpening = false
            easzy.bodydamage.CreateMenu()
        end)
    end
end)

-- Block movement while menu is active
hook.Add("StartCommand", "ezbodydamage_block_movement_while_menu_active_StartCommand", function(ply, cmd)
    if easzy.bodydamage.config.freezeWhenOpeningMenu and (isOpening or easzy.bodydamage.isMenuActive) then
        cmd:ClearMovement()
    end
end)

-- Loading bar when opening the menu
local loadingBarWidth = easzy.bodydamage.RespX(200)
local loadingBarHeight = easzy.bodydamage.RespX(10)
hook.Add("HUDPaint", "ezbodydamage_menu_loading_bar_HUDPaint", function()
    if not isOpening then return end

    local localPlayer = LocalPlayer()
    if easzy.bodydamage.isMenuActive then return end

    if not easzy.bodydamage.IsBodyHealthValid(localPlayer) then return end
    if localPlayer.easzy.bodydamage.isBeingTreated then return end
    if localPlayer.easzy.bodydamage.dead then return end

    local ratio = (CurTime() - lastClickMenu)/easzy.bodydamage.config.delayToOpenMenu
    draw.SimpleText(easzy.bodydamage.languages.loading, "EZFont20", ScrW()/2, (ScrH() - loadingBarHeight - 10)/2, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
    draw.RoundedBox(0, (ScrW() - loadingBarWidth)/2, (ScrH() - loadingBarHeight)/2, loadingBarWidth, loadingBarHeight, easzy.bodydamage.colors.almostBlack)
    draw.RoundedBox(0, (ScrW() - loadingBarWidth)/2, (ScrH() - loadingBarHeight)/2, loadingBarWidth * ratio, loadingBarHeight, easzy.bodydamage.colors.green)
end)

function easzy.bodydamage.UseItemOnBodyPart(bodyPart, itemClass)
    net.Start("ezbodydamage_use_item_on_body_part")
    net.WriteString(bodyPart)
    net.WriteString(itemClass)
    net.SendToServer()
end
