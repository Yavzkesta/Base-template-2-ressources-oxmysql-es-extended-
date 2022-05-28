local locakingder = false 
MainLocation = RageUI.CreateMenu("Location", "wsh akhy fidele")
MainLocation.Closed = function()
    locakingder = false
    previewfirst = false 
end

previewfirst = false 

coucoulaLoc = function()
    if locakingder == false then 
        locakingder, previewfirst = true, true
        RageUI.Visible(MainLocation, true)
        CreateThread(function()
            while locakingder do 
                RageUI.IsVisible(MainLocation, function()
   
                    RageUI.Button("Louer un véhicule ", "~g~Cela vous coutera ~s~700~g~$", {RightLabel = "~b~D.Enduro"}, not enduro, {
                        onSelected = function()
                            ESX.TriggerServerCallback('sucemoikehba', function(bought)
                                if bought then
                                    ESX.Game.SpawnVehicle('enduro', vector3(-817.76, -125.6, 36.92), 235.44, function(vehicle) end)
                                    ESX.ShowNotification("Vous avez louez une ~p~Enduro ~s~pour ~p~700~s~$ ~s~!")
                                else 
                                    ESX.ShowNotification("~r~Vous n'avez pas assez d'argent.")
                                end
                            end)
                        end
                    })
   
                    RageUI.Button("Louer un véhicule ", "~g~Cela vous coutera ~s~1200~g~$", {RightLabel = "~b~B.Panto"}, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback('sucemoikehbaa', function(bought)
                                if bought then
                                    ESX.Game.SpawnVehicle('panto', vector3(-817.76, -125.6, 36.92), 235.44, function(vehicle) end)
                                    ESX.ShowNotification("Vous avez louez une ~p~Enduro ~s~pour ~p~700~s~$ ~s~!")
                                else 
                                    ESX.ShowNotification("~r~Vous n'avez pas assez d'argent.")
                                end
                            end)
                        end
                    })
   

                end)
                Wait(0)
            end
        end)
    end
end



CreateThread(function()
    ESX.CreateBlipsKingder(523, 0.75, 26, "Location de véhicules", vector3(-819.88, -121.92, 37.45))
    while true do 
        local onverra = 7000
        local distance = #(GetEntityCoords(PlayerPedId()) - Config.location);

        if distance <= 60 then 
            onverra = 700 
        end

        if distance <= 10 then 
            if locakingder == false then 
                onverra = 0
                DrawMarker(20, Config.location, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 95, 73, 160, 255, false, true, true, false)  
            end
        end

        if distance <= 1.5 then 
            onverra = 0
            if locakingder == false then 
                Visual.Subtitle("<C>Appuyer sur ~p~[E]~s~ pour accéder à la location.</C>", 1) 
            end

            if IsControlJustPressed(1, 51) then
                coucoulaLoc()
            end
        end
        Wait(onverra)
    end 
end)