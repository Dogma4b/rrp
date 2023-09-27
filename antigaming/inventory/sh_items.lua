// Antigaming Team 2014 //

// Register new item and get him //

AG = AG or {}
AG_Items = {}

function AG:AddItem(id,type,name,model,desc)
	AG_Items[id] = {type = type, name = name, model = model, desc = desc}
end

function AG:GetItem(id)
	return AG_Items[id]
end

/*util.AddNetworkString("SendRequestItemsTable") 
net.Receive( "SendRequestItemsTable", function(len, ply)
	util.AddNetworkString("SendItemsTable") 
	net.Start( "SendItemsTable" )
		net.WriteTable( AG_Items ) 
	net.Send(ply)
end)*/

// End //

AG:AddItem(301,"item","Набор отмычек","models/weapons/w_defuser.mdl","Одноразовый набор дверных отмычек.\n+ 70% к скорости взлома")
AG:AddItem(302,"item","Батарейка","models/Items/battery.mdl","Одноразовая батарейка.\nСлужит источником питания фонарика,\nа также служит источником питания некоторых электроприборов.\nТребуеться для крафта некоторых вещей.")
AG:AddItem(401,"item","Тестовый крафт","models/weapons/w_defuser.mdl","Одноразовый набор дверных отмычек.\n+ 70% к скорости взлома")

//Ресурсы

AG:AddItem(501,"resource","Дерево","antigaming/craft/none.png","")
AG:AddItem(502,"resource","Железо","antigaming/craft/none.png","")

//Предметы влияющие на совершение каких то действий в игре

AG:AddItem(700,"item","Фонарик","models/maxofs2d/lamp_flashlight.mdl","предназначен для работы в качестве индивидуального осветительного прибора.\nФонарик выполнен в виде небольшого цилиндра.\nФонарик имеет неразборную конструкцию и защищен от прямого попадания осадков.\nДанный электроприбор использует в качестве энергоисточника одноразовые батарейки.")
