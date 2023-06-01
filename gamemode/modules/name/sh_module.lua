if (SERVER) then
    AddCSLuaFile("module/sh_name.lua");
    AddCSLuaFile("module/cl_nametags.lua");
    include("module/sv_name.lua");
end

if CLIENT then
    include("module/cl_nametags.lua");
end

include("module/sh_name.lua");
