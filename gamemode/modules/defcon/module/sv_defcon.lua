util.AddNetworkString( "IG_UpdateDefcon" )

local function UpdateClient( _, ply )
	net.Start( "IG_UpdateDefcon" )
	net.WriteUInt( IG_DEFCON, 3 )
	net.Send( ply )
end
net.Receive( "IG_UpdateDefcon", UpdateClient)

function UpdateDefcon( ply, level )
	if not ply:IsAdmin() then return end
	if not isnumber( level ) then return end
	if not ( level > 0 or level < 6 ) then return end
	-- TODO: Add regiment check

	IG_DEFCON = level
	UpdateClient( _, player.GetAll() )

	print( ply:Nick() .. " has changed the DEFCON level to: " .. level )
end