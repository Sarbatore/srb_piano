games { "rdr3" }
fx_version "adamant"
rdr3_warning "I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships."
lua54 "yes"
author "Sarbatore"

client_scripts {
	"@uiprompt/uiprompt.lua",
	"client.lua"
}

escrow_ignore {
	"client.lua",
	"config.lua",
}