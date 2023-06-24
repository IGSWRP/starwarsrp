local COLOUR = {
	background = Color( 0, 0, 0, 225 ),
	grid = Color( 49, 55, 66, 255 ),
	textcolour = Color( 225, 240, 255, 120 ),
	white = Color( 255, 255, 255, 255 ),
	highlight = Color( 46, 135, 255, 255 ),
}

surface.CreateFont("mellow_login_heading", {
	font = "Proxima Nova Rg",
	size = ScreenScale(11),
	weight = 800
})

surface.CreateFont("mellow_login_heading2", {
	font = "Proxima Nova Rg",
	size = ScreenScale(10),
	weight = 800
})
surface.CreateFont("mellow_login_text", {
	font = "Proxima Nova Rg",
	size = ScreenScale(5),
	weight = 800
})
surface.CreateFont("mellow_login_text2", {
	font = "Roboto Condensed",
	size = ScreenScale(8),
	weight = 500
})
surface.CreateFont("mellow_login_aurebesh", {
	font = "Aurebesh",
	size = ScreenScale(6),
	weight = 500
})

local credits = Material( "mellowcholy/login/credit_big.png" )
local logo = Material("mellowcholy/login/logo.png")

local canvas
local frameW, frameH

local function LoginMenu()
	local scrw = ScrW()
	local scrh = ScrH()

	local ply = LocalPlayer()

	local IG_LOGINBONUS = {}
	IG_LOGINBONUS["day"] = net.ReadUInt( 3 ) or 1
	IG_LOGINBONUS["streak"] = net.ReadUInt( 11 ) or 1
	IG_LOGINBONUS["longest_streak"] = net.ReadUInt( 11 ) or 1
	IG_LOGINBONUS["claimed_day"] = net.ReadBool()
	IG_LOGINBONUS["claimed_streak"] = net.ReadBool()

	local streak_claim = false

	local next_bonus = {}
	next_bonus["day"] = 0
	next_bonus["credit"] = 0

	-- decide which streak to show

	for k, v in pairs( IG_LOGINREWARD ) do
		if k > 7 and k == IG_LOGINBONUS["streak"] then
			next_bonus["day"] = k
			next_bonus["credit"] = v["credit"]
			next_bonus["xp"] = v["xp"]

			streak_claim = true
			break
		end
	end

	if not streak_claim then
		for k, v in pairs( IG_LOGINREWARD ) do
			if k > 7 and k > IG_LOGINBONUS["streak"] then
				next_bonus["day"] = k
				next_bonus["credit"] = v["credit"]
				next_bonus["xp"] = v["xp"]

				break
			end
		end
	end

	frameW = scrw * 0.9
	frameH = scrh * 0.9

	canvas = vgui.Create( "DFrame" )
	canvas:SetSize( frameW, frameH )
	canvas:Center()
	canvas:MakePopup()
	canvas:SetDraggable( true )
	canvas:ShowCloseButton( false )
	canvas:SetTitle( "" )
	canvas.Paint = function( self, w, h )

		--background
		surface.SetDrawColor( COLOUR.background )
		surface.DrawRect( 0, 0, w, h )

		-- scanlines
		mellowcholy.scanline( 0, 0, w, h, h / 2 )

		-- logo
		surface.SetDrawColor( COLOUR.white )
		surface.SetMaterial( logo )
		surface.DrawTexturedRect((w / 2) - logo:Width() / 12, h * 0.01, logo:Width() / 6, logo:Height() / 6)

		-- playermodel background
		surface.SetDrawColor( COLOUR.background )
		surface.DrawRect( w * 0.025, h * 0.17, w * 0.15, h * 0.4 )
		surface.SetDrawColor( COLOUR.textcolour )
		surface.DrawOutlinedRect( w * 0.025, h * 0.17, w * 0.15, h * 0.4, 2 )

		-- playermodel text
		surface.SetTextColor( COLOUR.textcolour )
		surface.SetFont( "mellow_login_heading2" )
		surface.SetTextPos( w * 0.2, h * 0.2 )
		surface.DrawText( string.upper( ply:Nick() ) )

		surface.SetTextColor( COLOUR.highlight )
		surface.SetTextPos( w * 0.2, h * 0.25 )
		surface.DrawText( string.upper( ply:GetRegimentName() ) )

		surface.SetTextColor( COLOUR.textcolour )
		surface.SetTextPos( w * 0.2, h * 0.3 )
		surface.DrawText( string.upper( ply:GetRankName() ) )

		-- streak text
		surface.SetTextColor( COLOUR.textcolour )
		surface.SetTextPos( w * 0.2, h * 0.4 )
		surface.DrawText( "CURRENT STREAK: " )
		surface.SetTextColor( COLOUR.highlight )
		surface.DrawText( IG_LOGINBONUS["streak"] )

		surface.SetTextColor( COLOUR.textcolour )
		surface.SetTextPos( w * 0.2, h * 0.45 )
		surface.DrawText( "LONGEST STREAK: " )
		surface.SetTextColor( COLOUR.highlight )
		surface.DrawText( IG_LOGINBONUS["longest_streak"] )

		-- news plus updates

		surface.SetDrawColor( COLOUR.background )
		surface.DrawRect( w * 0.54, h * 0.17, w * 0.43, h * 0.436)

		surface.SetDrawColor( COLOUR.textcolour )
		surface.DrawOutlinedRect( w * 0.54, h * 0.17, w * 0.43, h * 0.436, 2 )

		-- -------------------------------------------------------------------------

		-- daily bonus text
		surface.SetTextColor( COLOUR.highlight )
		surface.SetFont( "mellow_login_heading" )
		surface.SetTextPos( w * 0.025, h * 0.62 )
		surface.DrawText( "DAILY BONUS" )

		surface.SetTextColor( COLOUR.textcolour )

		for i = 1, 7 do
			-- offsets
			local xPos = (((i - 1) * 0.08) + 0.05)
			local yPos = h * 0.8

			if (i % 2 == 0) then
				yPos = h * 0.88
			end

			-- day text
			surface.SetTextPos( (xPos * w) + w * 0.014, yPos - h * 0.12)
			surface.SetFont( "mellow_login_heading" )
			surface.DrawText( "DAY " .. i )

			-- HEXAGON OUTLINE
			surface.SetDrawColor( COLOUR.textcolour )
			mellowcholy.hexagon((xPos * w) + (w * 0.04), yPos, w * 0.05)

			-- icon
			surface.SetDrawColor( COLOUR.textcolour )
			surface.SetMaterial( credits )
			surface.DrawTexturedRect((xPos * w) + w * 0.017, yPos - h * 0.05, w * 0.05, w * 0.05)

			draw.SimpleText(IG_LOGINREWARD[i]["credit"] .. " credits", "mellow_login_text", (xPos * w) + w * 0.016, yPos + h * 0.06, COLOUR.textcolour, TEXT_ALIGN, TEXT_ALIGN_CENTER)

			-- claimed
			if IG_LOGINBONUS["day"] > i then
				surface.SetDrawColor(COLOUR.highlight)
				mellowcholy.hexagon((xPos * w) + (w * 0.04), yPos, w * 0.047)
			end

			if IG_LOGINBONUS["day"] == i and IG_LOGINBONUS["claimed_day"] then
				surface.SetDrawColor(COLOUR.highlight)
				mellowcholy.hexagon((xPos * w) + (w * 0.04), yPos, w * 0.047)
			elseif IG_LOGINBONUS["day"] == i and not IG_LOGINBONUS["claimed_day"] then
				surface.SetDrawColor(COLOUR.textcolour)
				mellowcholy.hexagon((xPos * w) + (w * 0.04), yPos, w * 0.047)
			end
		end

		if IG_LOGINBONUS["streak"] == next_bonus["day"] and IG_LOGINBONUS["claimed_streak"] then
			surface.SetDrawColor(COLOUR.highlight)
			surface.DrawOutlinedRect(w * 0.805,h * 0.759,w * 0.167,h * 0.195,1)
			draw.SimpleText("CLAIMED","mellow_login_text",w * 0.885,h * 0.97,COLOUR.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
		end
		if shouldShow then
			surface.SetDrawColor(COLOUR.textcolour)
			surface.DrawOutlinedRect(w * 0.805,h * 0.759,w * 0.167,h * 0.195,1)
		end

		-- streak bonus
		surface.SetTextColor(COLOUR.highlight)
		surface.SetFont("mellow_login_heading")
		surface.SetTextPos(w * 0.79,h * 0.65)
		surface.DrawText("NEXT STREAK BONUS")

		surface.SetTextColor(COLOUR.textcolour)
		surface.SetTextPos(w * 0.8,h * 0.71)
		surface.SetFont("mellow_login_heading")
		surface.DrawText("DAY " .. next_bonus["day"])

		surface.SetDrawColor(COLOUR.textcolour)
		surface.DrawLine(w * 0.8, h * 0.75, w * 0.975, h * 0.75)
		surface.DrawLine(w * 0.8, h * 0.75, w * 0.8, h * 0.96)
		surface.DrawLine(w * 0.8, h * 0.96, w * 0.955, h * 0.96)
		surface.DrawLine(w * 0.975, h * 0.75, w * 0.975, h * 0.91)

		surface.DrawLine(w * 0.955, h * 0.96, w * 0.975, h * 0.91)
		surface.DrawLine(w * 0.951, h * 0.96, w * 0.975, h * 0.901)

		surface.SetDrawColor(COLOUR.textcolour)
		surface.SetMaterial(credits)
		surface.DrawTexturedRect(w * 0.86,h * 0.79,w * 0.05, w * 0.05)
		draw.SimpleText(next_bonus["credit"] .. " credits + " .. next_bonus["xp"] .. " xp","mellow_login_text",w * 0.885,h * 0.915,COLOUR.textcolour,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)

		-- random aurebesh
		surface.SetFont("mellow_login_aurebesh")

		local lalign = surface.GetTextSize("made by mellowcholy")

		surface.SetTextPos((w * 0.97) - lalign, h * 0.14)
		surface.DrawText("made by mellowcholy")

		surface.SetTextPos(w * 0.03, h * 0.14)
		surface.DrawText("john star wars")

		lalign = surface.GetTextSize("bonus")

		surface.SetTextPos((w * 0.985) - lalign, h * 0.685)
		surface.DrawText("bonus")

		-- outlines
		surface.SetDrawColor(COLOUR.textcolour)
		surface.SetTextColor(COLOUR.textcolour)

		-- base outline
		surface.DrawOutlinedRect(0,0,w,h,1)
		surface.DrawLine(0,h * 0.99, w, h * 0.99)

		-- header left
		surface.DrawLine(w * 0.025, h * 0.05, w * 0.4, h * 0.05)
		surface.DrawLine(w * 0.025, h * 0.05, w * 0.025, h * 0.07)
		surface.DrawLine(w * 0.025, h * 0.07, w * 0.035, h * 0.09)
		surface.DrawLine(w * 0.035, h * 0.09, w * 0.37, h * 0.09)

		surface.SetFont("mellow_login_text2")
		surface.SetTextPos(w * 0.04, h * 0.057)
		surface.DrawText("WELCOME BACK TROOPER")

		-- header right
		surface.DrawLine(w * 0.6, h * 0.09, w * 0.97, h * 0.09)
		surface.DrawLine(w * 0.97, h * 0.05, w * 0.97, h * 0.09)
		surface.DrawLine(w * 0.948, h * 0.05, w * 0.948, h * 0.09)

		surface.DrawLine(w * 0.63, h * 0.05, w * 0.8, h * 0.05)
		surface.DrawLine(w * 0.85, h * 0.05, w * 0.97, h * 0.05)

		surface.DrawLine(w * 0.805, h * 0.057, w * 0.845, h * 0.057)
		surface.DrawLine(w * 0.8, h * 0.05, w * 0.805, h * 0.057)
		surface.DrawLine(w * 0.845, h * 0.057, w * 0.85, h * 0.05)

		surface.SetTextPos(w * 0.78, h * 0.061)
		surface.DrawText(os.date("%H:%M:%S - %d/%m/%Y", os.time()))

		-- pistons

		surface.DrawOutlinedRect(w * 0.79, h * 0.8, w * 0.005, h * 0.11, 1)
		surface.DrawOutlinedRect(w * 0.782, h * 0.8, w * 0.005, h * 0.11, 1)
		surface.DrawOutlinedRect(w * 0.774, h * 0.8, w * 0.005, h * 0.11, 1)

		surface.DrawRect(w * 0.79, h * 0.889 + math.sin( CurTime() ) * 25, w * 0.005, h * 0.02 - math.sin( CurTime() ) * 25, 1)
		surface.DrawRect(w * 0.782, h * 0.854 + math.cos( CurTime() ) * 50, w * 0.005, h * 0.055 - math.cos( CurTime() ) * 50, 1)
		surface.DrawRect(w * 0.774, h * 0.849 + math.sin( CurTime() ) * 25, w * 0.005, h * 0.06 - math.sin( CurTime() ) * 25, 1)
	end

	local close = vgui.Create("DButton",canvas)
	close:SetSize(frameW * 0.02, frameW * 0.0205)
	close:SetPos(frameW * 0.95, frameH * 0.0525)
	close:SetText("")
	close.Paint = function(self,w,h)
		surface.SetDrawColor(COLOUR.background)

		surface.SetDrawColor(COLOUR.textcolour)
		surface.DrawOutlinedRect(0,0,w,h,1)

		draw.DrawText( "X", "mellow_login_heading2", w * 0.475, h * 0.1, COLOUR.textcolour, TEXT_ALIGN_CENTER)
	end
	close.DoClick = function()
		canvas:Close()
	end

	local model = vgui.Create("DModelPanel",canvas)
	model:SetSize(frameW * 0.15,frameH * 0.4)
	model:SetPos(frameW * 0.025,frameH * 0.15)
	model:SetModel(ply:GetModel())
	model:SetFOV(50)

	local patch_notes = vgui.Create("DHTML",canvas)
	patch_notes:SetSize(frameW * 0.4245,frameH * 0.489)
	patch_notes:SetPos(frameW * 0.5429, frameH * 0.144)
	patch_notes:OpenURL( "https://imperialgaming.net/patchnotes/" )

	local xOffset, yOffset
	if IG_LOGINBONUS["claimed_day"] then
		xOffset = -1
		yOffset = -1
	else
		xOffset = (((IG_LOGINBONUS["day"] - 1) * 0.08) + 0.06)

		if (IG_LOGINBONUS["day"] % 2 == 0) then
			yOffset = 0.965
		else
			yOffset = 0.885
		end
	end

	local claim = vgui.Create("DButton",canvas)
	claim:SetText("")
	claim:SetSize(frameW * 0.06,frameH * 0.02)
	claim:SetPos(frameW * xOffset,frameH * yOffset)
	claim.DoClick = function()
		net.Start( "IG_LoginClaim" )
		net.WriteBool(false)
		net.SendToServer()

		IG_LOGINBONUS["claimed_day"] = true

		claim:SetEnabled(false)
	end
	claim.Paint = function(self, w, h)
		if not IG_LOGINBONUS["claimed_day"] then
			draw.RoundedBox( 10, 0, 0, w, h, COLOUR.highlight )
			draw.DrawText( "CLAIM", "mellow_login_text", w * 0.475, h * 0.1, COLOUR.white, TEXT_ALIGN_CENTER)
		end
	end

	local claim_streak = vgui.Create("DButton",canvas)
	claim_streak:SetText("")
	claim_streak:SetSize(frameW * 0.175,frameH * 0.02)
	claim_streak:SetPos(frameW * 0.8,frameH * 0.97)

	if IG_LOGINBONUS["streak"] ~= next_bonus["day"] or IG_LOGINBONUS["claimed_streak"] then
		claim_streak:SetEnabled(false)
		streak_claim = false
	end

	claim_streak.DoClick = function()
		net.Start( "IG_LoginClaim" )
		net.WriteBool(true)
		net.SendToServer()

		streak_claim = false
		IG_LOGINBONUS["claimed_streak"] = true

		claim_streak:SetEnabled(false)
	end
	claim_streak.Paint = function(self, w, h)
		if not IG_LOGINBONUS["claimed_streak"] and IG_LOGINBONUS["streak"] == next_bonus["day"] then
			draw.RoundedBox( 10, 0, 0, w, h, COLOUR.highlight )
			draw.DrawText( "CLAIM", "mellow_login_text", w * 0.475, h * 0.1, COLOUR.textcolour, TEXT_ALIGN_CENTER)
		end
	end
end
net.Receive("IG_LoginMenu", LoginMenu )

hook.Add( "HUDPaint", "IG_LOGIN_HUDPAINT", function()
	if not IsValid(canvas) then return end

	local panelX, panelY = canvas:LocalToScreen(0, 0)
	mellowcholy.blur( 5, panelX, panelY, frameW, frameH )
end)