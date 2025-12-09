-- ===============================
-- CORRECCIONES PARA client/medic_inspection.lua
-- ===============================

-- Reemplaza la función easzy.bodydamage.CreateMedicInspectionMenu completamente:

function easzy.bodydamage.CreateMedicInspectionMenu(targetPlayer, targetBodyHealth)
    if easzy.bodydamage.isInspectionMenuActive then
        easzy.bodydamage.RemoveMedicInspectionMenu()
    end

    local menuPanelX = easzy.bodydamage.RespX(450)
    local menuPanelY = easzy.bodydamage.RespY(550)
    local itemsPanelY = easzy.bodydamage.RespY(80)
    local menuPanelOnlyY = menuPanelY - itemsPanelY

    local playerBodySize = menuPanelOnlyY/easzy.bodydamage.hudConfig.playerBodyHeight
    local playerBodyX = (menuPanelX - easzy.bodydamage.hudConfig.playerBodyWidth * playerBodySize)/2

    local menuPanel = vgui.Create("DPanel")
    menuPanel:SetSize(menuPanelX, menuPanelY)
    menuPanel:Center()
    menuPanel:MakePopup()
    menuPanel:SetKeyBoardInputEnabled(false)

    -- Título del menú (CORREGIDO: Ahora muestra el nombre del paciente)
    local titlePanel = vgui.Create("DPanel", menuPanel)
    titlePanel:SetTall(easzy.bodydamage.RespY(40))
    titlePanel:Dock(TOP)
    titlePanel.Paint = function(s, w, h)
        draw.RoundedBoxEx(8, 0, 0, w, h, easzy.bodydamage.colors.almostBlack, true, true, false, false)
        local titleText = "INSPECCIÓN MÉDICA - " .. (IsValid(targetPlayer) and targetPlayer:Name() or "Paciente Desconocido")
        draw.SimpleText(titleText, "EZFont20", w/2, h/2, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Indicadores para las partes del cuerpo
    menuPanel.indicators = {}

    local indicatorWidth = menuPanelX/5
    local indicatorHeight = menuPanelOnlyY/6
    local indicatorsInformations = {
        ["Head"] = { x = 0, y = easzy.bodydamage.RespY(40) },
        ["LeftArm"] = { x = 0, y = easzy.bodydamage.RespY(40) + (menuPanelOnlyY - indicatorHeight)/2 },
        ["LeftLeg"] = { x = 0, y = easzy.bodydamage.RespY(40) + menuPanelOnlyY - indicatorHeight },
        ["Body"] = { x = menuPanelX - indicatorWidth, y = easzy.bodydamage.RespY(40) },
        ["RightArm"] = { x = menuPanelX - indicatorWidth, y = easzy.bodydamage.RespY(40) + (menuPanelOnlyY - indicatorHeight)/2 },
        ["RightLeg"] = { x = menuPanelX - indicatorWidth, y = easzy.bodydamage.RespY(40) + menuPanelOnlyY - indicatorHeight }
    }

    -- Función para dibujar el cuerpo del paciente (CORREGIDO: Sin fondo oscuro)
    menuPanel.Paint = function(s, w, h)
        -- REMOVIDO: El fondo oscuro para que sea más limpio
        surface.SetDrawColor(50, 50, 50, 200) -- Fondo más sutil
        surface.DrawRect(0, 0, w, h)
        
        local bodyPartsPositions = easzy.bodydamage.DrawPatientBody(playerBodyX, easzy.bodydamage.RespY(40), playerBodySize, targetBodyHealth)

        for bodyPart, indicatorData in pairs(indicatorsInformations) do
            -- Líneas más sutiles
            local lineStartX = indicatorData.x + indicatorWidth/2
            local lineStartY = indicatorData.y + indicatorHeight * 4/5
            surface.SetDrawColor(255, 255, 255, 100) -- Líneas más transparentes
            surface.DrawLine(lineStartX, lineStartY, bodyPartsPositions[bodyPart].x, bodyPartsPositions[bodyPart].y)

            if menuPanel.indicators[bodyPart] then continue end

            local indicator = vgui.Create("EZBodyDamagePatientIndicator", menuPanel)
            indicator:SetPos(indicatorData.x, indicatorData.y)
            indicator:SetSize(indicatorWidth, indicatorHeight)
            indicator:SetBodyPart(bodyPart)
            indicator:SetPatientData(targetBodyHealth[bodyPart])
            indicator:SetTargetPlayer(targetPlayer) -- NUEVO: Para poder tratar

            menuPanel.indicators[bodyPart] = indicator
        end
    end

    -- Botón de cerrar
    local closeButton = vgui.Create("DButton", menuPanel)
    closeButton:SetText("✕")
    closeButton:SetFont("EZFont20")
    closeButton:SetTextColor(easzy.bodydamage.colors.white)
    closeButton:SetSize(30, 30)
    closeButton:SetPos(menuPanelX - 35, 5)
    closeButton.Paint = function(s, w, h)
        draw.RoundedBox(4, 0, 0, w, h, easzy.bodydamage.colors.red)
    end
    closeButton.DoClick = function()
        easzy.bodydamage.RemoveMedicInspectionMenu()
    end

    -- Panel de items médicos simplificado
    local itemsPanel = vgui.Create("DPanel", menuPanel)
    itemsPanel:SetTall(itemsPanelY)
    itemsPanel:Dock(BOTTOM)
    itemsPanel.Paint = function(s, w, h)
        surface.SetDrawColor(30, 30, 30, 200)
        surface.DrawRect(0, 0, w, h)
        
        -- Instrucciones de uso
        draw.SimpleText("Usa click derecho con tus items médicos para tratar al paciente", "EZFont16", w/2, h/2, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    easzy.bodydamage.inspectionMenu = menuPanel
    easzy.bodydamage.isInspectionMenuActive = true
    easzy.bodydamage.inspectionTarget = targetPlayer
end

function easzy.bodydamage.UseMedicItemOnPatient(targetPlayer, bodyPart, itemClass)
    net.Start("ezbodydamage_use_medic_item_on_patient")
    net.WriteEntity(targetPlayer)
    net.WriteString(bodyPart)
    net.WriteString(itemClass)
    net.SendToServer()
end

-- Función para cerrar el menú de inspección
function easzy.bodydamage.RemoveMedicInspectionMenu()
    if IsValid(easzy.bodydamage.inspectionMenu) then
        easzy.bodydamage.inspectionMenu:Remove()
        easzy.bodydamage.isInspectionMenuActive = false
        easzy.bodydamage.inspectionTarget = nil
    end
end

-- Función para dibujar el cuerpo del paciente
function easzy.bodydamage.DrawPatientBody(x, y, size, patientBodyHealth)
    local bodyPartsMaterials = {
        ["Head"] = easzy.bodydamage.materials.playerBodyHead,
        ["Body"] = easzy.bodydamage.materials.playerBodyBody,
        ["LeftArm"] = easzy.bodydamage.materials.playerBodyLeftArm,
        ["RightArm"] = easzy.bodydamage.materials.playerBodyRightArm,
        ["LeftLeg"] = easzy.bodydamage.materials.playerBodyLeftLeg,
        ["RightLeg"] = easzy.bodydamage.materials.playerBodyRightLeg,
    }

    local playerBodyHUDInformations = {
        ["Head"] = { x = 82, y = 0, w = 115, h = 149 },
        ["Body"] = { x = 57, y = 128, w = 181, h = 320 },
        ["LeftArm"] = { x = 0, y = 160, w = 84, h = 323 },
        ["RightArm"] = { x = 216, y = 158, w = 86, h = 323 },
        ["LeftLeg"] = { x = 22, y = 429, w = 134, h = 371 },
        ["RightLeg"] = { x = 138, y = 427, w = 152, h = 372 }
    }

    local bodyPartsPositions = {}
    local alphaHUD = 200
    
    for bodyPart, bodyPartMaterial in pairs(bodyPartsMaterials) do
        local bodyPartData = patientBodyHealth[bodyPart]
        local health = bodyPartData.health
        
        local healthPercentage = health/easzy.bodydamage.config.defaultBodyPartHealth
        local green = healthPercentage * 255
        local blue = healthPercentage * 255
        local bodyPartColor = Color(255, green, blue, alphaHUD)
        
        if health == 0 then
            bodyPartColor = Color(0, 0, 0, alphaHUD)
        end

        local bodyPartInfo = playerBodyHUDInformations[bodyPart]
        local bodyPartWidth = math.ceil(bodyPartInfo.w * size)
        local bodyPartHeight = math.ceil(bodyPartInfo.h * size)
        local bodyPartX = math.ceil(bodyPartInfo.x * size)
        local bodyPartY = math.ceil(bodyPartInfo.y * size)

        surface.SetDrawColor(bodyPartColor)
        surface.SetMaterial(bodyPartMaterial)
        surface.DrawTexturedRect(x + bodyPartX, y + bodyPartY, bodyPartWidth, bodyPartHeight)

        bodyPartsPositions[bodyPart] = {
            x = x + bodyPartX + bodyPartWidth/2,
            y = y + bodyPartY + bodyPartHeight/2
        }
    end

    return bodyPartsPositions
end

-- Recibir datos del servidor cuando se inspecciona a un jugador
net.Receive("ezbodydamage_medic_inspection", function()
    local targetPlayerID = net.ReadUInt(8)
    local targetPlayer = Player(targetPlayerID)
    
    if not IsValid(targetPlayer) then return end
    
    local targetBodyHealth = {}
    for i = 1, 6 do
        local bodyPart = net.ReadString()
        local health = net.ReadUInt(8)
        local broken = net.ReadBool()
        local bleeding = net.ReadBool()
        local isBoneBeingRepaired = net.ReadBool()
        
        targetBodyHealth[bodyPart] = {
            health = health,
            broken = broken,
            bleeding = bleeding,
            isBoneBeingRepaired = isBoneBeingRepaired
        }
    end
    
    easzy.bodydamage.inspectionTarget = targetPlayer
    easzy.bodydamage.CreateMedicInspectionMenu(targetPlayer, targetBodyHealth)
end)


net.Receive("ezbodydamage_medic_inspection", function()
    print("[DEBUG] ===== INICIANDO INSPECCIÓN =====")
    
    local targetPlayerID = net.ReadUInt(8)
    local targetPlayer = Player(targetPlayerID)
    
    print("[DEBUG] ID del jugador:", targetPlayerID)
    print("[DEBUG] Jugador válido:", IsValid(targetPlayer))
    
    if IsValid(targetPlayer) then
        print("[DEBUG] Nombre del jugador:", targetPlayer:Name())
    else
        print("[DEBUG] ERROR: El jugador no es válido")
        return
    end
    
    local targetBodyHealth = {}
    for i = 1, 6 do
        local bodyPart = net.ReadString()
        local health = net.ReadUInt(8)
        local broken = net.ReadBool()
        local bleeding = net.ReadBool()
        local isBoneBeingRepaired = net.ReadBool()
        
        targetBodyHealth[bodyPart] = {
            health = health,
            broken = broken,
            bleeding = bleeding,
            isBoneBeingRepaired = isBoneBeingRepaired
        }
        
        print("[DEBUG] " .. bodyPart .. " - HP:" .. health .. " Roto:" .. tostring(broken) .. " Sangrando:" .. tostring(bleeding))
    end
    
    print("[DEBUG] Verificando funciones...")
    print("[DEBUG] CreateMedicInspectionMenu existe:", easzy.bodydamage.CreateMedicInspectionMenu ~= nil)
    print("[DEBUG] hudConfig existe:", easzy.bodydamage.hudConfig ~= nil)
    
    if easzy.bodydamage.hudConfig then
        print("[DEBUG] hudConfig.playerBodyHeight:", easzy.bodydamage.hudConfig.playerBodyHeight)
    end
    
    print("[DEBUG] Intentando crear menú...")
    
    easzy.bodydamage.inspectionTarget = targetPlayer
    
    -- Intentar crear el menú con protección de errores
    local success, err = pcall(function()
        easzy.bodydamage.CreateMedicInspectionMenu(targetPlayer, targetBodyHealth)
    end)
    
    if success then
        print("[DEBUG] Menú creado exitosamente")
        print("[DEBUG] isInspectionMenuActive:", easzy.bodydamage.isInspectionMenuActive)
    else
        print("[DEBUG] ERROR al crear el menú:", err)
    end
    
    print("[DEBUG] ===== FIN DEBUG =====")
end)