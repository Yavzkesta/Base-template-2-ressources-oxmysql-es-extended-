_print = print
TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion


local deathCause = {}

local weaponHashType = { "Inconnue", "Dégâts de mêlée", "Blessure par balle", "Chute", "Dégâts explosifs", "Feu", "Chute", "Éléctrique", "Écorchure", "Gaz", "Gaz", "Eau" }
local boneTypes = {
    ["Dos"] = { 0, 23553, 56604, 57597 },
    ["Crâne"] = { 1356, 11174, 12844, 17188, 17719, 19336, 20178, 20279, 20623, 21550, 25260, 27474, 29868, 31086, 35731, 43536, 45750, 46240, 47419, 47495, 49979, 58331, 61839, 39317 },
    ["Coude droit"] = { 2992 },
    ["Coude gauche"] = { 22711 },
    ["Main gauche"] = { 4089, 4090, 4137, 4138, 4153, 4154, 4169, 4170, 4185, 4186, 18905, 26610, 26611, 26612, 26613, 26614, 60309 },
    ["Main droite"] = { 6286, 28422, 57005, 58866, 58867, 58868, 58869, 58870, 64016, 64017, 64064, 64065, 64080, 64081, 64096, 64097, 64112, 64113 },
    ["Bras gauche"] = { 5232, 45509, 61007, 61163 },
    ["Bras droit"] = { 28252, 40269, 43810 },
    ["Jambe droite"] = { 6442, 16335, 51826, 36864 },
    ["Jambe gauche"] = { 23639, 46078, 58271, 63931 },
    ["Pied droit"] = { 20781, 24806, 35502, 52301 },
    ["Pied gauche"] = { 2108, 14201, 57717, 65245 },
    ["Poîtrine"] = { 10706, 64729, 24816, 24817, 24818 },
    ["Ventre"] = { 11816 },
}

local function MarquerJoueur()
		local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
		local pos = GetEntityCoords(ped)
		local target, distance = ESX.Game.GetClosestPlayer()
	if distance <= 4.0 then
		DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 1, nil, nil, 0)
	end
end

function tableHasValue(tbl, value, k)
	if not tbl or not value or type(tbl) ~= "table" then return end
	for _,v in pairs(tbl) do
		if k and v[k] == value or v == value then return true, _ end
	end
end

function GetAllCauseOfDeath(ped)
    local exist, lastBone = GetPedLastDamageBone(ped)
    local cause, what, timeDeath = GetPedCauseOfDeath(ped), Citizen.InvokeNative(0x93C8B64DEB84728C, ped), Citizen.InvokeNative(0x1E98817B311AE98A, ped)
    if what and DoesEntityExist(what) then
        if IsEntityAPed(what) then
            what = "Traces de combat"
        elseif IsEntityAVehicle(what) then
            what = "Écrasé par un véhicule"
        elseif IsEntityAnObject(what) then
            what = "Semble s'être pris un objet"
        end
    end
    what = type(what) == "string" and what or "Inconnue"

    if cause then
        if IsWeaponValid(cause) then
            cause = weaponHashType[GetWeaponDamageType(cause)] or "Inconnue"
        elseif IsModelInCdimage(cause) then
            cause = "Véhicule"
        end
    end
    cause = type(cause) == "string" and cause or "Mêlée"

    local boneName = "Dos"
    if exist and lastBone then
        for k, v in pairs(boneTypes) do
            if tableHasValue(v, lastBone) then
                boneName = k
                break
            end
        end
    end

    return timeDeath, what, cause, boneName
end

local firstSpawn, PlayerLoaded = true, false

isDead = false


AddEventHandler('esx:onPlayerSpawn', function()
	isDead = false

	if firstSpawn then
		firstSpawn = false

		if Config.AntiCombatLog then
			while not PlayerLoaded do
				Citizen.Wait(1000)
			end

			ESX.TriggerServerCallback('esx_ambulancejob:getDeathStatus', function(shouldDie)
			end)
		end
	end
end)

function OnPlayerDeath()
	isDead = true
	deathCause = table.pack(GetAllCauseOfDeath(GetPlayerPed(-1)))
	ESX.UI.Menu.CloseAll()
	RageUI.CloseAll()
	Wait(100)
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', true)
	StartDeathTimer()
	SetTimecycleModifier("damage")
	PlaySoundFrontend(-1, "Bed", "WastedSounds", true)
	SetPedMovementClipset(PlayerPedId(), "move_m@injured", true)
	wsshmagrossebeat()
end



local societyambulancemoney = nil
local openBossAmbulance = false 
local mainBossAmbulancee = RageUI.CreateMenu("Ambulance", "orasity")
mainBossAmbulancee.Closed = function()
  openBossAmbulance = false
  coffreambulance = false 
  caisseambulance = false
  deposerambu = false
  prendreambu = false
end

listambulance, listambulancesecond, caisseambulance, coffreambulance, deposerambu, prendreambu = 1, 1, true, false, true, false

