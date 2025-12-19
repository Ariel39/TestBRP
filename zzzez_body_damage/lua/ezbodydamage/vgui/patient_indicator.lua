local PANEL = {}

AccessorFunc(PANEL, "bodyPart", "BodyPart")
AccessorFunc(PANEL, "patientData", "PatientData")
AccessorFunc(PANEL, "targetPlayer", "TargetPlayer")
AccessorFunc(PANEL, "highlight", "Highlight")

-- Función para verificar si se puede tratar una parte del cuerpo del paciente
local function CanTreatPatientBodyPart(bodyPart, itemClass, patientData)
    if not patientData then return false end

    local canTreatBrokenBone = patientData.broken and patientData.health != 0 and not patientData.isBoneBeingRepaired and itemClass == "ez_body_damage_splint"
    local canTreatBleeding = patientData.bleeding and patientData.health != 0 and itemClass == "ez_body_damage_bandage"
    local canGiveHealth = patientData.health < easzy.bodydamage.config.defaultBodyPartHealth and itemClass == "ez_body_damage_first_aid_kit"

    return canTreatBrokenBone or canTreatBleeding or canGiveHealth
end

function PANEL:Init()
    self.iconSize = easzy.bodydamage.RespY(10)
    self.iconMargin = easzy.bodydamage.RespY(8)

    -- Sistema de drag & drop para tratar partes del cuerpo
    self:Receiver("ezbodydamage_item", function(_, panels, dropped)
        local item = panels[1]
        if not IsValid(item) then return end

        local itemClass = item:GetClass()
        if not itemClass then return end

        local bodyPart = self:GetBodyPart()
        local patientData = self:GetPatientData()
        local targetPlayer = self:GetTargetPlayer()
        
        if not bodyPart or not patientData or not IsValid(targetPlayer) then return end

        if dropped then
            -- Usar item en el paciente
            easzy.bodydamage.UseMedicItemOnPatient(targetPlayer, bodyPart, itemClass)
            easzy.bodydamage.RemoveMedicInspectionMenu()
            return
        end

        if CanTreatPatientBodyPart(bodyPart, itemClass, patientData) then
            self:SetHighlight(true)
        end
    end)
end

function PANEL:PerformLayout(w, h)
    self.iconSize = w/2 - self.iconMargin
end

function PANEL:Paint(w, h)
    local bodyPart = self:GetBodyPart()
    local patientData = self:GetPatientData()
    
    if not bodyPart or not patientData then return end

    -- Porcentaje de salud
    local percentage = patientData.health
    local font = "EZFont16"
    surface.SetFont(font)
    local percentageW, percentageH = surface.GetTextSize(percentage .. "%")
    percentageH = 1.1 * percentageH

    -- Barra de salud con colores más claros
    draw.RoundedBox(percentageH/4, 0, h - percentageH, w, math.ceil(percentageH), Color(0, 0, 0, 100))
    
    local barColor = easzy.bodydamage.colors.green
    if percentage < 50 then barColor = easzy.bodydamage.colors.carrot end
    if percentage < 25 then barColor = easzy.bodydamage.colors.red end
    
    draw.RoundedBoxEx(percentageH/4, 0, h - percentageH, w * percentage/100, math.ceil(percentageH), barColor, true, percentage > 98, true, percentage > 98)
    draw.SimpleText(percentage .. "%", font, w/2, h - percentageH/2, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    -- Indicadores de estado
    local indicatorsX = 0

    -- Hueso roto
    if patientData.broken and not patientData.isBoneBeingRepaired then
        local indicatorX = indicatorsX + self.iconMargin/2
        draw.RoundedBox(4, indicatorX, 0, self.iconSize, self.iconSize, Color(20, 20, 20, 200))
        surface.SetDrawColor(easzy.bodydamage.colors.white:Unpack())
        surface.SetMaterial(easzy.bodydamage.materials.brokenBone)
        surface.DrawTexturedRect(indicatorX, 0, self.iconSize, self.iconSize)
        indicatorsX = indicatorsX + self.iconSize + self.iconMargin
    end

    -- Sangrado
    if patientData.bleeding then
        local indicatorX = indicatorsX + self.iconMargin/2
        draw.RoundedBox(4, indicatorX, 0, self.iconSize, self.iconSize, Color(20, 20, 20, 200))
        surface.SetDrawColor(easzy.bodydamage.colors.white:Unpack())
        surface.SetMaterial(easzy.bodydamage.materials.bleeding)
        surface.DrawTexturedRect(indicatorX, 0, self.iconSize, self.iconSize)
        indicatorsX = indicatorsX + self.iconSize + self.iconMargin
    end
    
    -- Hueso siendo reparado
    if patientData.isBoneBeingRepaired then
        local indicatorX = indicatorsX + self.iconMargin/2
        draw.RoundedBox(4, indicatorX, 0, self.iconSize, self.iconSize, easzy.bodydamage.colors.green)
        draw.SimpleText("R", "EZFont16", indicatorX + self.iconSize/2, self.iconSize/2, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

function PANEL:PaintOver(w, h)
    if not self:GetHighlight() then return end
    surface.SetDrawColor(easzy.bodydamage.colors.green:Unpack())
    surface.DrawOutlinedRect(0, 0, w, h, 2)
end

function PANEL:Think()
    if not self:IsHovered() then
        self:SetHighlight(false)
    end
end

vgui.Register("EZBodyDamagePatientIndicator", PANEL, "DPanel")
