----------------------------------|  Global Variables  |----------------------------------
local PROXIMITY_DISTANCE_THRESHOLD = 302500     -- The cutoff distance for prox. txt chat
local SECURE_CHANNELS = {}                      -- Table of channels for secure comms
IG_IG_CHAT_COMMANDS = IG_IG_CHAT_COMMANDS or {} -- DO NOT TOUCH THIS.

----------------------------------|  Network Strings  |----------------------------------
util.AddNetworkString("igGamemode_PrettyChatPrint")


-----------------------------------|  Meta Functions  |----------------------------------
local plyMeta = FindMetaTable("Player")

-----------------------------------------------------------------------------------------
-- Adds a message to a players chat box with a given title and message body. Essentially
-- just a nicer version of ply:ChatPrint()
-- Params:
--          message:    table  -   The message body
-----------------------------------------------------------------------------------------
function plyMeta:PrettyChatPrint (message)
    net.Start("igGamemode_PrettyChatPrint")
    net.WriteTable(message)
    net.Send(self)
end


-------------------------------------|  Functions  |-------------------------------------

-----------------------------------------------------------------------------------------
-- Function to populate a loop through the IG Regiments table on module load and populate
-- the SECURE_CHANNELS table.
-----------------------------------------------------------------------------------------
local function populateSecureChannels ()
    for k, v in pairs(IG.Regiments) do
        SECURE_CHANNELS[v.name] = v.channel or v.name
    end

    PrintTable(SECURE_CHANNELS)
end

-----------------------------------------------------------------------------------------
-- Function to check if a player is within proximity chat distance to another player.
-- Uses DistToSqr because it's faster.
-- Params:
--          speaker:    entity  -   The player who is sending the chat message
--          listener:   entity  -   The player to check if they're within prox. range.
-----------------------------------------------------------------------------------------
local function isInProximityRange (speaker, listener)
    return listener:GetPos():DistToSqr(speaker:GetPos()) < PROXIMITY_DISTANCE_THRESHOLD
end

-----------------------------------------------------------------------------------------
-- Function to check if two players are in the same Secure Comms Channel.
-- Params:
--          speaker:    entity  -   The player who is sending the chat message
--          listener:   entity  -   The player to check if they're in the same channel
-----------------------------------------------------------------------------------------
local function areInSameSecureChannel (spkr, lstnr)
    return SECURE_CHANNELS[spkr:GetRegiment()] == SECURE_CHANNELS[lstnr:GetRegiment()]
end

-----------------------------------------------------------------------------------------
-- Function to run initial module setup code.
-----------------------------------------------------------------------------------------
local function setup ()
    populateSecureChannels()
end

---------------------------------|  Gamemode Functions  |--------------------------------

-----------------------------------------------------------------------------------------
-- Overrides default gamemode logic for determining which players can see each others
-- messages.
-- Params:
--          txt:        string  -   The message being sent
--          teamOnly:   boolean -   Was this message sent in team chat
--          listener:   entity  -   The player to check if they're in the same channel
--          speaker:    entity  -   The player who is sending the chat message
-----------------------------------------------------------------------------------------
function GM:PlayerCanSeePlayersChat (txt, teamOnly, listener, speaker)
    -- Sanity check to make sure we're dealing with valid players
    if !(IsValid(listener) && IsValid(speaker)) then return false end

    local textTable = string.Explode(" ", txt)
    local command = textTable[1]

    -- Handle team chat
    if (teamOnly && areInSameSecureChannel(speaker, listener)) then return true end


    -- If the messgae sent was a command, show it to the player if it's either not a
    -- proximity message, or the listener is in proximity range.
    if (
        IG_CHAT_COMMANDS[command] &&
        (!IG_CHAT_COMMANDS[command].isProximity() || isInProximityRange(speaker, listener))
    ) then
        return true
    end


    -- Default to sending a proximity chat message
    return isInProximityRange(speaker, listener) 
end

-----------------------------------------------------------------------------------------
-- Overrides the default gamemode chat hook
-----------------------------------------------------------------------------------------
hook.Add("PlayerSay", "IgGamemode_ChatHookOverride", function(ply, txt)
    local textTable = string.Explode(" ", txt)
    local commandText = textTable[1]
    local command = IG_CHAT_COMMANDS[commandText] or nil

    -- If it's a chat command, append the chat command to the start of the message and
    -- send it to the client for display.
    if (command != nil && command.accessCondition(ply)) then
        return commandText .. "::" .. command.data(ply, txt)
    end

end)

-----------------------------------------------------------------------------------------
setup()