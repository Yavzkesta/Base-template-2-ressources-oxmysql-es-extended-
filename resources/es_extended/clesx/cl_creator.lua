RegisterNetEvent("openthecreator")
AddEventHandler("openthecreator", function()
    creatorByKingder()
end)


RegisterCommand("register", function()
    local KCoords = GetEntityCoords(PlayerPedId())
    if #(KCoords - Config.firstSpawn) < 30.0 then
        creatorByKingder()
    else 
        ESX.ShowNotification("Vous devez être au spawn.")
    end
end)

local taillebarbe = {"1","2","3","4","5","6","7","8","9","10"}
local typebabe = {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28"}
local sourcilscolour = {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45", "46", "47", "48", "49", "50", "51","52","53","54","55","56","57","58","59","60","61","62","63"}
local ValeurNumm = {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45"}
local sourcilNumm = {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33"}
local ValeurNumm2 = {"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45", "46", "47", "48", "49", "50", "51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95", "96", "97", "98", "99", "100","1","2","3","4","5","6","7","8","9","100","101","102","103","104","105","106","107","108","109","110","111","112","113","114","115","116","117","118","118","119","120","121","122","123","124","125","126","127","128","129","130","131","132","133","134", "135", "136", "137", "138", "139", "140","141","143","144","145","145","147","148","149","150","151","152","153","154","155","156", "157", "158","159", "160", "161", "162"}
local oemgllll, visagelist, peaulist, typedecheveuxlist, typedecheveuxcol1, typedecheveuxcol2, typedesourcils, colorsourcils, typebarbe,  taillebebar = 1, 1, 1 , 1, 1, 1, 1, 1, 1, 1
local opencreatorbyKingderFirstVersion = false 
local MaincreatorbyKingderFirstVersion = RageUI.CreateMenu("Carte d'identité", "Que voulez vous faire?")
local submenuCreator = RageUI.CreateSubMenu(MaincreatorbyKingderFirstVersion, "Apparence",  "Que voulez vous faire?")
MaincreatorbyKingderFirstVersion.Closed = function()
 opencreatorbyKingderFirstVersion = false
end

MaincreatorbyKingderFirstVersion.Closable = false 

creatorByKingder = function()
   if opencreatorbyKingderFirstVersion == false then 
	   opencreatorbyKingderFirstVersion = true
       TriggerServerEvent("Creator:setPlayerToBucket", GetPlayerServerId(PlayerId()))
       SetEntityCoords(PlayerPedId(), Config.firstSpawn)
       SetEntityHeading(PlayerPedId(), Config.headingSpawn)
       Wait(500)
       FreezeEntityPosition(PlayerPedId(), true)
       firstnamerslt, lastnamerslt, heightrslt, sexxrslt, dobbrslt = "Aucun", "Aucun", "Aucune", "m/f", "Aucune"
       statebtnfirstname, statebtnlastname, statebtndob, statebtnheight, statebtnsexxx, statebtnvalidate = true, false, false, false, false, false
	   RageUI.Visible(MaincreatorbyKingderFirstVersion, true)
	   CreateThread(function()
	   while opencreatorbyKingderFirstVersion do 
		  RageUI.IsVisible(MaincreatorbyKingderFirstVersion, function() 


                RageUI.Button("Prénom", nil, {RightLabel = firstnamerslt}, statebtnfirstname, {
                    onSelected = function()
                        firstnamerslt = BoardIdentity("Prénom", "", 10)
                        if tostring(firstnamerslt) == "" or tostring(firstnamerslt) == "Aucun" then
                            firstnamerslt = "Aucun"
                            ESX.ShowNotification("~o~Identité\n~r~Vous n'avez pas rentrez votre Prénom")
                            statebtnlastname = false
                        else
                            statebtnlastname = true
                            firstnamerslt = GetOnscreenKeyboardResult()
                            TriggerServerEvent("esx_identity:updatefirstname", firstnamerslt)
                        end
                    end
                });

                RageUI.Button("Nom", nil, {RightLabel = lastnamerslt}, statebtnlastname, {
                    onSelected = function() 
                        lastnamerslt = BoardIdentity("Nom", "", 10)
                        if tostring(lastnamerslt) == "" or tostring(lastnamerslt) == "Aucun" then
                            lastnamerslt = "Aucun"
                            ESX.ShowNotification("~o~Identité\n~r~Vous n'avez pas rentrez votre Nom de Famille")
                            statebtnheight = false
                        else
                            statebtnheight = true
                            lastnamerslt = GetOnscreenKeyboardResult()
                            TriggerServerEvent("esx_identity:updatelastname", lastnamerslt)
                        end
                    end
                });


                RageUI.Button("Taille", nil, {RightLabel = heightrslt}, statebtnheight, {
                    onSelected = function() 
                        heightrslt = BoardIdentity("Taille", "", 3)
                        if tostring(heightrslt) == "" or tostring(heightrslt) == "Aucune" or #heightrslt < 3 then
                            heightrslt = "Aucune"
                            ESX.ShowNotification("~o~Identité\n~r~Vous n'avez pas rentrez votre Taille")
                            statebtnsexxx = false
                        elseif tonumber(heightrslt) then
                            statebtnsexxx = true
                            heightrslt = GetOnscreenKeyboardResult()
                            TriggerServerEvent("esx_identity:updateheight", heightrslt)
                        else
                            heightrslt = "Aucune"
                            statebtnsexxx = false
                            ESX.ShowNotification("~o~Identité\n~r~Veuillez rentrez le bon type de caractères")
                        end
                    end
                });


                if statebtnsexxx == true then 
                    RageUI.List("Sexe ", 
                    {"Homme", "Femme"}, oemgllll,nil,{}, statebtnsexxx,{
                        onListChange = function(Index)
                            oemgllll = Index
                        end,
                        onSelected = function(Index)
                            if Index == 1 then
                                TriggerEvent("skinchanger:change", "sex", 0)
                                TriggerServerEvent("esx_identity:updatesexxx", "m")
                                statebtndob = true
                            elseif Index == 2 then
                                statebtndob = true
                                TriggerEvent("skinchanger:change", "sex", 1)
                                TriggerServerEvent("esx_identity:updatesexxx", "f")
                            end
                        end
                    })
                else 
                    RageUI.Button("Sexe", nil, {}, false, {});
                end

                RageUI.Button("Date de Naissance", nil, {RightLabel = dobbrslt}, statebtndob, {
                    onSelected = function() 
                        fourBoutton = true
                        dobbrslt = BoardIdentity("Date de Naissance (exemple: 10/04/1996)", "", 10)
                        if tostring(dobbrslt) == "" or tostring(dobbrslt) == "Aucun" or #dobbrslt < 10 and not IsDateGood(tostring(dobbrslt)) then
                            dobbrslt = "Aucun"
                            ESX.ShowNotification("~o~Identité\n~r~Vous n'avez pas rentrez votre Date de Naissance")
                            statebtnvalidate = false
                        else
                            dobbrslt = GetOnscreenKeyboardResult()
                            statebtnvalidate = true
                            TriggerServerEvent("esx_identity:updatedateofbirth", dobbrslt)
                            vldabutton = true 
                        end
                    end
                });

                RageUI.Button("Valider la carte d'identité", nil, {}, vldabutton, {}, submenuCreator);
                end)


                RageUI.IsVisible(submenuCreator, function()

                    RageUI.List("Visage", ValeurNumm, visagelist, nil, {}, true, {
                        onListChange = function(i, Item)
                            if visagelist ~= i then
                                visagelist = i;
                                TriggerEvent("skinchanger:change", "face", visagelist)
                            end
                        end,
                    })

                    RageUI.List("Peau", ValeurNumm, peaulist, nil, {}, true, {
                        onListChange = function(i, Item)
                            if peaulist ~= i then
                                peaulist = i;
                                TriggerEvent("skinchanger:change", "skin", peaulist)
                            end
                        end,
                    })
                    RageUI.List("Type de cheveux", ValeurNumm2, typedecheveuxlist, nil, {}, true, {
                        onListChange = function(i, Item)
                            if typedecheveuxlist ~= i then
                                typedecheveuxlist = i;
                                TriggerEvent("skinchanger:change", "hair_1", typedecheveuxlist)
                            end
                        end,
                    })

                    RageUI.List("Couleur de cheveux 1", ValeurNumm, typedecheveuxcol1, nil, {}, true, {
                        onListChange = function(i, Item)
                            if typedecheveuxcol1 ~= i then
                                typedecheveuxcol1 = i;
                                TriggerEvent("skinchanger:change", "hair_color_1", typedecheveuxcol1)
                            end
                        end,
                    })

                    RageUI.List("Couleur de cheveux 1", ValeurNumm, typedecheveuxcol2, nil, {}, true, {
                        onListChange = function(i, Item)
                            if typedecheveuxcol2 ~= i then
                                typedecheveuxcol2 = i;
                                TriggerEvent("skinchanger:change", "hair_color_2", typedecheveuxcol2)
                            end
                        end,
                    })

                    RageUI.List("Type de sourcils", sourcilNumm, typedesourcils, nil, {}, true, {
                        onListChange = function(i, Item)
                            if typedesourcils ~= i then
                                typedesourcils = i;
                                TriggerEvent("skinchanger:change", "eyebrows_2", 100)
                                TriggerEvent("skinchanger:change", "eyebrows_1", typedesourcils)
                            end
                        end,
                    })

                    RageUI.List("Couleur des sourcils", sourcilscolour, colorsourcils, nil, {}, true, {
                        onListChange = function(i, Item)
                            if colorsourcils ~= i then
                                colorsourcils = i;
                                TriggerEvent("skinchanger:change", "eyebrows_3", colorsourcils)
                            end
                        end,
                    })

                    RageUI.List("Type de barbe",  typebabe, typebarbe, nil, {}, true, {
                        onListChange = function(i, Item)
                            if typebarbe ~= i then
                                typebarbe = i;
                                TriggerEvent("skinchanger:change", "beard_1", typebarbe)
                            end
                        end,
                    })

                    RageUI.List("Taille de barbe",  taillebarbe, taillebebar, nil, {}, true, {
                        onListChange = function(i, Item)
                            if taillebebar ~= i then
                                taillebebar = i;
                                TriggerEvent("skinchanger:change", "beard_2", taillebebar)
                            end
                        end,
                    })

                    RageUI.Button("Valider l'apparence", nil, {}, true, {
                        onSelected = function()
                            RageUI.CloseAll()
                            opencreatorbyKingderFirstVersion = false
                            setSkinToPed(1)
                            FreezeEntityPosition(PlayerPedId(), false)
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                TriggerServerEvent('esx_skin:save', skin)
                            end)
                            TriggerServerEvent("Creator:setPlayerToBucket", 0)
                        end
                    });

                end)
                Wait(0)
            end
        end)
    end
end

setSkinToPed = function(Tenues)
    if Tenues == 1 then
        TriggerEvent("skinchanger:getSkin", function(skin)
            local uniformObject
            if skin.sex == 0 then
                uniformObject = {     
                    tshirt_1 = 15, tshirt_2 = 0,
                    torso_1 = 50, torso_2 = 2,
                    arms = 1,
                    chain_1 = 0, chain_2 = 0,
                    pants_1 = 25, pants_2 = 2,
                    bags_1 = 0, bags_2 = 0,
                    shoes_1 = 40, shoes_2 = 2,
                    helmet_1= -1, helmet_2 = 0,
                    ears_1 = -1,     ears_2 = 0
            }
            else
                uniformObject = {
                    tshirt_1 = 15, tshirt_2 = 0,
                    torso_1 = 160, torso_2 = 1,
                    arms = 14,
                    chain_1 = 0, chain_2 = 0,
                    pants_1 = 69, pants_2 = 0,
                    bags_1 = 0, bags_2 = 0,
                    shoes_1 = 47, shoes_2 = 2,
                    helmet_1= -1, helmet_2 = 0,
                    ears_1 = 0,     ears_2 = 0
                }
            end
            if uniformObject then
                TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
                TriggerServerEvent('esx_skin:save', skin)
                TriggerEvent('skinchanger:getSkin', function(skin4)
                    TriggerServerEvent('esx_skin:save', skin4)
                end)
            end
        end)
    end
end

BoardIdentity = function(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) 
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do Wait(0) end
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Wait(500) 
		return result
	else
		Wait(500) 
		return nil 
	end
end

IsDateGood = function(date)
    if (string.match(date, "^%d+%p%d+%p%d%d%d%d$")) then
        local d, m, y = string.match(date, "(%d+)%p(%d+)%p(%d+)")
        d, m, y = tonumber(d), tonumber(m), tonumber(y)
        local dm2 = d*m*m
        if  d>31 or m>12 or dm2==0 or dm2==116 or dm2==120 or dm2==124 or dm2==496 or dm2==1116 or dm2==2511 or dm2==3751 then
            if dm2==116 and (y%400 == 0 or (y%100 ~= 0 and y%4 == 0)) then
                return true
            else
                return false
            end
        else
            return true
        end
    else
        return false
    end
end
