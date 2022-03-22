fx_version 'cerulean'
game 'gta5'

name "zF5"
description "F5"
author "SayzXzDéveloppement"
version "1.5"

shared_scripts {
	'shared/*.lua'
}

client_scripts {
	'RageUI/RMenu.lua',
    'RageUI/menu/RageUI.lua',
    'RageUI/menu/Menu.lua',
    'RageUI/menu/MenuController.lua',
    'RageUI/components/*.lua',
    'RageUI/menu/elements/*.lua',
    'RageUI/menu/items/*.lua',
    'RageUI/menu/panels/*.lua',
    'RageUI/menu/windows/*.lua',
	'client/*.lua',
    'function.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}
