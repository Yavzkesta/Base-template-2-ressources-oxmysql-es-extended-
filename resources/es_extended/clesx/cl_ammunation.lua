if ConfigUseAmmunation == true then 

local Armuriekingder = false 
MainArmurie = RageUI.CreateMenu("Armurie", "wsh akhy fidele")
subArmurie = RageUI.CreateSubMenu(MainArmurie, "Accessoires", "wsh akhy fidele")
subArmurie2 = RageUI.CreateSubMenu(MainArmurie, "Armes blanches", "wsh akhy fidele")
subArmurie3 = RageUI.CreateSubMenu(MainArmurie, "Armes à feu", "wsh akhy fidele")
MainArmurie.Closed = function()
    Armuriekingder = false
end

previewfirst = false 

coucoulaArmurie = function(armuriefucktrigger)
    if Armuriekingder == false then 
        Armuriekingder = true
        RageUI.Visible(MainArmurie, true)
        ESX.TriggerServerCallback('verifsitaleppapd', function(cb)          
            if cb then
                ppa = true 
            else 
                ppa = false   
            end
        end)
        CreateThread(function()
            while Armuriekingder do 
                RageUI.IsVisible(MainArmurie, function()
   
                    RageUI.Button("Accessoires", nil, {}, true, {}, subArmurie)
                    RageUI.Button("Armes blanches", nil, {}, true, {}, subArmurie2)

                    if ppa == true then 
                        RageUI.Button("Armes à feu", nil, {}, true, {}, subArmurie3)
                    else 
                        RageUI.Button("Armes à feu", "~r~Vous n'avez pas le permis de port d'arme", {}, false, {})
                        RageUI.Button("Acheter le PPA", nil, {RightLabel = ""..Config.prixPermisArmes.."~g~$"}, true, {
                            onSelected = function()
                                TriggerServerEvent("envoislemisper", "weapon", armuriefucktrigger)
                            end
                        })
                    end
                end)

                RageUI.IsVisible(subArmurie, function()

                for k,v in pairs(Config.Accessoires) do
                    RageUI.Button("Acheter Accessoires : ", "~g~Cela vous coutera ~s~"..v.Price.."~g~$", {RightLabel = "~b~"..v.Label..""}, true, {
                        onSelected = function()
                            TriggerServerEvent("droplitemArmurie", v, armuriefucktrigger)
                        end
                    })
                end


                end)

                RageUI.IsVisible(subArmurie2, function()

                    for k,v in pairs(Config.Armesblanche) do
                        RageUI.Button("Acheter armes : ", "~g~Cela vous coutera ~s~"..v.Price.."~g~$", {RightLabel = "~b~"..v.Label..""}, true, {
                            onSelected = function()
                                TriggerServerEvent("droplarmermurie", v, armuriefucktrigger)
                            end
                        })
                    end    

                end)

                RageUI.IsVisible(subArmurie3, function()

                    for k,v in pairs(Config.armes) do
                        RageUI.Button("Acheter armes : ", "~g~Cela vous coutera ~s~"..v.Price.."~g~$", {RightLabel = "~b~"..v.Label..""}, true, {
                            onSelected = function()
                                TriggerServerEvent("droplarmermurie", v, armuriefucktrigger)
                            end
                        })
                    end    


                end)
                Wait(0)
            end
        end)
    end
end


CreateThread(function()
    for k, v in pairs(Config.Armuriepos) do 
        ESX.CreateBlipsKingder(156, 0.75, 1, "Ammunation", vector3(v.x, v.y, v.z))
    end
    while true do 
        local waitArmurie = 700
        for k, v in pairs(Config.Armuriepos) do 
            local distance = #(GetEntityCoords(PlayerPedId()) - vector3(v.x, v.y, v.z));

            if distance <= 10 then 
                if Armuriekingder == false then 
                    waitArmurie = 0
                    DrawMarker(20, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 95, 73, 160, 255, false, true, true, false)  
                end
            end

            if distance <= 1.5 then 
                waitArmurie = 0
                if Armuriekingder == false then 
                    Visual.Subtitle("<C>Appuyer sur ~p~[E]~s~ pour accéder à l'armurie.</C>", 1) 
                
                
                    if IsControlJustPressed(1, 51) then
                        coucoulaArmurie(vector3(v.x, v.y, v.z))
                    end
                end
            end
        end
        Wait(waitArmurie)
    end
end)
	
end
