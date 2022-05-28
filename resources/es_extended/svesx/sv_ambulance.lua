
local playersHealing, deadPlayers = {}, {}

TriggerEvent('esx_phone:registerNumber', 'ambulance', 'alerte_ambulance', true, true)
TriggerEvent('esx_society:registerSociety', 'ambulance', 'Ambulance', 'society_ambulance', 'society_ambulance', 'society_ambulance', {type = 'public'})


ESX.RegisterServerCallback('guettetongroupepdpdpdp', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	print(GetPlayerName(source).." - "..group)
	cb(group)
end)


RegisterServerEvent('Ambulance:AppelNotifs')
AddEventHandler('Ambulance:AppelNotifs', function(supprimer)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == 'ambulance' then
			TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'EMS', '~b~Information', 'L\'ambulancier ~b~'..name..'~s~ a pris l\'appel ~b~N°'..supprimer, 'CHAR_CALL911', 2)
		end
	end
end)

RegisterServerEvent('esx_ambulancejob:revive')
AddEventHandler('esx_ambulancejob:revive', function(target)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer.job.name ~= 'ambulance' then
		return
		PerformHttpRequest("https://discord.com/api/webhooks/912066147283763263/N2zJMQoymd2zepfd3NbXRd2fJMc0CuWvroZhhFm6TtURyZuDRZ62izXShE_d0Ft12-Qe", function(err, text, headers) end, 'POST', json.encode({username = "", content = xPlayer.getName() .. " a fait un /revive"}), { ['Content-Type'] = 'application/json' }) 
	  end
	
	xPlayer.addMoney(Config.ReviveReward)
	TriggerClientEvent('esx_ambulancejob:revive', target)
end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	deadPlayers[source] = 'dead'
	TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
end)

RegisterNetEvent('esx_ambulancejob:onPlayerDistress')
AddEventHandler('esx_ambulancejob:onPlayerDistress', function()
	if deadPlayers[source] then
		deadPlayers[source] = 'distress'
		TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
	end
end)

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
	if deadPlayers[source] then
		deadPlayers[source] = nil
		TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
	end
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if deadPlayers[playerId] then
		deadPlayers[playerId] = nil
		TriggerClientEvent('esx_ambulancejob:setDeadPlayers', -1, deadPlayers)
	end
end)

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(target, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:heal', target, type)
	end
end)

RegisterNetEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'ambulance' then
		TriggerClientEvent('esx_ambulancejob:putInVehicle', target)
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.RemoveCashAfterRPDeath then
		if xPlayer.getMoney() > 0 then
			xPlayer.removeMoney(xPlayer.getMoney())
		end

		if xPlayer.getAccount('black_money').money > 0 then
			xPlayer.setAccountMoney('black_money', 0)
		end
	end

	local playerLoadout = {}
	if Config.RemoveWeaponsAfterRPDeath then
		for i=1, #xPlayer.loadout, 1 do
			table.insert(playerLoadout, xPlayer.loadout[i])
		end

		-- give back wepaons after a couple of seconds
		Citizen.CreateThread(function()
			Citizen.Wait(5000)
			for i=1, #playerLoadout, 1 do
				if playerLoadout[i].label ~= nil then
					xPlayer.addWeapon(playerLoadout[i].name, playerLoadout[i].ammo)
				end
			end
		end)
	end

	cb()
end)

if Config.EarlyRespawnFine then
	ESX.RegisterServerCallback('esx_ambulancejob:checkBalance', function(source, cb)
		local xPlayer = ESX.GetPlayerFromId(source)
		local bankBalance = xPlayer.getAccount('bank').money

		cb(bankBalance >= Config.EarlyRespawnFineAmount)
	end)

	RegisterNetEvent('esx_ambulancejob:payFine')
	AddEventHandler('esx_ambulancejob:payFine', function()
		local xPlayer = ESX.GetPlayerFromId(source)
		local fineAmount = Config.EarlyRespawnFineAmount

		TriggerClientEvent("acore:notif", source, _U('respawn_bleedout_fine_msg', ESX.Math.GroupDigits(fineAmount)))
		xPlayer.removeAccountMoney('bank', fineAmount)
	end)
end

