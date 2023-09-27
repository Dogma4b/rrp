// Antigaming Team 2014 //

local PANEL = {}

PANEL.Active = false
PANEL.ActiveGui = nil

surface.CreateFont("AG_BigFont", {
	font = "Arial",
	size = 50,
	weight = 400,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("AG_MediumFont", {
	font = "Arial",
	size = 30,
	weight = 600,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

surface.CreateFont("AG_SmallFont", {
	font = "Arial",
	size = 15,
	weight = 700,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false
})

function PANEL:Init()

	timer.Simple(0.2, function() PANEL.Active = true end)
	
	self:SetSize(900,650)
	self:SetTitle("")
	self:SetVisible(true)
	self:SetDraggable(false)
	self:ShowCloseButton(false)
	self:MakePopup()
	self:Center()
	self.Paint = function(pnl,w,h)
		//draw.RoundedBox(10,0,0,self:GetWide(),self:GetTall(),Color(255,255,255,2),true,true,false,false)
		draw.RoundedBox(10,2,2,self:GetWide()-4,self:GetTall()-4,Color(135,135,135,255),true,true,false,false)
	end
	self:Frame()

end

function PANEL:Show()

	if PANEL.Active != true then
		timer.Simple(0.2, function() PANEL.Active = true end)
	end

end

function PANEL:Think()

	if PANEL.Active == true and input.IsKeyDown(KEY_F4) then
		self:SetVisible(false)
		self:Hide()
		
		PANEL.Active = false
	end

end

function PANEL:Frame()

	local AG_SideBar = vgui.Create("DPanel", self)
	AG_SideBar:SetSize(250,self:GetTall() - 4)
	AG_SideBar:SetPos(2,2)
	AG_SideBar.Paint = function(pnl,w,h)
		draw.RoundedBoxEx(10,0,0,w,h,Color(168,168,168,255),true,false,true,false)
	end

	local AG_Title = vgui.Create("DPanel", self)
	AG_Title:SetSize(250,55)
	AG_Title:SetPos(2,2)
	AG_Title.Paint = function(pnl,w,h)
		draw.RoundedBoxEx(10,0,0,w,h,Color(255,255,255,255),true,false,false,false)
		draw.DrawText("Antigaming","AG_BigFont",250/2+1,1,Color(40,180,40,255),1)
		draw.DrawText("Antigaming","AG_BigFont",250/2,0,Color(0,0,0,255),1)
	end
	
	BarY = 55
	pb = {}
	
	for k,menu in pairs(AG_F4Settings.Buttons) do
		if menu['name'] == "title" then
			local AG_Menu_Title = vgui.Create("DPanel", AG_SideBar)
			AG_Menu_Title:SetSize(250,AG_SideBar:GetTall() - 4)
			AG_Menu_Title:SetPos(0,BarY)
			AG_Menu_Title.Paint = function(pnl,w,h)
				draw.RoundedBoxEx(0,0,0,250,30,menu['color_title'],false,false,false,false)
				//draw.DrawText(menu['text'],"AG_MediumFont",11,3,Color(0,0,0,255))
				draw.DrawText(menu['text'],"AG_MediumFont",5,0,Color(207,208,207,255))
			end

			BarY = BarY + 30
			
			local Button_Background = vgui.Create("DPanel", AG_SideBar)
			Button_Background:SetSize(AG_SideBar:GetWide(),40*menu['num_buttons'])
			Button_Background:SetPos(0,BarY)
			Button_Background.Paint = function(pnl,w,h)
				draw.RoundedBoxEx(0,0,0,250,49*menu['num_buttons'],menu['color_background'],false,false,false,false)
			end
			
			//BarY = BarY + 5
		else
		
			local Button = vgui.Create("DButton", AG_SideBar)
			Button:SetSize(AG_SideBar:GetWide(),40)
			Button:SetPos(0,BarY)
			Button:SetText("")
			Button.Hover = false
			Button.Active = false
			Button.OnCursorEntered = function() Button.Hover = true end
			Button.OnCursorExited = function() Button.Hover = false end
			Button.DoClick = function()
				self:ShowGui(menu['gui'])
				if Button.Active == false then
					if LastButton then
						LastButton.Active = false
						LastButton = Button
					else
						LastButton = Button
					end
					Button.Active = true
				end
			end
			Button.Paint = function(pnl,w,h)
				if Button.Active == false then
					if Button.Hover == false then
						draw.RoundedBox(0,5,5,w-10,h-10,menu['color_button'])
						draw.DrawText(menu['text'],"AG_MediumFont",10,5,Color(150,150,150,255))
					else
						draw.RoundedBox(0,5,5,w-10,h-10,menu['color_button'])
						draw.RoundedBox(0,0,0,w,h,Color(232,233,254,50))
						draw.DrawText(menu['text'],"AG_MediumFont",10,5,Color(255,255,255,255))
					end
				else
					draw.RoundedBox(0,5,5,w-10,h-10,menu['color_button'])
					draw.RoundedBox(0,0,0,w,h,Color(232,233,254,50))
					draw.DrawText(menu['text'],"AG_MediumFont",10,5,Color(255,255,255,255))
				end
			end
			BarY = BarY + 40
		end
	end
	
end

function PANEL:ShowGui(gui_name)

	local gui = pb['gui_'..gui_name]
	
	if (self.ActiveGui == nil) or (gui != self.ActiveGui) then
		if (self.ActiveGui != nil) then
			self.ActiveGui:SetVisible(false)
		end
		if ValidPanel(gui) then
			gui:SetVisible(true)
		else
			pb['gui_'..gui_name] = vgui.Create(gui_name,self)
		end
	end
	
	self.ActiveGui = gui

end

vgui.Register("AG_F4Menu",PANEL,"DFrame")