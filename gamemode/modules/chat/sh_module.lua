if (SERVER) then
    AddCSLuaFile("module/sh_chat.lua");
    AddCSLuaFile("module/cl_chat.lua")
    include("module/sv_voice.lua");
    include("module/sv_chat.lua")
end

if CLIENT then
    include("module/cl_chat.lua");
end

include("module/sh_chat.lua")