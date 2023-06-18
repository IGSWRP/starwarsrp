----------------------------------|  Global Variables  |----------------------------------
IG_CHAT_COMMANDS = {}                                   -- Table for all chat commands

IG_CHAT_COLOURS = {}                                    -- Table for chat command colours
IG_CHAT_COLOURS.WHITE = Color(255, 255, 255, 255)
IG_CHAT_COLOURS.SECURE = Color(225, 200, 0, 255)
IG_CHAT_COLOURS.OOC = Color(90, 35, 170)
IG_CHAT_COLOURS.ROLL = Color(80, 217, 201)
IG_CHAT_COLOURS.ORDERS = Color(63, 98, 196)
IG_CHAT_COLOURS.COMMS = Color(9, 232, 17)
IG_CHAT_COLOURS.ECOMMS = Color(255, 33, 33)
IG_CHAT_COLOURS.ME = Color(115, 115, 115)
IG_CHAT_COLOURS.BRACKET = Color(0, 0, 0, 255)

-----------------------------------------------------------------------------------------
-- Function to create a chat command. This just makes things easier in terms of setup
-- and is not actually intended to be used externally.
-- Params:
--          command:            string              -   The string the player types
--
--          accessCondition     function|string     -   A boolean expression to determine
--                                                      who can run the chat command. Set
--                                                      this to be a string if you want
--                                                      you chat command to piggy back 
--                                                      off an existing chat command.
--                                                      E.g. '//' being the same as '/ooc'
--
--          isProximity         boolean             -   True to make the result of the
--                                                      command to display only to those
--                                                      in proximity to the sending user
--
--          data                function|string     -   The content to be displayed
--
--          display             function            -   The string to be displayed in the
--                                                      players chat window
-----------------------------------------------------------------------------------------
local function createChatCommand (command, accessCondition, isProximity, data, display)
    -- Make this command be the same as the command we've been given for the access
    -- string. This is so we don't need to define the same command twice for commands
    -- like '//' and '/ooc'
    if isstring(accessCondition) then
        IG_CHAT_COMMANDS[command] = IG_CHAT_COMMANDS[accessCondition]
        return
    end

    -- Add our new chat command to the commands table
    IG_CHAT_COMMANDS[command] = {
        accessCondition = accessCondition,
        isProximity = isProximity,
        data = data,
        display = display
    }
end

-----------------------------------------------------------------------------------------
-- Function to remove prefixes from a given message. E.g. remove '/me' from the message
-- '/me does something'
--          txt:                string   -   The string the player types
--
--          accessCondition     table   -   A table of prefixes to remove. CAUTION: This
--                                          needs to be in the form of {prefix = true}
--                                          or it will error out.
-----------------------------------------------------------------------------------------
local function removeMessagePrefix (txt, prefixTable)
    local textTable = string.Explode(" ", txt)

    if (prefixTable[textTable[1]]) then table.remove(textTable, 1) end
    return table.concat(textTable, " ")
end

-----------------------------------|  Chat Commands  |----------------------------------
-- All chat commands should be defined here. If you put them anywhere else I will find
-- you and yell at you for being a dissapointment -HenDoge

