--[[

Billy's Keypad - Imperial Gaming Edit
    - Gives the player a keycard on spawn based on their rank

Known Issues

    - Line 58 of sh_keycard_inventory.lua causes KeycardData to be erased when a dropped keycard is picked up again
        bKeypads_Keycards_Registry[keycardID] = bKeypads.Keycards:GetKeycardData(ply)
        ^^^^ Comment out that line if it's not commented out
]]

if ( CLIENT ) then return end

--[[*
* Utility Functions
]]
util.AddNetworkString("hideyoshiKeycards.processClient")

local hideyoshi_giveKeycard = {}
local keycardCache = {}
for i, l in pairs(bKeypads.Keycards.Levels) do
    KeycardNames[l.Name] = keycardCache
end     

--[[*
* PLAYER META FUNCTION
*
* Prepares the creation of the keycard data & Prepares the client (registry) to receive the keycard
*
* @param {Entity} ply - Player Entity
* @param {Table} levels - Table of keycard levels
*
* @return {Void}
]]
local meta = FindMetaTable("Player")
function meta:giveKeycard(levels)
    local id = hideyoshi_giveKeycard:assignID()
    hideyoshi_giveKeycard:createData(self, levels, id)
    hideyoshi_giveKeycard:processKeycard(self, id)
end

--[[*
* Identifies what keycard(s) the player should have
* Based on HenDoge's AWR System & Regiment Data (F2 Menu)
*
* @param {Entity} ply - Player Entity
* @return {Void}
]]
function meta:giveDefaultKeycards()
    return timer.Create("hideyoshi_GiveKeycard/" .. self:SteamID64(), 0.2, 1, function()

        local reg = IG.Regiments[self:GetRegiment()]
        local keycards = reg.level_bonuses[self:GetRank()].keycards
        
        for k, keycardName in pairs(keycards) do
            local keycardId = keycardCache[keycardName]
            if(keycardId) then
                self:giveKeycard({keycardId})
            end
        end


    end)
end

--[[*
* Assigns a unique ID to the keycard
*
* @return {Integer} id - Keycard ID
]]
function hideyoshi_giveKeycard:assignID()
    bKeypads_Keycards_ID = bKeypads_Keycards_ID + 1
    local id = bKeypads_Keycards_ID
    return id
end

--[[*
* Creates keycard data and assigns it to the registry (id)
*
* @param {Entity} ply - Player Entity
* @param {Table} levels - Table of keycard levels
* @param {Integer} id - Keycard ID
*
* @return {Table} keycardData - Keycard Data
]]
function hideyoshi_giveKeycard:createData(ply, levels, id)
    if id == 0 then return end

    local keycardData = {
        Levels = {},
        LevelsDict = {},
        PrimaryLevel = 1,
    }

    keycardData.SteamID = ply:SteamID()
    keycardData.PlayerModel = ply:GetModel()
    keycardData.Team = ply:Team()
    keycardData.PlayerBind = ply:SteamID()
    keycardData.id = id
    keycardData.Levels = {}

    for _, level in ipairs(levels) do
        local level = tonumber(level)
        if not level then continue end
        table.insert(keycardData.Levels, level)
        keycardData.LevelsDict[level] = true
        keycardData.PrimaryLevel = math.max(keycardData.PrimaryLevel, level)
    end

    table.sort(keycardData.Levels)
    bKeypads_Keycards_Registry[id] = keycardData

    return keycardData
end

--[[*
* Assigns the keycard data to the player and gives them the keycard (Weapon)
*
* @param {Entity} ply - Player Entity
* @param {Integer} keycardID - Keycard ID
*
* @return {Void}
]]
function hideyoshi_giveKeycard:giveKeycard(ply, keycardID)
    assert(IsValid(ply), "[Hideyoshi Keycards] NULL player tried to pickup a keycard!")
    assert(keycardID ~= 0, "[Hideyoshi Keycards] Tried to pick up keycard with no ID!")

    if bKeypads.Keycards.Inventory.Cards[ply] and bKeypads.Keycards.Inventory.Cards[ply][keycardID] then return end
    bKeypads.Keycards.Inventory.Cards[ply] = bKeypads.Keycards.Inventory.Cards[ply] or {}
    bKeypads.Keycards.Inventory.Cards[ply][keycardID] = true

    net.Start("hideyoshiKeycards.processClient") -- Sends the keycard data to the client to be cached 
      --net.WriteEntity(ply)
      net.WriteUInt(keycardID, 32)
      net.WriteTable(bKeypads_Keycards_Registry[keycardID])
    net.Send(ply)

    if bKeypads.Keycards.Inventory.Cards[ply] and bKeypads.Keycards.Inventory.Cards[ply][keycardID] then
        local bkeycard = ply:GetWeapon("bkeycard")

        if not IsValid(bkeycard) then
            bkeycard = ply:Give("bkeycard")
            if IsValid(bkeycard) then
                bkeycard:SetWasPickedUp(true)
            end
        end

        if IsValid(bkeycard) then
            bkeycard:SetSelectedKeycard(keycardID)
        end
    end
end
