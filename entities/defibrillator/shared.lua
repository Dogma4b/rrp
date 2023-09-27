if SERVER then
	AddCSLuaFile("shared.lua")
	
end

if CLIENT then
SWEP.PrintName = "Дефибриллятор"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true

end

SWEP.Base = "weapon_cs_base2"

SWEP.Author = "RRP Teams"
SWEP.Instructions = "Ты можешь оживить человека"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "rpg"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

local DropItem

if CLIENT then
	SWEP.FrameVisible = false
end

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:Deploy()
	if SERVER then
		self.Owner:DrawViewModel(false)
		self.Owner:DrawWorldModel(false)
	end
end

function SWEP:PrimaryAttack()
if SERVER then

	ply = self.Owner
	local trace = ply:GetEyeTrace()
	if(ply:EyePos():Distance(trace.HitPos)>150) then else
	for k,v in pairs ( player.GetAll()) do //print(k) print(v)
	if v:Alive() or v:GetPos():Distance(trace.HitPos) > 150 then else
	timer.Destroy("defib"..v:Nick())
		umsg.Start("SendMeter",ply)
			umsg.String("Зарядка дефибриллятора...")
			umsg.Float(3)
		umsg.End()
	timer.Create("defib"..v:Nick(), 3, 1, function(ply) 
	ply = self.Owner
	if math.Rand(1,5) > 3 then
	pos = v:GetPos()
	v:Spawn()
	v:SetHealth(25)
	v:SetSelfDarkRPVar("Energy", 25)
	ply:AddMoney(55) GAMEMODE:Notify(ply, 2, 4, v:Nick() .. " заплатил тебе 55$ за спасение своей жизни")
	v:AddMoney(-55) GAMEMODE:Notify(v, 2, 4, "Ты заплатил медику " .. ply:Nick() .. " за спасение своей жизни")
	v:SetPos( pos )
	v:UnLock()
	
	timer.Destroy("RemoveTimerSpawn"..v:Nick())
	umsg.Start("CancelMeter",v) umsg.End()
	else GAMEMODE:Notify(ply, 1, 4, "Пациента оживить не удалось")
	end
	end)
	end
	end 
	end
end
end