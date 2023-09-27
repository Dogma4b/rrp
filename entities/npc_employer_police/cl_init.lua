include('shared.lua') 

function ENT:Draw()
	self:DrawModel()
end

function jobs_legal()
		
	local window = vgui.Create( "DFrame" ) -- Создаёт дерма окно.
		window:SetPos( ScrW()*-1, ScrH()/2-350 ) -- Позиция на экране игрока.
		window:SetSize( 400, 500 ) -- Размер рабочего окна.
		window:SetTitle( "Выбор профессии" ) -- Название дерма окна.
		window:SetVisible( true )
		window:SetDraggable( false ) -- Делает окно передвежным.
		window:ShowCloseButton( true ) -- Показывает закрывающий крестик.
		window:MoveTo( ScrW()/2-500, ScrH()/2-350, .5, 0, .5)
		window:MakePopup()
		window.btnClose.DoClick = function() window:MoveTo( ScrW()*-1, ScrH()/2-350, .5, 0, .5) timer.Create("CloseFrame",1,1,function() window:Close() end) window:SetMouseInputEnabled(false) window:SetKeyboardInputEnabled(false) end
		window.Paint = function()
			draw.RoundedBox( 8, 0, 0, window:GetWide(), window:GetTall(), Color( 0, 0, 0, 150 ) )
		end
	
	/*local closebtn = vgui.Create( "DImageButton", window )
		closebtn:SetPos( 515, 5 )
		closebtn:SetImage( "rusrp/close_button.vtf" ) -- Set your .vtf image
		closebtn:SizeToContents()
		closebtn.DoClick = function()
			window:Close()
	end*/
--------------------
	local list1 = vgui.Create("DPanelList", window)
	list1:SetSize(390, 470)
	list1:SetPos(5, 25)
	list1:SetSpacing( 5 )
	list1:EnableHorizontal( false )
	list1:EnableVerticalScrollbar( true )
	
	local function info(desc,model)
		local window_info = vgui.Create( "DFrame" ) -- Создаёт дерма окно.
			window_info:SetPos( ScrW()*1, ScrH()/2-350 ) -- Позиция на экране игрока.
			window_info:SetSize( 300, 500 ) -- Размер рабочего окна.
			window_info:SetTitle( "Описание профессии" ) -- Название дерма окна.
			window_info:SetVisible( true )
			window_info:SetDraggable( false ) -- Делает окно передвежным.
			window_info:ShowCloseButton( true ) -- Показывает закрывающий крестик.
			window_info:MoveTo( ScrW()/2+200, ScrH()/2-350, .5, 0, .5)
			window_info:MakePopup()
			window_info.btnClose.DoClick = function() window_info:MoveTo( ScrW()*1, ScrH()/2-350, .5, 0, .5) timer.Create("CloseFrame",1,1,function() window_info:Close() end) window_info:SetMouseInputEnabled(false) window_info:SetKeyboardInputEnabled(false) end
			window_info.Paint = function()
				draw.RoundedBox( 8, 0, 0, window_info:GetWide(), window_info:GetTall(), Color( 0, 0, 0, 230 ) )
			end
			
			local desc1 = vgui.Create("DLabel", window_info)
			desc1:SetText( desc )
			desc1:SizeToContents()
			desc1:SetPos(5, 25)
			
			local icon = vgui.Create( "DModelPanel", window_info )
			icon:SetModel( model )
			icon:SetPos( 5, 50 )
			icon:SetSize( 300, 300 )
			icon:SetFOV(90)
	end
	
	local function AddList(job_model,job_name,job_command,job_desc)
	//for k,v in pairs(model) do
		local DPanel1 = vgui.Create('DPanel', list1)
		DPanel1:SetSize(390, 100)
		DPanel1.Paint = function()
		surface.SetDrawColor( 0,0,200,255 )
		surface.DrawRect( 0,0,DPanel1:GetWide(),DPanel1:GetTall() )
		draw.RoundedBox( 0, 1, 1, DPanel1:GetWide()-2, DPanel1:GetTall()-2, Color( 0, 0, 0, 255 ) )
		end
											--ITEM #1--
		local icon = vgui.Create("SpawnIcon", DPanel1)
		icon:SetModel( job_model )
		icon:SetPos(5,5)
		icon:SetMouseInputEnabled(false)
		
		local name = vgui.Create("DLabel", DPanel1)
		name:SetText( job_name )
		name:SizeToContents()
		name:SetPos(89, 5)
		
		/*local desc = vgui.Create("DLabel", DPanel1)
		desc:SetText( job_desc )
		desc:SizeToContents()
		desc:SetPos(89, 20)*/
		
		local desc = vgui.Create("DButton", DPanel1)
		desc:SetSize(70, 15)
		desc:SetPos(70, 77)
		desc:SetText("Информация")
		desc.DoClick = function()
			info(job_desc,job_model)
		end
		
		local drop = vgui.Create("DButton", DPanel1)
		drop:SetSize(50, 15)
		drop:SetPos(10, 77)
		drop:SetText("Выбрать")
		drop.DoClick = function()
		window:Close()
			LocalPlayer():ConCommand( "say /" .. job_command )
		end
		list1:AddItem(DPanel1)
	end