ratatatadanstamere = function()
	if openBossAmbulance == false then 
		openBossAmbulance = true
		RageUI.Visible(mainBossAmbulancee, true)
        GetAmbulance2()
        getDepAmbulance2()
        Wait(150)
		CreateThread(function()
		while openBossAmbulance do 
		   RageUI.IsVisible(mainBossAmbulancee,function() 


            local distance = #(GetEntityCoords(PlayerPedId()) - Config.coffrehosto);

                if distance <= 1.5 then 

                RageUI.List("~r~Interaction~s~", {"Caisse", "Coffre"}, listambulance,nil,{},true,{
                    onListChange = function(Index)
                        listambulance = Index
                        if Index == 1 then
                            if caisseambulance == false then 
                                caisseambulance = true 
                                coffreambulance = false
                                deposerambu = false
                                prendreambu = false
                            else 
                                caisseambulance = false 
                                coffreambulance = false
                                deposerambu = false
                                prendreambu = false
                            end
                        elseif Index == 2 then 
                            if coffreambulance == false then 
                                caisseambulance = false 
                                coffreambulance = true
                                deposerambu = true
                                prendreambu = false
                            else 
                                deposerambu = false
                                caisseambulance = false 
                                coffreambulance = false 
                                prendreambu = false
                            end
                        end
                    end
                })

                if caisseambulance == true then 

                    if  ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' and ESX.PlayerData.job.grade_name == 'boss' then 

                        RageUI.Separator("~b~↓~s~ Caisse de l'entreprise ~s~~b~↓~s~")

                        if societyambulancemoney ~= nil then
                            RageUI.Button("Argent société :", nil, {RightLabel = "$" .. societyambulancemoney}, true , {})
                        end


                        RageUI.Button("Retirer argent de société", nil, {RightLabel = "→→"}, true , {
                            onSelected = function()
                            local amount = ESX.ImputKeyboard("Montant", "Montant à retirer", nil, 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                ESX.ShowNotification("Montant invalide")
                            else
                                TriggerServerEvent('esx_society:withdrawMoney', 'ambulance', amount)
                                RefreshambulanceMoney()
                            end
                            end
                        })
        
                        RageUI.Button("Déposer argent de société", nil, {RightLabel = "→→"}, true , {
                        onSelected = function()
                            local amount = ESX.ImputKeyboard("Montant", "Montant à déposer", nil, 10)
                            amount = tonumber(amount)
                            if amount == nil then
                                ESX.ShowNotification("Montant invalide")
                            else
                                TriggerServerEvent('esx_society:depositMoney', 'ambulance', amount)
                                RefreshambulanceMoney()
                            end
                        end
                    })
        
                    RageUI.Button("Accéder aux actions de Management", nil, {RightLabel = "→→"}, true , {
                        onSelected = function()
                            ambulanceboss()
                            RageUI.CloseAll()
                            openBossAmbulance = false
                        end
                      })

                    else 
                        RageUI.Separator()
                        RageUI.Separator("~r~Vous n'avez pas accès.")
                        RageUI.Separator()
                    end

                end

                if coffreambulance == true then 

                    RageUI.List("~r~Interaction coffre~s~", {"Déposer", "Retirer"}, listambulancesecond,nil,{},true,{
                        onListChange = function(Index)
                            listambulancesecond = Index
                            if Index == 1 then
                                if deposerambu == false then 
                                    caisseambulance = false
                                    coffreambulance = true
                                    deposerambu = true
                                    prendreambu = false
                                else 
                                    caisseambulance = false 
                                    coffreambulance = false
                                    deposerambu = false
                                    prendreambu = false
                                end
                            elseif Index == 2 then 
                                if prendreambu == false then 
                                    caisseambulance = false 
                                    coffreambulance = true
                                    deposerambu = false
                                    prendreambu = true
                                else 
                                    deposerambu = false
                                    caisseambulance = false 
                                    coffreambulance = false 
                                    prendreambu = false
                                end
                            end
                        end
                    })
    
                    if deposerambu == true then 

                        RageUI.Separator("↓ Inventaire ↓")

                        for k,v in pairs(all_itemsss) do
                            RageUI.Button(v.label, nil, {RightLabel = "~r~x"..v.nb}, true , {
                                onSelected = function()
                                    local count = ESX.ImputKeyboard("Combien voulez vous déposer", "Combien voulez vous déposer", nil, 10)
                                    count = tonumber(count)
                                    TriggerServerEvent("ambulance:putStockItems",v.item, count)
                                    GetAmbulance2()
                                    getDepAmbulance2()
                                end
                            })
                        end

                    end

                    if  prendreambu == true then 

                        RageUI.Separator("↓  Stocks de l'Entreprise ↓")

                        for k,v in pairs(all_items) do
                            RageUI.Button(v.label, nil, {RightLabel = "~r~x"..v.nb}, true , {
                                onSelected = function()
                                    local count = ESX.ImputKeyboard("", "Combien voulez vous retirer", nil, 10)
                                    count = tonumber(count)
                                    if count <= v.nb then
                                        TriggerServerEvent("ambulance:takestockitem",v.item, count)
                                    else
                                        ESX.ShowNotification("<C>~r~Vous n'en avez pas assez sur vous</C>")
                                    end
                                    GetAmbulance2()
                                    getDepAmbulance2()
                                end
                            })
                        end

                    end
                    
                end

            else
                openBossAmbulance = false
                RageUI.Visible(mainBossAmbulancee, false)
            end

         end)
       Wait(0)
      end
   end)
end
end


local openGarageAmbulance = false 
local mainGarageAmbulancee = RageUI.CreateMenu("Ambulance", "orasity")
mainGarageAmbulancee.Closed = function()
    openGarageAmbulance = false
end

garageAmbulanceMonKho = function()
	if openGarageAmbulance == false then 
		openGarageAmbulance = true
		RageUI.Visible(mainGarageAmbulancee, true)
		CreateThread(function()
		while openGarageAmbulance do 
		   RageUI.IsVisible(mainGarageAmbulancee,function() 

            local distance = #(GetEntityCoords(PlayerPedId()) - Config.Garagehosto);

            if distance < 3.5 then 

                for k,v in pairs(tableAmbulance.vehicles) do 
                    RageUI.Button(v.Label, nil, {}, true, {
                        onSelected = function()
                            if ESX.Game.IsSpawnPointClear(v.coords, 1.5) then
                            ESX.Game.SpawnVehicle(v.Model, v.coords, v.heading, function() end)
                            else 
                                ESX.ShowNotification("~r~Quelque chose semble bloqué le véhicule.")
                            end
                        end
                    })
                end
        
            else 
                openGarageAmbulance = false
                RageUI.Visible(mainGarageAmbulancee, false)
            end

         end)
       Wait(0)
      end
   end)
end
end


local tglemesss = 1 --# RageUI LIST
local openamBuLancePhaRmacie = false 
local MainamBuLancePhaRmacie = RageUI.CreateMenu("Ambulance", "pharmacie")
MainamBuLancePhaRmacie.Closed = function()
 openamBuLancePhaRmacie = false
end

CoucouamBuLancePhaRmacie = function()
   if openamBuLancePhaRmacie == false then 
	   openamBuLancePhaRmacie = true
	   RageUI.Visible(MainamBuLancePhaRmacie, true)
	   CreateThread(function()
	   while openamBuLancePhaRmacie do 
		  RageUI.IsVisible(MainamBuLancePhaRmacie, function() 


			local distance = #(GetEntityCoords(PlayerPedId()) - Config.pharmaciehosto);
	
				if distance < 10.0 then

                RageUI.List("Prendre dans la pharmacie :", {"~b~Bandage~s~", "~b~Kit de soin~s~"}, tglemesss,nil,{},true,{
                        onListChange = function(Index)
                            tglemesss = Index
                        end,
                        onSelected = function(Index)
                            if Index == 1 then
                                TriggerServerEvent("Pharmacy:giveitem", "bandage")
                            elseif Index == 2 then
								TriggerServerEvent("Pharmacy:giveitem", "medikit")
                            end
                        end
                    })

				else 
					openamBuLancePhaRmacie = false
					RageUI.Visible(MainamBuLancePhaRmacie, false)
				end

                end)
                Wait(0)
            end
        end)
    end
end


function RefreshambulanceMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyambulanceMoney(money)
        end, ESX.PlayerData.job.name)
    end
