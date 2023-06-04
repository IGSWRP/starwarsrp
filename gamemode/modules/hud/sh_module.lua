if (SERVER) then
    AddCSLuaFile("module/cl_scoreboard.lua");
    AddCSLuaFile("module/cl_hud.lua");
end

if CLIENT then
    include("module/cl_scoreboard.lua");
    include("module/cl_hud.lua");
end