ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer"
ENT.Author = "grinchfox and Luna"
ENT.Spawnable = false
ENT.AdminSpawnable = false
//ENT.MoneyPerPrint = 20
ENT.DamageLow = 1
ENT.DamageHigh = 2	
ENT.Color = Color(192,220,255)
ENT.iName = "Base Printer"

function ENT:SetupDataTables()
	self:DTVar("Int",0,"price")
	self:DTVar("Entity",1,"owning_ent")
end