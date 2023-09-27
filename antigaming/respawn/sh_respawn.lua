if SERVER then

function respawntime(ply)
ply:Lock()
umsg.Start("RespawnTime",ply)
			umsg.Float(25)
		umsg.End()
timer.Create("RemoveTimerSpawn"..ply:Nick(),25,1, function() ply:UnLock() ply:Spawn() end)
end

hook.Add("PlayerDeath", "PlayerDeath", respawntime)

//concommand.Add("lolk", function(ply) ply:UnLock() end) 
end 

if CLIENT then

function CreateRespawnHUD(time)
	local MeterStart = CurTime()
	
	local widthpos = ScrW()*.25
	local heightpos = ScrH()*.55
	
	local width = 400
	local height = 50
	
	local function MeterHUDLocal()
		draw.RoundedBox( 4, widthpos, heightpos, 500, 200, Color(0,0,0,150) )
		draw.SimpleTextOutlined( "Вы умираете", "HUDNumber5", widthpos*1.97, heightpos-(height*-.7)-8, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0) )
			draw.RoundedBox( 8, widthpos+50, heightpos+120, width, height, Color( 0, 0, 0, 100 ) )
			draw.RoundedBox( 8, widthpos+54, heightpos+124, (width-8)*math.Clamp(((CurTime()-MeterStart)/time),.04,1), height-8, Color( 200, 0, 0, 150 ) )
			//draw.SimpleTextOutlined( text, "HUDNumber2", widthpos, heightpos-(height*-.7)-8, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, Color(0,0,0) )
	end
	hook.Add("HUDPaint","Shows a progress meter",MeterHUDLocal)
	
	timer.Create("MeterHUDRemove",time,1,function()
		hook.Remove("HUDPaint","Shows a progress meter")
	end)
end

function SendTime(um)
	CreateRespawnHUD(um:ReadFloat())
end
usermessage.Hook("RespawnTime",SendTime)

end