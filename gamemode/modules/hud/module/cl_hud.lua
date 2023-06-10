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
	boost = Color( 92, 190, 255 )
}

local health_table = {
	Color( 202, 66, 75 ),
	Color( 255, 140, 69 ),
	Color( 25, 255, 125 )
}

-- ------------------------------------

surface.CreateFont( "mellow_hp", {
	font = "Roboto Condensed",
	size = ScreenScale( 8 ),
	weight = 500
})

surface.CreateFont( "mellow_credit", {
	font = "Roboto Condensed",
	size = ScreenScale( 10 ),
	weight = 500
})

surface.CreateFont( "mellow_defcon", {
	font = "Roboto Condensed",
	size = ScreenScale( 20 ),
	weight = 1000
})

-- ------------------------------------

local empire = Material( "mellowcholy/empire.png" )
local credit = Material( "mellowcholy/credit.png" )

-- ------------------------------------

function IG_HUD()
	local scrw, scrh = ScrW(), ScrH()
	local ply = LocalPlayer()

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

	surface.SetFont( "mellow_hp" )
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
	mellowcholy.blur( 5, health_panel.x, scrh - health_panel.y - health_panel.h + health_panel.y_pad * 0.2, health_panel.w + health_bar.w + health_panel.x_pad, health_panel.h )

	-- panel
	surface.SetDrawColor( COLOUR.black )
	surface.DrawRect( health_panel.x, scrh - health_panel.y - health_panel.h + health_panel.y_pad * 0.2, health_panel.w + health_bar.w + health_panel.x_pad, health_panel.h )

	-- text
	surface.SetTextColor( COLOUR.black )
	surface.SetTextPos( health_text.x, health_text.y )
	surface.DrawText( back_hp )

	surface.SetTextColor( COLOUR.white )
	surface.SetTextPos( health_text.x, health_text.y )
	surface.DrawText( hp )

	-- bar back
	surface.SetDrawColor( COLOUR.black )
	surface.DrawRect( health_bar.x, health_bar.y, health_bar.w, health_bar.h )

	-- bar front
	surface.SetDrawColor( COLOUR.white )
	surface.DrawRect( health_bar.x, health_bar.y, health_bar.w * hp_lerp, health_bar.h )

	-- bar status
	surface.SetDrawColor( hp_colour )
	surface.DrawRect( health_bar.x, status_bar.y, health_bar.w, 1 )

	----------------------------------------------------------------

	surface.SetFont( "mellow_defcon" )

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
	surface.DrawRect( defcon_panel.x, defcon_panel.y, defcon_panel.w + defcon_icon.size + df_w, defcon_panel.h + defcon_icon.size )

	-- logo
	surface.SetDrawColor( IG_DEFCON_SH.COLOURS[IG_DEFCON] )
	surface.SetMaterial( empire )
	surface.DrawTexturedRect( defcon_icon.x, defcon_icon.y, defcon_icon.size, defcon_icon.size )

	-- text
	surface.SetTextPos( defcon_text.x, defcon_text.y )
	surface.DrawText( df )

	----------------------------------------------------------------

	surface.SetFont( "mellow_credit" )

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
	surface.DrawRect( scrw - credit_panel.x - credit_panel.w - credit_icon.size, scrh - credit_panel.y - credit_icon.size - credit_panel.h, credit_panel.w + credit_icon.size, credit_panel.h + credit_icon.size )

	-- icon
	surface.SetDrawColor( COLOUR.white )
	surface.SetMaterial( credit )
	surface.DrawTexturedRect( scrw - credit_icon.x - credit_icon.size, scrh - credit_icon.y - credit_icon.size, credit_icon.size, credit_icon.size )

	-- line
	surface.DrawLine( scrw - credit_line.x, credit_line.y, scrw - credit_line.x, credit_line.y + credit_icon.size )

	-- text
	surface.SetFont( "mellow_credit" )
	surface.SetTextColor( COLOUR.white )
	surface.SetTextPos( scrw - credit_text.x, credit_text.y )
	surface.DrawText( cd )

	----------------------------------------------------------------
end
hook.Add( "HUDPaint", "IG_HUD", IG_HUD)