end
  
function UpdateSocietyambulanceMoney(money)
    societyambulancemoney = ESX.Math.GroupDigits(money)
end

function ambulanceboss()
TriggerEvent('esx_society:openBossMenu', 'ambulance', function(data, menu)
    menu.close()
end, {wash = false})
end

function getDepAmbulance2()
    ESX.TriggerServerCallback('ambulance:playerinventory', function(inventory)       
        all_itemsss = inventory
    end)
end

function GetAmbulance2()
    ESX.TriggerServerCallback('ambulance:getStockItems', function(inventory)                     
        all_items = inventory
    end)
end

CreateThread(function()
    ESX.CreateBlipsKingder(61, 0.75, 66, "Hopital", Config.blipshosto)
    while true do 
        local sleepAmbulance = 700

        local distance = #(GetEntityCoords(PlayerPedId()) - Config.coffrehosto);

        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

            if distance < 10.0 then
                sleepAmbulance = 0;
                DrawMarker(2, Config.coffrehosto, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.1, 0.1, 0.1, 95, 73, 160, 255, false, false, false, false)
            end     

            if distance <= 1.5 then
                sleepAmbulance = 0;
               Visual.Subtitle("<C>Appuyer sur ~b~[E]~s~ acceder aux coffres.</C>", 1) 
        
                if IsControlJustPressed(1, 51) then
                    RefreshambulanceMoney()
                    ratatatadanstamere()
                end
            end
        end

		if isDead == true then 
			sleepAmbulance = 0;

			DisableControlAction(0, 19, true) -- INPUT_CHARACTER_WHEEL
			DisableControlAction(0, 21, true) -- INPUT_SPRINT
			DisableControlAction(0, 22, true) -- INPUT_JUMP
			DisableControlAction(0, 23, true) -- INPUT_ENTER
			DisableControlAction(0, 24, true) -- INPUT_ATTACK
			DisableControlAction(0, 25, true) -- INPUT_AIM
			DisableControlAction(0, 26, true) -- INPUT_LOOK_BEHIND
			DisableControlAction(0, 38, true) -- INPUT KEY
			DisableControlAction(0, 44, true) -- INPUT_COVER
			DisableControlAction(0, 45, true) -- INPUT_RELOAD
			DisableControlAction(0, 50, true) -- INPUT_ACCURATE_AIM
			DisableControlAction(0, 51, true) -- CONTEXT KEY
			DisableControlAction(0, 58, true) -- INPUT_THROW_GRENADE
			DisableControlAction(0, 59, true) -- INPUT_VEH_MOVE_LR
			DisableControlAction(0, 60, true) -- INPUT_VEH_MOVE_UD
			DisableControlAction(0, 61, true) -- INPUT_VEH_MOVE_UP_ONLY
			DisableControlAction(0, 62, true) -- INPUT_VEH_MOVE_DOWN_ONLY
			DisableControlAction(0, 63, true) -- INPUT_VEH_MOVE_LEFT_ONLY
			DisableControlAction(0, 64, true) -- INPUT_VEH_MOVE_RIGHT_ONLY
			DisableControlAction(0, 65, true) -- INPUT_VEH_SPECIAL
			DisableControlAction(0, 66, true) -- INPUT_VEH_GUN_LR
			DisableControlAction(0, 67, true) -- INPUT_VEH_GUN_UD
			DisableControlAction(0, 68, true) -- INPUT_VEH_AIM
			DisableControlAction(0, 69, true) -- INPUT_VEH_ATTACK
			DisableControlAction(0, 70, true) -- INPUT_VEH_ATTACK2
			DisableControlAction(0, 71, true) -- INPUT_VEH_ACCELERATE
			DisableControlAction(0, 72, true) -- INPUT_VEH_BRAKE
			DisableControlAction(0, 73, true) -- INPUT_VEH_DUCK
			DisableControlAction(0, 74, true) -- INPUT_VEH_HEADLIGHT
			DisableControlAction(0, 75, true) -- INPUT_VEH_EXIT
			DisableControlAction(0, 76, true) -- INPUT_VEH_HANDBRAKE
			DisableControlAction(0, 86, true) -- INPUT_VEH_HORN
			DisableControlAction(0, 92, true) -- INPUT_VEH_PASSENGER_ATTACK
			DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
			DisableControlAction(0, 140, true) -- INPUT_MELEE_ATTACK_LIGHT
			DisableControlAction(0, 141, true) -- INPUT_MELEE_ATTACK_HEAVY
			DisableControlAction(0, 142, true) -- INPUT_MELEE_ATTACK_ALTERNATE
			DisableControlAction(0, 143, true) -- INPUT_MELEE_BLOCK
			DisableControlAction(0, 144, true) -- PARACHUTE DEPLOY
			DisableControlAction(0, 145, true) -- PARACHUTE DETACH
			DisableControlAction(0, 156, true) -- INPUT_MAP
			DisableControlAction(0, 157, true) -- INPUT_SELECT_WEAPON_UNARMED
			DisableControlAction(0, 158, true) -- INPUT_SELECT_WEAPON_MELEE
			DisableControlAction(0, 159, true) -- INPUT_SELECT_WEAPON_HANDGUN
			DisableControlAction(0, 160, true) -- INPUT_SELECT_WEAPON_SHOTGUN
			DisableControlAction(0, 161, true) -- INPUT_SELECT_WEAPON_SMG
			DisableControlAction(0, 162, true) -- INPUT_SELECT_WEAPON_AUTO_RIFLE
			DisableControlAction(0, 163, true) -- INPUT_SELECT_WEAPON_SNIPER
			DisableControlAction(0, 164, true) -- INPUT_SELECT_WEAPON_HEAVY
			DisableControlAction(0, 165, true) -- INPUT_SELECT_WEAPON_SPECIAL
			DisableControlAction(0, 166, true) -- INPUT_SELECT_WEAPON_SPECIAL
			DisableControlAction(0, 183, true) -- GCPHONE
			DisableControlAction(0, 243, true) -- INPUT_ENTER_CHEAT_CODE
			DisableControlAction(0, 244, true) -- PERSONAL MENU
			DisableControlAction(0, 257, true) -- INPUT_ATTACK2
			DisableControlAction(0, 261, true) -- INPUT_PREV_WEAPON
			DisableControlAction(0, 262, true) -- INPUT_NEXT_WEAPON
			DisableControlAction(0, 263, true) -- INPUT_MELEE_ATTACK1
			DisableControlAction(0, 264, true) -- INPUT_MELEE_ATTACK2

		end
		
		local distance = #(GetEntityCoords(PlayerPedId()) - Config.pharmaciehosto);

        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

            if distance < 10.0 then
                sleepAmbulance = 0;
                DrawMarker(2, Config.pharmaciehosto, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.1, 0.1, 0.1, 95, 73, 160, 255, false, false, false, false)
            end     

            if distance <= 1.5 then
                sleepAmbulance = 0;
               Visual.Subtitle("<C>Appuyer sur ~b~[E]~s~ acceder à la pharmacie.</C>", 1) 
        
                if IsControlJustPressed(1, 51) then
					CoucouamBuLancePhaRmacie()
                end
            end
        end
        local distance = #(GetEntityCoords(PlayerPedId()) - Config.Garagehosto);

        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

            if distance < 10.0 then
                sleepAmbulance = 0;
                DrawMarker(2, Config.Garagehosto, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.1, 0.1, 0.1, 95, 73, 160, 255, false, false, false, false)
            end     

            if distance <= 1.5 then
                sleepAmbulance = 0;
               Visual.Subtitle("<C>Appuyer sur ~b~[E]~s~ acceder au garage.</C>", 1) 
        
                if IsControlJustPressed(1, 51) then
                    garageAmbulanceMonKho()
                end
            end
        end
        local distance = #(GetEntityCoords(PlayerPedId()) - Config.Helicohosto);

        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

            if distance < 10.0 then
                sleepAmbulance = 0;
                DrawMarker(2, Config.Helicohosto, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.1, 0.1, 0.1, 95, 73, 160, 255, false, false, false, false)
            end     

            if distance <= 1.5 then
                sleepAmbulance = 0;
                if not IsPedInAnyHeli(PlayerPedId()) then 
                    Visual.Subtitle("<C>Appuyer sur ~b~[E]~s~ acceder au garage hélicoptère.</C>", 1) 
                else 
                    Visual.Subtitle("<C>Appuyer sur ~b~[E]~s~ ranger l'hélicoptère.</C>", 1) 
                end

                if IsControlJustPressed(1, 51) then
                    if not IsPedInAnyHeli(PlayerPedId()) then 
                        ESX.Game.SpawnVehicle("polmav", Config.Helicohosto, 310.13, function(helico) 
                            SetVehicleExtra(helico, 3, true)
                            TaskWarpPedIntoVehicle(PlayerPedId(), helico, -1)
                        end)
                    else 
                        local caca = GetVehiclePedIsIn(PlayerPedId(), false)
                        DeleteEntity(caca)
                    end
                end
            end
        end
		local distance = #(GetEntityCoords(PlayerPedId()) - Config.rangervehiclehosto);

        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then

            if distance < 10.0 then
                sleepAmbulance = 0;
                DrawMarker(2, Config.rangervehiclehosto, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.1, 0.1, 0.1, 95, 73, 160, 255, false, false, false, false)
            end     

            if distance <= 1.5 then
                sleepAmbulance = 0;
                    Visual.Subtitle("<C>Appuyer sur ~b~[E]~s~ acceder ranger le véhicule.</C>", 1) 
        

                if IsControlJustPressed(1, 51) then
					local caca = GetVehiclePedIsIn(PlayerPedId(), false)
					DeleteEntity(caca)
                end
            end
        end
        Wait(sleepAmbulance)
    end
end)



