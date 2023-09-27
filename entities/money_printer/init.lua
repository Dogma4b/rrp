AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.iModel = "models/props_c17/consolebox05a.mdl"

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end
	self.Damage = (self.Damage or 100) - dmg:GetDamage()
	self:CheckDamage()
end

function ENT:CheckDamage()
	if self.Damage <= 0 then
		self.Damage = 0
		if self:WaterLevel() > 0 then
			self:Destruct()
			self:Remove()
		else
			self:BurstIntoFlames()
		end
	end
	self:SetNWInt("Damage",self.Damage)
	self:SetNWInt("CoolerUses",self.CoolerUses)
	self:SetNWInt("Temperature",self.Temperature)
end

function ENT:Initialize()
	self:SetModel(self.iModel)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	self.Damage = self.Damage or 100
	self.Money = self.Money or 0
	self.lvl = self.lvl or 1
	self.Temperature = self.Temperature or 0
	self.Cooled = self.Cooled or 0.5
	self.MoneyPerPrint = self.MoneyPerPrint or 20
	self.Enable = self.Enable or 1
	self.IsMoneyPrinter = true
	self.Color=self.Color or Color(255,255,255,255)
	self:SetColor(self.Color)
	self:SetNWInt("Printed",self.Money)
	self:SetNWInt("Damage",self.Damage)
	self:SetNWInt("Upgrade",self.lvl)
	self:SetNWInt("Temperature",self.Temperature)
end

//function ENT:MoneyPerPrint(ply,cmd,args)
	//if self.MoneyPerPrintValue !=args[1] then
	//printer.MoneyPerPrintValue = 100
	//end
//end
//concommand.Add("setmoneyperprint", ENT:MoneyPerPrint)

function ENT:BurstIntoFlames()
/*if self.HasCooler then
		self.CoolerUses = self.CoolerUses-1
		//self:SetNWInt("CoolerUses",self.CoolerUses)
		if self.CoolerUses <= 0 then
			DarkRP.notify(self.dt.owning_ent, 0, 4, "Твой денежный принтер был реанимирован однако кулер был уничтожен!")
			self.Damage = 100
			if self.HasCooler:IsValid() then self.HasCooler:Remove() end
			self.HasCooler = nil
			self.HadCooler = true
		else
			self.Damage = 100
			DarkRP.notify(self.dt.owning_ent, 0, 4, "Твой денежный принтер был реанимирован кулером (осталось ".. self.CoolerUses .." юза)")
		end
		return
	end*/
	if self.burningup then return end
	DarkRP.notify(self.dt.owning_ent, 1, 4, "Ваш денежный принтер горит!")
	self.burningup = true
	local burntime = math.random(8, 18)
	self:Ignite(20, 0)
	timer.Simple(burntime, function() self:Fireball() end)
end
function ENT:Fireball()
	if not self:IsOnFire() then return end
	local dist = math.random(20, 90) -- Explosion radius
	self:Destruct()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), dist)) do v:Ignite(math.random(20, 30), 0) end
	self:Remove()
end

function ENT:Think()
	self.lvl = self:GetNWInt("Upgrade")
	if self:WaterLevel() > 0 then
		self.Damage=self.Damage-20
	end
	if self.Enable > 0 then
	self:PrintSome()
	self.Temperature = self.Temperature + self.MoneyPerPrint/20 * (self:GetNWInt("Upgrade")/2)
	if self.Temperature > 90 then self.Damage=self.Damage-math.random(5,10) /*self.MoneyPerPrint = 20*/ end
	end
	self:CheckDamage() 
	
	if self.Temperature > 100 then  self.Temperature = 100 elseif self.Temperature < 0 then self.Temperature = 0 end
	self.Temperature = self.Temperature - self.Cooled
	self:NextThink(CurTime() + math.random(3,5))
	return true
end

function MPerPrint(ply,cmd,args)
ent = ply:GetEyeTrace().Entity
if ent.dt.owning_ent != ply then return end
if tonumber( args[1] ) > 300 then DarkRP.notify(ply, 2, 4, "Максимально возможный предел печати данного принтера 300 рублей") return end
ent.MoneyPerPrint = args[1]
end
concommand.Add("moneyperprint", MPerPrint)

