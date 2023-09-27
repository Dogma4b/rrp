if SERVER then

RunConsoleCommand("sv_skyname", "painted")

hook.Add("InitPostEntity","SpawnTheProps",timer.Simple(1, function() sky = ents.Create("env_skypaint") sky:Spawn() end))

function SkyUpdate()

		local time = tonumber(os.date("%H"))*60+tonumber(os.date("%M"))
	
		if time < 720 then cc = (time+50)/720 elseif time > 1260 then cc = (1490-time)/230 else cc = 1 end
		if time < 540 then colc = time/540 elseif time > 1260 then colc = (1440-time)/180 else colc = 1 end
		
		if time < 360 then texture = "skybox/starfield" skyspd = 0.01 skytopcol = Vector( 0, 0, 0 ) skybotcol = Vector( 0, 0, 0 ) colr = -0.09 colg = -0.09 colb = -0.09 elseif time > 1260 then texture = "skybox/starfield" skyspd = 0.01 skytopcol = Vector( 0, 0, 0 ) skybotcol = Vector( 0, 0, 0 ) colr = -0.09 colg = -0.09 colb = -0.09 else  texture = "skybox/clouds" skyspd = 0.03 skytopcol = Vector( 0.01, 0.15, 0.38 ) skybotcol = Vector( 0.07, 0.1, 0.31 ) colr = 0 colg = 0 colb = 0 end
		
		-----------------------------Change Light------------------------------
		
		if time == 1 then sunlight = "a"
		elseif time == 60 then sunlight = "b"
		elseif time == 120 then sunlight = "c"
		elseif time == 180 then sunlight = "d"
		elseif time == 240 then sunlight = "e"
		elseif time == 300 then sunlight = "f"
		elseif time == 360 then sunlight = "g"
		elseif time == 420 then sunlight = "h"
		elseif time == 480 then sunlight = "i"
		elseif time == 540 then sunlight = "j"
		elseif time == 600 then sunlight = "k"
		elseif time == 660 then sunlight = "l"
		elseif time == 720 then sunlight = "m"
		elseif time == 780 then sunlight = "n"
		elseif time == 840 then sunlight = "o"
		elseif time == 900 then sunlight = "p"
		elseif time == 960 then sunlight = "q"
		elseif time == 1020 then sunlight = "r"
		
		elseif time == 1140 then sunlight = "d"
		elseif time == 1260 then sunlight = "c"
		elseif time == 1380 then sunlight = "b"

		end
		
		
		-----------------------------------END---------------------------------
		
		sunpos = (time / 1440) * 360

		util.AddNetworkString("SendPlayerSkyColor")
		net.Start( "SendPlayerSkyColor" )
				net.WriteFloat( colr )
				net.WriteFloat( colg )
				net.WriteFloat( colb )
		net.Broadcast()
		
	if sky == nil then return end
			
		sky:SetTopColor( skytopcol )
		sky:SetBottomColor( skybotcol )
		sky:SetFadeBias( 1 )
		

		sky:SetSunNormal( Vector( 0.4, 0.0, 0.01 ) )
		sky:SetSunColor( Vector( 0.2, 0.1, 0.0 ) )
		sky:SetSunSize( 2.0 )

		sky:SetDuskColor( Vector( 0.0, 0.0, 0.0 ) ) 
		sky:SetDuskScale( 0 )
		sky:SetDuskIntensity( 0 )

		sky:SetDrawStars( true )
		sky:SetStarSpeed( skyspd )
		sky:SetStarScale( 1.59 )
		sky:SetStarFade( 1.91 )
		sky:SetStarTexture( texture )

		sky:SetHDRScale( 0.55 )

		
	if ( SERVER && sky.EnvSun == nil ) then
		sky.EnvSun = false;
		local list = ents.FindByClass( "env_sun" )
		if ( #list > 0 ) then
			sky.EnvSun = list[1]
		end
	end
	
	if ( SERVER && IsValid( sky.EnvSun ) ) then
		local vec = sky.EnvSun:GetInternalVariable( "m_vDirection" );
		if ( isvector( vec ) ) then
			sky:SetSunNormal( vec )
		end
	end
	
	local list = ents.FindByClass( "env_sun" )
		if ( #list > 0 ) then
			EnvSun = list[1]
		end
		
	sunang = Angle(sunpos,140,0)
		
	if ( IsValid( EnvSun ) ) then
		EnvSun:SetKeyValue( "sun_dir", tostring( sunang:Forward() ) )
		//EnvSun:SetKeyValue( 'material' , 'sprites/light_glow02_add_noz.vmt' )
		//EnvSun:SetKeyValue( 'overlaymaterial' , 'sprites/light_glow02_add_noz.vmt' )
	end

		local list = ents.FindByClass("light_environment")
	if ( #list > 0 ) then
			sun = list[1]
		end

			 sun:Fire( 'FadeToPattern' , "a" , 1 )
	
end

	
hook.Add("Think","Lol", SkyUpdate)
---------------------------------------------------
		

end

if CLIENT then

net.Receive( "SendPlayerSkyColor", function(len)
colr = net.ReadFloat()
colg = net.ReadFloat()
colb = net.ReadFloat()
end)

function RenderColorCorrection()

	local color_correction = {}
				color_correction[ "$pp_colour_brightness" ] = 0
			 	color_correction[ "$pp_colour_contrast" ] = 1
			 	color_correction[ "$pp_colour_colour" ] = 1
				color_correction[ "$pp_colour_addr" ] = 0//-0.09
			 	color_correction[ "$pp_colour_addg" ] = 0//-0.09
			 	color_correction[ "$pp_colour_addb" ] = 0//-0.09
			 	color_correction[ "$pp_colour_mulr" ] = 0
			 	color_correction[ "$pp_colour_mulg" ] = 0
			 	color_correction[ "$pp_colour_mulb" ] = 0
	DrawColorModify(color_correction)
	
end
hook.Add( "RenderScreenspaceEffects", "DrawVignetteAndOtherEffect", RenderColorCorrection )

end