local mortAmbulance = false 
local mainMortAmbulance = RageUI.CreateMenu("Ambulance", "orasity")
local subMortAmbulance = RageUI.CreateSubMenu(mainMortAmbulance, "Ambulance", "orasity")
mainMortAmbulance.Closed = function()
  mortAmbulance = false
end


mainMortAmbulance.Closable = false 
subMortAmbulance.Closable = false

wsshmagrossebeat = function()
	if mortAmbulance == false then 
		mortAmbulance = true
		RageUI.Visible(mainMortAmbulance, true)
		ESX.TriggerServerCallback('guettetongroupepdpdpdp', function(group)
			playergroup = group
		end)
        Wait(150)
		CreateThread(function()
		while mortAmbulance do 
		   RageUI.IsVisible(mainMortAmbulance,function() 

			RageUI.Separator("")
			RageUI.Button("Appuyez sur ~b~ENTRER~s~ pour envoyer le signal", nil, {}, true, {
				onSelected = function()
					local reasonResults = ("Urgent")
					local playerName = GetPlayerName(PlayerId())
					local typereport = "Appel EMS"
					local nameResults = "Appel EMS"
					TriggerServerEvent('ems:ajoutappels', typereport, playerName, nameResults, reasonResults)
					TriggerEvent("AppelemsGetCoords")
					ESX.ShowAdvancedNotification("Détresse", "~g~EMS", "Ta position a était envoyer au Ambulancier en service", "CHAR_CALL911", 7)
				end
			}, subMortAmbulance)


			RageUI.Button("Origine :", nil, {RightLabel = "~b~".. (deathCause[2] or "Inconnue").. "~s~"}, true , {})
			RageUI.Button("Blessure :", nil, {RightLabel = "~b~".. (deathCause[4] or "Inconnu").. "~s~"}, true , {})
			RageUI.Button("Cause :", nil, {RightLabel = "~b~".. (deathCause[3] or "Inconnue").. "~s~"}, true , {})
								

			if playergroup ~= nil and playergroup == "admin" or playergroup == "superadmin" or playergroup == "helper" then 
 
				RageUI.Separator("~r~Option(s) staff")

				RageUI.Button("Appuyez sur ~b~ENTRER~s~ pour vous réanimer", nil, {}, true, {
					onSelected = function()
						ExecuteCommand("revive me")
					end
				})


			end

			end)


			RageUI.IsVisible(subMortAmbulance, function()
			
				RageUI.Separator("")
			
				RageUI.Button("Position envoyer..", "~o~Tu dois attendre qu'un ~g~EMS~o~ viennent a ton secours", {}, true, {})

				RageUI.Button("Origine :", nil, {RightLabel = "~b~".. (deathCause[2] or "Inconnue").. "~s~"}, true , {})
				RageUI.Button("Blessure :", nil, {RightLabel = "~b~".. (deathCause[4] or "Inconnu").. "~s~"}, true , {})
				RageUI.Button("Cause :", nil, {RightLabel = "~b~".. (deathCause[3] or "Inconnue").. "~s~"}, true , {})

				if playergroup ~= nil and playergroup == "admin" or playergroup == "superadmin" or playergroup == "helper" then 
 
					RageUI.Separator("~r~Option(s) staff")
	
					RageUI.Button("Appuyez sur ~b~ENTRER~s~ pour vous réanimer", nil, {}, true, {
						onSelected = function()
							ExecuteCommand("revive me")
						end
					})
	
	
				end
	

			end)
			Wait(0)
			end
		end)
	end
