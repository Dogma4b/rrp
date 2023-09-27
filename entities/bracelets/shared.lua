if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Наручники"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

SWEP.Base = "weapon_cs_base2"

SWEP.Instructions = "Левый клик - аррестовать игрока\nПравый клик - освободить игрока"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "stunstick"

SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.NextStrike = 0

SWEP.ViewModel = Model("models/weapons/v_stunbaton.mdl")
SWEP.WorldModel = Model("models/weapons/w_stunbaton.mdl")

SWEP.Sound = Sound("weapons/stunstick/stunstick_swing1.wav")

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:PrimaryAttack()
	if CurTime() < self.NextStrike then return end

	self:SetWeaponHoldType("melee")
	timer.Simple(0.3, function() if self:IsValid() then self:SetWeaponHoldType("normal") end end)

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:EmitSound(self.Sound)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)

	self.NextStrike = CurTime() + .4

	if CLIENT then return end

	local trace = self.Owner:GetEyeTrace()

	if IsValid(trace.Entity) and trace.Entity:IsPlayer() and trace.Entity:IsCP() and not GAMEMODE.Config.cpcanarrestcp then
		GAMEMODE:Notify(self.Owner, 1, 5, "Ты неможешь арестовывать других полицейских")
		return
	end

	if trace.Entity:GetClass() == "prop_ragdoll" then
		for k,v in pairs(player.GetAll()) do
			if trace.Entity.OwnerINT and trace.Entity.OwnerINT == v:EntIndex() and GAMEMODE.KnockoutToggle then
				GAMEMODE:KnockoutToggle(v, true)
				return
			end
		end
	end

	if not IsValid(trace.Entity) or (self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 115) or (not trace.Entity:IsPlayer() and not trace.Entity:IsNPC()) then
		return
	end

	if not GAMEMODE.Config.npcarrest and trace.Entity:IsNPC() then
		return
	end

	if GAMEMODE.Config.needwantedforarrest and not trace.Entity:IsNPC() and not trace.Entity.DarkRPVars.wanted then
		GAMEMODE:Notify(self.Owner, 1, 5, "Тебе нужен ордер чтобы аррестовать этого игрока.")
		return
	end

	if FAdmin and trace.Entity:IsPlayer() and trace.Entity:FAdmin_GetGlobal("fadmin_jailed") then
		GAMEMODE:Notify(self.Owner, 1, 5, "Ты неможешь аррестовать игрока которого посадил за решётку админ :0.")
		return
	end

	local jpc = DB.CountJailPos()

	if not jpc or jpc == 0 then
		GAMEMODE:Notify(self.Owner, 1, 4, "Ты неможеш аррестовать игроков пока не установлена позиция тюремной камеры!")
	else
		-- Send NPCs to Jail
		if trace.Entity:IsNPC() then
			trace.Entity:SetPos(DB.RetrieveJailPos())
		else
			if not trace.Entity.Babygod then
				trace.Entity:Arrest()
				GAMEMODE:Notify(trace.Entity, 0, 20, "Ты был аррестован " .. self.Owner:Nick())

				if self.Owner.SteamName then
					DB.Log(self.Owner:SteamName().." ("..self.Owner:SteamID()..") аррестовал "..trace.Entity:Nick(), nil, Color(0, 255, 255))
				end
			else
				GAMEMODE:Notify(self.Owner, 1, 4, "Ты не можешь аррестовать мёртвого человека О_о.")
			end
		end
	end
end

function SWEP:SecondaryAttack()
if CurTime() < self.NextStrike then return end

	self:SetWeaponHoldType("melee")
	timer.Simple(0.3, function() if self:IsValid() then self:SetWeaponHoldType("normal") end end)

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:EmitSound(self.Sound)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)

	self.NextStrike = CurTime() + .4

	if CLIENT then return end

	local trace = self.Owner:GetEyeTrace()

	if not IsValid(trace.Entity) or not trace.Entity:IsPlayer() or (self.Owner:EyePos():Distance(trace.Entity:GetPos()) > 115) or not trace.Entity.DarkRPVars.Arrested then
		return
	end

	trace.Entity:Unarrest()
	GAMEMODE:Notify(trace.Entity, 0, 4, "Ты был освобождён человеком " .. self.Owner:Nick())

	if self.Owner.SteamName then
		DB.Log(self.Owner:SteamName().." ("..self.Owner:SteamID()..") отпустил "..trace.Entity:Nick(), nil, Color(0, 255, 255))
	end
end
