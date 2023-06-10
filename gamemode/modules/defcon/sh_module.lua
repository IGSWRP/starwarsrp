if (SERVER) then
	AddCSLuaFile("module/cl_defcon.lua")
	AddCSLuaFile("module/sh_defcon.lua")
	include("module/sv_defcon.lua")
end

if CLIENT then
	include("module/cl_defcon.lua");
end

include("module/sh_defcon.lua")