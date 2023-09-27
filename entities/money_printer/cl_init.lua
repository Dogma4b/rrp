include("shared.lua")

function ENT:Initialize()
end


function ENT:Draw()
	self.Entity:DrawModel()
		
	local Pos = self:GetPos()
	if Pos:Distance(LocalPlayer():GetPos())>512 then return end
	local Ang = self:GetAngles()
	
    local owner = self.dt.owning_ent
	owner = (IsValid(owner) and owner:Nick()) or "~unknown~"
	
	local txt2 = "$" ..self:GetNWInt("Printed")
	
	surface.SetFont("DermaLarge")
	local TextWidth = surface.GetTextSize(self.PrintName)*0.5
	local TextWidth2 = surface.GetTextSize(txt2)*0.5
	local TextWidth3 = surface.GetTextSize(owner)*0.5
	local hpw = 75
	local hp = self:GetNWInt("Damage")/100*hpw
	local wid = 3
	
	local hpcol = 70
	local txt3 = self:GetNWInt("CoolerUses")/4*hpcol
	
	local tempw = 250
	//local old_temperature = old_temperature or 0
	local result_temperature = self:GetNWInt("Temperature")/100*tempw
	//for i=old_temperature,new_temperature do
	//i = (old_temperature) + (new_temperature)
	//print(i)
  //    result_temperature = i
//	end
	
	
	
	
	local lvl = "Уровень: " .. self:GetNWInt("Upgrade")
	
	--Ang:RotateAroundAxis(Ang:Up(), 90)
	--print("draw")
	local bgcol = Color(0,0,0,192)
	cam.Start3D2D(Pos + Ang:Up() * 6 -Ang:Forward()*5, Ang, 0.08)	
	    draw.WordBox(2, -TextWidth3, -56, owner, "DermaLarge", bgcol, self.Color)
		draw.WordBox(2, -TextWidth, -20, self.PrintName, "DermaLarge", bgcol, self.Color)
		draw.WordBox(2, -TextWidth2, 16, txt2, "DermaLarge", bgcol, self.Color)
		
		surface.SetDrawColor(bgcol)
		surface.DrawRect(-tempw*0.48-wid,55-wid,tempw+wid*2,16+wid*2)
		surface.SetDrawColor(result_temperature/tempw*255,255-result_temperature/tempw*255,0)
		surface.DrawRect(-tempw*0.48,55,result_temperature,16)
		
		surface.SetDrawColor(bgcol)
		surface.DrawRect(-hpw*1.3-wid,100-wid,hpw+wid*2,16+wid*2)
		surface.SetDrawColor(255-hp/hpw*255,hp/hpw*255,0)
		surface.DrawRect(-hpw*1.3,100,hp,16)
	if txt3 >0 then
		surface.SetDrawColor(bgcol)
		surface.DrawRect(-hpcol*0.5-wid,-90-wid,hpcol+wid*2,16+wid*2)
	end
		surface.SetDrawColor(255-txt3/hpcol*255,txt3/hpcol*255,0)
		surface.DrawRect(-hpcol*0.5,-90,txt3,16)
		
		draw.WordBox(2, 23, 85, lvl, "DermaLarge", bgcol, self.Color)
	cam.End3D2D()
end

function ENT:Think()
end



function printer_menu(data)

	owner = data:ReadString()
	
