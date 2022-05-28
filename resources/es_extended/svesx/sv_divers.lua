
ESX.RegisterServerCallback('sucemoikehba', function(source, cb)
    if #(GetEntityCoords(GetPlayerPed(source)) - Config.location) < 10.0 then 
    local xPlayer = ESX.GetPlayerFromId(source)

          if xPlayer.getMoney() >= 700 then
            xPlayer.removeMoney(700)
            cb(true)
          else
            cb(false)
          end
      end
  end)
  

ESX.RegisterServerCallback('sucemoikehbaa', function(source, cb)
if #(GetEntityCoords(GetPlayerPed(source)) - Config.location) < 10.0 then 
local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer.getMoney() >= 1200 then
        xPlayer.removeMoney(1200)
        cb(true)
        else
        cb(false)
        end
    end
end)


RegisterNetEvent('droplitemsuperette')
AddEventHandler('droplitemsuperette', function(v, taurarienaugive)
	if #(GetEntityCoords(GetPlayerPed(source)) - taurarienaugive) > 5.0 then return end

		local xPlayer = ESX.GetPlayerFromId(source)
		local playerMoney = xPlayer.getMoney()

		  if playerMoney >= (v.Price) then
          xPlayer.addInventoryItem(v.Value, 1)
          xPlayer.removeMoney(v.Price)
          xPlayer.showNotification("Vous avez achetez x1 ~p~"..v.Label.." ~s~pour ~p~"..v.Price.."~s~$")
      else
          xPlayer.showNotification("~r~Vous n'avez pas assez d'argent.~s~")
      end
end)

RegisterNetEvent('droplitemArmurie')
AddEventHandler('droplitemArmurie', function(v, armuriefucktrigger)
	if #(GetEntityCoords(GetPlayerPed(source)) - armuriefucktrigger) > 5.0 then return end

		local xPlayer = ESX.GetPlayerFromId(source)
		local playerMoney = xPlayer.getMoney()

		  if playerMoney >= (v.Price) then
          xPlayer.addInventoryItem(v.Value, 1)
          xPlayer.removeMoney(v.Price)
          xPlayer.showNotification("Vous avez achetez x1 ~p~"..v.Label.." ~s~pour ~p~"..v.Price.."~s~$")
      else
          xPlayer.showNotification("~r~Vous n'avez pas assez d'argent.~s~")
      end
end)

RegisterNetEvent('droplarmermurie')
AddEventHandler('droplarmermurie', function(v, armuriefucktrigger)
	if #(GetEntityCoords(GetPlayerPed(source)) - armuriefucktrigger) > 5.0 then return end

		local xPlayer = ESX.GetPlayerFromId(source)
		local playerMoney = xPlayer.getMoney()

		  if playerMoney >= (v.Price) then
        if not xPlayer.hasWeapon(v.Value) then
          xPlayer.addWeapon(v.Value, 1500)
          xPlayer.removeMoney(v.Price)
        else 
          xPlayer.showNotification("~o~Vous avez déjà cette ~p~arme~s~.")
        end
          xPlayer.showNotification("Vous avez achetez x1 ~p~"..v.Label.." ~s~pour ~p~"..v.Price.."~s~$")
      else
          xPlayer.showNotification("~r~Vous n'avez pas assez d'argent.~s~")
      end
end)

ESX.RegisterServerCallback('verifsitaleppapd', function(source, cb, type)
  CheckLicense(source, 'weapon', cb)
end)

function CheckLicense(source, type, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  local identifier = xPlayer.identifier

MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
  ['@type']  = type,
  ['@owner'] = identifier
}, function(result) 
    if tonumber(result[1].count) > 0 then
      cb(true)
    else
      cb(false)
    end

   end)
end

RegisterServerEvent('envoislemisper')
AddEventHandler('envoislemisper', function(weapon, armuriefucktrigger)
	if #(GetEntityCoords(GetPlayerPed(source)) - armuriefucktrigger) > 5.0 then return end

	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getMoney()

	if playerMoney >= Config.prixPermisArmes then
      MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
          ['@type'] = weapon,
          ['@owner'] = xPlayer.identifier
      })
	      xPlayer.removeMoney(Config.prixPermisArmes)
        xPlayer.showNotification("~g~Achat réussis !")
    else
        xPlayer.showNotification("~r~Vous n'avez pas assez !")
    end
end)
