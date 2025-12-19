AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
    self.minigameScore = nil
    self.minigameQuality = nil
    self.minigameBodyPart = nil
    self.isSecondaryAttack = false
end

function SWEP:Deploy()
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    local hand = owner:LookupBone("ValveBiped.Bip01_R_Finger2")
    if hand then
        self:FollowBone(owner, hand)
    end

    local animationsList = {{name = "take_out", rate = 1}, {name = "idle", rate = 1}}
    easzy.bodydamage.AnimViewModelSequence(owner, animationsList)
end

function SWEP:AddAmmo(quantity)
    local clip1 = self:Clip1()
    local maxClip1 = self:GetMaxClip1()
    local maxQuantity = maxClip1 - clip1
    local quantityToAdd = (quantity > maxQuantity and maxQuantity or quantity)
    local remaining = quantity - quantityToAdd

    self:SetClip1(clip1 + quantityToAdd)

    return remaining
end

function SWEP:UseAmmo()
    local clip1 = self:Clip1()
    if clip1 == 0 then return end

    local newQuantity = clip1 - 1
    self:SetClip1(newQuantity)

    if newQuantity == 0 then
        local owner = self:GetOwner()
        if not IsValid(owner) then return end

        local weaponClass = self:GetClass()
        if not weaponClass then return end

        owner:StripWeapon(weaponClass)
        owner:SelectWeapon(easzy.bodydamage.config.hands)
    end
end

function SWEP:PrimaryAttack(bodyPart)
    local owner = self:GetOwner()

    -- To counter double uses
    local currentAnimation = easzy.bodydamage.GetViewModelAnimationName(owner)
    if currentAnimation == "use" then return end
    if not bodyPart and currentAnimation == "take_out" then return end

    -- Si no hay score de minijuego, solicitar minijuego
    if not self.minigameScore then
        -- Verify that there is something to treat
        local targetBodyPart = bodyPart or easzy.bodydamage.GetMostInjuredBodyPart(owner, "broken")
        if not targetBodyPart then return end
        
        -- Solicitar minijuego al cliente
        easzy.bodydamage.RequestMinigame(owner, "splint", self:GetClass(), targetBodyPart, owner)
        return
    end

    -- Plays the sound
    owner:EmitSound("easzy/ez_body_damage/splint.mp3")

    local function Use(ply)
        if not IsValid(owner) or not owner:IsPlayer() or not owner:Alive() then return end
        if not IsValid(ply) then return end
        if not IsValid(self) then return end

        local targetBodyPart = self.minigameBodyPart or bodyPart
        
        -- El score afecta el tiempo de reparación
        local baseTime = easzy.bodydamage.config.boneRepairTime or 10
        local score = self.minigameScore or 0.5
        local repairTime = baseTime * (2 - score)
        
        easzy.bodydamage.TreatBrokenBone(ply, targetBodyPart, repairTime)
        self:UseAmmo()
        
        -- Limpiar datos del minijuego
        self.minigameScore = nil
        self.minigameQuality = nil
        self.minigameBodyPart = nil
    end

    local animationsList = {
        {name = "use", rate = 1, callback = Use},
        {name = "take_out", rate = 1},
        {name = "idle", rate = 1}
    }
    easzy.bodydamage.AnimViewModelSequence(owner, animationsList)
end

function SWEP:SecondaryAttack()
    local owner = self:GetOwner()

    -- Si viene del minijuego, procesar directamente
    if self.isSecondaryAttack and self.minigameScore then
        self.isSecondaryAttack = false
        
        local ent = self.minigameTarget
        if not IsValid(ent) then return end
        
        -- To counter double uses
        local currentAnimation = easzy.bodydamage.GetViewModelAnimationName(owner)
        if currentAnimation != "idle" then return end

        -- Plays the sound
        owner:EmitSound("easzy/ez_body_damage/splint.mp3")

        local function Use(ply)
            if not IsValid(owner) or not owner:IsPlayer() or not owner:Alive() then return end
            if not IsValid(ply) then return end
            if not IsValid(self) then return end

            local targetBodyPart = self.minigameBodyPart
            
            -- Score afecta tiempo de reparación
            local baseTime = easzy.bodydamage.config.boneRepairTime or 10
            local score = self.minigameScore or 0.5
            local repairTime = baseTime * (2 - score)

            easzy.bodydamage.TreatBrokenBone(ply, targetBodyPart, repairTime)
            self:UseAmmo()
            
            -- Limpiar
            self.minigameScore = nil
            self.minigameQuality = nil
            self.minigameTarget = nil
            self.minigameBodyPart = nil
        end

        local animationsList = {
            {name = "take_out", rate = -0.5, delay = 1, callback = function() Use(ent) end},
            {name = "take_out", rate = 1},
            {name = "idle", rate = 1}
        }
        easzy.bodydamage.AnimViewModelSequence(owner, animationsList)
        return
    end

    -- Primera llamada: verificar y solicitar minijuego
    local ent = owner:GetEyeTrace().Entity
    if not IsValid(ent) or not ent:IsPlayer() or not ent:Alive() or not easzy.bodydamage.GetInDistance(ent, owner, 200) then return end

    -- To counter double uses
    local currentAnimation = easzy.bodydamage.GetViewModelAnimationName(owner)
    if currentAnimation != "idle" then return end

    -- Verify that there is something to treat
    local bodyPart = easzy.bodydamage.GetMostInjuredBodyPart(ent, "broken")
    if not bodyPart then return end

    -- Solicitar minijuego
    easzy.bodydamage.RequestMinigame(owner, "splint", self:GetClass(), bodyPart, ent)
end