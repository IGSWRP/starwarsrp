--[[
 
Billy's Keypad - Imperial Gaming Edit
    - Caches the keycard data for the client

]]--

if ( SERVER ) then return end

local function keycards_cache(len, ply)
    --local ply = net.ReadEntity()
    local keycardID = net.ReadUInt(32)
    local keycardDataTable = net.ReadTable()

    bKeypads_Keycards_Registry[keycardID] = keycardDataTable

    if !(IsValid(ply)) then return end

    assert(IsValid(ply), "[Hideyoshi Keycards] NULL player tried to pickup a keycard!")
    assert(keycardID ~= 0, "[Hideyoshi Keycards] Tried to pick up keycard with no ID!")

    if bKeypads.Keycards.Inventory.Cards[ply] and bKeypads.Keycards.Inventory.Cards[ply][keycardID] then return end
    bKeypads.Keycards.Inventory.Cards[ply] = bKeypads.Keycards.Inventory.Cards[ply] or {}
    bKeypads.Keycards.Inventory.Cards[ply][keycardID] = true

    if IsValid(bKeypads_Keycard_Inventory) then
        bKeypads_Keycard_Inventory.keycardsContainer:Populate()
    end

end 
net.Receive("hideyoshiKeycards.processClient", keycards_cache)