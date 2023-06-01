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