DeriveGamemode("sandbox");

IG = IG or {}

GM.Name = "Star Wars Roleplay"

function GM:Initialize()
	-- Do stuff
end

function LoadModule(module)
    print("[IG] Loading module:", module)

    local luaFile = "modules/" .. module .. "/sh_module.lua"

    if SERVER then AddCSLuaFile(luaFile) end
    include(luaFile)
end

function LoadData(data)
    print("[IG] Loading data:", data)

    local luaFile = "data/sh_" .. data .. ".lua"
    if SERVER then AddCSLuaFile(luaFile) end
    include(luaFile);
end

include("player_class/player_imperial.lua")

LoadData("ranks")
LoadData("regiments")

LoadModule("spawn")
LoadModule("character")
LoadModule("chat")
LoadModule("name")
LoadModule("currency")
