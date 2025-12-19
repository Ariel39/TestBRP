local function OpenNPCMenu()
    local localPlayer = LocalPlayer()
    if not easzy.bodydamage.IsBodyHealthValid(localPlayer) then return end

    local panelWide = easzy.bodydamage.RespX(500)
    local panelTall = easzy.bodydamage.RespY(500)
    local panelRadius = easzy.bodydamage.RespY(15)
    local itemMargin = easzy.bodydamage.RespY(20)
    local itemSize = (panelTall - itemMargin)/4 - itemMargin
    local itemPanelSize = itemSize + 2*itemMargin
    local panelMinusItemsWide = panelWide - itemPanelSize
    local priceMargin = easzy.bodydamage.RespY(5)

    local playerBodySize = (panelTall*2/3)/easzy.bodydamage.hudConfig.playerBodyHeight
    local playerBodyX = itemPanelSize + (panelMinusItemsWide - easzy.bodydamage.hudConfig.playerBodyWidth * playerBodySize)/2
    local playerBodyY = easzy.bodydamage.RespY(30)

    local treatButtonTall = easzy.bodydamage.RespY(50)
    local treatButtonMargin = easzy.bodydamage.RespY(30)

    local panel = vgui.Create("DPanel")
    panel:SetSize(panelWide, panelTall)
    panel:Center()
    panel:MakePopup()

    -- Indicators
    panel.indicators = {}

    local indicatorWidth = panelMinusItemsWide/5
    local indicatorHeight = panelTall/9
    local indicatorsInformations = {
        ["Head"] = {
            x = itemPanelSize + itemMargin,
            y = playerBodyY
        },
        ["LeftArm"] = {
            x = itemPanelSize + itemMargin,
            y = (panelTall - treatButtonTall - treatButtonMargin - indicatorHeight)/2
        },
        ["LeftLeg"] = {
            x = itemPanelSize + itemMargin,
            y = panelTall - treatButtonTall - 2 * treatButtonMargin - indicatorHeight
        },
        ["Body"] = {
            x = panelWide - indicatorWidth - itemMargin,
            y = playerBodyY
        },
        ["RightArm"] = {
            x = panelWide - indicatorWidth - itemMargin,
            y = (panelTall - treatButtonTall - treatButtonMargin - indicatorHeight)/2
        },
        ["RightLeg"] = {
            x = panelWide - indicatorWidth - itemMargin,
            y = panelTall - treatButtonTall - 2 * treatButtonMargin - indicatorHeight
        }
    }

    -- Draw player body and indicators
    panel.Paint = function(s, w, h)
        draw.RoundedBox(panelRadius, 0, 0, w, h, easzy.bodydamage.colors.background)

        local bodyPartsPositions = easzy.bodydamage.DrawPlayerBody(playerBodyX, playerBodyY, playerBodySize)

        for bodyPart, indicatorData in pairs(indicatorsInformations) do
            -- Draw lines in all cases
            local lineStartX = indicatorData.x + indicatorWidth/2
            local lineStartY = indicatorData.y + indicatorHeight * 4/5
            surface.SetDrawColor(easzy.bodydamage.colors.transparentWhite:Unpack())
            surface.DrawLine(lineStartX, lineStartY, bodyPartsPositions[bodyPart].x, bodyPartsPositions[bodyPart].y)

            if panel.indicators[bodyPart] then continue end

            -- Create indicators panels only if not already exists
            local indicator = vgui.Create("EZBodyDamageIndicator", panel)
            indicator:SetPos(indicatorData.x, indicatorData.y)
            indicator:SetSize(indicatorWidth, indicatorHeight)
            indicator:SetBodyPart(bodyPart)

            panel.indicators[bodyPart] = indicator
        end
    end

    local closeButtonSize = easzy.bodydamage.RespY(20)
    local closeButtonMargin = easzy.bodydamage.RespY(8)
    local closeButton = vgui.Create("DImageButton", panel)
    closeButton:SetSize(closeButtonSize, closeButtonSize)
    closeButton:SetPos(panelWide - closeButtonSize - closeButtonMargin, closeButtonMargin)
    closeButton:SetMaterial(easzy.bodydamage.materials.close)
    closeButton.DoClick = function()
        panel:Remove()
    end

    -- Items
    local itemsPanel = vgui.Create("DPanel", panel)
    itemsPanel:SetWide(itemPanelSize)
    itemsPanel:Dock(LEFT)
    itemsPanel.Paint = function(s, w, h)
        draw.RoundedBoxEx(panelRadius, 0, 0, w, h, easzy.bodydamage.colors.itemsPanelbackground, true, false, true, false)
    end

    for _, shimpent in ipairs(CustomShipments) do
        if not easzy.bodydamage.bodyDamageItems[shimpent.entity] then continue end

        local item = vgui.Create("DImageButton", itemsPanel)
        item:SetTall(itemSize)
        item:Dock(TOP)
        item:DockMargin(itemMargin, itemMargin, itemMargin, 0)
        item:SetImage("entities/" .. shimpent.entity .. ".png")
        item.PaintOver = function(s, w, h)
            surface.SetDrawColor(easzy.bodydamage.colors.white:Unpack())
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText(easzy.bodydamage.FormatCurrency(shimpent.pricesep), "EZFont16", w - priceMargin, h - priceMargin/2, easzy.bodydamage.colors.white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
            return true
        end
        item.DoClick = function()
            RunConsoleCommand("DarkRP", "buy", shimpent.name)
        end
    end

    -- Treat
    local treatButton = vgui.Create("DButton", panel)
    local infosRatio = 3/5
    treatButton:SetTall(treatButtonTall)
    treatButton:Dock(BOTTOM)
    treatButton:DockMargin(treatButtonMargin, treatButtonMargin, treatButtonMargin, treatButtonMargin)
    treatButton.Paint = function(s, w, h)
        local leftPartWide = w * (1 - infosRatio)
        local rightPartWide = w * infosRatio
        draw.RoundedBoxEx(h/2, 0, 0, leftPartWide, h, easzy.bodydamage.colors.treatButton, true, false, true, false)
        draw.RoundedBoxEx(h/2, leftPartWide, 0, rightPartWide, h, easzy.bodydamage.colors.price, false, true, false, true)

        local costText = easzy.bodydamage.FormatCurrency(localPlayer.easzy.bodydamage.treatmentCost)
        local timeText = localPlayer.easzy.bodydamage.treatmentTime .. "s"
        draw.SimpleText(string.upper(easzy.bodydamage.languages.treat), "EZFont30", leftPartWide/2, h/2, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(costText .. " - " .. timeText, "EZFont30", leftPartWide + rightPartWide/2, h/2, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        return true
    end
    treatButton.DoClick = function()
        -- Try to buy a complete treatment
        net.Start("ezbodydamage_complete_treatment")
        net.SendToServer()

        panel:Remove()
    end
end

net.Receive("ezbodydamage_open_npc_menu", function()
    OpenNPCMenu()
end)
