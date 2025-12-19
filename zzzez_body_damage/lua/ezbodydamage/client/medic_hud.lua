-- HUD de médico simple con diagnóstico al mantener K presionada
if not easzy then easzy = {} end
if not easzy.bodydamage then easzy.bodydamage = {} end

local medicHUD = {
    showDiagnosis = false,
    diagnosisTarget = nil,
    maxDistance = 300,
    
    -- Sistema de hold key
    keyHeld = false,
    holdStartTime = 0,
    holdDuration = 2,  -- 2 segundos
    holdTarget = nil
}

-- Función auxiliar para obtener el código de tecla
local function GetInspectionKeyCode()
    local keyString = easzy.bodydamage.config.medicInspectionKey or "K"
    local keyStringLower = string.lower(keyString)
    local keyCode = input.GetKeyCode(keyStringLower)
    return keyCode
end

-- Nombres de las partes del cuerpo
local bodyPartNames = {
    Head = "Cabeza",
    Body = "Cuerpo",
    LeftArm = "Brazo Izq.",
    RightArm = "Brazo Der.",
    LeftLeg = "Pierna Izq.",
    RightLeg = "Pierna Der."
}

-- Sistema de recomendación
local function GetTreatmentRecommendation(bodyHealth)
    local recommendations = {}
    local priorities = {
        bleeding = {},
        broken = {},
        lowHealth = {},
        pain = false
    }
    
    -- Analizar cada parte del cuerpo
    for partID, partData in pairs(bodyHealth) do
        if partData then
            if partData.bleeding and partData.health > 0 then
                table.insert(priorities.bleeding, {
                    part = partID,
                    name = bodyPartNames[partID],
                    health = partData.health
                })
            end
            
            if partData.broken and not partData.isBoneBeingRepaired and partData.health > 0 then
                table.insert(priorities.broken, {
                    part = partID,
                    name = bodyPartNames[partID],
                    health = partData.health
                })
            end
            
            if partData.health < 80 and partData.health > 0 then
                table.insert(priorities.lowHealth, {
                    part = partID,
                    name = bodyPartNames[partID],
                    health = partData.health
                })
            end
            
            if partData.broken or partData.bleeding then
                priorities.pain = true
            end
        end
    end
    
    -- Construir recomendaciones
    if #priorities.bleeding > 0 then
        table.insert(recommendations, {
            item = "🩹 Vendaje",
            reason = "Detener sangrado",
            parts = priorities.bleeding,
            urgency = "URGENTE",
            color = Color(255, 50, 50)
        })
    end
    
    if #priorities.broken > 0 then
        table.insert(recommendations, {
            item = "🔧 Férula",
            reason = "Reparar huesos",
            parts = priorities.broken,
            urgency = "IMPORTANTE",
            color = Color(255, 200, 50)
        })
    end
    
    if #priorities.lowHealth > 0 then
        local avgHealth = 0
        for _, part in ipairs(priorities.lowHealth) do
            avgHealth = avgHealth + part.health
        end
        avgHealth = avgHealth / #priorities.lowHealth
        
        if avgHealth < 40 then
            table.insert(recommendations, {
                item = "❤️ Botiquín",
                reason = "Salud crítica",
                parts = priorities.lowHealth,
                urgency = "MODERADO",
                color = Color(100, 255, 100)
            })
        end
    end
    
    if priorities.pain then
        table.insert(recommendations, {
            item = "💊 Analgésicos",
            reason = "Reducir dolor",
            parts = {},
            urgency = "OPCIONAL",
            color = Color(150, 150, 255)
        })
    end
    
    return recommendations
end

