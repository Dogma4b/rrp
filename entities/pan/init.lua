// Antigaming Team 2014 //

AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_interiors/pot01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
end

function ENT:AcceptInput( Name, Activator, Caller )	
	self:SetUseType(SIMPLE_USE)
	if Name == "Use" and Caller:IsPlayer() then
		umsg.Start("Ent_Crafting_Menu", Caller)
			umsg.String(self:EntIndex())
		umsg.End() 
	end
end