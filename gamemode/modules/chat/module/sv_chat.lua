----------------------------------|  Global Variables  |----------------------------------
local CHAT_COMMANDS = {}                        -- The table of chat commands
local PROXIMITY_DISTANCE_THRESHOLD = 302500     -- The cutoff distance for prox. txt chat
local SECURE_CHANNELS = {}                      -- Table of channels for secure comms

----------------------------------|  Network Strings  |----------------------------------
util.AddNetworkString("igGamemode_PrettyChatPrint")


-----------------------------------|  Meta Functions  |----------------------------------
local plyMeta = FindMetaTable("Player")

-----------------------------------------------------------------------------------------
-- Adds a message to a players chat box with a given title and message body. Essentially
-- just a nicer version of ply:ChatPrint()
-- Params:
--          title:      string  -   The title of the message
--          message:    string  -   The message body
-----------------------------------------------------------------------------------------
function plyMeta:PrettyChatPrint (title, message)
    net.Start("igGamemode_PrettyChatPrint")
    net.WriteString(title)
    net.WriteString(message)
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
-- Function to create a chat command. This just makes things easier in terms of setup
-- and is not actually intended to be used externally.
-- Params:
--          command:            string              -   The string the player types
--
--          accessCondition     function|string     -   A boolean expression to determine
--                                                      who can see the result of the cmd.
--                                                      Set this to be a string if you
--                                                      want you chat command to piggy 
--                                                      back off an existing chat command.
--                                                      E.g. '//' being the same as '/ooc'
--
--          isProximity         boolean             -   True to make the result of the
--                                                      command to display only to those
--                                                      in proximity to the sending user
--
--          data                function|string     -   The content to be displayed
-----------------------------------------------------------------------------------------
local function createChatCommand (command, accessCondition, isProximity, data)
    -- Make this command be the same as the command we've been given for the access
    -- string. This is so we don't need to define the same command twice for commands
    -- like '//' and '/ooc'
    if isstring(accessCondition) then
        CHAT_COMMANDS[command] = CHAT_COMMANDS[accessCondition]
        return
    end

    -- Add our new chat command to the commands table
    CHAT_COMMANDS[command] = {
        accessCondition = accessCondition,
        isProximity = isProximity,
        data = data
    }
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

    -- Handle team chat
    if (teamOnly && areInSameSecureChannel(speaker, listener)) then return true end

    -- TODO:    - Add logic for proximity chat
    --          - Add chat commands
end



-----------------------------------------------------------------------------------------
setup()