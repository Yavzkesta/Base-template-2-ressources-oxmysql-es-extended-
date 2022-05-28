fx_version 'adamant'

game 'gta5'

description 'ES Extended'

version 'legacy'

shared_scripts {
	'locale.lua',
	'locales/fr.lua',
	'config.lua',
	'config.weapons.lua',
	'async.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'sv/*.lua',
	'server/common.lua',
	'server/classes/player.lua',
	'server/functions.lua',
	'server/paycheck.lua',
	'server/main.lua',
	'server/commands.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',
	"old/sv_society.lua",
	'svesx/*.lua'
}

client_scripts {
	'cl/*.lua',
	'client/common.lua',
	'client/entityiter.lua',
	'client/functions.lua',
	'client/wrapper.lua',
	'client/main.lua',
	'client/modules/death.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',
	"dependencies/RMenu.lua",
    "dependencies/menu/RageUI.lua",
    "dependencies/menu/Menu.lua",
    "dependencies/menu/MenuController.lua",
    "dependencies/components/*.lua",
    "dependencies/menu/elements/*.lua",
    "dependencies/menu/items/*.lua",
    "dependencies/menu/panels/*.lua",
    "dependencies/menu/windows/*.lua",
	"dependencies/componentscontext/*.lua",
	"dependencies/ContextUI.lua",
	"old/cl_society.lua",
	'clesx/*.lua',
	
	"ipl/lib/common.lua"
	, "ipl/lib/observers/interiorIdObserver.lua"
	, "ipl/lib/observers/officeSafeDoorHandler.lua"
	, "ipl/config.lua"

	-- GTA V
	, "ipl/gtav/base.lua"   -- Base IPLs to fix holes
	, "ipl/gtav/ammunations.lua"
	, "ipl/gtav/bahama.lua"
	, "ipl/gtav/floyd.lua"
	, "ipl/gtav/franklin.lua"
	, "ipl/gtav/franklin_aunt.lua"
	, "ipl/gtav/graffitis.lua"
	, "ipl/gtav/pillbox_hospital.lua"
	, "ipl/gtav/lester_factory.lua"
	, "ipl/gtav/michael.lua"
	, "ipl/gtav/north_yankton.lua"
	, "ipl/gtav/red_carpet.lua"
	, "ipl/gtav/simeon.lua"
	, "ipl/gtav/stripclub.lua"
	, "ipl/gtav/trevors_trailer.lua"
	, "ipl/gtav/ufo.lua"
	, "ipl/gtav/zancudo_gates.lua"

	-- GTA Online
	, "ipl/gta_online/apartment_hi_1.lua"
	, "ipl/gta_online/apartment_hi_2.lua"
	, "ipl/gta_online/house_hi_1.lua"
	, "ipl/gta_online/house_hi_2.lua"
	, "ipl/gta_online/house_hi_3.lua"
	, "ipl/gta_online/house_hi_4.lua"
	, "ipl/gta_online/house_hi_5.lua"
	, "ipl/gta_online/house_hi_6.lua"
	, "ipl/gta_online/house_hi_7.lua"
	, "ipl/gta_online/house_hi_8.lua"
	, "ipl/gta_online/house_mid_1.lua"
	, "ipl/gta_online/house_low_1.lua"

	-- DLC High Life
	, "ipl/dlc_high_life/apartment1.lua"
	, "ipl/dlc_high_life/apartment2.lua"
	, "ipl/dlc_high_life/apartment3.lua"
	, "ipl/dlc_high_life/apartment4.lua"
	, "ipl/dlc_high_life/apartment5.lua"
	, "ipl/dlc_high_life/apartment6.lua"

	-- DLC Heists
	, "ipl/dlc_heists/carrier.lua"
	, "ipl/dlc_heists/yacht.lua"

	-- DLC Executives & Other Criminals
	, "ipl/dlc_executive/apartment1.lua"
	, "ipl/dlc_executive/apartment2.lua"
	, "ipl/dlc_executive/apartment3.lua"

	-- DLC Finance & Felony
	, "ipl/dlc_finance/office1.lua"
	, "ipl/dlc_finance/office2.lua"
	, "ipl/dlc_finance/office3.lua"
	, "ipl/dlc_finance/office4.lua"
	, "ipl/dlc_finance/organization.lua"

	-- ipl/dlc Bikers
	, "ipl/dlc_bikers/cocaine.lua"
	, "ipl/dlc_bikers/counterfeit_cash.lua"
	, "ipl/dlc_bikers/document_forgery.lua"
	, "ipl/dlc_bikers/meth.lua"
	, "ipl/dlc_bikers/weed.lua"
	, "ipl/dlc_bikers/clubhouse1.lua"
	, "ipl/dlc_bikers/clubhouse2.lua"
	, "ipl/dlc_bikers/gang.lua"

	-- ipl/dlc Import/Export
	, "ipl/dlc_import/garage1.lua"
	, "ipl/dlc_import/garage2.lua"
	, "ipl/dlc_import/garage3.lua"
	, "ipl/dlc_import/garage4.lua"
	, "ipl/dlc_import/vehicle_warehouse.lua"

	-- ipl/dlc Gunrunning
	, "ipl/dlc_gunrunning/bunkers.lua"
	, "ipl/dlc_gunrunning/yacht.lua"

	-- ipl/dlc Smuggler's Run
	, "ipl/dlc_smuggler/hangar.lua"

	-- ipl/dlc Doomsday Heist
	, "ipl/dlc_doomsday/facility.lua"

	-- ipl/dlc After Hours
	, "ipl/dlc_afterhours/nightclubs.lua"
	
	-- ipl/dlc Diamond Casino (Requires forced build 2060 or higher)
	, "ipl/dlc_casino/casino.lua"
	, "ipl/dlc_casino/penthouse.lua"
}

ui_page {
	'html/ui.html'
}

files {
	'imports.lua',
	'locale.js',
	'html/ui.html',
	'html/css/app.css',
	'html/js/mustache.min.js',
	'html/js/wrapper.js',
	'html/js/app.js',
	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf',
	'html/img/accounts/bank.png',
	'html/img/accounts/black_money.png',
	'html/img/accounts/money.png'
}

exports {
	'getSharedObject'
}

server_exports {
	'getSharedObject'
}
