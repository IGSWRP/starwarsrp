-- one central initpostentity hook to prevent duplicates
local function ReadyNetworking()
	-- currency module
	net.Start( "IG_UpdateCurrency" )
	net.SendToServer()

	net.Start( "IG_LoginMenu" )
	net.SendToServer()

	-- defcon module
	net.Start( "IG_UpdateDefcon" )
	net.SendToServer()
end
hook.Add( "InitPostEntity", "ReadyNetworking", ReadyNetworking )