end



RegisterNetEvent('esx_ambulancejob:useItem')
AddEventHandler('esx_ambulancejob:useItem', function(itemName)
	ESX.UI.Menu.CloseAll()

	if itemName == 'medikit' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end

			TriggerEvent('esx_ambulancejob:heal', 'big', true)
			ESX.ShowNotification('used_medikit')
		end)

	elseif itemName == 'bandage' then
		local lib, anim = 'anim@heists@narcotics@funding@gang_idle', 'gang_chatting_idle01' -- TODO better animations
		local playerPed = PlayerPedId()

		ESX.Streaming.RequestAnimDict(lib, function()
			TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)

			Citizen.Wait(500)
			while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
				Citizen.Wait(0)
				DisableAllControlActions(0)
			end

			TriggerEvent('esx_ambulancejob:heal', 'small', true)
			ESX.ShowNotification('used_bandage')
		end)
	end
end)

function SendDistressSignal()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerServerEvent('esx_ambulancejob:onPlayerDistress')
end

function DrawGenericTextThisFrame()
	SetTextFont(6)
	SetTextScale(0.0, 0.4)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function secondsToClock(seconds)
	local seconds, hours, mins, secs = tonumber(seconds), 0, 0, 0

	if seconds <= 0 then
		return 0, 0
	else
		local hours = string.format('%02.f', math.floor(seconds / 3600))
		local mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)))
		local secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60))

		return mins, secs
	end
end

function StartDeathTimer()
	local canPayFine = false

	if Config.EarlyRespawnFine then
		ESX.TriggerServerCallback('esx_ambulancejob:checkBalance', function(canPay)
			canPayFine = canPay
		end)
	end

	local earlySpawnTimer = ESX.Math.Round(Config.EarlyRespawnTimer / 1000)
	local bleedoutTimer = ESX.Math.Round(Config.BleedoutTimer / 1000)

	CreateThread(function()
		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Wait(1000)

			if earlySpawnTimer > 0 then
				earlySpawnTimer = earlySpawnTimer - 1
			end
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Wait(1000)

			if bleedoutTimer > 0 then
				bleedoutTimer = bleedoutTimer - 1
			end
		end
	end)

	CreateThread(function()
		local text, timeHeld

		-- early respawn timer
		while earlySpawnTimer > 0 and isDead do
			Wait(0)
			text = _U('respawn_available_in', secondsToClock(earlySpawnTimer))

			DrawGenericTextThisFrame()

			SetTextEntry('STRING')
			AddTextComponentString(text)
			DrawText(0.150, 0.150)
		end

		-- bleedout timer
		while bleedoutTimer > 0 and isDead do
			Wait(0)
			text = _U('respawn_bleedout_in', secondsToClock(bleedoutTimer))

			if not Config.EarlyRespawnFine then
				text = text .. 'respawn_bleedout_prompt'

				if IsControlPressed(0, 38) and timeHeld > 60 then
					RemoveItemsAfterRPDeath()
					break
				end
			elseif Config.EarlyRespawnFine and canPayFine then
				text = text .. _U('respawn_bleedout_fine', ESX.Math.GroupDigits(Config.EarlyRespawnFineAmount))

				if IsControlPressed(0, 38) and timeHeld > 60 then
					TriggerServerEvent('esx_ambulancejob:payFine')
					RemoveItemsAfterRPDeath()
					break
				end
			end

			if IsControlPressed(0, 38) then
				timeHeld = timeHeld + 1
			else
				timeHeld = 0
			end

			DrawGenericTextThisFrame()

			SetTextEntry('STRING')
			AddTextComponentString(text)
			DrawText(0.5, 0.8)
		end

		if bleedoutTimer < 1 and isDead then
			RemoveItemsAfterRPDeath()
		end
	end)
