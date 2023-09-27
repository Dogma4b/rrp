// Antigaming Team 2014 //

function ShowEntityCraftMenu(ent)
	local entid = tonumber(ent:ReadString())
	local ItemName = ""
	local ItemId = nil
	if not istable(Recipes) then
		timer.Simple(0.01,function()
			net.Start( "SendRequestRecipesToServer" )
			net.SendToServer()
			net.Start("SendRequestEntityCraftingFrame")
			net.WriteInt(entid,12)
			net.SendToServer()
		end)
	end
	net.Start("SendRequestEntityCraftingFrame")
	net.WriteInt(entid,12)
	net.SendToServer()
	
		local CraftMenu = vgui.Create("DFrame")
		CraftMenu:SetPos( ScrW()/2-300, ScrH()/2-200 )
		CraftMenu:SetSize( 600, 400 )
		CraftMenu:SetTitle( "" )
		CraftMenu:SetVisible( true )
		CraftMenu:SetDraggable( false )
		CraftMenu:ShowCloseButton( true )
		CraftMenu:MakePopup()
		CraftMenu.Paint = function(pnl,w,h)
			draw.RoundedBox(4,0,0,w,h,Color(84,84,84,255),true,true,true,true)
			draw.RoundedBox(0,0,h-150,w-170,5,Color(50,50,50,255))
			draw.RoundedBox(0,w-170,0,5,h,Color(50,50,50,255))
			draw.DrawText("Список Рецептов","AG_SmallFont",w-450,h-390,Color(230,230,230,255))
			draw.DrawText("Ваш инвентарь","AG_SmallFont",w-125,h-380,Color(230,230,230,255))
		end
		
		// Список рецептов игрока
		
		local recipes_list = vgui.Create("DCategoryList",CraftMenu)
		recipes_list:SetPos(5,30)
		recipes_list:SetSize(420,215)
		recipes_list.Paint = function(pnl,w,h) end
		
		local resources = recipes_list:Add("Ресурсы")
			resources:Toggle()
			resources.Paint = function(pnl,w,h) draw.RoundedBox(4,0,0,w,h,Color(130,130,130,255)) end
			
		local resource_pos_y = 75
		local resources_list = vgui.Create("DPanelList",resources)
			resources_list:SetPos(15,25)
			resources_list:SetSize(405,resource_pos_y)
			resources_list:SetSpacing(5)
			resources_list:EnableHorizontal( true )
			resources_list:EnableVerticalScrollbar( true )
			
		local items = recipes_list:Add("Предметы")
			items:Toggle()
			items.Paint = function(pnl,w,h) draw.RoundedBox(4,0,0,w,h,Color(130,130,130,255)) end
			
		local items_pos_y = 75
		local items_list = vgui.Create("DPanelList",items)
			items_list:SetPos(5,25)
			items_list:SetSize(405,items_pos_y)
			items_list:SetSpacing( 5 )
			items_list:EnableHorizontal( true )
			items_list:EnableVerticalScrollbar( true )
			
		local eats = recipes_list:Add("Еда")
			eats:Toggle()
			eats.Paint = function(pnl,w,h) draw.RoundedBox(4,0,0,w,h,Color(130,130,130,255)) end
			
		local eats_pos_y = 75
		local eats_list = vgui.Create("DPanelList",eats)
			eats_list:SetPos(5,25)
			eats_list:SetSize(405,eats_pos_y)
			eats_list:SetSpacing( 5 )
			eats_list:EnableHorizontal( true )
			eats_list:EnableVerticalScrollbar( true )
		
		net.Start( "SendRequestRecipesToServer" )
		net.SendToServer()
		net.Receive( "RecipesTable", function(len, ply)
		Recipes = net.ReadTable()
			for k,RecipeTbl in pairs(AG.Recipes) do
				for _,r in pairs(Recipes) do
					if k == r then
						local recipe = nil
						if RecipeTbl.category == "resource" then
							recipe = vgui.Create("DPanel",resources_list)
							resources_list:AddItem(recipe)
						elseif RecipeTbl.category == "item" then
							recipe = vgui.Create("DPanel",items_list)
							items_list:AddItem(recipe)
						elseif RecipeTbl.category == "eat" then
							recipe = vgui.Create("DPanel",eats_list)
							eats_list:AddItem(recipe)
						end
						
						recipe:SetSize(70,70)
						//recipe.Paint = function(pnl,w,h) end
						
						local ItemTbl = AG:GetItem(k)
						
						local icon = nil
						local IsModel = string.find(ItemTbl.model,"mdl")
						if IsModel != nil then
							icon = vgui.Create("SpawnIcon", recipe)
							icon:SetModel(ItemTbl.model)
						else
							icon = vgui.Create("DImageButton", recipe)
							icon:SetImage(ItemTbl.model)
						end
						icon:SetSize(70,70)
						icon:SetPos(0,0)
						icon:SetMouseInputEnabled(false)
						
						local button = vgui.Create("DButton",recipe)
						button:SetSize(70,70)
						button:SetText("")
						button.Paint = function(pnl,w,h) end
						button.DoClick = function()
							ItemName = ItemTbl.name
							ItemId = k
						end
						
						if (#Recipes % 5) == 0 then
							if RecipeTbl.category == "resource" then
								resource_pos_y = resource_pos_y + 70
								resources_list:SetSize(405,resource_pos_y)
							elseif RecipeTbl.category == "item" then
								items_pos_y = items_pos_y + 70
								items_list:SetSize(405,items_pos_y)
							elseif RecipeTbl.category == "eat" then
								eats_pos_y = eats_pos_y + 70
								eats_list:SetSize(405,eats_pos_y)
							end
						end
					end
				end
			end
		end)
		
		// Инвентарь игрока
		
		local player_inventory = vgui.Create("DPanelList",CraftMenu)
		player_inventory:SetPos(CraftMenu:GetWide()-160, 40)
		player_inventory:SetSize(155, 460)
		player_inventory:SetSpacing( 5 )
		player_inventory:EnableHorizontal( false )
		player_inventory:EnableVerticalScrollbar( false )
		
		net.Start( "SendRequestInventoryToServer" )
		net.SendToServer()
		net.Receive( "SendTableEntity", function(len, ply)
			player_inventory:Clear(true)
			local InvTbl = net.ReadTable()
			for x=1,table.Count(InvTbl) do 
			for y=1,table.Count(InvTbl[x]) do
				if(InvTbl[x][y]!=0) then
					local inv_item = AG:GetItem(InvTbl[x][y].id)
					if(inv_item.type == "resource") then
						local item = vgui.Create("DButton",player_inventory)
						item:SetSize(155,20)
						item:SetText("")
						item.Active = false
						item.OnCursorEntered = function() item.Active = true end
						item.OnCursorExited = function() item.Active = false end
						item.Paint = function(pnl,w,h)
							if item.Active == false then
								draw.RoundedBox(4,0,0,w,h,Color(110,110,110,255),true,true,true,true)
							else
								draw.RoundedBox(4,0,0,w,h,Color(170,170,170,255),true,true,true,true)
								item:SetCursor("hand")
							end
							draw.DrawText(inv_item.name.." x"..InvTbl[x][y].count,"AG_SmallFont",w-140,h-18,Color(230,230,230,255))
						end
						item.DoClick = function()
							local CountMenu = vgui.Create("DFrame")
							CountMenu:SetPos( ScrW()/2-100, ScrH()/2-50 )
							CountMenu:SetSize( 200, 100 )
							CountMenu:SetTitle( "" )
							CountMenu:SetVisible( true )
							CountMenu:SetDraggable( false )
							CountMenu:ShowCloseButton( false )
							CountMenu:MakePopup()
							CountMenu.Paint = function(pnl,w,h)
								draw.RoundedBox(4,0,0,w,h,Color(120,120,120,255),true,true,true,true)
								draw.DrawText("Количество:","AG_SmallFont",60,10,Color(230,230,230,255))
							end
							
							local CountMenuClose = vgui.Create("DButton",CountMenu)
							CountMenuClose:SetPos(180,5)
							CountMenuClose:SetSize(15,15)
							CountMenuClose:SetText("X")
							CountMenuClose.DoClick = function()
								CountMenu:Close()
							end
							
							local CountMenuText = vgui.Create("DTextEntry",CountMenu)
							CountMenuText:SetPos(50,35)
							CountMenuText:SetSize(100,20)
							
							local CountMenuSend = vgui.Create("DButton",CountMenu)
							CountMenuSend:SetPos(70,60)
							CountMenuSend:SetSize(60,15)
							CountMenuSend:SetText("Положить")
							CountMenuSend.DoClick = function()
								CountMenu:Close()
								RunConsoleCommand("send_ent_item",entid,InvTbl[x][y].id,tonumber(CountMenuText:GetValue()))
								timer.Simple(0.1, function()
								net.Start( "SendRequestInventoryToServer" )
								net.SendToServer()
								net.Start("SendRequestEntityCraftingFrame")
								net.WriteInt(entid,12)
								net.SendToServer()
								end)
							end
						end
						player_inventory:AddItem(item)
					end
				end
			end
			end
		end)
		
		// Текущий крафт
		
		local Item_Craft_Panel = vgui.Create("DPanel",CraftMenu)
		Item_Craft_Panel:SetPos(5,CraftMenu:GetTall()-140)
		Item_Craft_Panel:SetSize(420,55)
		Item_Craft_Panel.Paint = function(pnl,w,h)
			draw.DrawText(ItemName,"AG_MediumFont",130,10,Color(230,230,230,255))
			if ItemName != "" then
				local pos_y = 0
				for k,v in pairs(AG.GetCraftItem(ItemId).components) do
					draw.DrawText(AG:GetItem(k).name.." x"..v,"AG_SmallFont",280,pos_y,Color(230,230,230,255))
					pos_y = pos_y + 12
				end
			end
		end
		
		local Items_String = vgui.Create("DPanelList",CraftMenu)
		Items_String:SetPos(10, CraftMenu:GetTall()-70)
		Items_String:SetSize(420, 50)
		Items_String:SetSpacing( 5 )
		Items_String:EnableHorizontal( true )
		Items_String:EnableVerticalScrollbar( false )
		
		net.Receive( "CraftingTable", function(len, ply)
			Items_String:Clear(true)
			local ItemsTbl = net.ReadTable()
			for x=1,(table.Count(ItemsTbl)-1) do
				local item = vgui.Create("DPanel",Items_String)
				item:SetSize(48,48)
				if (ItemsTbl[x].id != 0) then
					local icon = vgui.Create("SpawnIcon", item)
					local model = AG:GetItem(ItemsTbl[x].id).model
					icon:SetModel(model)
					icon:SetSize(48,48)
					icon:SetPos(0,0)
					icon:SetMouseInputEnabled(false)
					icon.Paint = function(pnl,w,h)
						draw.RoundedBox(0,0,0,w,h,Color(47,47,47,255))
						draw.DrawText(ItemsTbl[x].count,"AG_SmallFont",item:GetWide()-12,item:GetTall()-15,Color(230,230,230,255))
					end
				else
					local icon = vgui.Create("DImage", item)
					icon:SetImage("antigaming/craft/none.png")
					icon:SetSize(48,48)
					icon:SetPos(0,0)
					icon:SetMouseInputEnabled(false)
				end
				Items_String:AddItem(item)
			end
			
			local Craft_Button = vgui.Create("DButton",CraftMenu)
			Craft_Button:SetPos(275,CraftMenu:GetTall()-70)
			Craft_Button:SetSize(80,48)
			Craft_Button:SetText("")
			Craft_Button.Paint = function(pnl,w,h)
				draw.RoundedBox(0,0,0,w,h,Color(150,150,150,255))
				draw.DrawText("Craft","AG_MediumFont",10,10,Color(230,230,230,255))
			end
			Craft_Button.DoClick = function()
				if AG.GetCraftItem(ItemId) then
					timer.Create("craft_timer_id_"..entid,AG.GetCraftItem(ItemId).time,1,function() end)
				end
			end
			
			local item = vgui.Create("DPanel",Items_String)
			item:SetPos(Items_String:GetWide()-70,0)
			item:SetSize(48,48)
			if (ItemsTbl[10].id != 0) then
				local icon = vgui.Create("SpawnIcon", item)
				local model = AG:GetItem(ItemsTbl[10].id).model
				icon:SetModel(model)
				icon:SetSize(48,48)
				icon:SetPos(0,0)
				icon:SetMouseInputEnabled(false)
				icon.Paint = function(pnl,w,h)
					draw.RoundedBox(0,0,0,w,h,Color(47,47,47,255))
					draw.DrawText(ItemsTbl[10].count,"AG_SmallFont",item:GetWide()-12,item:GetTall()-15,Color(230,230,230,255))
				end
			else
				local icon = vgui.Create("DImage", item)
				icon:SetImage("antigaming/craft/none.png")
				icon:SetSize(48,48)
				icon:SetPos(0,0)
				icon:SetMouseInputEnabled(false)
			end
			
		local Craft_Timer = vgui.Create("DPanel",CraftMenu)
		Craft_Timer:SetPos(10,CraftMenu:GetTall()-18)
		Craft_Timer:SetSize(398,14)
		Craft_Timer.Paint = function(pnl,w,h)
			draw.RoundedBox(0,0,0,w,h,Color(70,70,70,255))
			local time_left = timer.TimeLeft("craft_timer_id_"..entid)
			if time_left then
				local timer_box_width = w-4
				local timer_box_time_left = (AG.GetCraftItem(ItemId).time-time_left)/100*timer_box_width
				draw.RoundedBox(0,2,2,timer_box_time_left,h-4,Color(170,255,170,255))
			end
		end
			
		end)
		
end
usermessage.Hook("Ent_Crafting_Menu",ShowEntityCraftMenu)