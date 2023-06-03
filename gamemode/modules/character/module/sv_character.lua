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

    if !target then
        print("no user with steamid", steamid)
        return
    end

    if !ply:CanPromote(target) then
        print(ply:SteamID64(), "attempted to promote", target:SteamID64())
        return
    end

    if target:GetRegiment() == "RECRUIT" then
        local rank = 1
        local regiment = "ST"
        target:SetRegiment(regiment)
        target:SetCharacterData(1, target:GetName(), regiment, "", rank)
        player_manager.RunClass(target, "SetModel")
    else
        local rank = target:GetRank() + 1
        target:SetRank(rank)
        if IG.Regiments[target:GetRegiment()].ranks[rank] then
            target:SetCharacterData(1, target:GetName(), target:GetRegiment(), target:GetRegimentClass(), rank)
            player_manager.RunClass(target, "SetModel")
        end
    end
end)

util.AddNetworkString("DemotePlayer")

net.Receive("DemotePlayer", function(_, ply)
    if IG.Regiments[ply:GetRegiment()].ranks[ply:GetRank()].cl < 2 or ply:GetRegiment() == "RECRUIT" then return end

    local steamid = net.ReadString()
    local target = player.GetBySteamID64(steamid)

    if !target then
        print("no user with steamid", steamid)
        return
    end

    if !ply:CanDemote(target) then
        print(ply:SteamID64(), "attempted to demote", target:SteamID64())
        return
    end

    local weapons_old = target:AvailableWeapons()
    local rank = target:GetRank() - 1
    if rank == 0 then -- set to recruit if they're the minimum rank
        local rank = 1
        local regiment = "RECRUIT"
        local class = ""
        target:SetRank(rank)
        target:SetRegiment(regiment)
        target:SetRegimentClass(class)
        target:SetCharacterData(1, target:GetName(), regiment, class, rank)
        player_manager.RunClass(target, "SetModel")
    else
        target:SetRank(rank)
        target:SetCharacterData(1, target:GetName(), target:GetRegiment(), target:GetRegimentClass(), rank)
        -- They could lose a model they previously had access to, so running this
        player_manager.RunClass(target, "SetModel")
    end

    -- Get rid of any weapons they shouldn't have access to anymore
    local weapons_new = target:AvailableWeapons()
    for i=1, #weapons_old do
        if !table.HasValue(weapons_new, weapons_old[i]) then
            target:StripWeapon(weapons_old[i])
        end
    end
end)

util.AddNetworkString("SetPlayersClass")

net.Receive("SetPlayersClass", function(_, ply)
    local steamid = net.ReadString()
    local class = net.ReadString()

    local target = player.GetBySteamID64(steamid)

    if !target then
        print("no user with steamid", steamid)
        return
    end

    if !ply:CanSetClass(target) then
        print(ply:SteamID64(), "attempted to set class of", target:SteamID64())
        return
    end

    local weapons_old = target:AvailableWeapons()

    target:SetRegimentClass(class)
    print(target:GetRegimentClass())
    target:SetCharacterData(1, target:GetName(), target:GetRegiment(), class, target:GetRank())
    player_manager.RunClass(target, "SetModel")
    
    local weapons_new = target:AvailableWeapons()

    for i=1, #weapons_old do
        if !table.HasValue(weapons_new, weapons_old[i]) then
            target:StripWeapon(weapons_old[i])
        end
    end
end)