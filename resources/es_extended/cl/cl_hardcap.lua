Citizen.CreateThread(function()
	while true do
		local startwait = 700

		if NetworkIsSessionStarted() then
			startwait = 0
			TriggerServerEvent('hardcap:playerActivated')

			return
		end
		Wait(startwait)
	end
end)