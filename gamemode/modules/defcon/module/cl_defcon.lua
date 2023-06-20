function ReceiveDefcon()
	local defcon = net.ReadUInt( 3 )
	local defconColour = IG_DEFCON_SH.COLOURS[defcon]
	local defconRoman = IG_DEFCON_SH.ROMAN[defcon]

	IG_DEFCON = defcon

	chat.AddText( color_white, "[", defconColour, "DEFCON", color_white, "] The current DEFCON level has been changed to: ", defconColour, "DEFCON ", defconRoman, color_white, ".")

	surface.PlaySound( "mellowcholy/gamemode/defcon.ogg" )
end
net.Receive( "IG_UpdateDefcon", ReceiveDefcon )