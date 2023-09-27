RRP = {}

RRP.MeterLength = 550

RRP.MeterLengthHalf = 250/2
RRP.MeterHeight = 250*.17

function RRP.CreateMeterHUD(text,time)
	local MeterStart = CurTime()
	local function MeterHUDLocal()
		draw.RoundedBox( 8, ScrW()*.35-RRP.MeterLengthHalf, ScrH()*.1-RRP.MeterHeight-8, RRP.MeterLength, RRP.MeterHeight, Color( 0, 0, 0, 200 ) )
		draw.RoundedBox( 8, ScrW()*.35-RRP.MeterLengthHalf+4, ScrH()*.1-RRP.MeterHeight-8+4, (RRP.MeterLength-8)*math.Clamp(((CurTime()-MeterStart)/time),.04,1), RRP.MeterHeight-8, Color( 13, 21, 178, 180 ) )
		draw.SimpleTextOutlined( text, "HUDNumber5", ScrW()*.5, ScrH()*.1-(RRP.MeterHeight*.5)-8, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0) )
	end
	hook.Add("HUDPaint","Shows a progress meter",MeterHUDLocal)
	
	timer.Create("MeterHUDRemove",time,1,function()
		hook.Remove("HUDPaint","Shows a progress meter")
	end)
end

function RRP.SendMeter(um)
	RRP.CreateMeterHUD(um:ReadString(),um:ReadFloat())
end
usermessage.Hook("SendMeter",RRP.SendMeter)

function RRP.CancelMeter() 
		hook.Remove("HUDPaint","Shows a progress meter")
end
usermessage.Hook("CancelMeter",RRP.CancelMeter)

function RRP.NPCNames()
		local LP = LocalPlayer()
		local LPos = LP:GetPos()
		local LPAng = LP:EyeAngles()
		
		local npc1 = ents.FindByClass("npc_attach_dealer")
			local p1 = table.GetFirstValue(npc1):GetPos()
		local npc2 = ents.FindByClass("npc_employer")
			local p2 = table.GetFirstValue(npc2):GetPos()
		local npc3 = ents.FindByClass("npc_donate")
			local p3 = table.GetFirstValue(npc3):GetPos()
		local npc4 = ents.FindByClass("npc_item_dealer")
			local p4 = table.GetFirstValue(npc4):GetPos()
			
		local test1 = 500-p1:Distance(LocalPlayer():EyePos())
		local test2 = 500-p2:Distance(LocalPlayer():EyePos())
		local test3 = 500-p3:Distance(LocalPlayer():EyePos())
		local test3 = 500-p4:Distance(LocalPlayer():EyePos())
			
			if LPos:Distance(p1) < 512 then
				cam.Start3D2D( p1+Vector(0,0,80), Angle(0, LPAng.y-90, 90), .3 )
					draw.SimpleText( "Продавец модулей", "Trebuchet24", 0, 0, Color(13,21,178,test1), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				cam.End3D2D()
			end
			if LPos:Distance(p2) < 512 then
				cam.Start3D2D( p2+Vector(0,0,80), Angle(0, LPAng.y-90, 90), .3 )
					draw.SimpleText( "Работодатель", "Trebuchet24", 0, 0, Color(13,21,178,test2), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				cam.End3D2D()
			end
			if LPos:Distance(p3) < 512 then
				cam.Start3D2D( p3+Vector(0,0,80), Angle(0, LPAng.y-90, 90), .3 )
					draw.SimpleText( "Донат вещи", "Trebuchet24", 0, 0, Color(13,21,178,test3), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				cam.End3D2D()
			end
			
			if LPos:Distance(p4) < 512 then
				cam.Start3D2D( p4+Vector(0,0,80), Angle(0, LPAng.y-90, 90), .3 )
					draw.SimpleText( "Тысяча мелочей", "Trebuchet24", 0, 0, Color(13,21,178,test4), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				cam.End3D2D()
			end

end
//hook.Add("PostDrawOpaqueRenderables","NPC Name ~_~",RRP.NPCNames)