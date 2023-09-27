// Antigaming Team 2014 //

/*local PANEL = {}

function PANEL:Init()

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
	
	local close_button = vgui.Create("DButton",self)
	close_button:SetPos(self:GetWide-25,self:GetTall-25)
	close_button:SetSize(20,20)
	close_button.Paint = function(pnl,w,h)
		draw.RoundedBox(10,2,2,0,0,Color(255,0,0,255),true,true,true,true)
	end
	close_button.DoClick = function()
		self:Close()
	end
	
end

vgui.Register("craft_gui",PANEL,"DFrame")

function test()
	vgui.Create("craft_gui")
end
concommand.Add("craft_gui",test)*/