AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")



function ENT:Initialize()
	-------Entity Inicial--------
	self.iModel = self.iModel or "" // potom dobavit
	self.id = self.id or "0"
	self.name = self.name or "Unknown"
	self.desc = self.desc or "Empty"
	self.count = self.count or 1
	self.Color = self.Color or Color(255,255,255,255)
	
	-----------Entity Spawn------------
	self:SetModel(self.iModel)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self:SetColor(self.Color)
	
	-----------Entity Network------------
	//self:SetNWInt("Damage",self.Damage)
end

