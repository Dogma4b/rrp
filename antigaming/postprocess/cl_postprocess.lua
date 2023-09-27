local ppex_sunbeams 			= 1
	local ppex_sunbeams_ignore 		= CreateClientConVar( "ppex_sunbeams_ignore", 			"0", 		false, false )
	local ppex_sunbeams_darken	= CreateClientConVar( "ppex_sunbeams_darken", 		"0.95", 	false, false )
	local ppex_sunbeams_multiply  = CreateClientConVar( "ppex_sunbeams_multiply", 	"1.0", 		false, false )
	local ppex_sunbeams_sunsize	= CreateClientConVar( "ppex_sunbeams_sunsize", 		"0.075", 	false, false )
 
	local ppex_sunbeams_x_offset	= CreateClientConVar( "ppex_sunbeams_x_offset", 		"0.000", 	false, false )
	local ppex_sunbeams_y_offset	= CreateClientConVar( "ppex_sunbeams_y_offset", 		"0.000", 	false, false )
	local ppex_sunbeams_z_offset	= CreateClientConVar( "ppex_sunbeams_z_offset", 		"0.000", 	false, false )
 
	local function DrawInternal()
		local modx = ppex_sunbeams_x_offset:GetFloat()
		local mody = ppex_sunbeams_y_offset:GetFloat()
		local modz = ppex_sunbeams_z_offset:GetFloat()
 
		local sun = util.GetSunInfo()
		if (!sun) then return end
 
		if !ppex_sunbeams_ignore:GetBool() && (sun.obstruction == 0) then return end
 
		sun.direction.x = sun.direction.x + modx
		sun.direction.y = sun.direction.y + mody
		sun.direction.z = sun.direction.z + modz
 
		local sunpos = EyePos() + sun.direction * 4096
		local scrpos = sunpos:ToScreen()
 
		local dot = (sun.direction:Dot( EyeVector() ) - 0.8) * 5
		if (dot <= 0) then return end
 
		local newmul = ppex_sunbeams_multiply:GetFloat()
		if ppex_sunbeams_ignore:GetBool() then
			newmul = newmul * dot
		else
			newmul = newmul * dot * sun.obstruction
		end
 
		DrawSunbeams( ppex_sunbeams_darken:GetFloat(),
					newmul,
					ppex_sunbeams_sunsize:GetFloat(), 
					scrpos.x / ScrW(), 
					scrpos.y / ScrH()
					);
 
	end
	hook.Add( "RenderScreenspaceEffects", "CocksPostProcess", DrawInternal )

function DrawVignetteAndOtherEffect()
//LocalPlayer().Settings = LocalPlayer().Settings or {}
	//local time = tonumber(os.date("%H"))*60+tonumber(os.date("%M"))
	
	//if time < 720 then cc = (time+50)/720 elseif time > 1260 then cc = (1490-time)/230 else cc = 1 end
	//if time < 540 then colc = time/540 elseif time > 1260 then colc = (1440-time)/180 else colc = 1 end
	//if LocalPlayer():Nick()..Vignette1 == 0 then return end
    DrawMaterialOverlay( "overlays/vignette01.vtf", 0.1 )
	//local color_correction = {}
	//			color_correction[ "$pp_colour_brightness" ] = 0
	//		 	color_correction[ "$pp_colour_contrast" ] = 1
	//		 	color_correction[ "$pp_colour_colour" ] = 1
	//			color_correction[ "$pp_colour_addr" ] = 0//-0.09
	//		 	color_correction[ "$pp_colour_addg" ] = 0//-0.09
	//		 	color_correction[ "$pp_colour_addb" ] = 0//-0.09
	//		 	color_correction[ "$pp_colour_mulr" ] = 0
	//		 	color_correction[ "$pp_colour_mulg" ] = 0
	//		 	color_correction[ "$pp_colour_mulb" ] = 0
	//DrawColorModify(color_correction)
end
 
//hook.Add( "RenderScreenspaceEffects", "DrawVignetteAndOtherEffect1", DrawVignetteAndOtherEffect )