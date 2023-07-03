if (SERVER) then
	AddCSLuaFile("module/cl_bodyworks.lua")
	include("module/sv_bodyworks.lua")
end

if CLIENT then
	include("module/cl_bodyworks.lua");
end