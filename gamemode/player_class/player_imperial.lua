DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.SlowWalkSpeed = 100
PLAYER.WalkSpeed = 160
PLAYER.RunSpeed = 240
PLAYER.JumpPower = 160

function PLAYER:Spawn()
    local ply = self.Player

    local regimental_spawn = IG.Spawns[ply:GetRegiment()]
    if regimental_spawn then
        ply:SetPos(regimental_spawn)
    end

    ply:SetMaxHealth(ply:MaxHealth())
    ply:SetHealth(ply:MaxHealth())
end

-- gives players all their available weapons
function PLAYER:Loadout()
    local ply = self.Player

    ply:Give("none")

    local weps = ply:AvailableWeapons()
    for i=1, #weps do
        ply:Give(weps[i])
    end

end

function PLAYER:GetModels()
    return self.Player:AvailableModels()
end

-- checks their model against the regiment table and sets their model if it's not in the list
function PLAYER:SetModel()
    local ply = self.Player

    local current_model = ply:GetModel()
    local valid_models = ply:AvailableModels()

    if !table.HasValue(valid_models, current_model) then
        ply:SetModel(valid_models[1])
        ply:SetupHands()

        net.Start("bodyworks_load")
        net.Send(ply)
    end
end

function PLAYER:GetHandsModel()
	local playermodel = player_manager.TranslateToPlayerModelName( self.Player:GetModel() )
	local info = player_manager.TranslatePlayerHands( playermodel )
    if info and info.model ~= "models/weapons/c_arms_citizen.mdl" then
        return info
    end

    return { model = "models/ig_hands/tk/tk_hands.mdl", skin = 0, body = "0000000" }
end

function PLAYER:SaveCharacterData()
    local ply = self.Player
    ply:SetCharacterData(ply:GetSelectedCharacter(), ply:GetName(), ply:GetRegiment(), ply:GetRegimentClass(), ply:GetRank())

    ply:SetMaxHealth(ply:MaxHealth())
    self:SetModel()
end

function PLAYER:ShowTeam()
    self.Player:ConCommand("promotion_menu")
end

-- sets all the network variables for both the client and server to use
-- initialises the network variables with the detault character's data from the database
-- if the player has no data, then it defaults to recruit
function PLAYER:SetupDataTables()
    local ply = self.Player

    ply:NetworkVar("String", 0, "RPName")
    ply:NetworkVar("String", 1, "Regiment")
    ply:NetworkVar("String", 2, "RegimentClass")
    ply:NetworkVar("Int", 0, "Rank")

    if SERVER then
        print("Retrieving player data for " .. ply:SteamID64())
        local data = ply:GetCharacterData(ply:GetSelectedCharacter())
        ply:SetRPName(data.name or "TK-" .. math.random(1000, 9999))
        ply:SetRegiment(data.regiment or "RECRUIT")
        ply:SetRegimentClass(data.class or "")
        ply:SetRank(data.rank or 1)
    end
end

player_manager.RegisterClass("player_imperial", PLAYER, "player_default")
