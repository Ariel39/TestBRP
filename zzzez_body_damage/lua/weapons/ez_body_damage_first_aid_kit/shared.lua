SWEP.PrintName          = "First aid kit"
SWEP.Author             = "Easzy"
SWEP.Instructions       = ""
SWEP.Category           = "Easzy Body Damage"

SWEP.AutomaticFrameAdvance = true

SWEP.Spawnable          = true
SWEP.AdminOnly          = true

SWEP.Slot               = 3
SWEP.SlotPos            = 0

SWEP.Base               = "weapon_base"
SWEP.WorldModel         = "models/easzy/ez_body_damage/first_aid_kit/w_first_aid_kit.mdl"
SWEP.ViewModel          = "models/easzy/ez_body_damage/first_aid_kit/v_first_aid_kit.mdl"

SWEP.UseHands           = true
SWEP.HoldType           = "slam"

SWEP.DrawAmmo           = false
SWEP.DrawCrosshair      = false
SWEP.ViewModelFOV       = 54
SWEP.ShouldDropOnDie    = false
SWEP.AutoSwitchFrom     = true
SWEP.AutoSwitchTo       = false

SWEP.Primary.ClipSize = easzy.bodydamage.config.maxStackFirstAidKit
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = easzy.bodydamage.config.maxHealthFirstAidKit
SWEP.Secondary.DefaultClip = easzy.bodydamage.config.maxHealthFirstAidKit
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.BobScale = 0.5 -- (Clientside) The scale of the viewModel bob (viewModel movement from left to right when walking around)
SWEP.SwayScale = 0.5 -- (Clientside) The scale of the viewModel sway (viewModel position lerp when looking around)
