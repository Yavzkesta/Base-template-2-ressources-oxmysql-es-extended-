local context = ContextUI:CreateMenu("Informations") 

ContextUI:IsVisible(context, function()
        
    ContextUI:Button("Métiers : "..ESX.PlayerData.job.label, nil, function(Selected)
        if (Selected) then
        end
    end)

    ContextUI:Button("Organisation : "..ESX.PlayerData.job2.label, nil, function(Selected)
        if (Selected) then
        end
    end)

    for i = 1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == 'money' then
            ContextUI:Button("Argent liquide : ~g~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.."$"), nil, function(Selected)
            end)
        end
    end


    for i = 1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == 'bank'  then
            ContextUI:Button("Argent Banque : ~b~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.."~s~$"), nil, function(Selected)
            end)
        end
    end


    for i = 1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == 'black_money'  then
            ContextUI:Button("Argent Sale : ~r~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.."~s~$"), nil, function(Selected)
            end)
        end
    end

end)
