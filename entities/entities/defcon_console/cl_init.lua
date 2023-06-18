include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

surface.CreateFont( "mellow_defcon_banner", {
	font = "Roboto Condensed",
	size = 20,
	weight = 800
})

surface.CreateFont( "mellow_defcon_aurebesh", {
	font = "Aurebesh",
	size = 8,
	weight = 800
})

surface.CreateFont( "mellow_defcon_subtext", {
	font = "Roboto Condensed",
	size = 13,
	weight = 800
})

surface.CreateFont( "mellow_defcon_mini", {
	font = "Roboto Condensed",
	size = 8,
	weight = 1000
})

STATE = STATE or 0
/*
	0 - Not logged in
	1 - Logged in
	2 - Access denied
*/

local selected_defcon = IG_DEFCON

function ENT:Initialize()
	STATE = 0
	selected_defcon = IG_DEFCON
end

local COLOUR = {
	back = Color( 24, 28, 27 )
}

local flashing_val = 0
local flashing_col = color_black

local transition = 0

function ENT:DrawTranslucent()
	local ply = LocalPlayer()
	local rank = ply:GetRankName() or "Crewman"

	self:DrawModel()

	flashing_val = flashing_val + 1.5 * RealFrameTime()
	if flashing_val > 2 then flashing_val = 0 end

	if flashing_val <= 1 then flashing_col = color_black else flashing_col = color_transparent end

	-- SCREEN DISPLAY
	if mellowcholy.imgui.Entity3D2D( self, Vector( -0.1, -25, 50 ), Angle( 0, 90, 62 ), 0.1, 500, 100 ) then

		if STATE == 0 then
			-- login banner
			surface.SetDrawColor( color_white )
			surface.DrawRect( 280, 70, 120, 50 )

			surface.SetTextColor( color_black )
			surface.SetTextPos( 284, 70 )
			surface.SetFont( "mellow_defcon_banner" )
			surface.DrawText( "DEFCON-TRML" )

			surface.SetTextColor( color_black )
			surface.SetTextPos( 285, 88 )
			surface.SetFont( "mellow_defcon_aurebesh" )
			surface.DrawText( "mellow" )

			surface.SetTextColor( flashing_col )
			surface.SetTextPos( 300, 105 )
			surface.SetFont( "mellow_defcon_subtext" )
			surface.DrawText( "PLEASE LOGIN" )

			-- side monitor display
			surface.SetTextColor( color_white )
			surface.SetTextPos( 119, 73 )
			surface.SetFont( "mellow_defcon_mini" )
			surface.DrawText( "STATUS_IDLE" )

			surface.SetTextColor( color_white )
			surface.SetTextPos( 189, 73 )
			surface.SetFont( "mellow_defcon_mini" )
			surface.DrawText( "AWAIT_INPUT" )
		end

		if STATE == 1 then
			-- back
			draw.RoundedBox( 8, 280, 51, 118, 100, color_black )

			-- header
			draw.RoundedBox( 20, 282, 50, 114, 15, color_white )

			surface.SetTextColor( color_black )
			surface.SetTextPos( 290, 55 )
			surface.SetFont( "mellow_defcon_mini" )
			surface.DrawText( "WELCOME, " .. string.upper( rank ) )

			surface.SetTextColor( color_white )
			surface.SetTextPos( 290, 80 )
			surface.DrawText( "PLEASE SELECT DEFCON LVL" )

			surface.SetTextPos( 290, 100 )

			surface.SetTextColor( color_white )
			surface.DrawText( "CURRENT LVL: " )

			surface.SetTextColor( IG_DEFCON_SH.COLOURS[ IG_DEFCON ] )
			surface.DrawText( "DEFCON " .. IG_DEFCON_SH.ROMAN[ IG_DEFCON ] )

			surface.SetTextPos( 290, 110 )

			surface.SetTextColor( color_white )
			surface.DrawText( "SELECTED LVL: " )

			surface.SetTextColor( IG_DEFCON_SH.COLOURS[ selected_defcon ] )
			surface.DrawText( "DEFCON " .. IG_DEFCON_SH.ROMAN[ selected_defcon ] )
		end

	mellowcholy.imgui.End3D2D() end

	-- BUTTON DISPLAY
	if mellowcholy.imgui.Entity3D2D( self, Vector( 0, -25, 36.2 ), Angle( 0, 90, 15 ), 0.1, 500, 100 ) then
		if STATE == 0 then
			surface.SetDrawColor( COLOUR.back )
			surface.DrawRect( 254, 180, 53, 25 )
			local login = mellowcholy.imgui.xTextButton( "LOGIN", "mellow_defcon_mini", 254, 180, 53, 25, 1, color_white, IG_DEFCON_SH.COLOURS[ IG_DEFCON ], color_white )

			if login and CurTime() > transition and ply:HasFlag( "defcon" ) then
				STATE = 1
				self:SetSkin( 9 )
				selected_defcon = IG_DEFCON

				transition = CurTime() + 1
			end

			surface.SetDrawColor( COLOUR.back )
			surface.DrawRect( 316, 180, 57, 19 )
		end

		if STATE == 1 then
			surface.SetDrawColor( COLOUR.back )
			surface.DrawRect( 254, 180, 53, 25 )
			local logout = mellowcholy.imgui.xTextButton( "LOGOUT", "mellow_defcon_mini", 254, 180, 53, 25, 1, color_white, IG_DEFCON_SH.COLOURS[ IG_DEFCON ], color_white )

			surface.SetDrawColor( COLOUR.back )
			surface.DrawRect( 316, 180, 57, 19 )
			local submit = mellowcholy.imgui.xTextButton( "SUBMIT", "mellow_defcon_mini", 316, 180, 57, 19, 1, color_white, IG_DEFCON_SH.COLOURS[ IG_DEFCON ], color_white )

			-- DEFCON BUTTONS
			surface.SetDrawColor( IG_DEFCON_SH.COLOURS[ 5 ])
			surface.DrawRect( 331, 119, 12, 12 )
			local d5 = mellowcholy.imgui.xTextButton( "", "mellow_defcon_mini", 331, 119, 12, 12, 1, color_transparent, color_white, color_white )
			if d5 then selected_defcon = 5 end

			surface.SetDrawColor( IG_DEFCON_SH.COLOURS[ 4 ])
			surface.DrawRect( 345, 119, 12, 12 )
			local d4 = mellowcholy.imgui.xTextButton( "", "mellow_defcon_mini", 345, 119, 12, 12, 1, color_transparent, color_white, color_white )
			if d4 then selected_defcon = 4 end

			surface.SetDrawColor( IG_DEFCON_SH.COLOURS[ 3 ])
			surface.DrawRect( 359, 119, 12, 12 )
			local d3 = mellowcholy.imgui.xTextButton( "", "mellow_defcon_mini", 359, 119, 12, 12, 1, color_transparent, color_white, color_white )
			if d3 then selected_defcon = 3 end

			surface.SetDrawColor( IG_DEFCON_SH.COLOURS[ 2 ])
			surface.DrawRect( 331, 133, 12, 12 )
			local d2 = mellowcholy.imgui.xTextButton( "", "mellow_defcon_mini", 331, 133, 12, 12, 1, color_transparent, color_white, color_white )
			if d2 then selected_defcon = 2 end

			surface.SetDrawColor( IG_DEFCON_SH.COLOURS[ 1 ])
			surface.DrawRect( 345, 133, 12, 12 )
			local d1 = mellowcholy.imgui.xTextButton( "", "mellow_defcon_mini", 345, 133, 12, 12, 1, color_transparent, color_white, color_white )
			if d1 then selected_defcon = 1 end

			-- ----

			if logout and CurTime() > transition then
				STATE = 0
				self:SetSkin( 12 )

				transition = CurTime() + 1
			end

			if submit and ply:HasFlag( "defcon" ) then
				net.Start( "IG_UpdateDefconTerminal" )
				net.WriteUInt( selected_defcon, 3 )
				net.SendToServer()
			end
		end

		mellowcholy.imgui.xCursor(73, 88, 353, 170)
	mellowcholy.imgui.End3D2D() end
end