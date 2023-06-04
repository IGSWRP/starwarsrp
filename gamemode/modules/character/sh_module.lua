if (SERVER) then
    AddCSLuaFile("module/sh_character.lua");
    include("module/sv_character.lua");
end

include("module/sh_character.lua");