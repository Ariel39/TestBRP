local PANEL = {}

AccessorFunc(PANEL, "bodyPart", "BodyPart")
AccessorFunc(PANEL, "highlight", "Highlight")

local function CanTreatBodyPart(bodyPart, itemClass)
    local localPlayer = LocalPlayer()

    if not easzy.bodydamage.IsBodyHealthValid(localPlayer) then return end
    local bodyHealth = localPlayer.easzy.bodydamage.bodyHealth

    local bodyPartData = bodyHealth[bodyPart]

    local canTreatBrokenBone = bodyPartData.broken and bodyPartData.health != 0 and not bodyPartData.isBoneBeingRepaired and itemClass == "ez_body_damage_splint"
    local canTreatBleeding = bodyPartData.bleeding and bodyPartData.health != 0 and itemClass == "ez_body_damage_bandage"
    local canGiveHealth = bodyPartData.health < easzy.bodydamage.config.defaultBodyPartHealth and itemClass == "ez_body_damage_first_aid_kit"

    return canTreatBrokenBone or canTreatBleeding or canGiveHealth
end

function PANEL:Init()
    self.iconSize = easzy.bodydamage.RespY(10)
    self.iconMargin = easzy.bodydamage.RespY(8)

    self:Receiver("ezbodydamage_item", function(_, panels, dropped)
        local item = panels[1]
        if not IsValid(item) then return end

        local itemClass = item:GetClass()
        if not itemClass then return end

        local bodyPart = self:GetBodyPart()
        if not bodyPart then return end

        if dropped then
            easzy.bodydamage.RemoveMenu()
            easzy.bodydamage.UseItemOnBodyPart(bodyPart, itemClass)
            return
        end

        if CanTreatBodyPart(bodyPart, itemClass) then
            self:SetHighlight(true)
        end
    end)
end

function PANEL:PerformLayout(w, h)
    self.iconSize = w/2 - self.iconMargin
end

function PANEL:Paint(w, h)
    local localPlayer = LocalPlayer()

    if not easzy.bodydamage.IsBodyHealthValid(localPlayer) then return end
    local bodyHealth = localPlayer.easzy.bodydamage.bodyHealth

    local bodyPart = self:GetBodyPart()
    if not bodyPart then return end

    local bodyPartData = bodyHealth[bodyPart]

    -- Percentage
    local percentage = bodyPartData.health
    local font = "EZFont16"
    surface.SetFont(font)
    local percentageW, percentageH = surface.GetTextSize(percentage)
    percentageH = 1.1 * percentageH

    draw.RoundedBox(percentageH/4, 0, h - percentageH, w, math.ceil(percentageH), easzy.bodydamage.colors.transparentBlack)
    draw.RoundedBoxEx(percentageH/4, 0, h - percentageH, w * percentage/100, math.ceil(percentageH), easzy.bodydamage.colors.green, true, percentage > 98, true, percentage > 98)

    draw.SimpleText(percentage .. "%", font, w/2, h - percentageH/2, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    -- Indicators
    local indicatorsX = 0

    -- Broken bone
    if bodyPartData.broken then
        local bodyPartIndicatorX = indicatorsX + self.iconMargin/2

        draw.RoundedBox(easzy.bodydamage.RespY(4), bodyPartIndicatorX, 0, self.iconSize, self.iconSize, easzy.bodydamage.colors.almostBlack)

        surface.SetDrawColor(easzy.bodydamage.colors.white:Unpack())
        surface.SetMaterial(easzy.bodydamage.materials.brokenBone)
        surface.DrawTexturedRect(bodyPartIndicatorX, 0, self.iconSize, self.iconSize)

        indicatorsX = indicatorsX + self.iconSize + self.iconMargin
    end

    -- Bleeding
    if bodyPartData.bleeding then
        local bodyPartIndicatorX = indicatorsX + self.iconMargin/2

        draw.RoundedBox(easzy.bodydamage.RespY(4), bodyPartIndicatorX, 0, self.iconSize, self.iconSize, easzy.bodydamage.colors.almostBlack)

        surface.SetDrawColor(easzy.bodydamage.colors.white:Unpack())
        surface.SetMaterial(easzy.bodydamage.materials.bleeding)
        surface.DrawTexturedRect(bodyPartIndicatorX, 0, self.iconSize, self.iconSize)

        indicatorsX = indicatorsX + self.iconSize + self.iconMargin
    end
end

function PANEL:PaintOver(w, h)
    if not self:GetHighlight() then return end
    surface.SetDrawColor(easzy.bodydamage.colors.green:Unpack())
    surface.DrawOutlinedRect(0, 0, w, h)
end

function PANEL:Think()
    if not self:IsHovered() then
        self:SetHighlight(false)
    end
end

vgui.Register("EZBodyDamageIndicator", PANEL, "DPanel")