-----------------------------------------------------------------------------------------
-- Functions for /setname command.
-----------------------------------------------------------------------------------------
createChatCommand(
    "/setname",
    function (ply) return true end,
    false,
    function (ply, msg)
        local textTable = string.Explode(" ", msg)

        if (textTable[2] == "" or textTable[2] == nil) then
            ply:PrettyChatPrint("GAMEMODE", "Invalid name given.")
            return ""
        end

        local nameStr = table.concat(textTable, " ", 2, #textTable)
        if string.match(nameStr, "[a-z]") == nil then
            ply:PrettyChatPrint("GAMEMODE", "Invalid name given.")
            return "" 
        end

        if string.len(nameStr) < 2 then
            ply:PrettyChatPrint("GAMEMODE", "That name is too short")
            return ""
        elseif string.len(nameStr) > 32 then
            ply:PrettyChatPrint("GAMEMODE", "That name is too long")
            return ""
        end

        ply:SetPlayerName(nameStr)
        ply:PrettyChatPrint("GAMEMODE", "Set name to " .. nameStr)

        return ""
    end,
    function (ply, txt)
        return ""
    end
)

createChatCommand(
    "!setname",
    "/setname"
)

-----------------------------------------------------------------------------------------
-- Functions for /roll command
-----------------------------------------------------------------------------------------
createChatCommand(
    "/roll",
    function (ply) return true end,
    true,
    function (ply, msg) return math.random(100) end,
    function (ply, txt)
        return unpack({
            IG_CHAT_COLOURS.BRACKET,
            "(",
            IG_CHAT_COLOURS.ROLL,
            "ROLL",
            IG_CHAT_COLOURS.BRACKET,
            ") ",
            IG_CHAT_COLOURS.WHITE,
            ply:GetRankName(),
            " ",
            ply:Nick(),
            " has rolled ",
            txt,
            "."
        })
    end
)

createChatCommand(
    "!roll",
    "/roll"
)

-----------------------------------------------------------------------------------------
-- Functions for /ooc command
-----------------------------------------------------------------------------------------
createChatCommand(
    "/ooc",
    function (ply) return true end,
    false,
    function (ply, msg)
        -- Prefixes for the command to remove
        local prefixes = {
            ["//"] =  true,
            ["/ooc"] = true,
            ["!ooc"] = true 
        }

        return removeMessagePrefix(msg, prefixes)
    end,
    function (ply, txt)
        return unpack({
            IG_CHAT_COLOURS.BRACKET,
            "(",
            IG_CHAT_COLOURS.OOC,
            "OOC",
            IG_CHAT_COLOURS.BRACKET,
            ") ",
            ply:GetRegimentColour(),
            ply:GetRankName(),
            " ",
            ply:Nick(),
            ": ",
            IG_CHAT_COLOURS.WHITE,
            txt
        })
    end
)

createChatCommand(
    "!ooc",
    "/ooc"
)

createChatCommand(
    "//",
    "/ooc"
)

-----------------------------------------------------------------------------------------
-- Functions for /looc command
-----------------------------------------------------------------------------------------
createChatCommand(
    "/looc",
    function (ply) return true end,
    true,
    function (ply, msg)
        -- Prefixes for the command to remove
        local prefixes = {
            ["!looc"] =  true,
            ["/looc"] = true
        }

        return removeMessagePrefix(msg, prefixes)
    end,
    function (ply, txt)
        return unpack({
            IG_CHAT_COLOURS.BRACKET,
            "(",
            IG_CHAT_COLOURS.OOC,
            "LOOC",
            IG_CHAT_COLOURS.BRACKET,
            ") ",
            ply:GetRegimentColour(),
            ply:GetRankName(),
            " ",
            ply:Nick(),
            ": ",
            IG_CHAT_COLOURS.WHITE,
            txt
        })
    end
)

createChatCommand(
    "!looc",
    "/looc"
)

-----------------------------------------------------------------------------------------
-- Functions for /me command
-----------------------------------------------------------------------------------------
createChatCommand(
    "/me",
    function (ply) return true end,
    true,
    function (ply, msg)
        -- Prefixes for the command to remove
        local prefixes = {
            ["/me"] =  true,
        }

        return removeMessagePrefix(msg, prefixes)
    end,
    function (ply, txt)
        return unpack({
            IG_CHAT_COLOURS.ME,
            ply:GetRankName(),
            " ",
            ply:Nick(),
            " ",
            txt
        })
    end
)

createChatCommand(
    "!me",
    "/me"
)

-----------------------------------------------------------------------------------------
-- Functions for /comms command
-----------------------------------------------------------------------------------------
createChatCommand(
    "/comms",
    function (ply) return true end,
    false,
    function (ply, msg)
        -- Prefixes for the command to remove
        local prefixes = {
            ["!comms"] =  true,
            ["/comms"] = true,
        }

        return removeMessagePrefix(msg, prefixes)
    end,
    function (ply, txt)
        return unpack({
            IG_CHAT_COLOURS.BRACKET,
            "(",
            IG_CHAT_COLOURS.COMMS,
            "COMMS",
            IG_CHAT_COLOURS.BRACKET,
            ") ",
            ply:GetRegimentColour(),
            ply:GetRankName(),
            " ",
            ply:Nick(),
            ": ",
            IG_CHAT_COLOURS.WHITE,
            txt
        })
    end
)

createChatCommand(
    "!comms",
    "/comms"
)

-----------------------------------------------------------------------------------------
-- Functions for /ocomms command
-----------------------------------------------------------------------------------------
createChatCommand(
    "/ocomms",
    function (ply) 
        return ply:IsAdmin() or ply:GetRegiment() == "IHC"
    end,
    false,
    function (ply, msg)
        -- Prefixes for the command to remove
        local prefixes = {
            ["/ocomms"] =  true,
        }

        return removeMessagePrefix(msg, prefixes)
    end,
    function (ply, txt)
        return unpack({
            IG_CHAT_COLOURS.BRACKET,
            "(",
            IG_CHAT_COLOURS.ORDERS,
            "ORDERS",
            IG_CHAT_COLOURS.BRACKET,
            ") ",
            ply:GetRegimentColour(),
            ply:GetRankName(),
            " ",
            ply:Nick(),
            ": ",
            IG_CHAT_COLOURS.WHITE,
            txt
        })
    end
)

createChatCommand(
    "!ocomms",
    "/ocomms"
)