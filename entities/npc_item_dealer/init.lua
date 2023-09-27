AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize( ) 
 
	self:SetModel( "models/Humans/Group01/male_09.mdl" )
	self:SetHullType( HULL_HUMAN ) 
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX ) 
	self:CapabilitiesAdd( CAP_ANIMATEDFACE , CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE ) 
	self:DropToFloor()
 
	self:SetMaxYawSpeed( 90 ) 
 
end

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
		umsg.Start("ShopNpcItemUsed", Caller) 
		umsg.End() 
	end
end

function FirstSpawn( ply )
 
end
 
hook.Add( "PlayerInitialSpawn", "playerInitialSpawn", FirstSpawn )
RRP = RRP
concommand.Add("buy_disposable_masterkey", function(ply) RRP.AddNewItem(ply, 301, 7) end)
concommand.Add("buy_battarey", function(ply) RRP.AddNewItem(ply, 302, 1) end)
//concommand.Add("buy_kobra", function(ply) ply:AddMoney(-1000) ply:ConCommand("buy_kobra_attachment") end)
//concommand.Add("buy_aimpoint", function(ply) ply:AddMoney(-1000) ply:ConCommand("buy_aimpoint_attachment") end)
//concommand.Add("buy_ballistic", function(ply) ply:AddMoney(-1000) ply:ConCommand("buy_ballistic_attachment") end)
//concommand.Add("buy_vertgrip", function(ply) ply:AddMoney(-1000) ply:ConCommand("buy_vertgrip_attachment") end)