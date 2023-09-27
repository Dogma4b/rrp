local RRP = {}

function RRP.UpgradePrinter(ply)
	local ent = ply:GetEyeTrace().Entity
	
	if ent and ent:IsValid() and (ent:GetClass() == "money_printer" or ent:GetClass() == "money_printer_silver") then
		local order = ent:GetNWInt("Upgrade")
		if order >= 4 then
			DarkRP.notify(ply, 0, 4, "Твой принтер улучшен до максимально возможного уровня.")
		else
			local up = order+1
			local price = up*1000
			if ply:canAfford(4000) then
				ply:addMoney(-price)
				DarkRP.notify(ply, 0, 4, "Ты улучшил свой принтер до " .. up .. " уровня за " .. price .. " рублей")
				ent:SetNWInt("Upgrade",up)
			else
				DarkRP.notify(ply, 1, 4, "Тебе нехватает на улучшение принтера до " .. up .. " уровня - " .. price .." рублей")
			end
		end
	else
		DarkRP.notify(ply, 1, 4, "Ты должен смотреть на предмет чтобы его улучшить")
	end
	return ""
end
concommand.Add("rp_printer_upgrade",RRP.UpgradePrinter)