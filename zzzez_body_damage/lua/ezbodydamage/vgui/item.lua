local PANEL = {}

AccessorFunc(PANEL, "text", "Text")
AccessorFunc(PANEL, "model", "Model")
AccessorFunc(PANEL, "class", "Class")

function PANEL:Init()
    self.boderWidth = easzy.bodydamage.RespX(1)

    self:Droppable("ezbodydamage_item")

    local model = vgui.Create("ModelImage", self)
    model:SetMouseInputEnabled(false)
    self.model = model
end

function PANEL:SetModel(model)
    if not IsValid(self.model) then return end
    self.model:SetModel(model)
end

function PANEL:PerformLayout(w, h)
    local sidePadding = (w - h)/2

    self.model:SetPos(sidePadding, 0)
    self.model:SetSize(h, h)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(easzy.bodydamage.colors.transparentBlack:Unpack())
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(easzy.bodydamage.colors.white:Unpack())
    surface.DrawRect(w - 1, 0, 1, h)

    draw.SimpleText(self:GetText(), "EZFont16", 2*self.boderWidth, 0, easzy.bodydamage.colors.white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
end

vgui.Register("EZBodyDamageItem", PANEL, "DPanel")
