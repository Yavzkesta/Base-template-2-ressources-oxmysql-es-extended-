Keys.Register('F6', 'Métier', 'Ouvrir le menu des métiers', function()
    if ESX.PlayerData.job ~= nil then
        if ESX.PlayerData.job.name == 'ambulance' then
            menuf6ambulance()
        end
      end
end) 
