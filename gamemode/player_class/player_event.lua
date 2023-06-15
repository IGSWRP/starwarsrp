DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.SlowWalkSpeed = 100
PLAYER.WalkSpeed = 160
PLAYER.RunSpeed = 240
PLAYER.JumpPower = 160

function PLAYER:SaveCharacterData() return end -- noop

function PLAYER:ShowTeam()
    self.Player:ConCommand("event_menu")
end

function PLAYER:Spawn()
    local ply = self.Player

    if IG.EventPresetSpawns[ply:GetEventPreset()] then
        ply:SetPos(IG.EventPresetSpawns[ply:GetEventPreset()])
    else
        local regimental_spawn = IG.Spawns[ply:GetRegiment()]
        if regimental_spawn then
            ply:SetPos(regimental_spawn)
        end
    end

    if IG.EventPresets[ply:GetEventPreset()] then
        ply:SetHealth(IG.EventPresets[ply:GetEventPreset()].health)
        ply:SetMaxHealth(IG.EventPresets[ply:GetEventPreset()].health)    
    end
end

function PLAYER:SetModel()
    local ply = self.Player

    local current_model = ply:GetModel()
    local valid_models = (IG.EventPresets[ply:GetEventPreset()] or {}).models or IG.Regiments[ply:GetRegiment()].models

    if !table.HasValue(valid_models, current_model) then
        ply:SetModel(valid_models[math.random(1, #valid_models)])
        ply:SetupHands()
        -- TODO: send net message to client for bodyworks to handle
    end
end

function PLAYER:Loadout()
    local ply = self.Player

    ply:Give("none")

    if not IG.EventPresets[ply:GetEventPreset()] then return end

    local weps = IG.EventPresets[ply:GetEventPreset()].weapons
    for i=1, #weps do
        ply:Give(weps[i])
    end
end

function PLAYER:SetupDataTables()
    local ply = self.Player

    ply:NetworkVar("String", 0, "RPName")
    ply:NetworkVar("String", 3, "EventPreset")

    -- We don't need to network these as they'll always be the same
    function ply:GetRegiment() return "EVENT" end
    function ply:GetRank() return 1 end
    function ply:GetRegimentClass() return "" end
end

player_manager.RegisterClass("player_event", PLAYER, "player_default")