ESX.RegisterServerCallback('esx_ambulancejob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('esx_ambulancejob:buyJobVehicle', function(source, cb, vehicleProps, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = getPriceFromHash(vehicleProps.model, xPlayer.job.grade_name, type)

	-- vehicle model not found
	if price == 0 then
		cb(false)
	else
		if xPlayer.getMoney() >= price then
			xPlayer.removeMoney(price)

			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, vehicle, plate, type, job, `stored`) VALUES (@owner, @vehicle, @plate, @type, @job, @stored)', {
				['@owner'] = xPlayer.identifier,
				['@vehicle'] = json.encode(vehicleProps),
				['@plate'] = vehicleProps.plate,
				['@type'] = type,
				['@job'] = xPlayer.job.name,
				['@stored'] = true
			}, function (rowsChanged)
				cb(true)
			end)
		else
			cb(false)
		end
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:storeNearbyVehicle', function(source, cb, nearbyVehicles)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundPlate, foundNum

	for k,v in ipairs(nearbyVehicles) do
		local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = v.plate,
			['@job'] = xPlayer.job.name
		})

		if result[1] then
			foundPlate, foundNum = result[1].plate, k
			break
		end
	end

	if not foundPlate then
		cb(false)
	else
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE owner = @owner AND plate = @plate AND job = @job', {
			['@owner'] = xPlayer.identifier,
			['@plate'] = foundPlate,
			['@job'] = xPlayer.job.name
		}, function (rowsChanged)
			if rowsChanged == 0 then
				cb(false)
			else
				cb(true, foundNum)
			end
		end)
	end
end)

function getPriceFromHash(vehicleHash, jobGrade, type)
	local vehicles = Config.AuthorizedVehicles[type][jobGrade]

	for k,v in ipairs(vehicles) do
		if GetHashKey(v.model) == vehicleHash then
			return v.price
		end
	end

	return 0
end

RegisterNetEvent('esx_ambulancejob:removeItem')
AddEventHandler('esx_ambulancejob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item, 1)

	if item == 'bandage' then
		TriggerClientEvent('acore:notif', _source, '~b~Vous avez utilisé un bandage')
	elseif item == 'medikit' then
		TriggerClientEvent('acore:notif', _source, '~b~Vous avez utilisé un Medikit')
	end
end)

ESX.RegisterCommand('revive', 'sousmerde', function(xPlayer, args, showError)
	args.playerId.triggerEvent('esx_ambulancejob:revive')
end, true, {help = _U('revive_help'), validate = true, arguments = {
	{name = 'playerId', help = 'The player id', type = 'player'}
}})

ESX.RegisterCommand('reviveall', "admin", function(xPlayer, args, showError)
	for _, playerId in ipairs(GetPlayers()) do
		TriggerClientEvent('esx_ambulancejob:revive', playerId)
	end
end, false)

RegisterServerEvent('Pharmacy:giveitem')
AddEventHandler('Pharmacy:giveitem', function(itemName, itemLabel)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local qtty = xPlayer.getInventoryItem(itemName).count

		if qtty < 10 then
			xPlayer.addInventoryItem(itemName, 5)
			TriggerClientEvent('acore:notif', _source, '~g~Ambulance\n~w~Tu as recu des bandages ~o~(10 Maximum)')
		else
			TriggerClientEvent('acore:notif', _source, '~g~Ambulance\n~r~Maximum de bandages Atteints')
		end
	end)

RegisterServerEvent('Pharmacy:giveitemm')
AddEventHandler('Pharmacy:giveitemm', function(itemName, itemLabel)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local qtty = xPlayer.getInventoryItem(itemName).count

		if qtty < 5 then
			xPlayer.addInventoryItem(itemName, 1)
			TriggerClientEvent('acore:notif', _source, '~g~Ambulance\n~w~Tu as recu des Medikit ~o~(5 Maximum)')
		else
			TriggerClientEvent('acore:notif', _source, '~g~Ambulance\n~r~Maximum de bandages Atteints')
		end
	end)

ESX.RegisterUsableItem('medikit', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('medikit', 1)

		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'medikit')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterUsableItem('bandage', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('bandage', 1)

		playersHealing[source] = true
		TriggerClientEvent('esx_ambulancejob:useItem', source, 'bandage')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterServerCallback('esx_ambulancejob:getDeathStatus', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(isDead)
				
		if isDead then
		end

		cb(isDead)
	end)
end)

RegisterNetEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(isDead)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type(isDead) == 'boolean' then
		MySQL.Sync.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier,
			['@isDead'] = isDead
		})
	end
end)

RegisterServerEvent('EMS:Ouvert')
AddEventHandler('EMS:Ouvert', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()

    if xPlayer.job.name ~= 'ambulance' then
		return
	  end
	

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'EMS', '~b~Annonce EMS', 'Un ~g~EMS~s~ est en service ! Votre santé avant tout !', 'CHAR_CALL911', 7)
    end
end)

RegisterServerEvent('EMS:Fermer')
AddEventHandler('EMS:Fermer', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()

    if xPlayer.job.name ~= 'ambulance' then
		return
	  end
	

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'EMS', '~b~Annonce EMS', 'Il n\'y a plus ~r~d\'EMS~s~ en service ! ', 'CHAR_CALL911', 7)
    end
end)


