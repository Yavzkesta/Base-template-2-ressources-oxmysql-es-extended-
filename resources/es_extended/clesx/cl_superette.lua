
if ConfigUseSuperette == true then

local superettekingder = false 
MainSuperette = RageUI.CreateMenu("Superette", "wsh akhy fidele")
subSuperette = RageUI.CreateSubMenu(MainSuperette, "Nourritures", "wsh akhy fidele")
subSuperette2 = RageUI.CreateSubMenu(MainSuperette, "Boissons", "wsh akhy fidele")
subSuperette3 = RageUI.CreateSubMenu(MainSuperette, "Divers", "wsh akhy fidele")
MainSuperette.Closed = function()
    superettekingder = false
end

previewfirst = false 

coucoulasuperette = function(taurarienaugive)
    if superettekingder == false then 
        superettekingder = true
        RageUI.Visible(MainSuperette, true)
        CreateThread(function()
            while superettekingder do 
                RageUI.IsVisible(MainSuperette, function()
   
                    RageUI.Button("Rayons ~g~nourritures", nil, {}, true, {}, subSuperette)
                    RageUI.Button("Rayons ~b~Boissons", nil, {}, true, {}, subSuperette2)
                    RageUI.Button("Rayons ~m~Divers", nil, {}, true, {}, subSuperette3)

                end)

                RageUI.IsVisible(subSuperette, function()

                for k,v in pairs(Config.Nourritures) do
                    RageUI.Button("Acheter nourriture : ", "~g~Cela vous coutera ~s~"..v.Price.."~g~$", {RightLabel = "~b~"..v.Label..""}, true, {
                        onSelected = function()
                            TriggerServerEvent("droplitemsuperette", v, taurarienaugive)
                        end
                    })
                end


                end)

                RageUI.IsVisible(subSuperette2, function()

                    for k,v in pairs(Config.Boissons) do
                        RageUI.Button("Acheter boissons : ", "~g~Cela vous coutera ~s~"..v.Price.."~g~$", {RightLabel = "~b~"..v.Label..""}, true, {
                            onSelected = function()
                                TriggerServerEvent("droplitemsuperette", v, taurarienaugive)
                            end
                        })
                    end    

                end)

                RageUI.IsVisible(subSuperette3, function()

                    for k,v in pairs(Config.Divers) do
                        RageUI.Button("Acheter Divers : ", "~g~Cela vous coutera ~s~"..v.Price.."~g~$", {RightLabel = "~b~"..v.Label..""}, true, {
                            onSelected = function()
                                TriggerServerEvent("droplitemsuperette", v, taurarienaugive)
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
    for k, v in pairs(Config.LocationApu) do 
        ESX.CreateBlipsKingder(59, 0.75, 4, "Superettes", vector3(v.x, v.y, v.z))
    end
    while true do 
        local waitapu = 7000
        for k, v in pairs(Config.LocationApu) do 
            local distance = #(GetEntityCoords(PlayerPedId()) - vector3(v.x, v.y, v.z));

            if distance <= 60 then 
                waitapu = 700 
            end

            if distance <= 10 then 
                if superettekingder == false then 
                    waitapu = 0
                    DrawMarker(20, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 95, 73, 160, 255, false, true, true, false)  
                end
            end

            if distance <= 1.5 then 
                waitapu = 0
                if superettekingder == false then 
                    Visual.Subtitle("<C>Appuyer sur ~p~[E]~s~ pour accéder à la superette.</C>", 1) 
                end

                if IsControlJustPressed(1, 51) then
                    coucoulasuperette(vector3(v.x, v.y, v.z))
                end
            end
        end
        Wait(waitapu)
    end 
end)

end