end

function RemoveItemsAfterRPDeath()
	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
	CreateThread(function()
		DoScreenFadeOut(800)
		while not IsScreenFadedOut() do Wait(10) end
		ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()
			local formattedCoords = {
				x = Config.RespawnPoint.coords.x,
				y = Config.RespawnPoint.coords.y,
				z = Config.RespawnPoint.coords.z
			}

			ESX.SetPlayerData('loadout', {})
			RespawnPed(PlayerPedId(), formattedCoords, Config.RespawnPoint.heading)
			SetTimecycleModifier('')
			SetEntityCoords(PlayerPedId(), 359.92, -591.77, 28.65, false, false, false, false)
			DoScreenFadeIn(800)
			mortAmbulance = false
			RageUI.Visible(mainMortAmbulance, false)
			ESX.ShowNotification("~o~Vous devez rester 1 minutes en observation.")
			SetPlayerControl(PlayerId(), false, 12)
			Wait(60000)
			ESX.ShowNotification("~g~Vous sembez aller mieux, bonne journée.")
			SetPlayerControl(PlayerId(), true, 12)
		end)
	end)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)

	TriggerServerEvent('esx:onPlayerSpawn')
	TriggerEvent('esx:onPlayerSpawn')
	TriggerEvent('playerSpawned')
	RenderScriptCams(0, 0, 0, 0, 0)
end

 AddEventHandler('esx:onPlayerDeath', function(data)
 	OnPlayerDeath()
 end)

RegisterNetEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerServerEvent('esx_ambulance:setDeathStatus', false)
	ResetPedMovementClipset(PlayerPedId(),0)
	CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}
		
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(playerPed, formattedCoords, 0.0)
		SetTimecycleModifier('')
		DoScreenFadeIn(800)
		mortAmbulance = false
		RageUI.Visible(mainMortAmbulance, false)
	end)
end)


RegisterNetEvent('esx_ambulance:revive2')
AddEventHandler('esx_ambulance:revive2', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	TriggerServerEvent('esx_ambulance:setDeathStatus', false)

	Citizen.CreateThread(function()
		DoScreenFadeOut(800)

		while not IsScreenFadedOut() do
			Citizen.Wait(50)
		end

		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}
		
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		RespawnPed(playerPed, formattedCoords, 0.0)
		SetTimecycleModifier('')
		DoScreenFadeIn(800)
		mortAmbulance = false
		RageUI.Visible(mainMortAmbulance, false)
	end)
end)


RegisterNetEvent("AppelemsGetCoords")

AddEventHandler("AppelemsGetCoords", function()

     ped = PlayerPedId()

     GetPed(ped)

	coords = GetEntityCoords(ped, true)

	idJoueur = GetPlayerServerId(PlayerId())

	print(idJoueur)

	TriggerServerEvent("Server:emsAppel", coords, idJoueur)

end)



RegisterNetEvent("AppelemsTropBien")

AddEventHandler("AppelemsTropBien", function(coords, id)

	AppelEnAttente = true

	AppelCoords = coords

	AppelID = id

	ESX.ShowAdvancedNotification("EMS", "~b~Demande d'EMS", "Quelqu'un à besoin d'un ems ! Ouvrez votre menu [F6] pour intervenir", "CHAR_CALL911", 8)

end)


reportlistesql = {}



local tabletteAmbulance = false 
local mainTabletteAmbulance = RageUI.CreateMenu("Ambulance", "orasity")
local subtabletteAmbulance = RageUI.CreateSubMenu(mainTabletteAmbulance, "Ambulance", "orasity")
local subtabletteAmbulance2 = RageUI.CreateSubMenu(mainTabletteAmbulance, "Ambulance", "orasity")
local gestr = RageUI.CreateSubMenu(mainTabletteAmbulance, "Ambulance", "orasity")
mainTabletteAmbulance.Closed = function()
  tabletteAmbulance = false
end

local rouletteannounce = 1

