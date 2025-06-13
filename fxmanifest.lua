fx_version "cerulean"
game "gta5"
lua54 "yes"
author "4rudy"
description "Prison Script"

shared_scripts {
	"@ox_lib/init.lua",
	"@mc9-lib/import.lua",
	"config.lua"
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	"server/*.lua"
}

client_scripts {
	"client/*.lua",
	"@PolyZone/client.lua",
	"@PolyZone/BoxZone.lua",
	"@PolyZone/ComboZone.lua"
}
