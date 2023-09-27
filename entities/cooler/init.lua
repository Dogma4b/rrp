AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/nukeftw/faggotbox.mdl");
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end
end

function ENT:Touch(ent)
	if ent:IsValid() and (ent:GetClass() == "money_printer" or ent:GetClass() == "money_printer_silver") and !ent.HasCooler then
		if ent.HadCooler then
			local ply = self.Entity.dt.owning_ent
			if ply and ply:IsValid() then GAMEMODE:Notify(ply, 1, 4, "В этом принтере повреждён слот для кулера.") end
			return
		end
		self:Remove()
		ent:SetAngles(Angle(0,0,0))
		ent.Cooled = 1.5
		local CoolerFake = ents.Create("prop_physics")
		CoolerFake:SetModel("models/nukeftw/faggotbox.mdl")
		CoolerFake:SetMoveType(MOVETYPE_NONE)
		CoolerFake:SetNotSolid(true)
		CoolerFake:SetParent(ent)
		CoolerFake:SetAngles(Angle(180,180,90))
		CoolerFake:SetPos(ent:GetPos()-Vector(13, -6, -5))
		CoolerFake:Spawn()
		ent.HasCooler = CoolerFake
	end
end

function ENT:Use(ply, caller)
	self:Remove()
	ply:AddItem("cooler", 1)
end