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
    self:SetClip2(easzy.bodydamage.config.maxHealthFirstAidKit)

    if newQuantity == 0 then
        local owner = self:GetOwner()
        if not IsValid(owner) then return end

        local weaponClass = self:GetClass()
        if not weaponClass then return end

        owner:StripWeapon(weaponClass)
        owner:SelectWeapon(easzy.bodydamage.config.hands)
    end
end

function SWEP:UseSecondaryAmmo(quantity)
    local clip2 = self:Clip2()
    if clip2 == 0 then return end

    local newQuantity = clip2 - quantity
    local remaining = -newQuantity
    if newQuantity < 0 then
        newQuantity = 0
    else
        remaining = 0
    end

    self:SetClip2(newQuantity)

    if newQuantity == 0 then
        self:UseAmmo()
    end

    return remaining
end

function SWEP:PrimaryAttack(bodyPart)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    -- To counter double uses
    local currentAnimation = easzy.bodydamage.GetViewModelAnimationName(owner)
    if currentAnimation == "use" then return end
    if not bodyPart and currentAnimation == "take_out" then return end

    -- Si no hay score de minijuego, solicitar minijuego
    if not self.minigameScore then
        -- Verify that there is something to treat
        local targetBodyPart = bodyPart or easzy.bodydamage.GetMostInjuredBodyPart(owner)
        if not targetBodyPart then return end
        
        -- Solicitar minijuego al cliente
        easzy.bodydamage.RequestMinigame(owner, "firstaid", self:GetClass(), targetBodyPart, owner)
        return
    end

    -- Plays the sound
    owner:EmitSound("easzy/ez_body_damage/first_aid_kit.mp3")

    local function Use(ply)
        if not IsValid(owner) or not owner:IsPlayer() or not owner:Alive() then return end
        if not IsValid(ply) then return end
        if not IsValid(self) then return end

        -- Get maximum health we can give
        local clip2 = self:Clip2()
        if clip2 == 0 then return end
        
        local targetBodyPart = self.minigameBodyPart or bodyPart
        
        -- El score afecta cuánto cura
        local score = self.minigameScore or 0.5
        local effectiveHealth = math.floor(clip2 * score)

        local remaining = easzy.bodydamage.HealthBodyPart(ply, targetBodyPart, effectiveHealth)
        local used = effectiveHealth - remaining
        self:UseSecondaryAmmo(used)
        
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

        -- If ent is a ragdoll, means a player is dead
        local entIsRagdoll = ent:IsRagdoll()
        
        -- Plays the sound
        owner:EmitSound("easzy/ez_body_damage/first_aid_kit.mp3")

        local function Use(ply)
            if not IsValid(owner) or not owner:IsPlayer() or not owner:Alive() then return end
            if not IsValid(ply) then return end
            if not IsValid(self) then return end

            local entIsRagdoll = ent:IsRagdoll()
            if entIsRagdoll then
                ply = ply:CPPIGetOwner()
            end

            -- Get maximum health we can give
            local clip2 = self:Clip2()
            if clip2 == 0 then return end

            -- Score afecta curación
            local score = self.minigameScore or 0.5
            local effectiveHealth = math.floor(clip2 * score)

            -- If the player is dead, revive
            if easzy.bodydamage.PlayerCanRevive(owner) and entIsRagdoll then
                local halfClip = math.floor(effectiveHealth/2)
                local headRemaining = easzy.bodydamage.HealthBodyPart(ply, "Head", halfClip)
                local bodyRemaining = easzy.bodydamage.HealthBodyPart(ply, "Body", halfClip)
                local used = halfClip * 2 - (headRemaining + bodyRemaining)
                self:UseSecondaryAmmo(used)

                easzy.bodydamage.UpdateAllHealth(ply)

                -- In order not to reset body health on respawn
                ply.easzy.bodydamage.dontResetBodyHealth = true
                easzy.bodydamage.Respawn(ply)
                
                -- Limpiar
                self.minigameScore = nil
                self.minigameQuality = nil
                self.minigameTarget = nil
                self.minigameBodyPart = nil
                return
            end

            local targetBodyPart = self.minigameBodyPart
            if not targetBodyPart then return end

            local remaining = easzy.bodydamage.HealthBodyPart(ply, targetBodyPart, effectiveHealth)
            local used = effectiveHealth - remaining
            self:UseSecondaryAmmo(used)
            
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
    if not IsValid(ent) or not easzy.bodydamage.GetInDistance(ent, owner, 200) then return end

    -- If ent is a ragdoll, means a player is dead, we verify if the owner is allowed to revive someone
    local entIsRagdoll = ent:IsRagdoll()
    if (entIsRagdoll and not easzy.bodydamage.PlayerCanRevive(owner)) or (not entIsRagdoll and not ent:IsPlayer()) then return end

    -- To counter double uses
    local currentAnimation = easzy.bodydamage.GetViewModelAnimationName(owner)
    if currentAnimation != "idle" then return end

    -- Verify that there is something to treat
    local bodyPart = easzy.bodydamage.GetMostInjuredBodyPart(ent)
    if not entIsRagdoll and not bodyPart then return end

    -- Solicitar minijuego (usar "Body" si está muerto)
    local targetBodyPart = entIsRagdoll and "Body" or bodyPart
    easzy.bodydamage.RequestMinigame(owner, "firstaid", self:GetClass(), targetBodyPart, ent)
end