function EnablePrinter(ply,cmd,args)
ent = ply:GetEyeTrace().Entity
//if tonumber( args[1] ) > 300 then DarkRP.notify(ply, 2, 4, "Максимально возможный предел печати данного принтера 300 рублей") return end
ent.Enable = tonumber(args[1])

end
concommand.Add("enable_money_printer", EnablePrinter) 

-- print some money
function ENT:PrintSome()
	if self.Damage<=0 then return end
	local lvlprinter = self:GetNWInt("Upgrade")
	if lvlprinter > 1 then
	self.Money=self.Money + self.MoneyPerPrint*lvlprinter
	else
	self.Money=self.Money + self.MoneyPerPrint
	end
	self:Spark()
	self:SetNWInt("Printed",self.Money)
end

function ENT:Spark()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())
	effectdata:SetMagnitude(1)
	effectdata:SetScale(1)
	effectdata:SetRadius(1)
	util.Effect("Sparks", effectdata)
end

function ENT:AcceptInput( Name, Activator, Caller )	
	self:SetUseType(SIMPLE_USE)
	if Name == "Use" and Caller:IsPlayer() then
	local owner = self.dt.owning_ent
	owner = (IsValid(owner) and owner:Nick()) or "~unknown~"
		umsg.Start("Printer_Menu", Caller)
			umsg.String(owner)
		umsg.End() 
	end
end

function PickUpMoney(ply)
ent = ply:GetEyeTrace().Entity 
if not ent:IsValid() then DarkRP.notify(ply, 2, 4, "Ты должен смотреть на принтер чтобы собрать деньги") return end
if not ply:IsPlayer() or ent.Money <= 0 then return end
	ent:EmitSound("/ambient/office/coinslot1.wav", 100, 100)
	print(ent.Money)
	ply:addMoney(ent.Money)
	DarkRP.notify(ply, 2, 4, "Вы собрали $"..ent.Money.." с денежного принтера.")
	ent.Money = 0
	ent:SetNWInt("Printed",0)
end
concommand.Add("pickup_prnt_money", PickUpMoney)

function HackMoneyPrinter(ply)
	local ent = ply:GetEyeTrace().Entity 


if not ent:IsValid() then DarkRP.notify(ply, 2, 4, "Ты должен смотреть на принтер чтобы взломать его") return end

	local owner = ent.dt.owning_ent
	local eid = ent:EntIndex()

if owner != ply then
		umsg.Start("SendMeter",ply)
			umsg.String("Попытка взлома принтера...")
			umsg.Float(25)
		umsg.End()
		
		local sec = 0
		timer.Create("StealPrinter_" .. eid,1,0,function()
			if !ply or !ply:IsValid() then timer.Remove("StealPrinter_" .. eid) return end
			if !ent or !ent:IsValid() or !ply:GetEyeTrace().Entity or !ply:GetEyeTrace().Entity:IsValid() or ply:GetEyeTrace().Entity != ent.Entity then
				umsg.Start("CancelMeter",ply) umsg.End()
				timer.Remove("StealPrinter_" .. eid)
				return
			end
			ent:EmitSound("ambient/alarms/klaxon1.wav",60,120)
			sec = sec+1
			if sec > 25 then
				ent.dt.owning_ent = ply
				ply:addMoney(ent.Money)
				DarkRP.notify(ply, 0, 4, "Ты успешно взломал принтер игрока " ..ent.dt.owning_ent:Name().. " и получил "..ent.Money.." рублей.")
				ent.Money = 0
				ent:SetNWInt("Printed",0)
				timer.Remove("StealPrinter_" .. eid)
			end
		end)
	
		return
	end

end
concommand.Add("hack_money_printer", HackMoneyPrinter)


function ConfiscatePrinter(ply)
	local ent = ply:GetEyeTrace().Entity 


if not ent:IsValid() then DarkRP.notify(ply, 2, 4, "Ты должен смотреть на принтер чтобы конфисковать его") return end

	local eid = ent:EntIndex()

