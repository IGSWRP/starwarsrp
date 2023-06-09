----------------------------------|  Global Variables  |----------------------------------
local COLOURS = {}
COLOURS.WHITE = Color(255, 255, 255, 255)
COLOURS.SECURE = Color(225, 200, 0, 255)
COLOURS.OOC = Color(90, 35, 170)
COLOURS.ROLL = Color(80, 217, 201)
COLOURS.ORDERS = Color(63, 98, 196)
COLOURS.COMMS = Color(9, 232, 17)
COLOURS.ECOMMS = Color(255, 33, 33)
COLOURS.ME = Color(115, 115, 115)

-------------------------------------|  Networking  |------------------------------------

-----------------------------------------------------------------------------------------
-- Receives a net message to pretty print a message to a users chat.
-----------------------------------------------------------------------------------------
net.Receive("igGamemode_PrettyChatPrint", function () 
	local COLOURS = {}
	COLOURS.BRACKET = Color(0, 0, 0, 255)
	COLOURS.GM = Color(106, 6, 142, 255)
	COLOURS.WHITE = Color(255, 255, 255, 255)

    local title = net.ReadString()
	local message = net.ReadString()

	chat.AddText(
		COLOURS.BRACKET,
		"[", 
		COLOURS.GM, 
		title, 
		COLOURS.BRACKET, 
		"] ", 
		COLOURS.WHITE, 
		message
	)
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
hook.Add("OnPlayerChat", "egm_ClientChat", function(ply, msg, teamOnly, isDead)
	-- Display Team Chat
	if (teamOnly) then
		chat.AddText(
			COLOURS.SECURE, 
			"(SECURE COMMS) ", 
			ply:GetRegimentColour(), 
			ply:GetRankName(), 
			" ", 
			ply:Nick(), 
			": ", 
			COLOURS.WHITE,
			msg
		)
		return true
	end


	-- Display normal messages
	chat.AddText(ply:GetRegimentColour(), ply:GetRankName(), " ", ply:Nick(), ": ", COLOURS.WHITE, msg)

	-- Suppress default gamemode chat display
	return true
end)
