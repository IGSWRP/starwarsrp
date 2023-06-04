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

    local target = net.ReadEntity()

    if !target then
        print("recieved net message with non-existent player")
        return
    end

    if !ply:CanPromote(target) then
        print(ply:SteamID64(), "attempted to promote", target:SteamID64())
        return
    end

    if target:GetRegiment() == "RECRUIT" then
        local regiment = "ST"
        target:SetRegiment(regiment)
    else
        local rank = target:GetRank() + 1
        if !IG.Regiments[target:GetRegiment()].ranks[rank] then return end
        target:SetRank(rank)
    end

    player_manager.RunClass(target, "SaveCharacterData")
end)

util.AddNetworkString("DemotePlayer")

net.Receive("DemotePlayer", function(_, ply)
    if IG.Regiments[ply:GetRegiment()].ranks[ply:GetRank()].cl < 2 or ply:GetRegiment() == "RECRUIT" then return end

    local target = net.ReadEntity()

    if !target then
        print("recieved net message with non-existent player")
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
    else
        target:SetRank(rank)
    end

    player_manager.RunClass(target, "SaveCharacterData")

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
    local target = net.ReadEntity()
    local class = net.ReadString()

    if !target then
        print("recieved net message with non-existent player")
        return
    end

    if !ply:CanSetClass(target) then
        print(ply:SteamID64(), "attempted to set class of", target:SteamID64())
        return
    end

    local weapons_old = target:AvailableWeapons()

    target:SetRegimentClass(class)
    player_manager.RunClass(target, "SaveCharacterData")
    
    local weapons_new = target:AvailableWeapons()

    for i=1, #weapons_old do
        if !table.HasValue(weapons_new, weapons_old[i]) then
            target:StripWeapon(weapons_old[i])
        end
    end
end)

util.AddNetworkString("EditPlayer")

net.Receive("EditPlayer", function(_, ply)
    if !ply:IsAdmin() then return end

    local target = net.ReadEntity()
    local regiment = net.ReadString()
    local rank = net.ReadUInt(8)
    local class = net.ReadString()

    if !target then
        print("recieved net message with non-existent player")
        return
    end

    target:SetRegiment(regiment)
    target:SetRank(rank)
    target:SetRegimentClass(class)
    player_manager.RunClass(target, "SaveCharacterData")
end)