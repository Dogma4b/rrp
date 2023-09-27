// Antigaming Team 2014 //

// Hooks
RunConsoleCommand("sv_skyname", "painted")
hook.Add("InitPostEntity","SpawnTheProps",timer.Simple(1, function() if environment == nil then environment = ents.Create("env_skypaint") environment:Spawn() print("Entity environment spawned") else return end end))
//
AG_Weather = {}

AG_Weather["sunny"] = { ["skybox"] = { texture = "skybox/clouds", speed = 0.03, scale = 1.59, hdrscale = 0.55, fade = 1, topcolour = Vector(0.01, 0.15, 0.38), botcolour = Vector(0.07, 0.1, 0.31)}, ["sun"] = { normal = Vector(0,0,0), colour = Vector(0,0,0), size = 2.0, duskcolour = Vector(0,0,0), duskscale = 0, duskintencity = 0}, ["weather"] = { brightness = 0, contrast = 0, colour = 0, precipitation = 0, soundlevel = 0, pitch = 0, sound = ""}}
AG_Weather["night"] = { ["skybox"] = { texture = "skybox/starfield", speed = 0.01, scale = 1.59, hdrscale = 0.55, fade = 1, topcolour = Vector(0, 0, 0), botcolour = Vector(0, 0, 0)}, ["sun"] = { normal = Vector(0,0,0), colour = Vector(0,0,0), size = 2.0, duskcolour = Vector(0,0,0), duskscale = 0, duskintencity = 0}, ["weather"] = { brightness = 0, contrast = 0, colour = 0, precipitation = 0, soundlevel = 0, pitch = 0, sound = ""}}

function SetWeather()
	local weather = table.Random(AG_Weather)
	
	for k,v in pairs(weather) do
		if (k == "skybox") then
			environment:SetTopColor( v.topcolour )
			environment:SetBottomColor( v.botcolour )
			environment:SetFadeBias( v.fade )
			environment:SetDrawStars( true )
			environment:SetStarSpeed( v.speed )
			environment:SetStarScale( v.scale )
			environment:SetStarFade( v.fade )
			environment:SetStarTexture( v.texture )
			environment:SetHDRScale( v.hdrscale )
			print("skybox: "..table.ToString(v))
		elseif (k == "sun") then
			environment:SetSunNormal( v.normal )
			environment:SetSunColor( v.colour )
			environment:SetSunSize( v.size )
			environment:SetDuskColor( v.duskcolour ) 
			environment:SetDuskScale( v.duskscale )
			environment:SetDuskIntensity( v.duskintencity )
			print("sun: "..table.ToString(v))
		elseif (k == "weather") then
		print("weather: "..table.ToString(v))
		
		end
	end
end