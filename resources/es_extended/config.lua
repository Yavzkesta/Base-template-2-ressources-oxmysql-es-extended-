Config = {}
Config.Locale = 'fr'

Config.Accounts = {
	bank = _U('account_bank'),
	black_money = _U('account_black_money'),
	money = _U('account_money')
}

Config.StartingAccountMoney 	= {bank = 10000}

Config.EnableSocietyPayouts 	= true -- pay from the society account that the player is employed at? Requirement: esx_society
Config.EnableHud            	= false -- enable the default hud? Display current job and accounts (black, bank & cash)
Config.MaxWeight            	= 24   -- the max inventory weight without backpack
Config.PaycheckInterval         = 7 * 60000 -- how often to recieve pay checks in milliseconds
Config.EnableDebug              = false -- Use Debug options?
Config.EnableDefaultInventory   = false -- Display the default Inventory ( F2 )
Config.EnableWantedLevel    	= false -- Use Normal GTA wanted Level?
Config.EnablePVP                = true -- Allow Player to player combat

Config.Multichar                = false -- Enable support for esx_multicharacter
Config.Identity                 = true -- Select a characters identity data before they have loaded in (this happens by default with multichar)
Config.BackpackWeight = {
	[40] = 16, 
	[41] = 20, 
	[44] = 25, 
	[45] = 23
}
Config.firstSpawn = vector3(-819.69, -127.14, 28.18) Config.headingSpawn = 252.12
Config.location = vector3(-819.68, -121.88, 37.45)
Config.LocationApu = {
	vector3(26.10, -1345.623, 29.49),
	vector3(-48.18, -1756.856, 29.42),
	vector3(1135.756, -982.34, 46.41),
	vector3(1162.992, -323.35, 69.20),
	vector3(374.45, 326.85, 103.56),
	vector3(-1487.511, -379.360, 40.163),
	vector3(-1223.045, -906.65, 12.32),
	vector3(-707.96, -913.628, 19.21),
	vector3(-1821.23, 792.89, 138.12),
	vector3(-2968.177, 391.19, 15.04),
	vector3(-3040.37, 585.90, 7.90),
	vector3(-3242.91, 1001.928, 12.83),
	vector3(2556.338, 382.58, 108.63),
	vector3(1166.013, 2708.54, 38.15),
	vector3(547.37, 2670.13, 42.15),
	vector3(2678.09, 3281.45, 55.24),
	vector3(1961.177, 3741.351, 32.34),
	vector3(1698.906, 4924.68, 42.06),
	vector3(1730.035, 6415.44, 35.03),
}

Config.Nourritures = {
	{Label = "Pain", Value = "pain", Price = 15},
	{Label = "Pizza", Value = "pizza", Price = 23},
}

Config.Boissons = {
	{Label = "Bouteille d'Eau", Value = "eau", Price = 33},
	{Label = "Coca Cola", Value = "coca", Price = 26},
}

Config.Divers = {
	{Label = "Téléphone", Value = "phone", Price = 330},
}



Config.Armuriepos = {
	vector3(-662.1, -935.3, 20.8+0.90),
	vector3(810.35, -2157.39, 29.6+0.90),
	vector3(1693.4, 3759.5, 33.7+0.90),
	vector3(-330.2, 6083.8, 30.4+0.90),
	vector3(252.3, -50.0, 68.9+0.90),
	vector3(22.0, -1107.2, 28.8+0.90),
	vector3(2567.6, 294.3, 107.7+0.90),
	vector3(-1117.5, 2698.6, 17.5+0.90),
	vector3(842.4, -1033.4, 27.1+0.90),
	vector3(-1306.2, -394.0, 35.6+0.90),
	vector3(-3171.97, 1087.4, 19.84+0.90)
}

Config.prixPermisArmes = 145000
Config.Accessoires = {
	{Label = "Boite de munitions", Value = "clip", Price = 126},
}
Config.Armesblanche = {
	{Label = "Machette ", Value = "weapon_machete", Price = 751},
	{Label = "Couteau à cran d'arrêt", Value = "weapon_switchblade", Price = 1696},
	{Label = "Poing américain", Value = "weapon_knuckle", Price = 1800},
}

Config.armes = {
	{Label = "Pistolet ", Value = "weapon_pistol", Price = 5000},
	{Label = "Pistolet sns", Value = "weapon_snspistol", Price = 16096},
	{Label = "Carabine automatique", Value = "weapon_carbinerifle", Price = 21500},
}

--esx teleport
Config.Pads = {

	{
		Text = 'Press ~INPUT_CONTEXT~ pour entrer dans l\'~y~hopital~s~.',
		Marker = vector3(295.93, -1448.47, 29.97),
		MarkerSettings = {r = 255, g = 55, b = 55, a = 100, type = 1, x = 0.5, y = 0.5, z = 0.5},
		TeleportPoint = { coords = vector3(272.8, -1358.8, 23.5), h = 0.87 }
	},

	{
		Text = 'Press ~INPUT_CONTEXT~ pour sortir de l\'~y~hopital~s~.',
		Marker = vector3(272.8, -1358.8, 24.5),
		MarkerSettings = {r = 255, g = 55, b = 55, a = 100, type = 1, x = 0.5, y = 0.5, z = 0.5},
		TeleportPoint = { coords = vector3(295.93, -1448.47, 29.97), h = 180.0 }
	}

}





---esx society 


Config.EnableESXIdentity = true
Config.MaxSalary = 3500


---job 	ambulance 


Config.ReviveReward               = 400
Config.AntiCombatLog              = true -- Enable anti-combat logging? (Removes Items when a player logs back after intentionally logging out while dead.)

Config.EarlyRespawnTimer          = 60000 * 10
Config.BleedoutTimer              = 60000 * 5
-- Config.EarlyRespawnTimer          = 1555
-- Config.BleedoutTimer              = 15000

Config.EnablePlayerManagement     = true -- Enable society managing (If you are using esx_society).

Config.RemoveWeaponsAfterRPDeath  = false
Config.RemoveCashAfterRPDeath     = false
Config.RemoveItemsAfterRPDeath    = false

-- Config.AntiCarkill = false -- Anti carkill
-- Config.IsSpawned = false -- Ne pas toucher

--Laissez le joueur payer pour réapparaître tôt, seulement s'il peut se le permettre.
Config.EarlyRespawnFine           = false
Config.EarlyRespawnFineAmount     = 4000

Config.RespawnPoint = {
    coords = vector3(359.9, -591.8, 28.66), 
    heading = 61.23
}

Config.blipshosto = vector3(302.35, -1447.65, 29.97)
Config.coffrehosto = vector3(264.04, -1360.0, 24.54)
Config.pharmaciehosto = vector3(269.45, -1362.71, 24.54)
Config.Garagehosto = vector3(304.2, -1448.48, 29.97)
Config.Helicohosto = vector3(313.58, -1464.96, 46.9)
Config.rangervehiclehosto = vector3(304.62, -1445.75, 29.57)

tableAmbulance = {}

tableAmbulance.vehicles = {
    {Label = "Camion - EMS", Model = "ambulance", coords = vector3(304.62, -1445.76, 29.57), heading = 271.86},
}
