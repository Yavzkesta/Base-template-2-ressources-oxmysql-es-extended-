local HasAlreadyEnteredMarker = false
local LastPad, LastAction, LastPadData, CurrentAction, CurrentActionData, CurrentActionMsg

RegisterNetEvent('esx_teleportpads:hasEnteredMarker')
AddEventHandler('esx_teleportpads:hasEnteredMarker', function(currentPad, padData)
	CurrentAction = 'pad.' .. string.lower(currentPad)
	CurrentActionMsg = padData.Text
	CurrentActionData = { padData = padData }
end)

RegisterNetEvent('esx_teleportpads:hasExitedMarker')
AddEventHandler('esx_teleportpads:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()

	CurrentAction = nil
end)

-- Draw marker
Citizen.CreateThread(function()
	while true do
		local filsdepute = 700
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		for pad, padData in ipairs(Config.Pads) do

			if GetDistanceBetweenCoords(coords, padData.Marker, true) < 30 then
				filsdepute = 300
			end

			if GetDistanceBetweenCoords(coords, padData.Marker, true) < 10 then
				filsdepute = 0 
				DrawMarker(2, padData.Marker, 0.0, 0.0, 0.0, 0, 0.0, 0.0, padData.MarkerSettings.x, padData.MarkerSettings.y, padData.MarkerSettings.z, padData.MarkerSettings.r, padData.MarkerSettings.g, padData.MarkerSettings.b, padData.MarkerSettings.a, false, true, 2, false, false, false, false)
			end
		end
		Wait(filsdepute)
	end
end)

Citizen.CreateThread(function()
	while true do
		local mglwsh = 700
		
		local playerPed = PlayerPedId()
		local coords, isInMarker, currentPad, currentAction, currentPadData = GetEntityCoords(playerPed), false, nil, nil, nil

		for pad, padData in ipairs(Config.Pads) do
			if GetDistanceBetweenCoords(coords, padData.Marker, true) < padData.MarkerSettings.x then
				mglwsh = 0
				isInMarker, currentPad, currentAction, currentPadData = true, pad, 'pad.' .. string.lower(pad), padData
			end
		end

		local hasExited = false

		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastPad ~= currentPad or LastAction ~= currentAction)) then
			if (LastPad ~= nil and LastAction ~= nil) and (LastPad ~= currentPad or LastAction ~= currentAction) then
				TriggerEvent('esx_teleportpads:hasExitedMarker', LastPad, LastAction)
				
				hasExited = true
			end

			HasAlreadyEnteredMarker = true
			LastPad, LastAction, LastPadData = currentPad, currentAction, currentPadData

			TriggerEvent('esx_teleportpads:hasEnteredMarker', currentPad, currentPadData)
		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false

			TriggerEvent('esx_teleportpads:hasExitedMarker', LastPad, LastAction)
		end

		if not HasAlreadyEnteredMarker then
			Citizen.Wait(500)
		end
		Wait(mglwsh)
	end
end)

Citizen.CreateThread(function()
	while true do
		local wshfilsdeup = 300

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)
			wshfilsdeup = 0

			if IsControlJustReleased(0, 38) then
				ESX.Game.Teleport(PlayerPedId(), CurrentActionData.padData.TeleportPoint.coords, function()
					SetEntityHeading(PlayerPedId(), CurrentActionData.padData.TeleportPoint.h)
				end)
			end
		else
			Citizen.Wait(500)
		end
		Wait(wshfilsdeup)
	end
end)
