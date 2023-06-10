-- one central initpostentity hook to prevent duplicates
local function ReadyNetworking()
	-- currency module
	net.Start( "IG_UpdateCurrency" )
	net.SendToServer()
end
hook.Add( "InitPostEntity", "ReadyNetworking", ReadyNetworking)