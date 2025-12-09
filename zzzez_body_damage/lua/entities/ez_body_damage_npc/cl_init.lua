include("shared.lua")

function ENT:Draw()
    self:DrawModel()

	local localPlayer = LocalPlayer()
    if not easzy.bodydamage.GetInDistance(self, localPlayer, 500) then return end
	if not easzy.bodydamage.config.textOverNPC then return end

	self:DrawInfo()
end

function ENT:DrawInfo()
	local text = easzy.bodydamage.config.textOverNPC
	if not text or text == "" then return end

	local localPlayer = LocalPlayer()
	local font = "EZFont60"
    local textWidth, textHeight = easzy.bodydamage.GetTextSize(text, font)

	local pos = self:GetPos() + self:GetUp() * 76
	pos = pos + self:GetUp() * math.abs(math.sin(CurTime()) * 1)
	local ang = Angle(0, localPlayer:EyeAngles().y - 90, 90)

	cam.Start3D2D(pos, ang, 0.1)
        draw.RoundedBox(10, -textWidth/2, -textHeight/2, textWidth, textHeight, easzy.bodydamage.colors.almostBlack)
		draw.SimpleText(text, font, 0, 0, easzy.bodydamage.colors.white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
