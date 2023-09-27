require("glon")
RRP = {}

util.AddNetworkString("SendRequestInventoryToServer")
	net.Receive( "SendRequestInventoryToServer", function(len, ply) 
	util.AddNetworkString("SendTableEntity") 
	net.Start( "SendTableEntity" )
				net.WriteTable( ply.rrp_inventory  ) 
	net.Send(ply)
		print ("Request Player Inventory complete") 
	end)

function RRP.LoadInventory(ply)
if file.Exists( "inventory/".. ply:UniqueID() ..".txt", "DATA" ) then
invcoded = file.Read("inventory/".. ply:UniqueID() ..".txt")
ply.rrp_inventory = glon.decode(invcoded)

	util.AddNetworkString("SendTableEntity") 
	net.Start( "SendTableEntity" )
				net.WriteTable( ply.rrp_inventory  ) 
	net.Send(ply)//broadcast eto vsem clientam lol Ups neto xD
	MsgN("Player Inventory Loaded")
	else
	if(ply.rrp_inventory==nil) then
		ply.rrp_inventory = {}
		for x=1,10 do
			ply.rrp_inventory[x]={}
			for y=1,10 do	
				ply.rrp_inventory[x][y]=0
			end
		end
	end
	InventorySave(ply)
	MsgN("Player First Spawn")
	end
end
hook.Add( "PlayerInitialSpawn", "Player Loaded Inventory", RRP.LoadInventory )

function InventorySave(ply)
file.Write("inventory/".. ply:UniqueID() ..".txt", glon.encode(ply.rrp_inventory))
end

function RRP.AddItm(ply)
	local ent = ply:GetEyeTrace().Entity
	
	local blacklist = {"worldspawn", "func_", "door", "player", "npc_"}
	for k,v in pairs(blacklist) do
	if string.find(string.lower(ent:GetClass()), v) then MsgN("Player "..ply:Name().." tried adding rejected item ".. v .. "in your inventory") return end
	end
	
	//if ent:GetClass() == "worldspawn"  then return end
	if(ply.rrp_inventory==nil) then
		ply.rrp_inventory = {}
		for x=1,10 do
			ply.rrp_inventory[x]={}
			for y=1,10 do	
				ply.rrp_inventory[x][y]=0
			end
		end
	end
	local freeslot = getEmptySlot(ply.rrp_inventory)
	if(freeslot==nil)then MsgN("net mesta v inventare!") return end//net svobodnogo mesta v inventare
	ply.rrp_inventory[freeslot.x][freeslot.y]={}
	if ent:GetClass() == "spawned_weapon" then
	ply.rrp_inventory[freeslot.x][freeslot.y].class = ent.weaponclass //MsgN( ent.GetAmmoCount(ent.weaponclass:GetPrimaryAmmoType()))
	ply.rrp_inventory[freeslot.x][freeslot.y].clip = ent.clip1
	elseif
	(ent:GetClass() == "money_printer" /*or ent:GetClass() == "money_printer_silver"*/) then
	ply.rrp_inventory[freeslot.x][freeslot.y].class = ent:GetClass() 
	ply.rrp_inventory[freeslot.x][freeslot.y].money = ent.Money
	ply.rrp_inventory[freeslot.x][freeslot.y].damage = ent.Damage
	ply.rrp_inventory[freeslot.x][freeslot.y].temperature = ent.Temperature
	ply.rrp_inventory[freeslot.x][freeslot.y].lvl = ent.lvl
	ply.rrp_inventory[freeslot.x][freeslot.y].cooled = ent.Cooled
	elseif 
	(ent:GetClass() == "spawned_shipment" ) then
	ply.rrp_inventory[freeslot.x][freeslot.y].class = ent:GetClass() 
	ply.rrp_inventory[freeslot.x][freeslot.y].content = ent.dt.contents
	ply.rrp_inventory[freeslot.x][freeslot.y].count = ent.dt.count
	//ply.rrp_inventory[freeslot.x][freeslot.y].name = ent.dt.name
	elseif 
	(ent:GetClass() == "item_base" ) then
	ply.rrp_inventory[freeslot.x][freeslot.y].class = "item_base"
	ply.rrp_inventory[freeslot.x][freeslot.y].id = ent.id
	ply.rrp_inventory[freeslot.x][freeslot.y].count = ent.count
	else
	ply.rrp_inventory[freeslot.x][freeslot.y].class = ent:GetClass() 
	end
	ply.rrp_inventory[freeslot.x][freeslot.y].model = ent:GetModel() 
	ent:Remove()
	//nu poka vse
    //   0  1  2  3  4  5  6  7 ->X
	//0 01 02 03 04 05 06 07 08 
	//1 09 10 11 12 13 14 15 16
	//2 17 18 19 20 21 22 23 24
	//|
	//Y
	//Width = 8
	
	// INDEXOF(0,0)+W=INDEXOF(0,1)
	//Y = I%8 stroki
	//X = I-Y*8 stolbci
	// is odnomernogo massiva 2xmernii
	
	util.AddNetworkString("SendTableEntity") 
	net.Start( "SendTableEntity" )
				net.WriteTable( ply.rrp_inventory  ) 
	net.Send(ply)
	
