local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function(name)
	if ( hide[name] ) then
		return false
	end
end)

-- ------------------------------------

local COLOUR = {
	black = Color( 18, 18, 18, 200 ),
	white = Color( 211, 220, 225 ),
	boost = Color( 92, 190, 255 ),
	scanline = Color(255, 255, 255, 150 )
}

local health_table = {
	Color( 202, 66, 75 ),
	Color( 255, 140, 69 ),
	Color( 25, 255, 125 )
}

-- ------------------------------------

surface.CreateFont( "mellow_hud_text", {
	font = "Roboto Condensed",
	size = ScreenScale( 10 ),
	weight = 500
})

surface.CreateFont( "mellow_hud_defcon", {
	font = "Roboto Condensed",
	size = ScreenScale( 15 ),
	weight = 1000
})

surface.CreateFont( "mellow_hud_subtext", {
	font = "Aurebesh",
	size = ScreenScale( 4 ),
	weight = 500
})

-- ------------------------------------

local empire = Material( "mellowcholy/empire.png")
local credit = Material( "mellowcholy/credit.png" )

local hp_flash = 0

-- ------------------------------------

function IG_HUD()

	if not mellowcholy then
		print("[♡] | SOMETHING HAS GONE WRONG, AND YOU DO NOT HAVE THE MELLOWCHOLY LIBRARY")
		return
	end

	local scrw, scrh = ScrW(), ScrH()
	local ply = LocalPlayer()

	local sway_u, sway_v = mellowcholy.getsway()
	local sway_u_t, sway_v_t = sway_u * 1.2, sway_v * 1.2

	----------------------------------------------------------------

	----------------------------------------------------------------

	local hp = ply:Health()
	local hp_max = ply:GetMaxHealth()
	local hp_lerp = math.Clamp( hp / hp_max, 0, 1 )

	local back_hp_max = math.floor( math.log10( hp_max ) + 1 )
	local back_hp_current = math.floor( math.log10( math.Clamp( hp, 0, 2147483647 ) ) + 1 )

	local back_hp = ""
	local back_hp_using = back_hp_max

	if hp > hp_max then back_hp_using = back_hp_current end

	for i = 1, back_hp_using do
		back_hp = back_hp .. "0"
	end

	local hp_colour = mellowcholy.lerpcolours( hp_lerp, health_table )
	if hp > hp_max then hp_colour = COLOUR.boost end

	if hp <= hp_max * 0.1 then
		hp_flash = hp_flash + 1 * RealFrameTime()

		if hp_flash >= 1 then hp_flash = 0 end
	else
		hp_flash = 0
	end

	if hp_flash > 0 then
		if hp_flash <= 0.5 then
			hp_colour = health_table[1]
		else
			hp_colour = COLOUR.black
		end
	end

	surface.SetFont( "mellow_hud_text" )
	local _, hp_h = surface.GetTextSize( hp )
	local bhp_w, _ = surface.GetTextSize( back_hp )

	local health_panel = {}
	health_panel.x = scrw * 0.01
	health_panel.y = scrh * 0.02

	health_panel.y_pad = scrh * 0.02
	health_panel.x_pad = scrw * 0.005

	health_panel.w = bhp_w + health_panel.x_pad * 2
	health_panel.h = hp_h + health_panel.y_pad * 0.7

	local health_text = {}
	health_text.x = health_panel.x + health_panel.x_pad
	health_text.y = scrh - health_panel.y - health_panel.h + health_panel.y_pad / 2

	local health_bar = {}
	health_bar.x = health_panel.x + health_panel.w
	health_bar.y = health_text.y + hp_h * 0.25

	health_bar.w = scrw * 0.2
	health_bar.h = hp_h * 0.36

	local status_bar = {}
	status_bar.y = health_bar.y + health_bar.h + health_panel.y_pad * 0.2

	-- blur
	mellowcholy.blur( 5, sway_u + health_panel.x, sway_v + scrh - health_panel.y - health_panel.h + health_panel.y_pad * 0.2, health_panel.w + health_bar.w + health_panel.x_pad, health_panel.h )

	-- panel
	surface.SetDrawColor( COLOUR.black )
	surface.DrawRect( sway_u + health_panel.x, sway_v + scrh - health_panel.y - health_panel.h + health_panel.y_pad * 0.2, health_panel.w + health_bar.w + health_panel.x_pad, health_panel.h )

	-- text
	surface.SetTextColor( COLOUR.black )
	surface.SetTextPos( sway_u_t + health_text.x, sway_v_t + health_text.y )
	surface.DrawText( back_hp )

	surface.SetTextColor( COLOUR.white )
	surface.SetTextPos( sway_u_t + health_text.x, sway_v_t + health_text.y )
	surface.DrawText( hp )

	-- bar back
	surface.SetDrawColor( COLOUR.black )
	surface.DrawRect( sway_u + health_bar.x, sway_v + health_bar.y, health_bar.w, health_bar.h )

	-- bar front
	surface.SetDrawColor( COLOUR.white )
	surface.DrawRect( sway_u_t + health_bar.x, sway_v_t + health_bar.y, health_bar.w * hp_lerp, health_bar.h )

	-- scanline
	surface.SetDrawColor( COLOUR.scanline )
	mellowcholy.scanline( sway_u + health_panel.x, sway_v + scrh - health_panel.y - health_panel.h + health_panel.y_pad * 0.2, health_panel.w + health_bar.w + health_panel.x_pad, health_panel.h, health_panel.h / 2 )

	-- bar status
	surface.SetDrawColor( hp_colour )
	surface.DrawRect( sway_u_t + health_bar.x, sway_v_t + status_bar.y, health_bar.w, 1 )

	----------------------------------------------------------------

	surface.SetFont( "mellow_hud_defcon" )

	local df = "DEFCON " .. IG_DEFCON_SH.ROMAN[IG_DEFCON]
	local df_w, _ = surface.GetTextSize( df )

	local defcon_panel = {}
	defcon_panel.x = scrw * 0.01
	defcon_panel.y = scrh * 0.02

	defcon_panel.x_pad = scrw * 0.006
	defcon_panel.y_pad = scrh * 0.008

	defcon_panel.w = defcon_panel.x_pad * 3
	defcon_panel.h = defcon_panel.y_pad * 2

	local defcon_icon = {}
	defcon_icon.x = defcon_panel.x + defcon_panel.x_pad
	defcon_icon.y = defcon_panel.y + defcon_panel.y_pad

	defcon_icon.size = scrw * 0.035

	local defcon_text = {}
	defcon_text.x = defcon_icon.x + defcon_icon.size + defcon_panel.x_pad
	defcon_text.y = defcon_icon.y + defcon_panel.y_pad * 0.4

	-- blur
	mellowcholy.blur( 5, defcon_panel.x, defcon_panel.y, defcon_panel.w + defcon_icon.size + df_w, defcon_panel.h + defcon_icon.size )

	-- panel
	surface.SetDrawColor( COLOUR.black )
	surface.DrawRect( sway_u + defcon_panel.x, sway_v + defcon_panel.y, defcon_panel.w + defcon_icon.size + df_w, defcon_panel.h + defcon_icon.size )

	-- logo
	surface.SetDrawColor( color_white )
	surface.SetMaterial( empire )
	surface.DrawTexturedRect( sway_u_t + defcon_icon.x, sway_v_t +  defcon_icon.y, defcon_icon.size, defcon_icon.size )

	-- text
	surface.SetTextPos( sway_u_t + defcon_text.x, sway_v_t + defcon_text.y )
	surface.DrawText( "DEFCON " )
	surface.SetTextColor( IG_DEFCON_SH.COLOURS[IG_DEFCON] )
	surface.DrawText( IG_DEFCON_SH.ROMAN[IG_DEFCON] )

	surface.SetFont( "mellow_hud_subtext" )
	surface.SetTextPos( sway_u_t + defcon_text.x, sway_v_t + defcon_panel.y + defcon_panel.h + defcon_icon.size - defcon_panel.y_pad * 3.5 )
	surface.DrawText( "mellowcholy" )

	-- scanline
	surface.SetDrawColor( COLOUR.scanline )
	mellowcholy.scanline( sway_u + defcon_panel.x, sway_v + defcon_panel.y, defcon_panel.w + defcon_icon.size + df_w, defcon_panel.h + defcon_icon.size, ( defcon_panel.h + defcon_icon.size ) / 2 )

	----------------------------------------------------------------

	surface.SetFont( "mellow_hud_text" )

	local cd = ( string.Comma(ply:GetCredits()) )
	local cd_w, _ = surface.GetTextSize( cd )

	local credit_panel = {}
	credit_panel.x = scrw * 0.01
	credit_panel.y = scrh * 0.02

	credit_panel.x_pad = scrw * 0.005
	credit_panel.y_pad = scrh * 0.01

	credit_panel.w = credit_panel.x_pad * 4 + cd_w
	credit_panel.h = credit_panel.y_pad * 2

	local credit_icon = {}
	credit_icon.x = credit_panel.x + credit_panel.w - credit_panel.x_pad
	credit_icon.y = credit_panel.y + credit_panel.h - credit_panel.y_pad

	credit_icon.size = scrw * 0.013

	local credit_line = {}
	credit_line.x = credit_icon.x - credit_panel.x_pad
	credit_line.y = scrh - credit_icon.y - credit_icon.size

	local credit_text = {}
	credit_text.x = credit_line.x - credit_panel.x_pad
	credit_text.y = scrh - credit_icon.y - credit_icon.size * 1.1

	-- panel
	surface.SetDrawColor( COLOUR.black )
	surface.DrawRect( sway_u + scrw - credit_panel.x - credit_panel.w - credit_icon.size, sway_v + scrh - credit_panel.y - credit_icon.size - credit_panel.h, credit_panel.w + credit_icon.size, credit_panel.h + credit_icon.size )

	-- icon
	surface.SetDrawColor( COLOUR.white )
	surface.SetMaterial( credit )
	surface.DrawTexturedRect( sway_u_t + scrw - credit_icon.x - credit_icon.size, sway_v_t + scrh - credit_icon.y - credit_icon.size, credit_icon.size, credit_icon.size )

	-- line
	surface.DrawLine( sway_u_t + scrw - credit_line.x, sway_v_t + credit_line.y, sway_u_t + scrw - credit_line.x, sway_v_t + credit_line.y + credit_icon.size )

	-- text
	surface.SetTextColor( COLOUR.white )
	surface.SetTextPos( sway_u_t + scrw - credit_text.x, sway_v_t + credit_text.y )
	surface.DrawText( cd )

	-- scanline
	surface.SetDrawColor( COLOUR.scanline )
	mellowcholy.scanline( sway_u + scrw - credit_panel.x - credit_panel.w - credit_icon.size, sway_v + scrh - credit_panel.y - credit_icon.size - credit_panel.h, credit_panel.w + credit_icon.size, credit_panel.h + credit_icon.size, ( credit_panel.h + credit_icon.size ) / 2 )

	----------------------------------------------------------------



	----------------------------------------------------------------
end
hook.Add( "HUDPaint", "IG_HUD", IG_HUD)