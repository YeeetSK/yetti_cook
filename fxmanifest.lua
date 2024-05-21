fx_version "cerulean"
game "gta5"
lua54 'yes'

author 'Yetti Development'
description 'peds in cpz, able to call police and get food/drinks.'

client_scripts {
    'client/client.lua',
}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
}

files {
    'locales/*.json'
  }