// Antigaming Team 2014 //

AG.EntityTable = {}

function AG.CreateEnt(entid)
	AG.EntityTable[entid] = {}
	for x = 1,5 do
		AG.EntityTable[entid][x] = {id = 0, count = 0}
	end
	AG.EntityTable[entid][10] = {id = 0, count = 0}
end

function AG.EntAddItem(entid,id,count)
	for k,v in pairs(AG.EntityTable[entid]) do
		if v.id == id then
			v.count = v.count + count
			return
		elseif v.id == 0 then
			v.id = id
			v.count = count
			return
		end
	end
end

function AG.SendEntItem(ply,cmd,args)
	local entid,id,count = tonumber(args[1]),tonumber(args[2]),tonumber(args[3])
	if (AG.CheckItemInventory(ply,id) >= count) then
		local slot = RRP.CheckItem(ply,id)
		ply.rrp_inventory[slot.x][slot.y].count = ply.rrp_inventory[slot.x][slot.y].count - tonumber(count)
		AG.EntAddItem(entid,id,count)
	else
		return nil
	end
end
concommand.Add("send_ent_item",AG.SendEntItem)

function AG.CraftEnt(id)
	for craft_item_id, craft_item in pairs(AG_Recipes) do
		if craft_item_id == tonumber(itemid) then
			for component_id, need_count in pairs(craft_item) do
				if (AG.CheckItemInventory(ply,component_id) >= need_count) then
					local slot = RRP.CheckItem(ply,component_id)
					ply.rrp_inventory[slot.x][slot.y].count = ply.rrp_inventory[slot.x][slot.y].count - (need_count*tonumber(count))
				else
					print("craft failed")
					return nil
				end
				print("["..component_id.."] "..need_count*tonumber(count))
			end
			RRP.AddNewItem(ply,tonumber(itemid),tonumber(count))
			hook.Call("OnCraftingItem",nil,ply,tonumber(itemid),tonumber(count))
		end
	end
end

util.AddNetworkString("SendRequestEntityCraftingFrame")
	net.Receive( "SendRequestEntityCraftingFrame", function(len, ply) 
	local entid = net.ReadInt(12)
		if (AG.EntityTable[entid] == nil) then
			AG.CreateEnt(entid)
		end
		util.AddNetworkString("CraftingTable") 
		net.Start( "CraftingTable" )
			net.WriteTable(AG.EntityTable[entid]) 
		net.Send(ply)
		print ("Crafting Table Send")
	end)