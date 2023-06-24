if ( SERVER ) then
	AddCSLuaFile( "module/cl_currency.lua" )
	AddCSLuaFile( "module/cl_loginbonus.lua" )

	AddCSLuaFile( "module/sh_currency.lua" )
	AddCSLuaFile( "module/sh_loginbonus.lua" )

	include( "module/sv_currency.lua" )
	include( "module/sv_loginbonus.lua" )
end

if ( CLIENT ) then
	include( "module/cl_currency.lua" )
	include( "module/cl_loginbonus.lua" )
end

include( "module/sh_currency.lua" )
include( "module/sh_loginbonus.lua" )