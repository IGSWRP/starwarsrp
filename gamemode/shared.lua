DeriveGamemode("sandbox");

IG = IG or {}

GM.Name = "Star Wars Roleplay"

function GM:Initialize()
	-- Do stuff
end

local function LoadPlayerClass(class)
    print("[IG] Loading player class:", class)

    local luaFile = "player_class/player_" .. class .. ".lua"
    if SERVER then AddCSLuaFile(luaFile) end
    include(luaFile);
end

local function LoadModule(module)
    print("[IG] Loading module:", module)

    local luaFile = "modules/" .. module .. "/sh_module.lua"

    if SERVER then AddCSLuaFile(luaFile) end
    include(luaFile)
end

local function LoadData(data)
    print("[IG] Loading data:", data)

    local luaFile = "data/sh_" .. data .. ".lua"
    if SERVER then AddCSLuaFile(luaFile) end
    include(luaFile);
end

LoadPlayerClass("imperial")
LoadPlayerClass("event")

LoadData("ranks")
LoadData("regiments")

LoadModule("spawn")
LoadModule("character")
LoadModule("chat")
LoadModule("name")
LoadModule("currency")
LoadModule("promotion")
LoadModule("hud")
LoadModule("event")
LoadModule("defcon")
LoadModule("day")
