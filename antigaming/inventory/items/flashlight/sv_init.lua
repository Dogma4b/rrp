// Antigaming Team 2014 //

function AllowFlashlight(ply,state)
	if state then
		if RRP.CheckItem(ply,700) != nil then
			//print("Flashlight on")
		else
			DarkRP.notify(ply,1,4,"У тебя нет фонарика, купи его")
			return false
		end
	end
end

hook.Add("PlayerSwitchFlashlight","AllowFlashlight",AllowFlashlight)