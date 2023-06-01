if (SERVER) then
    AddCSLuaFile("module/sh_character.lua");
    AddCSLuaFile("module/cl_promotionmenu.lua");
    include("module/sv_character.lua");
end

if CLIENT then
    include("module/cl_promotionmenu.lua");
end

include("module/sh_character.lua");