if LocalPlayer():Team() == TEAM_POLICE then
AddList("models/player/ct_urban.mdl", "Повар", "cook", "Ваша работа готовить еду и кормить жителей города.\nОткройте кафе и продавайте там еду или же\nходите по городу в поисках клиентов.\nНуждающихся в еде пропускайте вне очереди")
AddList("models//player/ct_gsg9.mdl", "Бармен", "bartender", "Вы Бармен.\nВаша работа открыть небольшой бар.\nДоговоритесь с Поваром и устройте совместное кафе!\nВся ваша продукция абсолютно легальна.")
AddList("models/player/ct_sas.mdl", "Охранник", "guard", "Вы охранник.\nВаша задача охранять людей или имущество.\nДоговоритесь с Банкиром об охране банка,\nили с Поваром об охране магазина.\nВы можете охранять Мэра или Мафиози.\nЗа умеренную плату разумеется!")

else
AddList("models/mw2/cop.mdl", "Полицейский", "cp", "Вы защитник честных граждан города.\nВаша работа - арестовывать преступников.\nВыполняйте распоряжения Мэра.\nЕсли объявлен комендантский час,\nследите за тем, чтобы никого не было на улицах.\nПроводите обыск квартир,\nконфисковывайте нелегальное имущество.\nПроверяйте людей на наличие оружия.")
AddList("models/player/breen.mdl", "Мэр города", "mayor", "Вы Мэр города.\nВы имеете право создавать новые законы.\nВы можете разрешить Money Printer или ношение легкого оружия.\nУправляйте Полицией, следите за порядком в городе.\nНаправьте Полицию патрулировать город.\nВ крайнем случае, введите комендантский час.")

end
/*AddList("models/player/kleiner.mdl", "Медик", "medic", "Лечите людей за умеренную плату.\nБез медика человек не сможет пополнить запас здоровья.\nДоговоритесь с местной бандой и лечите её членов или\nдоговоритесь с полицией и помогайте им.\nОткройте больницу, чтобы обеспечить себе неплохой заработок.")
AddList("models/player/mossman.mdl", "Повар", "cook", "Ваша работа готовить еду и кормить жителей города.\nОткройте кафе и продавайте там еду или же\nходите по городу в поисках клиентов.\nНуждающихся в еде пропускайте вне очереди")
AddList("models/player/eli.mdl", "Бармен", "bartender", "Вы Бармен.\nВаша работа открыть небольшой бар.\nДоговоритесь с Поваром и устройте совместное кафе!\nВся ваша продукция абсолютно легальна.")
AddList("models/player/odessa.mdl", "Охранник", "guard", "Вы охранник.\nВаша задача охранять людей или имущество.\nДоговоритесь с Банкиром об охране банка,\nили с Поваром об охране магазина.\nВы можете охранять Мэра или Мафиози.\nЗа умеренную плату разумеется!")
AddList("models/player/Hostage/Hostage_02.mdl", "Банкир", "banker", "Вы банкир.\nВаша задача открыть банк.\nПрежде чем это сделать поговорите с Мэром,\nесли он даст разрешение,\nто храните в банке Money Printer'ы других игроков.\nОрганизуйте защиту банка, наймите Body Guard'а.\nБерите процент от печатаемых Money Printer'ом денег.")
AddList("models/player/monk.mdl", "Торговец Вооружением", "gundealer", "Дилер Оружия продаёт оружие людям.\nБудьте уверены, что у ваших клиентов есть лицензия на оружие,\nв противном случае повысьте цену на товар.\nДоговоритесь с местной бандой.\nПоставляйте им оружие по сниженным ценам.\nВы не можете работать исключительно на банду,\nэто пресекает вашей рабочей этике.")
AddList("models/player/gman_high.mdl", "Глава Гангстеров", "mobboss", "The Mobboss is the boss of the criminals in the city.\nWith his power he coordinates the gangsters and forms an efficent crime\norganization.\nHe has the ability to break into houses by using a lockpick.\nThe Mobboss also can unarrest you.")
AddList("models/player/Group03/male_03.mdl", "Гангстер", "gangster", "Вы самое низкое звено преступности.\nРаздобудьте себе ствол и устраивайте рэкет местных граждан.\nЗаставьте торгашей выплачивать вам дань.\nВыполняйте заказные убийства.\nРаботайте плечом к плачу с профессиональными ворами.")
AddList("models/player/leet.mdl", "Вор", "theif", "Вы вор, ваша задача\n\"помогать людям избавляться от ненужного хлама\".\nПроникайте в тюремные участки и освобождайте заключенных.\nВы можете вступить как в банду, так и работать одиночкой.\nИспользуйте Инвентарь, он вам очень пригодиться.\nСтарайтесь не привлекать внимания Полиции.")
AddList("models/player/corpse1.mdl", "Бродяга", "hobo", "Вы изгой общества.\nУ вас нет дома, постройте его себе из мусора.\nПросите деньги на пропитание.\nВ скупых людей кидайтесь грязью (ЛКМ с оружием Bugbait),\nщедрым пойте (ПКМ с оружием Bugbait).\nУчтите, спам Bugbait'ами карается Баном!")*/

end

usermessage.Hook("jobs_police", jobs_legal) 