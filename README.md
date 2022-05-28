# Base-template-2-ressources

Bien lire le .txt 

# Pub 

Meilleure menu admin FiveM -> https://youtu.be/fvzCPfNt2nk

Drogue builder -> https://youtu.be/LkBHU4Jh9Dc

# Téléchargement

Lien de téléchargement : https://flix.horizon-dev.xyz/nextcloud/s/5QYkKpJ3n7eSk2Y

# Information

Base template 2 ressources 

Les groupes pour les perms sont "helper" et "admin" . 

ESX 1.3 (Legacy)

- 0.10 Resmon.

- Double job

[oxmysql | es_extended]

es_extended contient 

-async

-spawnmanager.

-sessionmanager.

-hardcap

-esx_addonaccount

-esx_addoninventory 

-esx_datastore

-esx_billing

-esx_skin

-esx_license

-esx society

-vsync (géstion méteo)

-Creator (création d'identité)

-Bob74Ipl

-skinchanger

-esx_teleport

-script superette 

-script ammunation 

-script location de vehicule

-/coords (afficher les coordonées)

-Mini "hud" en ContextUI (restez appuyez sur W) | si vous voulez le supprimer --> [es_extended/clesx/cl_contextUI]

-Job ambulance [Se n'est pas mon code ni mes idées mais cela est fait également par moi!]


fonction créer par moi même et ajouter à la base.

- 'ESX.RepairVehicleKingder()' dans vos scripts et cela répare le véhicule dans lequel le joueur se trouve.

- 'ESX.CreateBlipsKingder(100, 0.75, 42, "test", vector3(-819.88, -121.92, 37.45))' ------- à placer entre "CreateThread" & "While true do" pour placer un blips

- 'ESX.CreatePedKingder("PED_TYPE_CIVFEMALE", "a_m_o_acult_02", vector3(-1120.04, 4976.29, 185.51), 355.4, true, true)' ------- à placer entre "CreateThread" & "While true do" pour placer un pnj. [#1 true = invincible  #2 true = freeze

- local exemple = ESX.ImputKeyboard("Exemple", "sous titre de l'exemple", nil, 10) ---systeme de keyboard souvent utilisé.



Pour rajouter un script dans l'es extended

je vous déconseille de le faire , et de juste poursuivre le developpement de votre base en ajoutant vos scripts sans les compacter si vous êtes novices.

Enlever les déclarations esx "getSharedObject" et toutes les autres qui servent à rien et qui peuvent casser la base "ESX = nil" "esx:setjob" ....

Si vous voulez compacter votre ressource et quel celle ci doit être start avant une n'autre , mettez la dans "es_extended/old/*".