local window = vgui.Create( "DFrame" ) -- Создаёт дерма окно.
	window:SetPos( ScrW()*-1, ScrH()/2-250 ) -- Позиция на экране игрока.
	window:SetSize( 300, 110 ) -- Размер рабочего окна.
	window:SetTitle( "Меню принтера" ) -- Название дерма окна.
	window:SetVisible( true )
	window:SetDraggable( false ) -- Делает окно передвежным.
	window:ShowCloseButton( true ) -- Показывает закрывающий крестик.
	window:MoveTo( ScrW()/2-150, ScrH()/2-250, .5, 0, .5)
	window:MakePopup()
	window.btnClose.DoClick = function() window:MoveTo( ScrW()*1, ScrH()/2-250, .5, 0, .5) timer.Create("CloseMoneyFrame" .. tostring(math.Rand(1,100)),1,1,function() window:Close() end) window:SetMouseInputEnabled(false) window:SetKeyboardInputEnabled(false) end
	window.Paint = function()
		draw.RoundedBox( 8, 0, 0, window:GetWide(), window:GetTall(), Color( 0, 0, 0, 150 ) )
	end

	local PerPrintBox = vgui.Create( "DTextEntry", window )
		PerPrintBox:SetPos( 5, 25 )
		PerPrintBox:SetTall( 15 )
		PerPrintBox:SetWide( 140 )
		PerPrintBox:SetText( "Значение от 1 до 300" )
		PerPrintBox:SetEnterAllowed( true )
		PerPrintBox.OnMousePressed = function() PerPrintBox:SetText( "" ) end

	local PerPrintButton = vgui.Create( "DButton", window)
		PerPrintButton:SetPos (5, 45)
		PerPrintButton:SetSize (140, 15)
		PerPrintButton:SetText ("Установить")
		PerPrintButton.DoClick = function() RunConsoleCommand("moneyperprint", PerPrintBox:GetValue()) end
		PerPrintButton.Paint = function() draw.RoundedBox( 4, 0, 0, PerPrintButton:GetWide(), PerPrintButton:GetTall(), Color( 13, 21, 178, 255 ) ) end		
	
	local enable = vgui.Create( "DButton", window)
		enable:SetPos (155, 25)
		enable:SetSize (140, 15)
		enable:SetText ("Включить принтер")
		enable.DoClick = function() LocalPlayer():ConCommand("enable_money_printer 1") end
		enable.Paint = function() draw.RoundedBox( 4, 0, 0, enable:GetWide(), enable:GetTall(), Color( 13, 21, 178, 255 ) ) end
	
	local disable = vgui.Create( "DButton", window)
		disable:SetPos (155, 45)
		disable:SetSize (140, 15)
		disable:SetText ("Выключить принтер")
		disable.DoClick = function() LocalPlayer():ConCommand("enable_money_printer 0") end
		disable.Paint = function() draw.RoundedBox( 4, 0, 0, disable:GetWide(), disable:GetTall(), Color( 13, 21, 178, 255 ) ) end
	
if  LocalPlayer():Team() == TEAM_POLICE then
		local button1 = vgui.Create( "DButton", window)
		button1:SetPos (5, 65)
		button1:SetSize (140, 40)
		button1:SetText ("Конфисковать принтер")
		button1.DoClick = function() LocalPlayer():ConCommand("confiscate_printer") window:MoveTo( ScrW()*1, ScrH()/2-250, .5, 0, .5) timer.Create("CloseMoneyFrame" .. tostring(math.Rand(1,100)),1,1,function() window:Close() end) window:SetMouseInputEnabled(false) window:SetKeyboardInputEnabled(false) end
		button1.Paint = function() draw.RoundedBox( 4, 0, 0, button1:GetWide(), button1:GetTall(), Color( 13, 21, 178, 255 ) ) end

elseif  owner == LocalPlayer():Nick() then

		local button1 = vgui.Create( "DButton", window)
		button1:SetPos (5, 65)
		button1:SetSize (140, 40)
		button1:SetText ("Собрать деньги")
		button1.DoClick = function() LocalPlayer():ConCommand("pickup_prnt_money") window:MoveTo( ScrW()*1, ScrH()/2-250, .5, 0, .5) timer.Create("CloseMoneyFrame" .. tostring(math.Rand(1,100)),1,1,function() window:Close() end) window:SetMouseInputEnabled(false) window:SetKeyboardInputEnabled(false) end
		button1.Paint = function() draw.RoundedBox( 4, 0, 0, button1:GetWide(), button1:GetTall(), Color( 13, 21, 178, 255 ) ) end
else
		local button1 = vgui.Create( "DButton", window)
		button1:SetPos (5, 65)
		button1:SetSize (140, 40)
		button1:SetText ("Взломать принтер")
		button1.DoClick = function() LocalPlayer():ConCommand("hack_money_printer") window:MoveTo( ScrW()*1, ScrH()/2-250, .5, 0, .5) timer.Create("CloseMoneyFrame" .. tostring(math.Rand(1,100)),1,1,function() window:Close() end) window:SetMouseInputEnabled(false) window:SetKeyboardInputEnabled(false) end
		button1.Paint = function() draw.RoundedBox( 4, 0, 0, button1:GetWide(), button1:GetTall(), Color( 13, 21, 178, 255 ) ) end
end

local button2 = vgui.Create( "DButton", window)
button2:SetPos (155, 65)
button2:SetSize (140, 40)
button2:SetText ("Улучшить принтер")
button2.DoClick = function() LocalPlayer():ConCommand("rp_printer_upgrade") end
button2.Paint = function() draw.RoundedBox( 4, 0, 0, button2:GetWide(), button2:GetTall(), Color( 13, 21, 178, 255 ) ) end

end
usermessage.Hook("Printer_Menu", printer_menu)