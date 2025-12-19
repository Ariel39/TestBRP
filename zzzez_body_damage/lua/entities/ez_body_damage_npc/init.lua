AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD))
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self:SetMaxYawSpeed(90)
end

util.AddNetworkString("ezbodydamage_open_npc_menu")

function ENT:Use(activator)
	if not activator:IsPlayer() or not activator:Alive() then return end
	if not easzy.bodydamage.GetInDistance(self, activator, 80) then return end

	net.Start("ezbodydamage_open_npc_menu")
	net.Send(activator)
end
