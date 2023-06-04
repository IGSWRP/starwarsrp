DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

function PLAYER:Spawn()
    local ply = self.Player
    ply:SetMaxHealth(ply:MaxHealth())
    ply:SetHealth(ply:MaxHealth())
end

-- gives players all their available weapons
function PLAYER:Loadout()
    local ply = self.Player

    local weps = ply:AvailableWeapons()
    for i=1, #weps do
        ply:Give(weps[i])
    end

end

-- checks their model against the regiment table and sets their model if it's not in the list
function PLAYER:SetModel()
    local ply = self.Player

    local current_model = ply:GetModel()
    local valid_models = ply:AvailableModels()

    if !table.HasValue(valid_models, current_model) then
        ply:SetModel(valid_models[1])
        -- TODO: send net message to client for bodyworks to handle
    end
end

function PLAYER:SaveCharacterData()
    local ply = self.Player
    ply:SetCharacterData(1, ply:GetName(), ply:GetRegiment(), ply:GetRegimentClass(), ply:GetRank())

    ply:SetMaxHealth(ply:MaxHealth())
    self:SetModel()
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
        local data = ply:GetCharacterData(1)
        ply:SetRPName(data.name or ply:Nick())
        ply:SetRegiment(data.regiment or "RECRUIT")
        ply:SetRegimentClass(data.class or "")
        ply:SetRank(data.rank or 1)
    end
end

player_manager.RegisterClass("player_imperial", PLAYER, "player_default")