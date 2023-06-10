if SERVER then
	AddCSLuaFile("module/cl_spawn.lua")
    include("module/sv_spawn.lua")
end

if CLIENT then
	include("module/cl_spawn.lua")
end