akhyfideletablettems = function()
	if tabletteAmbulance == false then 
		tabletteAmbulance = true
		RageUI.Visible(mainTabletteAmbulance, true)
        Wait(150)
		CreateThread(function()
		while tabletteAmbulance do 
		   RageUI.IsVisible(mainTabletteAmbulance,function() 

		
			RageUI.List("Faire une annonce : ~m~EMS ", {"~g~disponible~s~", "~r~Indisponible~s~", "~o~Personalisée~s~"}, rouletteannounce,nil,{},true,{
				onListChange = function(Index)
                    rouletteannounce = Index
                end,
                onSelected = function(Index)
					listmecano = Index
					if Index == 1 then
						TriggerServerEvent("EMS:Ouvert")
					elseif Index == 2 then 
						TriggerServerEvent("EMS:Fermer")
					elseif Index == 3 then 
						local msg = ESX.ImputKeyboard("Message", "Message", nil, 100)
						TriggerServerEvent("EMS:Perso", msg)
					end
				end
			})


			RageUI.Button("Intéraction citoyen", nil, {RightLabel = "~b~Intéragir ~s~→→"}, true, {}, subtabletteAmbulance)

			RageUI.Button("Intéraction Appels", nil, {RightLabel = "~b~Intéragir ~s~→→"}, true, {
				onSelected = function()
					ESX.TriggerServerCallback('ems:afficheappels', function(keys)
					reportlistesql = keys
					end)
				end
				}, subtabletteAmbulance2)


			end)


			RageUI.IsVisible(subtabletteAmbulance, function()
			
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
				if closestDistance <= 3.0 then 


					RageUI.Button("Mettre une facture", nil, { RightBadge = RageUI.BadgeStyle.Heart }, true , {
						onActive = function()
							if closestPlayer ~= -1 then
								MarquerJoueur()
							end
						end,
						onSelected = function()
							amount = ESX.ImputKeyboard("Montant de la facture", "Montant de la facture", nil, 10)
							amount = tonumber(amount)
							local player, distance = ESX.Game.GetClosestPlayer()
			
							if player ~= -1 and distance <= 3.0 then
					
							if amount == nil then
								ESX.ShowNotification("<C>~r~Problèmes~s~: Montant invalide</C>")
							else
								local playerPed = PlayerPedId()
								Wait(5000)
								TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_ambulance', ('ambulance'), amount)
								Wait(100)
								ESX.ShowNotification("<C>~g~Vous avez bien envoyer la facture</C>")
							end
					
							else
							ESX.ShowNotification("<C>~r~Problèmes~s~: Aucun joueur à proximitée</C>")
							end
						end
					})

				RageUI.Button("Réanimer la Personne", nil, { RightBadge = RageUI.BadgeStyle.Heart },true, {
					onActive = function()
						if closestPlayer ~= -1 then
							MarquerJoueur()
						end
					end,
					onSelected = function()
						revivePlayer(closestPlayer)    
					end
				})

				RageUI.Button("Soigner une petite blessure", nil, { RightBadge = RageUI.BadgeStyle.Heart },true, {
					onActive = function()
						if closestPlayer ~= -1 then
							MarquerJoueur()
						end
					end,
					onSelected = function() 
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 1.0 then
							ESX.ShowNotification('Aucune Personne à Proximité')
						else
							ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
								if quantity > 0 then
									local closestPlayerPed = GetPlayerPed(closestPlayer)
									local health = GetEntityHealth(closestPlayerPed)
									if health > 0 then
										local playerPed = PlayerPedId()
										IsBusy = true
										ESX.ShowNotification(_U('heal_inprogress'))
										TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
										Citizen.Wait(10000)
										ClearPedTasks(playerPed)
										TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
										TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
										ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
										IsBusy = false
									else
										ESX.ShowNotification(_U('player_not_conscious'))
									end
								else
									ESX.ShowNotification(_U('not_enough_bandage'))
								end
							end, 'bandage')
						end
					end
				})

	

				RageUI.Button("Soigner une plus grande blessure", nil, { RightBadge = RageUI.BadgeStyle.Heart },true, {
					onActive = function()
						if closestPlayer ~= -1 then
							MarquerJoueur()
						end
					end,
					onSelected = function() 
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer == -1 or closestDistance > 1.0 then
							ESX.ShowNotification('Aucune Personne à Proximité')
						else
							ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
								if quantity > 0 then
									local closestPlayerPed = GetPlayerPed(closestPlayer)
									local health = GetEntityHealth(closestPlayerPed)
									if health > 0 then
										local playerPed = PlayerPedId()
										IsBusy = true
										ESX.ShowNotification(_U('heal_inprogress'))
										TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
										Citizen.Wait(10000)
										ClearPedTasks(playerPed)
										TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
										TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
										ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
										IsBusy = false
									else
										ESX.ShowNotification(_U('player_not_conscious'))
									end
								else
									ESX.ShowNotification(_U('not_enough_medikit'))
								end
							end, 'medikit')

						end
					end
				})
			end

			end)


			RageUI.IsVisible(subtabletteAmbulance2, function()


				RageUI.Separator('↓ ~b~Autres ↓')

				RageUI.Button("Effacer les appels en cours", nil, {RightLabel = "→→"}, true, {
					onSelected = function()
						TriggerEvent("EMS:ClearAppel")
					end
				})

				RageUI.Separator('↓ ~b~Appels ↓')

				for numreport = 1, #reportlistesql, 1 do
				  RageUI.Button("[~y~Patient ~s~: "..reportlistesql[numreport].reporteur.."~s~] - ~b~Numéro ~s~: "..reportlistesql[numreport].id, nil, { RightLabel = "~r~En ATTENTE"}, true, {
					onSelected = function()
						  typereport = reportlistesql[numreport].type
						  reportjoueur = reportlistesql[numreport].reporteur
						  raisonreport = reportlistesql[numreport].raison
						  joueurreporter = reportlistesql[numreport].nomreporter
						  supprimer = reportlistesql[numreport].id
					  end
					}, gestr)
				end

			end)


			RageUI.IsVisible(gestr, function()
			
				RageUI.Separator("~y~Type~s~ : Demande d'EMS")

				
			if AppelID ~= nil and AppelCoords ~= nil and supprimer ~= nil and reportjoueur ~= nil then 

				 RageUI.Separator("~b~Nom du Patient~s~ : ".. reportjoueur)
		
				RageUI.Button("~g~Accepter ~s~l'appel", nil, {}, true,  {
					onSelected = function()
						pris = true
						TriggerServerEvent('EMS:PriseAppelServeur')
						TriggerServerEvent("EMS:AjoutAppelTotalServeur")
						TriggerEvent('emsAppelPris', AppelID, AppelCoords)
						TriggerServerEvent('ems:supprimeappels', supprimer)
						TriggerServerEvent('Ambulance:AppelNotifs', supprimer)
					end
				})
		
				RageUI.Button("~r~Refuser ~s~l'appel~s~ ~b~N°".. supprimer, nil, {}, true, {
					onSelected = function()
						pris = false
						ESX.ShowAdvancedNotification("ems", "~b~Demande de ems", "Vous avez refuser l'appel.", "CHAR_CALL911", 8)
						TriggerServerEvent('ems:supprimeappels', supprimer)
					end
				})
			end

			end)
			Wait(0)
			end
		end)
	end
end


function GetPed(ped)

	PedARevive = ped

end



RegisterNetEvent("emsAppelPris")

