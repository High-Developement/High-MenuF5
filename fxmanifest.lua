fx_version 'adamant'
game 'gta5' 

author 'Alga'

client_scripts {
    'client/**.*'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/**.*'
}

shared_scripts {
    'config.lua'
}