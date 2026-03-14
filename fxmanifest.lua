fx_version 'cerulean'
lua54 'yes'
game 'gta5'
name 'DBD Mining'
author 'DonBurtron'
version '2.0'
description 'DBD Mining'

shared_scripts {
    'config/main.lua',
    'config/xp.lua',
    'config/mining.meta.lua'
}

client_scripts {
    'shared/locale.lua',
    'cl_weaponNames.lua',
    'client/init.lua',
    'client/functions.lua',
    'client/target.lua',
    'client/ui.lua',
    'client/tasks.lua',
    'client/mining.lua',
    'client/xp.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'shared/locale.lua',
    'shared/framework.lua',
    'shared/inventory.lua',
    'server/storage.lua',
    'server/leaderboard.lua',
    'server/tasks.lua',
    'server/mining.lua',
    'server/xp.lua'
}

files {
    'locales/*.json',
    'ui/index.html',
    'ui/style.css',
    'ui/app.js',
    'ui/images/counter.png',
    '**/weaponarchetypes.meta',
    '**/weaponanimations.meta',
    '**/pedpersonality.meta',
    '**/weapons.meta'
}


escrow_ignore {
    'config/main.lua',
    'config/mining.meta.lua',
    'config/xp.lua'
}

ui_page 'ui/index.html'

data_file 'WEAPON_METADATA_FILE' '**/weaponarchetypes.meta'
data_file 'WEAPON_ANIMATIONS_FILE' '**/weaponanimations.meta'
data_file 'PED_PERSONALITY_FILE' '**/pedpersonality.meta'
data_file 'WEAPONINFO_FILE' '**/weapons.meta'


dependency '/assetpacks'