AddCSLuaFile( "cl_init.lua" ) 
AddCSLuaFile( "shared.lua" )

include('shared.lua')


function ENT:Initialize( )
	
	self:SetModel( "models/mw2/cop.mdl" ) -- Модель нпс.
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE , CAP_TURN_HEAD ) -- Указывает аи нпс какие действия он может выполнять
	self:SetUseType( SIMPLE_USE ) -- Следит чтобы открывалась только 1 активное окно.
	self:DropToFloor()
	
	self:SetMaxYawSpeed( 90 ) -- Угол на который может вращаться нпс
	
end

function ENT:OnTakeDamage()
	return false -- Устанавливает бессмертие для нпс.
end 

function ENT:AcceptInput( Name, Activator, Caller )	

	if Name == "Use" and Caller:IsPlayer() then
		
		umsg.Start("jobs_police", Caller) -- Вызывает меню игроку
		umsg.End() -- Можно указать дополнительные параметры которые будут выполняться при активации нпс
		
	end
	
end
