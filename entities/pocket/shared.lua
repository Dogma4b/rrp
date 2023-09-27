if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Инвентарь"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Base = "weapon_cs_base2"

SWEP.Author = "RRP Teams"
SWEP.Instructions = "Левой кнопкой ты можеш подобрать вещь\n Вещи в инвентаре доступны из основного меню"
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

	local trace = self.Owner:GetEyeTrace()

	if self.Owner:EyePos():Distance(trace.HitPos) > 90 then
		return
	end
	if CLIENT then
	timer.Destroy("timer1")
	timer.Create("timer1", 0.1, 1, function(ply) RunConsoleCommand("enttotable") end)
//timer.Simple(1, function(ply) RunConsoleCommand("enttotable") end)
end
	
	
	
end

function SWEP:SecondaryAttack()

end