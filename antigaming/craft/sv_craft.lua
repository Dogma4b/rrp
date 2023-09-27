AG = AG or {}

function AG.CraftItem(ply,itemid,count)
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
concommand.Add("craft_item", function(ply,cmd,args) AG.CraftItem(ply,args[1],args[2]) end)