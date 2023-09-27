include('shared.lua') 

function ENT:Initialize()
end

function ENT:Draw()
/*
	ang = self:GetAngles()+Angle(0,90,90)
	pos = self:GetPos()+Vector(0,0,100)//+ang:Forward()*8.5+ang:Up()*1.50
	
	surface.SetFont("DermaLarge")
	
	cam.Start3D2D(pos, ang, 100)
		draw.DrawText("TEST TEST TESR", "TargetID", 1, 1, Color(255, 255, 255, test1),0.1)
	cam.End3D2D()
	*/
end

function SpawnItem()

	local window = vgui.Create( "DFrame" ) -- Создаёт дерма окно.
	window:SetPos( ScrW()*-1, ScrH()/2-250 ) -- Позиция на экране игрока.
	window:SetSize( 550, 300 ) -- Размер рабочего окна.
	window:SetTitle( "Торговец модулями" ) -- Название дерма окна.
	window:SetVisible( true )
	window:SetDraggable( false ) -- Делает окно передвежным.
	window:ShowCloseButton( true ) -- Показывает закрывающий крестик.
	window:MoveTo( ScrW()/2-275, ScrH()/2-250, .5, 0, .5)
	window:MakePopup()
	window.btnClose.DoClick = function() window:MoveTo( ScrW()*1, ScrH()/2-250, .5, 0, .5) timer.Create("CloseFrame",1,1,function() window:Close() end) window:SetMouseInputEnabled(false) window:SetKeyboardInputEnabled(false) end
	window.Paint = function()
		draw.RoundedBox( 8, 0, 0, window:GetWide(), window:GetTall(), Color( 0, 0, 0, 150 ) )
	end
	
	/*local closebtn = vgui.Create( "DImageButton", window )
		closebtn:SetPos( 515, 5 )
		closebtn:SetImage( "rusrp/close_button.vtf" ) -- Set your .vtf image
		closebtn:SizeToContents()
		closebtn.DoClick = function()
			window:Close()
	end*/
--------------------
	local list1 = vgui.Create("DPanelList", window)
	list1:SetSize(530, 265)
	list1:SetPos(10, 25)
	list1:SetSpacing( 5 )
	list1:EnableHorizontal( false )
	list1:EnableVerticalScrollbar( true )
	
	local function AddList(item_model,item_name,item_desc,item_command,item_price)
	//for k,v in pairs(model) do
		local DPanel1 = vgui.Create('DPanel', list1)
		DPanel1:SetSize(419, 100)
		DPanel1.Paint = function()
		surface.SetDrawColor( 0,0,200,255 )
		surface.DrawRect( 0,0,DPanel1:GetWide(),DPanel1:GetTall() )
		draw.RoundedBox( 0, 1, 1, DPanel1:GetWide()-2, DPanel1:GetTall()-2, Color( 0, 0, 0, 255 ) )
		end
											--ITEM #1--
		local icon = vgui.Create("DImageButton", DPanel1)
		icon:SetImage( item_model )
		icon:SetPos(5,5)
		icon:SetSize(65,65)
		icon:SetMouseInputEnabled(false)
		
		local name = vgui.Create("DLabel", DPanel1)
		name:SetText( item_name )
		name:SizeToContents()
		name:SetPos(89, 5)
		
		local desc = vgui.Create("DLabel", DPanel1)
		desc:SetText( item_desc )
		desc:SizeToContents()
		desc:SetPos(89, 20)
		
		local price = vgui.Create("DLabel", DPanel1)
		price:SetText( "Цена: "..item_price )
		price:SizeToContents()
		price:SetPos(450, 75)
		
		local drop = vgui.Create("DButton", DPanel1)
		drop:SetSize(50, 15)
		drop:SetPos(10, 77)
		drop:SetText("Купить")
		drop.DoClick = function()
			RunConsoleCommand( item_command )
		end
		list1:AddItem(DPanel1)
	end
	
-------------------------------------------ITEM----------------------------------------------

AddList("models/Items/BoxSRounds.mdl", "Лазерный прицел", "Уменьшает разброс в движении на 25%\nПри автоматической стрельбе уменьшает разброс на 15%", "buy_laser", "1000")
AddList("spawnicons/models/attachments/cmore.png", "Кобра", "Стандартный прицел стоит на вооружении сил России.\nОбеспечивает небольшое увеличение", "buy_kobra", "1000")
AddList("spawnicons/models/attachments/aimpoint.png", "Aimpoint", "Голографический прицел, стоит на вооружении США.\nОбспечивает среднее увелечение", "buy_aimpoint", "1000")
AddList("spawnicons/models/attachments/ballistic.png", "Баллистический прицел 12x", "Съемный баллистический прицел.\nИспользуеться только при стрельбе на очень большие дистанции", "buy_ballistic", "1000")

-----------------------------------------ITEM END--------------------------------------------
	
end


usermessage.Hook("ShopNPCUsed", SpawnItem)