file.Write("inventory/".. ply:UniqueID() ..".txt", glon.encode(ply.rrp_inventory))
end

function RRP.AddNewItem(ply,id,count)
if(ply.rrp_inventory==nil) then
		ply.rrp_inventory = {}
		for x=1,10 do
			ply.rrp_inventory[x]={}
			for y=1,10 do	
				ply.rrp_inventory[x][y]=0
			end
		end
	end
	local slot = RRP.CheckItem(ply,id)
	if slot == nil then
		local freeslot = getEmptySlot(ply.rrp_inventory)
		if(freeslot==nil)then MsgN("net mesta v inventare!") return end//net svobodnogo mesta v inventare
		ply.rrp_inventory[freeslot.x][freeslot.y]={}
		
		ply.rrp_inventory[freeslot.x][freeslot.y].class = "item_base"
		ply.rrp_inventory[freeslot.x][freeslot.y].id = id
		ply.rrp_inventory[freeslot.x][freeslot.y].count = count
		//ply.rrp_inventory[freeslot.x][freeslot.y].CreditCardAccountMoney = AccountMoney
	else
		ply.rrp_inventory[slot.x][slot.y].count = ply.rrp_inventory[slot.x][slot.y].count + count
	end
	
	
	util.AddNetworkString("SendTableEntity") 
	net.Start( "SendTableEntity" )
				net.WriteTable( ply.rrp_inventory  ) 
	net.Send(ply)
	
file.Write("inventory/".. ply:UniqueID() ..".txt", glon.encode(ply.rrp_inventory))
end

/*function AddInventoryCreditCard(Account,owner,AccountMoney)
if(ply.rrp_inventory==nil) then
		ply.rrp_inventory = {}
		for x=1,10 do
			ply.rrp_inventory[x]={}
			for y=1,10 do	
				ply.rrp_inventory[x][y]=0
			end
		end
	end
	local freeslot = getEmptySlot(ply.rrp_inventory)
	if(freeslot==nil)then MsgN("net mesta v inventare!") return end//net svobodnogo mesta v inventare
	ply.rrp_inventory[freeslot.x][freeslot.y]={}
	
	ply.rrp_inventory[freeslot.x][freeslot.y].CreditCardAccount = Account
	ply.rrp_inventory[freeslot.x][freeslot.y].CreditCardOwner = owner
	ply.rrp_inventory[freeslot.x][freeslot.y].CreditCardAccountMoney = AccountMoney
	
	
	util.AddNetworkString("SendTableEntity") 
	net.Start( "SendTableEntity" )
				net.WriteTable( ply.rrp_inventory  ) 
	net.Send(ply)
	
file.Write("inventory/".. ply:UniqueID() ..".txt", glon.encode(ply.rrp_inventory))
end*/

function AG.CheckItemInventory(ply,id)
	for k,v in pairs(ply.rrp_inventory) do
		for l,item in pairs(v) do
			if istable(item) && item.id == id then
				return item.count
			end
		end
	end
end

function RRP.CheckItem(ply,id)
	for k,v in pairs(ply.rrp_inventory) do
		for l,item in pairs(v) do
			if istable(item) && item.id == id then
				return {x=k,y=l}
			end
		end
	end
end
concommand.Add("check_item",function(ply,cmd,args) RRP.CheckItem(ply,args[1]) end)