RegisterServerEvent('EMS:Perso')
AddEventHandler('EMS:Perso', function(msg)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers    = ESX.GetPlayers()

    if xPlayer.job.name ~= 'ambulance' then
		return
	  end
	

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'EMS', '~b~Annonce EMS', ''..msg..'', 'CHAR_CALL911', 7)
    end
end)


ESX.RegisterServerCallback('ems:afficheappels', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local keys = {}

    MySQL.Async.fetchAll('SELECT * FROM appels_ems', {}, 
        function(result)
        for numreport = 1, #result, 1 do
            table.insert(keys, {
                id = result[numreport].id,
                type = result[numreport].type,
                reporteur = result[numreport].reporteur,
                nomreporter = result[numreport].nomreporter,
                raison = result[numreport].raison
            })
        end
        cb(keys)

    end)
end)

RegisterServerEvent('ems:ajoutappels')
AddEventHandler('ems:ajoutappels', function(typereport, reporteur, nomreporter, raison)
    MySQL.Async.execute('INSERT INTO appels_ems (type, reporteur, nomreporter, raison) VALUES (@type, @reporteur, @nomreporter, @raison)', {
        ['@type'] = typereport,
        ['@reporteur'] = reporteur,
        ['@nomreporter'] = nomreporter,
        ['@raison'] = raison
    })
end)

RegisterServerEvent('ems:supprimeappels')
AddEventHandler('ems:supprimeappels', function(supprimer)
    MySQL.Async.execute('DELETE FROM appels_ems WHERE id = @id', {
            ['@id'] = supprimer
    })
end)


RegisterServerEvent("Server:emsAppel")
AddEventHandler("Server:emsAppel", function(coords, id)

	local _id = id
	local _coords = coords
	local xPlayers	= ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'ambulance' then
			TriggerClientEvent("AppelemsTropBien", xPlayers[i], _coords, _id)
		end
end
end)
RegisterServerEvent('EMS:PriseAppelServeur')
AddEventHandler('EMS:PriseAppelServeur', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = xPlayer.getName(source)
	local xPlayers = ESX.GetPlayers()

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('EMS:AppelDejaPris', xPlayers[i], name)
    end
end)
ESX.RegisterServerCallback('EMS:GetID', function(source, cb)
	local idJoueur = source
	cb(idJoueur)
end)

local AppelTotal = 0
RegisterServerEvent('EMS:AjoutAppelTotalServeur')
AddEventHandler('EMS:AjoutAppelTotalServeur', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local name = xPlayer.getName(source)
	local xPlayers = ESX.GetPlayers()
	AppelTotal = AppelTotal + 1

	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
			TriggerClientEvent('EMS:AjoutUnAppel', xPlayers[i], AppelTotal)
	end
end)

RegisterServerEvent('aw:wipe')
AddEventHandler('aw:wipe', function()
	MySQL.Async.execute([[
		DELETE FROM addon_account_data WHERE owner = @wipeID;
		DELETE FROM users WHERE identifier = @wipeID;	]], {
		['@wipeID'] = wipeid,
		['@wipeTEL'] = phone,
	}, function(rowsChanged)
	end)
end)

RegisterServerEvent('emssapl:deleteallappels')
AddEventHandler('emssapl:deleteallappels', function()
    MySQL.Async.execute('DELETE FROM appels_ems', {
    })
end)



ESX.RegisterServerCallback('ambulance:getStockItems', function(source, cb)
    local all_items = {}
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)
        for k,v in pairs(inventory.items) do
            if v.count > 0 then
                table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
				print(v.label.."/"..v.name.."/"..v.count)	
            end
        end
    end)
    cb(all_items)
end)

RegisterServerEvent('ambulance:putStockItems')
AddEventHandler('ambulance:putStockItems', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item_in_inventory = xPlayer.getInventoryItem(itemName).count

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)
        if item_in_inventory >= count and count > 0 then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
            TriggerClientEvent('esx:showNotification', xPlayer.source, "- ~g~Dépot\n~s~- ~g~Item ~s~: "..itemName.."\n~s~- ~o~Quantitée ~s~: "..count.."")
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "<C>~r~Vous n'en avez pas assez sur vous")
        end
    end)
end)

RegisterServerEvent('ambulance:takestockitem')
AddEventHandler('ambulance:takestockitem', function(itemName, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ambulance', function(inventory)
            xPlayer.addInventoryItem(itemName, count)
            inventory.removeItem(itemName, count)
    end)
end)


ESX.RegisterServerCallback('ambulance:playerinventory', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items   = xPlayer.inventory
    local all_itemsss = {}
    for k,v in pairs(items) do
        if v.count > 0 then
            table.insert(all_itemsss, {label = v.label, item = v.name,nb = v.count})
        end
    end
    cb(all_itemsss)
end)
