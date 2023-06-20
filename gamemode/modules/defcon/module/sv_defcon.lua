util.AddNetworkString( "IG_UpdateDefcon" )

local function UpdateClient( _, ply )
	net.Start( "IG_UpdateDefcon" )
	net.WriteUInt( IG_DEFCON, 3 )
	net.Send( ply )
end
net.Receive( "IG_UpdateDefcon", UpdateClient)

function UpdateDefcon( ply, level )
	if not ply:IsAdmin() or not ply:HasFlag("defcon") then return end
	if not isnumber( level ) then return end
	if not ( level > 0 or level < 6 ) then return end

	IG_DEFCON = level
	UpdateClient( _, player.GetAll() )

	print( ply:Nick() .. " has changed the DEFCON level to: " .. level )
end