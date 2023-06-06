AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

-- Disable sprays
function GM:PlayerSpray(ply) return true end

-- F2 Menu - different per player class
function GM:ShowTeam(ply) player_manager.RunClass(ply, "ShowTeam") end