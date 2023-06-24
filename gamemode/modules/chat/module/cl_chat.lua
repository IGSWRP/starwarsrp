----------------------------------|  Global Variables  |----------------------------------
-- local COLOURS = {}
-- COLOURS.WHITE = Color(255, 255, 255, 255)
-- COLOURS.SECURE = Color(225, 200, 0, 255)
-- COLOURS.OOC = Color(90, 35, 170)
-- COLOURS.ROLL = Color(80, 217, 201)
-- COLOURS.ORDERS = Color(63, 98, 196)
-- COLOURS.COMMS = Color(9, 232, 17)
-- COLOURS.ECOMMS = Color(255, 33, 33)
-- COLOURS.ME = Color(115, 115, 115)

-------------------------------------|  Networking  |------------------------------------

-----------------------------------------------------------------------------------------
-- Receives a net message to pretty print a message to a users chat.
-----------------------------------------------------------------------------------------
net.Receive("igGamemode_PrettyChatPrint", function () 
	local args = net.ReadTable()

	chat.AddText( unpack( args ) )
end)

----------------------------------|  Gamemode Hooks  |----------------------------------

-----------------------------------------------------------------------------------------
-- Overrides default gamemode logic for handling the recieving receiving and display of
-- chat messages.
-- Params:
--          ply:    	entity  -   The player who is sending the chat message
--          msg:        string  -   The message being sent
--          teamOnly:   boolean -   Was this message sent in team chat
--          isDead:		boolean	-   Is the player who sent the message dead?
-----------------------------------------------------------------------------------------
hook.Add("OnPlayerChat", "IgGamemode_ClientChatHookOverride", function(ply, msg, teamOnly, isDead)
	local textTable = string.Explode("::", msg)
	local commandText = textTable[1]
	local command = IG_CHAT_COMMANDS[commandText] or nil

	-- Display Team Chat
	if (teamOnly) then
		chat.AddText(
			IG_CHAT_COLOURS.SECURE, 
			"(SECURE COMMS) ", 
			ply:GetRegimentColour(), 
			ply:GetRankName(),
			" ", 
			ply:Nick(), 
			": ", 
			IG_CHAT_COLOURS.WHITE,
			msg
		)
		return true
	end

	if (command != nil) then
		if (string.Trim(textTable[2]) == "") then return true end -- No empty messages please
		chat.AddText(command.display(ply, textTable[2]))
		return true
	end

	-- Display normal messages
	chat.AddText(ply:GetRegimentColour(), ply:GetRankName(), " ", ply:Nick(), ": ", IG_CHAT_COLOURS.WHITE, msg)

	-- Suppress default gamemode chat display
	return true
end)
