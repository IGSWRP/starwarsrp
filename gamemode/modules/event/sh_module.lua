if SERVER then
    AddCSLuaFile("module/cl_event.lua")
    AddCSLuaFile("module/cl_eventinvite.lua")
    AddCSLuaFile("module/cl_eventmenu.lua")
    AddCSLuaFile("module/cl_orders.lua")
    AddCSLuaFile("module/sh_event.lua")
    include("module/sv_event.lua")
end

if CLIENT then
    include("module/cl_event.lua")
    include("module/cl_eventinvite.lua")
    include("module/cl_eventmenu.lua")
    include("module/cl_orders.lua")
end

include("module/sh_event.lua")