if ply:Team() == TEAM_POLICE then
	umsg.Start("SendMeter",ply)
			umsg.String("Конфискация принтера...")
			umsg.Float(10)
		umsg.End()
		
		local sec = 0
		timer.Create("ConsfiscatePrinter_" .. eid,1,0,function()
			if !ply or !ply:IsValid() then timer.Remove("ConsfiscatePrinter_" .. eid) return end
			if !ent or !ent:IsValid() or !ply:GetEyeTrace().Entity or !ply:GetEyeTrace().Entity:IsValid() or ply:GetEyeTrace().Entity != ent.Entity then
				umsg.Start("CancelMeter",ply) umsg.End()
				timer.Remove("ConsfiscatePrinter_" .. eid)
				return
			end
			ent:EmitSound("ambient/alarms/klaxon1.wav",60,120)
			sec = sec+1
			if sec > 10 then
	
		DarkRP.notify(ply, 0, 4, "Вы получили ".. math.Round(ent.Money/1.3) .."$ за конфискацию принтера")
		ply:addMoney(math.Round( ent.Money/1.3 ))
		ent:Remove()
		timer.Remove("ConsfiscatePrinter_" .. eid)
			end
		end)
		return
	end

end
concommand.Add("confiscate_printer", ConfiscatePrinter)

/*function ENT:Use(ply, activator)
----------------Call Menu-------------
----------------Menu end--------------
	local eid = self:EntIndex()

	if activator:Team() == TEAM_POLICE then
	umsg.Start("SendMeter",ply)
			umsg.String("Конфискация принтера...")
			umsg.Float(10)
		umsg.End()
		
		local sec = 0
		timer.Create("ConsfiscatePrinter_" .. eid,1,0,function()
			if !ply or !ply:IsValid() then timer.Remove("ConsfiscatePrinter_" .. eid) return end
			if !self or !self:IsValid() or !ply:GetEyeTrace().Entity or !ply:GetEyeTrace().Entity:IsValid() or ply:GetEyeTrace().Entity != self.Entity then
				umsg.Start("CancelMeter",ply) umsg.End()
				timer.Remove("ConsfiscatePrinter_" .. eid)
				return
			end
			self:EmitSound("ambient/alarms/klaxon1.wav",60,120)
			sec = sec+1
			if sec > 10 then
	
		DarkRP.notify(activator, 0, 4, "Вы получили ".. math.Round(self.Money/1.3) .."$ за конфискацию принтера")
		activator:AddMoney(math.Round( self.Money/1.3 ))
		self:Remove()
		timer.Remove("ConsfiscatePrinter_" .. eid)
			end
		end)
		return
	end
	
	
	if self.dt.owning_ent != ply then
		umsg.Start("SendMeter",ply)
			umsg.String("Попытка взлома принтера...")
			umsg.Float(25)
		umsg.End()
		
		local sec = 0
		timer.Create("StealPrinter_" .. eid,1,0,function()
			if !ply or !ply:IsValid() then timer.Remove("StealPrinter_" .. eid) return end
			if !self or !self:IsValid() or !ply:GetEyeTrace().Entity or !ply:GetEyeTrace().Entity:IsValid() or ply:GetEyeTrace().Entity != self.Entity then
				umsg.Start("CancelMeter",ply) umsg.End()
				timer.Remove("StealPrinter_" .. eid)
				return
			end
			self:EmitSound("ambient/alarms/klaxon1.wav",60,120)
			sec = sec+1
			if sec > 25 then
				self.dt.owning_ent = ply
				activator:AddMoney(self.Money)
				DarkRP.notify(ply, 0, 4, "Ты успешно взломал принтер игрока " ..self.dt.owning_ent:Name().. " и получил "..self.Money.." рублей.")
				self.Money = 0
				self:SetNWInt("Printed",0)
				timer.Remove("StealPrinter_" .. eid)
			end
		end)
	
		return
	end
	
	if not activator:IsPlayer() or self.Money <= 0 then return end
	self:EmitSound("/ambient/office/coinslot1.wav", 100, 100)
	activator:AddMoney(self.Money)
	DarkRP.notify(activator, 2, 4, "Вы собрали $"..self.Money.." с денежного принтера.")
	self.Money = 0
	self:SetNWInt("Printed",0)
end*/

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	--fu_explode.explode(self:GetPos(),"metalgibs",24,400)
	util.Effect("Explosion", effectdata)
	DarkRP.notify(self.dt.owning_ent, 1, 4, "Ваш денежный принтер взорвался!")
end