function getEmptySlot(tab)
	for X=1,table.Count(tab) do 
		for Y=1,table.Count(tab[X]) do
			if tab[X][Y]==0 then
				return {x=X,y=Y}//klu4i:x,y 
			end
		end
	end
	return nil
end
//ne eto nenushno esli ti budesh udalat veshi da
//func inventoyhasentity(ENTITY)
//func getfirstemptsylot()
//func putentitytoslot(X,Y)
//func getentityfromslot(X,Y)
// tebe nushni eti funkcii kak minimum pishi ih xD

function RRP.ListInventory(ply)
	ply.rrp_inventory = ply.rrp_inventory or {}
	
	MsgN("YOUR INVENTORY:")
	for X=1,table.Count(ply.rrp_inventory) do 
		for Y=1,table.Count(ply.rrp_inventory[X]) do
			if(ply.rrp_inventory[X][Y]!=0)then
				MsgN("    ["..X..","..Y.."] "..ply.rrp_inventory[X][Y].class.." "..ply.rrp_inventory[X][Y].model)
			end
		end
	end
	
	file.Write("data.txt", ply.rrp_inventory)
end
function RRP.ClearInventory(ply)
	ply.rrp_inventory=nil
end
concommand.Add("enttotable", RRP.AddItm)
concommand.Add("ent_list_inventory", RRP.ListInventory)
concommand.Add("ent_clear_inventory", RRP.ClearInventory)

function RRP.SpawnEntity(ply,command,args)
//if table.HasValue( ply.rrp_class, args[1] ) then // Checks if the table has "milk" in it
local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 85
		trace.filter = ply

		local tr = util.TraceLine(trace)
  MsgN("ARGX "..args[1])
  MsgN("ARGY "..args[2])
  MsgN(ply)
  MsgN(ply.rrp_inventory)
  local pitem=ply.rrp_inventory[tonumber(args[1])][tonumber(args[2])]
  
	entspawn=ents.Create(pitem.class)
	local item = AG:GetItem(pitem.id)
	if ( pitem.class == "money_printer" /*or pitem.class == "money_printer_silver"*/ ) then
		entspawn.dt.owning_ent = ply 
		entspawn.Money = pitem.money
		entspawn.Damage = pitem.damage
		entspawn.Temperature = pitem.temperature
		entspawn.lvl = pitem.lvl
		entspawn.Cooled = pitem.cooled
		if pitem.cooled > 0.5 then
			local CoolerFake = ents.Create("prop_physics")
			CoolerFake:SetModel("models/nukeftw/faggotbox.mdl")
			CoolerFake:SetMoveType(MOVETYPE_NONE)
			CoolerFake:SetNotSolid(true)
			CoolerFake:SetParent(entspawn)
			CoolerFake:SetAngles(Angle(180,180,90))
			CoolerFake:SetPos(entspawn:GetPos()-Vector(13, -6, -5))
			CoolerFake:Spawn()
		end
	elseif string.find(string.lower(pitem.class), "spawned_shipment") then
		entspawn:SetContents(pitem.content, pitem.count, 10) -- why not.
		//entspawn.contents = pitem.content
		//entspawn.contents = pitem.count
	elseif string.find(string.lower(pitem.class), "item_base") then
	entspawn.id = pitem.id
	entspawn.name = item.name
	entspawn.iModel = item.model
	entspawn.desc = item.desc
	entspawn.count = pitem.count
	end
		//entspawn.Money = 1000
	entspawn:SetModel(pitem.model or item.model)
	entspawn:SetPos(tr.HitPos)
	entspawn:Spawn()
	if string.find(string.lower(pitem.class), "cstm_") then
	entspawn:SetClip1(pitem.clip)
	end
	ply.rrp_inventory[tonumber(args[1])][tonumber(args[2])]=0
	
	util.AddNetworkString("SendTableEntity") 
	net.Start( "SendTableEntity" )
				net.WriteTable( ply.rrp_inventory  ) 
	net.Send(ply)
file.Write("inventory/".. ply:UniqueID() ..".txt", glon.encode(ply.rrp_inventory))
end 
//else
//	return 
//end
concommand.Add("testspawn", RRP.SpawnEntity)
 
