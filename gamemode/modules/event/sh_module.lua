if SERVER then
    AddCSLuaFile("module/cl_event.lua")
    AddCSLuaFile("module/cl_eventmenu.lua")
    AddCSLuaFile("module/sh_event.lua")
    include("module/sv_event.lua")
end

if CLIENT then
    include("module/cl_event.lua")
    include("module/cl_eventmenu.lua")
end

include("module/sh_event.lua")