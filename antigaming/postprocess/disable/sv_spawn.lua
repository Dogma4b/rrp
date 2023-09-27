function SpawnNpc_function()
SpawnNpc(Vector( -2121, -325, -195 ), Angle(0,180,0), "npc_attach_dealer")
SpawnNpc(Vector( -2121, -375, -195 ), Angle(0,180,0), "npc_employer")
SpawnNpc(Vector( -2121, -425, -195 ), Angle(0,180,0), "npc_donate")
SpawnNpc(Vector( -2121, -475, -195 ), Angle(0,180,0), "npc_item_dealer")
SpawnNpc(Vector( -2121, -525, -195 ), Angle(0,180,0), "npc_employer_police")
end
hook.Add("InitPostEntity","SpawnTheProps",timer.Simple(1,SpawnNpc_function))

function SpawnNpc(position, angl, entity)
	local ent = ents.Create(entity) 
	local ang = angl
	ent:SetAngles(ang)
	local pos = position
	pos.z = pos.z - ent:OBBMaxs().z
	ent:SetPos( pos )
	ent:Spawn() 
end