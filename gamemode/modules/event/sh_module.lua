if SERVER then
    AddCSLuaFile("module/cl_eventmenu.lua")
end

if CLIENT then
    include("module/cl_eventmenu.lua")
end