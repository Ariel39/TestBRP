SWEP.PrintName          = "Bandage"
SWEP.Author             = "Easzy"
SWEP.Instructions       = ""
SWEP.Category           = "Easzy Body Damage"

SWEP.AutomaticFrameAdvance = true

SWEP.Spawnable          = true
SWEP.AdminOnly          = true

SWEP.Slot               = 3
SWEP.SlotPos            = 0

SWEP.Base               = "weapon_base"
SWEP.WorldModel         = "models/easzy/ez_body_damage/bandage/w_bandage.mdl"
SWEP.ViewModel          = "models/easzy/ez_body_damage/bandage/v_bandage.mdl"

SWEP.UseHands           = true
SWEP.HoldType           = "pistol"

SWEP.DrawAmmo           = false
SWEP.DrawCrosshair      = false
SWEP.ViewModelFOV       = 54
SWEP.ShouldDropOnDie    = false
SWEP.AutoSwitchFrom     = true
SWEP.AutoSwitchTo       = false

SWEP.Primary.ClipSize = easzy.bodydamage.config.maxStackBandage
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.BobScale = 0.5 -- (Clientside) The scale of the viewModel bob (viewModel movement from left to right when walking around)
SWEP.SwayScale = 0.5 -- (Clientside) The scale of the viewModel sway (viewModel position lerp when looking around)
