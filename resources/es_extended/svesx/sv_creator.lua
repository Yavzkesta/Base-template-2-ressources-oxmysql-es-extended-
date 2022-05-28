
RegisterServerEvent("Creator:setPlayerToBucket")
AddEventHandler("Creator:setPlayerToBucket", function(id)
    SetPlayerRoutingBucket(source, id)
end)

RegisterServerEvent("esx_identity:updatesexxx")
AddEventHandler("esx_identity:updatesexxx", function(sexInput)
    local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute("UPDATE users SET sex=@sexInput WHERE identifier=@identifier", {
        ['@identifier'] = xPlayer.identifier,
        ['@sexInput'] = tostring(sexInput)
    })
end)

RegisterServerEvent("esx_identity:updatefirstname")
AddEventHandler("esx_identity:updatefirstname", function(nameInput)
    local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute("UPDATE users SET firstname=@nameInput WHERE identifier=@identifier", {
        ['@identifier'] = xPlayer.identifier,
        ['@nameInput'] = tostring(nameInput)
    })
end)


RegisterServerEvent("esx_identity:updatelastname")
AddEventHandler("esx_identity:updatelastname", function(prenomInput)
    local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute("UPDATE users SET lastname=@prenomInput WHERE identifier=@identifier", {
        ['@identifier'] = xPlayer.identifier,
        ['@prenomInput'] = tostring(prenomInput)
    })
end)

RegisterServerEvent("esx_identity:updateheight")
AddEventHandler("esx_identity:updateheight", function(tailleInput)
    local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute("UPDATE users SET height=@tailleInput WHERE identifier=@identifier", {
        ['@identifier'] = xPlayer.identifier,
        ['@tailleInput'] = tonumber(tailleInput)
    })
end)

RegisterServerEvent("esx_identity:updatedateofbirth")
AddEventHandler("esx_identity:updatedateofbirth", function(dateInput)
    local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute("UPDATE users SET dateofbirth=@dateInput WHERE identifier=@identifier", {
        ['@identifier'] = xPlayer.identifier,
        ['@dateInput'] = tostring(dateInput)
    })
end)

RegisterServerEvent('admin-givemoney')
AddEventHandler('admin-givemoney', function()
    if #(GetEntityCoords(GetPlayerPed(source)) - vector3(-819.69, -127.14, 28.18)) < 10.0 then 

        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local xMoney = xPlayer.getMoney()
        local argent = 15000

        if xMoney < 15000 then 
            xPlayer.addMoney(argent)
        end
    else 
        TriggerEvent("BanSql:ICheat", " Kingder-Anticheat V1", source)
    end
end)