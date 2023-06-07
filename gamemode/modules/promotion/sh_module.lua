if (SERVER) then
    AddCSLuaFile("module/sh_promotion.lua");
    AddCSLuaFile("module/cl_promotion.lua");
    AddCSLuaFile("module/cl_regimentinvite.lua");
    include("module/sv_promotion.lua");
end

if CLIENT then
    include("module/cl_promotion.lua");
    include("module/cl_regimentinvite.lua");
end

include("module/sh_promotion.lua");