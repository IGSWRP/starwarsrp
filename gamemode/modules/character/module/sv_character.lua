IG.SelectedCharacters = IG.SelectedCharacters or {}

local meta = FindMetaTable("Player")

if !sql.TableExists("character_data") then
    print("Creating character_data table")
    sql.Query( "CREATE TABLE IF NOT EXISTS character_data (steamid TEXT NOT NULL, slot INTEGER NOT NULL, name TEXT, regiment TEXT, class TEXT, rank INTEGER, PRIMARY KEY (steamid, slot))" )
end

function meta:GetCharacterData(slot)
    local result = sql.Query(string.format("SELECT * FROM character_data WHERE steamid = \"%s\" AND slot = %i LIMIT 1", self:SteamID64(), slot))
    return result and result[1] or {}
end

function meta:SetCharacterData(slot, name, regiment, class, rank)
    return sql.Query(string.format("REPLACE INTO character_data ( steamid, slot, name, regiment, class, rank) VALUES (%s, %i, %s, %s, %s, %i)", sql.SQLStr(self:SteamID64()), slot, sql.SQLStr(name), sql.SQLStr(regiment), sql.SQLStr(class), rank)) ~= false
end

function meta:GetSelectedCharacter()
    return IG.SelectedCharacters[self:SteamID64()] or 1
end

function meta:SetSelectedCharacter(slot)
    IG.SelectedCharacters[self:SteamID64()] = slot
end

-- Open F2 Menu
function GM:ShowTeam(ply)
    ply:ConCommand("promotion_menu")
end

util.AddNetworkString("PromotePlayer")

net.Receive("PromotePlayer", function(_, ply)
    if IG.Regiments[ply:GetRegiment()].ranks[ply:GetRank()].cl < 2 then return end

    local steamid = net.ReadString()
    local target = player.GetBySteamID64(steamid)

    if target:GetRegiment() == "RECRUIT" then
        local rank = 1
        local regiment = "ST"
        ply:SetRegiment(regiment)
        ply:SetCharacterData(1, ply:GetName(), regiment, "", rank)
        player_manager.RunClass(ply, "SetModel")
    elseif ply:GetRegiment() == target:GetRegiment() and ply:GetRank() > target:GetRank() then
        local rank = ply:GetRank() + 1
        ply:SetRank(rank)
        if IG.Regiments[ply:GetRegiment()].ranks[rank] then
            ply:SetCharacterData(1, ply:GetName(), ply:GetRegiment(), ply:GetRegimentClass(), rank)
            player_manager.RunClass(ply, "SetModel")
        end
    end
end)

util.AddNetworkString("DemotePlayer")

net.Receive("DemotePlayer", function(_, ply)
    if IG.Regiments[ply:GetRegiment()].ranks[ply:GetRank()].cl < 2 or ply:GetRegiment() == "RECRUIT" then return end

    local steamid = net.ReadString()
    local target = player.GetBySteamID64(steamid)

    if ply:GetRegiment() == target:GetRegiment() and ply:GetRank() > target:GetRank() then
        local weapons_old = target:AvailableWeapons()
        local rank = ply:GetRank() - 1
        if rank == 0 then
            -- get set back to recruit bitch
            local rank = 1
            local regiment = "RECRUIT"
            local class = ""
            ply:SetRank(rank)
            ply:SetRegiment(regiment)
            ply:SetRegimentClass(class)
            ply:SetCharacterData(1, ply:GetName(), regiment, class, rank)
            player_manager.RunClass(ply, "SetModel")
        else
            ply:SetRank(rank)
            ply:SetCharacterData(1, ply:GetName(), ply:GetRegiment(), ply:GetRegimentClass(), rank)
            -- They could lose a model they previously had access to, so running this
            player_manager.RunClass(ply, "SetModel")
        end

        -- Get rid of any weapons they shouldn't have access to anymore
        local weapons_new = target:AvailableWeapons()
        for i=1, #weapons_old do
            if !table.HasValue(weapons_new, weapons_old[i]) then
                target:StripWeapon(weapons_old[i])
            end
        end
    end
end)