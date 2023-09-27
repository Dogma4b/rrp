// Antigaming Team 2014 //

local AG = AG or {}
local AG_Frame

function AG:OpenF4Menu()
	if AG_Frame then
		AG_Frame:SetVisible(true)
		AG_Frame:Show()
		AG_Frame.Active = false
	else
		AG_Frame = vgui.Create("AG_F4Menu")
		hook.Call("OpenF4Menu")
	end
end

function AG:CloseF4Menu()
	if AG_Frame then
		AG_Frame:SetVisible(false)
		AG_Frame:Hide()
		AG_Frame.Active = false
	else
		AG:OpenF4Menu()
	end
end

function AG:HandleF4Menu()
	if not ValidPanel(AG_Frame) or not AG_Frame:IsVisible() then
		AG:OpenF4Menu()
	else
		AG:CloseF4Menu()
	end
end
hook.Add("ShowSpare2","AG.HandleF4Menu",AG.HandleF4Menu)