AddEventHandler("emsAppelPris", function(Xid, XAppelCoords)

	ESX.ShowAdvancedNotification("EMS", "~b~Demande d'EMS", "Vous avez pris l'appel, ~y~Dirigez-vous là-bas ~s~via votre GPS !", "CHAR_CALL911", 2)   

	afficherTextVolant(XAppelCoords, Xid)

end)



function afficherTextVolant(XAcoords, XAid)

	 emsBlip = AddBlipForCoord(XAcoords)

	--SetBlipSprite(emsBlip, 353)

	SetBlipShrink(emsBlip, true)

	SetBlipScale(emsBlip, 0.9)

	SetBlipPriority(emsBlio, 150)

	BeginTextCommandSetBlipName("STRING")

	AddTextComponentSubstringPlayerName("~b~[EMS] Appel en cours")

	EndTextCommandSetBlipName(emsBlip)

	 SetBlipRoute(emsBlip, true)

	 SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)

	 table.insert(tableBlip, emsBlip)

	 rea = true

	 while rea do

	 if GetDistanceBetweenCoords(XAcoords, GetEntityCoords(PlayerPedId())) < 10.0 then

		ESX.ShowAdvancedNotification("EMS", "~b~GPS d'EMS", "Vous êtes arrivé !", "CHAR_CALL911", 2)   

		TriggerEvent("EMS:ClearAppel")

end

Wait(1)

end

end





RegisterNetEvent("EMS:ClearAppel")

AddEventHandler("EMS:ClearAppel", function()

	for k, v in pairs(tableBlip) do

		RemoveBlip(v)

	end

	rea = false

	tableBlip = {}

end)



function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)

	 local px,py,pz=table.unpack(GetGameplayCamCoords())

	 local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    

	 local scale = (1/dist)*20

	 local fov = (1/GetGameplayCamFov())*100

	 local scale = scale*fov   

	 SetTextScale(scaleX*scale, scaleY*scale)

	 SetTextFont(fontId)

	 SetTextProportional(1)

	 SetTextColour(250, 250, 250, 255)		-- You can change the text color here

	 SetTextDropshadow(1, 1, 1, 1, 255)

	 SetTextEdge(2, 0, 0, 0, 150)

	 SetTextDropShadow()

	 SetTextOutline()

	 SetTextEntry("STRING")

	 SetTextCentre(1)

	 AddTextComponentString(textInput)

	 SetDrawOrigin(x,y,z+2, 0)

	 DrawText(0.0, 0.0)

	 ClearDrawOrigin()

end



local AppelTotal = 0

local NomAppel = "~r~personne"

local enService = false



RegisterNetEvent("EMS:AjoutUnAppel")

AddEventHandler("EMS:AjoutUnAppel", function(Appel)

	AppelTotal = Appel

end)





RegisterNetEvent("EMS:PriseDeService")

AddEventHandler("EMS:PriseDeService", function(service)

	enService = service

end)



RegisterNetEvent("EMS:DernierAppel")

AddEventHandler("EMS:DernierAppel", function(Appel)

	NomAppel = Appel

end)



function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)

	SetTextFont(font)

	SetTextProportional(0)

	SetTextScale(sc, sc)

	N_0x4e096588b13ffeca(jus)

	SetTextColour(r, g, b, a)

	SetTextDropShadow(0, 0, 0, 0,255)

	SetTextEdge(1, 0, 0, 0, 255)

	SetTextDropShadow()

	SetTextOutline()

	SetTextEntry("STRING")

	AddTextComponentString(text)

	DrawText(x - 0.1+w, y - 0.02+h)

end



Citizen.CreateThread( function()	

	while true do

	local oemongars = 700

		if enService then
			oemongars = 0;
			DrawRect(0.888, 0.254, 0.196, 0.116, 0, 0, 0, 50)

			DrawAdvancedText(0.984, 0.214, 0.008, 0.0028, 0.4, "Dernière prise d'appel:", 0, 191, 255, 255, 6, 0)

			DrawAdvancedText(0.988, 0.236, 0.005, 0.0028, 0.4, "~b~"..NomAppel.." ~w~à pris le dernier appel EMS", 255, 255, 255, 255, 6, 0)

			DrawAdvancedText(0.984, 0.274, 0.008, 0.0028, 0.4, "Total d'appel prise en compte", 0, 191, 255, 255, 6, 0)

			DrawAdvancedText(0.988, 0.294, 0.005, 0.0028, 0.4, AppelTotal, 255, 255, 255, 255, 6, 0)

		end

		Wait(oemongars)
	end
end)





RegisterNetEvent("EMS:ClearAppel")

AddEventHandler("EMS:ClearAppel", function()

	for k, v in pairs(tableBlip) do

		RemoveBlip(v)

	end

	rea = false

	tableBlip = {}

end)





RegisterNetEvent('openappels')

AddEventHandler('openappels', function()

	ESX.TriggerServerCallback('ems:afficheappels', function(keys)

		reportlistesql = keys

		end)

	  RageUI.Visible(RMenu:Get('appels', 'main'), not RageUI.Visible(RMenu:Get('appels', 'main')))

end)





function revivePlayer(closestPlayer)

local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

if closestPlayer == -1 or closestDistance > 3.0 then

  ESX.ShowNotification(_U('no_players'))

else

ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(qtty)

if qtty > 0 then

local closestPlayerPed = GetPlayerPed(closestPlayer)

local health = GetEntityHealth(closestPlayerPed)

if health == 0 then

local playerPed = PlayerPedId()

Citizen.CreateThread(function()

ESX.ShowNotification(_U('revive_inprogress'))

TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)

Wait(10000)

ClearPedTasks(playerPed)

if GetEntityHealth(closestPlayerPed) == 0 then

TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')

TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(closestPlayer))

else

ESX.ShowNotification(_U('isdead'))

end

end)

else

	ESX.ShowNotification(_U('unconscious'))

end

 else

ESX.ShowNotification(_U('not_enough_medikit'))

end

end, 'medikit')

end

end



AddEventHandler("onResourceStart", function()

TriggerServerEvent('emssapl:deleteallappels', supprimer)

end)


