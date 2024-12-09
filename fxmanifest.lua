fx_version 'adamant' 
game 'gta5' 

lua54 'yes'
ui_page "html/index.html"
 
client_scripts { 
	"config.lua",
	"core/client.lua",
} 
 
server_scripts { 
	"config.lua",
	"core/server.lua",
	'@oxmysql/lib/MySQL.lua',
	
} 

shared_scripts {
    '@ox_lib/init.lua',
}

files {
	"html/index.html",
	"html/css/cat.css",
	"html/js/cat.js",
	"html/img/*.png",
}