-- Dibujar panel de diagnóstico A LA DERECHA del paciente
local function DrawDiagnosisPanel(target, bodyHealth)
    if not IsValid(target) then return end
    
    local ply = LocalPlayer()
    
    -- MÉTODO ORIGINAL SIMPLE
    local pos = target:GetPos() + Vector(-20, 0, 105)
    local ang = Angle(0, ply:EyeAngles().y - 90, 90)
    
    -- Mover a la DERECHA
    pos = pos + ang:Right() * 40
    
    cam.Start3D2D(pos, ang, 0.08)
        -- Panel más pequeño
        local panelWidth = 420
        local panelHeight = 350
        
        draw.RoundedBox(8, 0, 0, panelWidth, panelHeight, Color(20, 20, 20, 240))
        draw.RoundedBox(8, 0, 0, panelWidth, 35, Color(100, 200, 255, 255))
        
        -- Título
        draw.SimpleText(
            "DIAGNÓSTICO MÉDICO",
            "DermaDefaultBold",
            panelWidth/2,
            18,
            Color(255, 255, 255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
        
        -- Nombre del paciente
        draw.SimpleText(
            "Paciente: " .. target:Nick(),
            "DermaDefault",
            10,
            50,
            Color(255, 255, 255),
            TEXT_ALIGN_LEFT
        )
        
        -- Calcular salud total
        local totalHealth = 0
        local maxHealth = 0
        local hasBleeding = false
        
        for partID, partData in pairs(bodyHealth) do
            if partData then
                totalHealth = totalHealth + partData.health
                maxHealth = maxHealth + 100
                if partData.bleeding then hasBleeding = true end
            end
        end
        
        local healthPercent = totalHealth / maxHealth
        
        -- Barra de salud
        local barX = 10
        local barY = 70
        local barWidth = 280
        local barHeight = 22
        
        surface.SetDrawColor(30, 30, 30, 255)
        surface.DrawRect(barX, barY, barWidth, barHeight)
        
        local healthColor = Color(50, 255, 50)
        if healthPercent < 0.5 then healthColor = Color(255, 200, 50) end
        if healthPercent < 0.25 then healthColor = Color(255, 50, 50) end
        
        surface.SetDrawColor(healthColor.r, healthColor.g, healthColor.b, 255)
        surface.DrawRect(barX + 2, barY + 2, (barWidth - 4) * healthPercent, barHeight - 4)
        
        draw.SimpleText(
            string.format("Salud: %d%%", math.floor(healthPercent * 100)),
            "DermaDefault",
            barX + barWidth/2,
            barY + barHeight/2,
            Color(255, 255, 255),
            TEXT_ALIGN_CENTER,
            TEXT_ALIGN_CENTER
        )
        
        -- Sangrado
        if hasBleeding then
            draw.SimpleText(
                "⚠ SANGRANDO",
                "DermaDefaultBold",
                barX + barWidth + 15,
                barY + barHeight/2,
                Color(255, 50, 50),
                TEXT_ALIGN_LEFT,
                TEXT_ALIGN_CENTER
            )
        end
        
        -- Detalles por parte
        local detailY = 105
        draw.SimpleText(
            "Partes del cuerpo:",
            "DermaDefaultBold",
            10,
            detailY,
            Color(200, 200, 200),
            TEXT_ALIGN_LEFT
        )
        detailY = detailY + 18
        
        for partID, partName in pairs(bodyPartNames) do
            local partData = bodyHealth[partID]
            if partData then
                local healthColor = Color(50, 255, 50)
                if partData.health < 75 then healthColor = Color(255, 200, 50) end
                if partData.health < 50 then healthColor = Color(255, 150, 50) end
                if partData.health < 25 then healthColor = Color(255, 50, 50) end
                
                -- Nombre
                draw.SimpleText(
                    partName,
                    "DermaDefault",
                    15,
                    detailY,
                    Color(200, 200, 200),
                    TEXT_ALIGN_LEFT
                )
                
                -- Salud
                draw.SimpleText(
                    string.format("%d%%", partData.health),
                    "DermaDefault",
                    110,
                    detailY,
                    healthColor,
                    TEXT_ALIGN_LEFT
                )
                
                -- Estados
                local statusX = 150
                if partData.bleeding then
                    draw.SimpleText("🩸", "DermaDefault", statusX, detailY, Color(255, 50, 50), TEXT_ALIGN_LEFT)
                    statusX = statusX + 18
                end
                if partData.broken then
                    local iconColor = partData.isBoneBeingRepaired and Color(255, 200, 50) or Color(255, 100, 100)
                    local icon = partData.isBoneBeingRepaired and "⚙️" or "🔧"
                    draw.SimpleText(icon, "DermaDefault", statusX, detailY, iconColor, TEXT_ALIGN_LEFT)
                end
                
                detailY = detailY + 16
            end
        end
        
        -- Recomendaciones
        detailY = detailY + 8
        draw.SimpleText(
            "═══ RECOMENDACIÓN ═══",
            "DermaDefaultBold",
            panelWidth/2,
            detailY,
            Color(100, 200, 255),
            TEXT_ALIGN_CENTER
        )
        detailY = detailY + 18
        
        local recommendations = GetTreatmentRecommendation(bodyHealth)
        
        if #recommendations == 0 then
            draw.SimpleText(
                "✓ Paciente estable",
                "DermaDefault",
                panelWidth/2,
                detailY,
                Color(100, 255, 100),
                TEXT_ALIGN_CENTER
            )
        else
            for i, rec in ipairs(recommendations) do
                if i > 3 then break end
                
                draw.SimpleText(
                    string.format("[%s] %s", rec.urgency, rec.item),
                    "DermaDefaultBold",
                    10,
                    detailY,
                    rec.color,
                    TEXT_ALIGN_LEFT
                )
                detailY = detailY + 14
                
                draw.SimpleText(
                    "  → " .. rec.reason,
                    "DermaDefault",
                    10,
                    detailY,
                    Color(200, 200, 200),
                    TEXT_ALIGN_LEFT
                )
                detailY = detailY + 12
            end
        end
        
        -- Instrucciones
        draw.SimpleText(
            "Usa CLICK DERECHO con tus items médicos",
            "DermaDefault",
            panelWidth/2,
            panelHeight - 15,
            Color(150, 150, 150),
            TEXT_ALIGN_CENTER
        )
        
    cam.End3D2D()
end

-- Detectar cuando se PRESIONA K (inicio del hold)
hook.Add("PlayerButtonDown", "easzy.bodydamage.MedicDiagnosis.Start", function(ply, button)
    if not IsValid(ply) or ply != LocalPlayer() then return end
    if button != GetInspectionKeyCode() then return end
    if not easzy.bodydamage.IsMedic(ply) then return end
    if medicHUD.keyHeld then return end
    
    local target = ply:GetEyeTrace().Entity
    if not IsValid(target) or not target:IsPlayer() or target == ply then return end
    
    local distance = ply:GetPos():Distance(target:GetPos())
    if distance > medicHUD.maxDistance then return end
    
    -- Iniciar hold
    medicHUD.keyHeld = true
    medicHUD.holdStartTime = CurTime()
    medicHUD.holdTarget = target
    surface.PlaySound("buttons/button17.wav")
end)

-- Detectar cuando se SUELTA K (cancelar hold)
hook.Add("PlayerButtonUp", "easzy.bodydamage.MedicDiagnosis.Cancel", function(ply, button)
    if button != GetInspectionKeyCode() then return end
    
    if medicHUD.keyHeld then
        -- Cancelar hold manualmente
        medicHUD.keyHeld = false
        medicHUD.holdTarget = nil
        surface.PlaySound("buttons/button8.wav")
        chat.AddText(Color(255, 200, 50), "[Médico] ", color_white, "Inspección cancelada")
        
        -- Si ya estaba mostrando el diagnóstico, cerrarlo
        if medicHUD.showDiagnosis then
            medicHUD.showDiagnosis = false
            medicHUD.diagnosisTarget = nil
        end
    end
end)

-- Think para verificar progreso del hold
hook.Add("Think", "easzy.bodydamage.MedicDiagnosis.Think", function()
    if not medicHUD.keyHeld then return end
    
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    
    local elapsed = CurTime() - medicHUD.holdStartTime
    
    -- Verificar que el objetivo sigue siendo válido y está en rango
    if not IsValid(medicHUD.holdTarget) then
        -- Target inválido, cancelar
        medicHUD.keyHeld = false
        medicHUD.holdTarget = nil
        surface.PlaySound("buttons/button8.wav")
        chat.AddText(Color(255, 200, 50), "[Médico] ", color_white, "Inspección cancelada - objetivo perdido")
        return
    end
    
    local distance = ply:GetPos():Distance(medicHUD.holdTarget:GetPos())
    if distance > medicHUD.maxDistance then
        -- Se alejó, cancelar
        medicHUD.keyHeld = false
        local targetName = medicHUD.holdTarget:Nick()
        medicHUD.holdTarget = nil
        surface.PlaySound("buttons/button8.wav")
        chat.AddText(Color(255, 200, 50), "[Médico] ", color_white, "Inspección cancelada - ", Color(100, 200, 255), targetName, color_white, " se alejó")
        return
    end
    
    -- Si completó los 2 segundos, mostrar diagnóstico
    if elapsed >= medicHUD.holdDuration then
        medicHUD.keyHeld = false
        
        -- Verificar que podemos obtener datos
        local bodyHealth = easzy.bodydamage.patientCache:GetPatientData(medicHUD.holdTarget)
        if not bodyHealth then
            chat.AddText(Color(255, 50, 50), "[Médico] ", color_white, "No se pueden obtener los datos del paciente")
            medicHUD.holdTarget = nil
            return
        end
        
        medicHUD.showDiagnosis = true
        medicHUD.diagnosisTarget = medicHUD.holdTarget
        medicHUD.holdTarget = nil
        surface.PlaySound("buttons/button14.wav")
        
        -- Auto-cerrar después de 15 segundos
        timer.Create("easzy.bodydamage.CloseDiagnosis", 15, 1, function()
            if medicHUD.showDiagnosis then
                medicHUD.showDiagnosis = false
                medicHUD.diagnosisTarget = nil
                surface.PlaySound("buttons/button10.wav")
            end
        end)
    end
end)

-- BARRA DE PROGRESO mientras se mantiene K presionada
hook.Add("HUDPaint", "easzy.bodydamage.MedicDiagnosis.Progress", function()
    if not medicHUD.keyHeld then return end
    
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    
    local elapsed = CurTime() - medicHUD.holdStartTime
    local progress = math.Clamp(elapsed / medicHUD.holdDuration, 0, 1)
    
    local scrW, scrH = ScrW(), ScrH()
    local barWidth = scrW * 0.2
    local barHeight = scrH * 0.015
    local barX = (scrW - barWidth) / 2
    local barY = scrH * 0.6
    
    -- Fondo de la barra
    draw.RoundedBox(8, barX, barY, barWidth, barHeight, Color(20, 20, 20, 200))
    
    -- Progreso
    local progressWidth = barWidth * progress
    draw.RoundedBox(8, barX, barY, progressWidth, barHeight, Color(100, 200, 255, 255))
    
    -- Texto arriba de la barra
    local keyText = easzy.bodydamage.config.medicInspectionKey or "K"
    local text = "Manteniendo [" .. keyText .. "] - Inspeccionando..."
    draw.SimpleText(text, "DermaDefault", scrW/2, barY - 20, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    
    -- Nombre del objetivo debajo de la barra
    if IsValid(medicHUD.holdTarget) then
        local targetName = medicHUD.holdTarget:Nick()
        draw.SimpleText(targetName, "DermaDefault", scrW/2, barY + barHeight + 12, Color(200, 200, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end)

-- TEXTO DE AYUDA cuando miras a alguien
hook.Add("HUDPaint", "easzy.bodydamage.MedicDiagnosis.Help", function()
    if medicHUD.keyHeld or medicHUD.showDiagnosis then return end
    
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    if not easzy.bodydamage.IsMedic(ply) then return end
    
    local target = ply:GetEyeTrace().Entity
    if not IsValid(target) or not target:IsPlayer() or target == ply then return end
    
    local distance = ply:GetPos():Distance(target:GetPos())
    if distance > medicHUD.maxDistance then return end
    
    local keyText = easzy.bodydamage.config.medicInspectionKey or "K"
    local helpText = "Mantén [" .. keyText .. "] para inspeccionar a " .. target:Nick()
    
    draw.SimpleText(helpText, "DermaDefault", ScrW()/2, ScrH()/2 + 80, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)

-- Renderizar diagnóstico en 3D con datos EN TIEMPO REAL
hook.Add("PostDrawTranslucentRenderables", "easzy.bodydamage.DrawMedicDiagnosis", function()
    if not medicHUD.showDiagnosis then return end
    if not IsValid(medicHUD.diagnosisTarget) then return end
    
    -- OBTENER DATOS FRESCOS cada frame para que se actualice en tiempo real
    local bodyHealth = easzy.bodydamage.patientCache:GetPatientData(medicHUD.diagnosisTarget)
    if not bodyHealth then 
        -- Si no hay datos, cerrar el diagnóstico
        medicHUD.showDiagnosis = false
        medicHUD.diagnosisTarget = nil
        return 
    end
    
    DrawDiagnosisPanel(medicHUD.diagnosisTarget, bodyHealth)
end)

-- Limpiar al desconectar
hook.Add("ShutDown", "easzy.bodydamage.MedicHUD.Cleanup", function()
    timer.Remove("easzy.bodydamage.CloseDiagnosis")
end)

print("[zzzez_body_damage] HUD de médico simple cargado")