include("shared.lua")

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)

    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    local hand = owner:LookupBone("ValveBiped.Bip01_R_Finger2")
    if hand then
        self:FollowBone(owner, hand)
    end
end

-- Specify a good position
local offsetVector = Vector(1.4, -4, 2)
local offsetAngle = Angle(150, 70, 20)

function SWEP:DrawWorldModel(flags)
    local owner = self:GetOwner()
    if not IsValid(owner) then
	    self:DrawModel(flags)
        return
    end

	if not IsValid(self.worldModel) then
		self.worldModel = ClientsideModel(self.WorldModel)
		self.worldModel:SetSkin(1)
		self.worldModel:SetNoDraw(true)
		self.worldModel:DrawShadow(false)
	else
        local boneid = owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
        if not boneid then return end

        local matrix = owner:GetBoneMatrix(boneid)
        if not matrix then return end

        local newPos, newAng = LocalToWorld(offsetVector, offsetAngle, matrix:GetTranslation(), matrix:GetAngles())

        self.worldModel:SetPos(newPos)
        self.worldModel:SetAngles(newAng)
        self.worldModel:SetupBones()
    end
    self.worldModel:DrawModel()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end