function entcoded()
	MsgN("YOUR INVENTORY:")
	for id,ent in SortedPairs(ply.rrp_inventory) do
	 entcoded =	glon.encode( ent )
	end
	
print(entcoded)
end
concommand.Add("testencode", entcoded)

function LoadInventoryModules()
print("  |----Loading inventory modules----")

AG.PathInventoryModules = "darkrp_modules/antigaming/inventory/items/"

local files, folders = file.Find(AG.PathInventoryModules.."*","LUA")
local num_modules = 0

for num, folder in pairs(folders) do
	//print("Module: "..folder.." loading")
	for _, File in pairs(file.Find(AG.PathInventoryModules..folder.."/sv_*.lua","LUA")) do
		include(AG.PathInventoryModules..folder.."/"..File)
	end
	
	for _, File in pairs(file.Find(AG.PathInventoryModules..folder.."/sh_*.lua","LUA")) do
		include(AG.PathInventoryModules..folder.."/"..File)
		AddCSLuaFile(AG.PathInventoryModules..folder.."/"..File)
	end
	
	for _, File in pairs(file.Find(AG.PathInventoryModules..folder.."/cl_*.lua","LUA")) do
		AddCSLuaFile(AG.PathInventoryModules..folder.."/"..File)
	end
	print("  |>Module: "..folder.." loaded")
	num_modules = num_modules + 1
end

print("  |Loaded: "..num_modules.." inventory modules")
print("  -----------------------------------------")
end

LoadInventoryModules()

//util.AddNetworkString("Test23")
//	net.Receive( "Test23", function(len, ply) 
	
//	end)
 


//meta = FindMetaTable("Player")

//file.Write("data.txt", glon.encode(tableglon))
//lol = file.Read("data.txt", lol)


/*function CreateTableInv(ply)
ply.inv = {}
ply.inv.itm = {}
ply.inv.model = {}
util.AddNetworkString("Send123") 
	net.Start( "Send123" )
				net.WriteTable( ply.inv.itm  ) 
				net.WriteTable( ply.inv.model ) 
	net.Broadcast() 

end
concommand.Add("send_table", CreateTableInv)*/

/*function addinventory(ply)
	local trace = ply:GetEyeTrace()

	if not IsValid(trace.Entity) or (SERVER and trace.Entity:IsPlayerHolding()) then
		return
	end

	if ply:EyePos():Distance(trace.HitPos) > 65 then
		return
	end

	if CLIENT then return end

	local phys = trace.Entity:GetPhysicsObject()
	if not phys:IsValid() then return end
	local mass = trace.Entity.RPOriginalMass and trace.Entity.RPOriginalMass or phys:GetMass()

	ply:GetTable().Pocket = ply:GetTable().Pocket or {}
	if not trace.Entity:CPPICanPickup(ply) or trace.Entity.IsPocketed or trace.Entity.jailWall then
		GAMEMODE:Notify(ply, 1, 4, "Ты неможеш положить эту вещь в свой инвентарь!")
		return
	end
	for k,v in pairs(blacklist) do
		if string.find(string.lower(trace.Entity:GetClass()), v) then
			GAMEMODE:Notify(ply, 1, 4, "Ты неможеш положить "..v.." в свой инвентарь")
			return
		end
	end

	if mass > 100 then
		GAMEMODE:Notify(ply, 1, 4, "Этот обьект слишком тяжёлый.")
		return
	end

	if #ply:GetTable().Pocket >= GAMEMODE.Config.pocketitems then
		GAMEMODE:Notify(ply, 1, 4, "Твой инвентарь заполнен")
		return
	end


	umsg.Start("Pocket_AddItem", ply)
		umsg.Short(trace.Entity:EntIndex())
	umsg.End()

	table.insert(ply:GetTable().Pocket, trace.Entity)
	trace.Entity:SetNoDraw(true)
	trace.Entity:SetPos(trace.Entity:GetPos())
	local phys = trace.Entity:GetPhysicsObject()
	phys:EnableMotion(false)
	trace.Entity.OldCollisionGroup = trace.Entity:GetCollisionGroup()
	trace.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
	trace.Entity.PhysgunPickup = false
	trace.Entity.OldPlayerUse = trace.Entity.PlayerUse
	trace.Entity.PlayerUse = false
	trace.Entity.IsPocketed = true
end*/