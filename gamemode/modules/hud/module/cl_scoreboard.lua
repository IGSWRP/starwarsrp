-- surface.CreateFont( "bleur_scoreboard48bold", {
-- 	font = "Roboto Condensed",
-- 	size = 48,
-- 	weight = 700,
-- 	antialias = true,
-- 	additive = true,
-- })

surface.CreateFont( "bleur_scoreboard14bold", {
	font = "Roboto",
	size = 16,
	weight = 700,
	outline = true,
	antialias = true,
	additive = true,
})

surface.CreateFont( "bleur_scoreboard12", {
	font = "Roboto",
	size = 14,
	weight = 100,
	antialias = true,
	additive = true,
})

local header_img = Material( "mellowcholy/tab/header_standard.png" )

/*---------------------------------------------------------------------------
	CONFIG
---------------------------------------------------------------------------*/
local config = {
    ["menuAccessGroups"] = {
        ["superadmin"] = true
    },
    ["width"] = 800	,
    ["height"] = ScrH() - 100,
    ["header"] = "Imperial Gaming",
    ["footer"] = "https://imperialgaming.io",
    ["defaultSortingTab"] = 1,
    ["updateDelay"] = 0.5,
    ["showPlayerNum"] = true,
}


local groups = {
    ["superadmin"]  = "Super Admin",
    ["user"]        = "User"
} 

local theme = {
    ["top"]     = Color( 30, 30, 30, 255 ),
    ["bottom"] 	= Color( 30, 30, 30, 255 ),
    ["tab"]	 	= Color( 230, 230, 230, 255 ),
    ["footer"] 	= Color( 125, 10, 12 ),
    ["header"] 	= Color( 240, 240, 240 ),
}

/*---------------------------------------------------------------------------
	TABS

	Explanation:
	name - 	self-explanatory
	size - 	fraction of tab area that it should take, number between 0 and 1
			where 1 means whole tab area and 0 means none
	fetch -	this is just a function that returns what to put in certain tab,
			very useful if you want developers to add a tab for their addon to
			the scoreboard
	liveUpdate 	- 	set to true if you want values to update for the tab while
					scoreboard is open
	fetchColor 	-	this function fetches for color, useful for different
					rank colors and whatnot
---------------------------------------------------------------------------*/

local tabs = {
    [0] = { name = "Name",		size = 0.3,		liveUpdate = false,		fetch = function( ply ) return ((ply:GetRankName() and ply:GetRankName() .. " ") or "") .. ply:GetName() end },
    [1] = { name = "Regiment",	size = 0.2675,	liveUpdate = false,		fetch = function( ply ) return ply:GetRegimentName() or "LOADING" end },
    [2] = { name = "Usergroup",	size = 0.2675,	liveUpdate = false,		fetch = function( ply ) return ply.sam_getrank and ply:sam_getrank() or "" end },
    [3] = { name = "Ping", 		size = 0.055,	liveUpdate = true, 		fetch = function( ply ) return ply:Ping() end },
}

if not tabs then
	error( "Bleur Scoreboard: You haven't enabled ANY tabs! Open bleur_scoreboard.lua and remove comment lines to enable certain tabs", 0 )
	return false
end

local size = 0
for _, tab in pairs ( tabs ) do
	size = size + tab.size
end
if size > 1 then
	error( "Bleur Scoreboard: Your tabs are way too big. Summarized tab sizes can't be bigger than 1!")
	return false
end

/*---------------------------------------------------------------------------
	END OF CONFIG, DON'T TOUCH ANYTHING BELOW
---------------------------------------------------------------------------*/
local tabArea = config.width - 35 -- preserve 35px from left edge for avatar
tabArea = tabArea - 30 -- preserve 30px from right edge for mute button
for i, tab in pairs( tabs ) do
	local prev = tabs[ i - 1 ] or { pos = 0, size = 0 }
	tabs[ i ].pos = prev.pos + prev.size
	tabs[ i ].size = tabArea * tab.size
end

local function fetchRowColor( ply )
	local col = ply:GetRegimentColour() or Color( 50, 50, 50 )
	col.a = 200

	return col
end
/*---------------------------------------------------------------------------
	VISUALS
---------------------------------------------------------------------------*/
local blur = Material( "pp/blurscreen" )
local function drawPanelBlur( panel, layers, density, alpha )
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( theme.header )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

local function drawRectOutline( x, y, w, h, color )
	surface.SetDrawColor( color )
	surface.DrawOutlinedRect( x, y, w, h )
end
/*---------------------------------------------------------------------------
	PANEL
---------------------------------------------------------------------------*/
local PANEL = {}
function PANEL:Init()
	self:SetSize( 100, 50 )
	self:Center()
	self.color = Color( 0, 0, 0, 200 )
	self.ply = nil
end

-- TODO
function PANEL:OnMousePressed()
	local ply = self.ply
	if not config.menuAccessGroups[ LocalPlayer():GetNWString( "usergroup" ) ] then return end

	self.menu = vgui.Create( "DMenu" )
	self.menu:SetPos( gui.MouseX(), gui.MouseY() )
	self.menu.categories = {}
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( self.color.r, self.color.g, self.color.b, 170 ) )
	drawRectOutline( 0, 0, w, h, Color( self.color.r, self.color.g, self.color.b, 180 ) )
	mellowcholy.scanline( 0, 0, w, h, h / 2 )
end
vgui.Register( "bleur_row", PANEL, "EditablePanel" )

local PANEL = {}
function PANEL:Init()
	self:SetSize( config.width, config.height )
	self:SetPos(ScrW() / 2 - (config.width /2 ), ScrH() )
	self:MoveTo(ScrW() / 2 - (config.width /2 ), ScrH() / 2 - (config.height / 2), 0.1 , 0 , 5)
	self.sortAsc = false

	self.alphaMul = 1

	for i, tab in pairs( tabs ) do
		surface.SetFont( "bleur_scoreboard14bold" )
		local width, height = surface.GetTextSize( tab.name )
		local tabLabel = vgui.Create( "DLabel", self )
		tabLabel:SetFont( "bleur_scoreboard14bold" )
		tabLabel:SetColor( Color( theme.tab.r, theme.tab.g, theme.tab.b, theme.tab.a ) )
		tabLabel:SetText( tab.name )
		tabLabel:SizeToContents()
		tabLabel:SetPos( 35 + tab.pos + ( tab.size / 2 ) - ( width / 2 ), 81 )
		tabLabel:SetMouseInputEnabled( true )
		function tabLabel:DoClick()
			self:GetParent().sortAsc = !self:GetParent().sortAsc
			self:GetParent():populate( tab.name )
		end
	end
end

function PANEL:Paint( w, h )
	self.alphaMul = Lerp( 0.1, self.alphaMul, 1 )

	drawPanelBlur( self, 3, 6, 255 )
	draw.RoundedBox( 0, 0, 75, w, h - 100, Color( 0, 0, 0, 150 * self.alphaMul ) )
	drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 75 * self.alphaMul  ) )
	//Top bar
	draw.RoundedBoxEx( 4, 0, 0, w, 75, Color( theme.top.r, theme.top.g, theme.top.b, theme.top.a * self.alphaMul ), true, true, false, false )

	// Header
	surface.SetDrawColor( color_white )
	surface.SetMaterial( header_img )
	surface.DrawTexturedRect( 0, 0, w, 75 )
	
	// local _, th = draw.SimpleText( config.header, "bleur_scoreboard48bold", w / 2, 15, Color( theme.header.r, theme.header.g, theme.header.b, theme.header.a * self.alphaMul ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
	if config.showPlayerNum then
		draw.SimpleText( "Players: " .. #player.GetAll() .. "/" .. game.MaxPlayers(), "bleur_scoreboard14bold", 5, 55 )
	end
	//Tabs
	draw.RoundedBox( 0, 0, 76, tabArea + 65, 25, Color( 0, 0, 0, 220 * self.alphaMul ) )
	//Bottom bar
	draw.RoundedBoxEx( 4, 0, h - 25, w, 25, Color( theme.bottom.r, theme.bottom.g, theme.bottom.b, theme.bottom.a * self.alphaMul ), false, false, true, true )
	draw.SimpleText( config.footer, "bleur_scoreboard12", w / 2, h - 12.5, Color( theme.footer.r, theme.footer.g, theme.footer.b, theme.footer.a * self.alphaMul ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	mellowcholy.scanline( 0, 0, w, h, h / 2 )
end

function PANEL:populate( sorting )
	self.scrollPanel = vgui.Create( "DScrollPanel", self )
	self.scrollPanel:SetPos( 1, 102 )
	self.scrollPanel:SetSize( self:GetWide() + 18, self:GetTall() - 128 )

	if self.list then
		self.list:Remove()
	end

	self.list = vgui.Create( "DIconLayout", self.scrollPanel )
	self.list:SetSize( self.scrollPanel:GetWide() - 20, self.scrollPanel:GetTall() )
	self.list:SetPos( 1, 0 )
	self.list:SetSpaceY( 1 )

	local players = {}
	for i, ply in pairs( player.GetAll() ) do
		table.insert(players, 1, {ply=ply})
		--if not players[1] then i = 1 end
		--players[ i ] = { ply = ply }
		for _, tab in pairs( tabs ) do
			--print(tab.name)
			--print(tab.fetch(ply))
			players[ 1 ][ tab.name ] = tab.fetch( ply )
		end
	end
	table.SortByMember( players, sorting or tabs[ 0 ].name, self.sortAsc )

	for i, data in pairs( players ) do
		local row = vgui.Create( "bleur_row", self.list )
		row:SetSize( self.list:GetWide() - 2, 30 )
		row.color = fetchRowColor( data.ply )
		row.ply = data.ply

		row.avatar = vgui.Create( "AvatarImage", row )
		row.avatar:SetSize( 26, 26 )
		row.avatar:SetPos( 2, 2 )
		row.avatar:SetPlayer( data.ply, 64 )

		if row.ply ~= LocalPlayer() then
			row.mute = vgui.Create( "DImageButton", row )
			row.mute:SetSize( 16, 16 )
			row.mute:SetPos( row:GetWide()  - 31, 8 )
			row.mute:SetImage( "icon16/sound_mute.png" )
			row.mute:SetColor( Color( 0, 0, 0 ) )
			if row.ply:IsMuted() then
				row.mute:SetColor( Color( 255, 0, 0 ) )
			end

			function row.mute:DoClick()
				local row = self:GetParent()
				row.ply:SetMuted( !row.ply:IsMuted() )

				self:SetColor( Color( 0, 0, 0 ) )
				if row.ply:IsMuted() then
					self:SetColor( Color( 255, 0, 0 ) )
				end
			end
		end

		for i, tab in pairs( tabs ) do
			surface.SetFont( "bleur_scoreboard14bold" )
			local width, height = surface.GetTextSize( data[ tab.name ] or "" )
			local info = vgui.Create( "DLabel", row )
			info:SetFont( "bleur_scoreboard14bold" )
			info:SetColor( theme.header )
			info:SetText( data[ tab.name ] or "ERROR" )
			info:SizeToContents()
			info:SetPos( 35 + tab.pos + ( tab.size / 2 ) - ( width / 2 ), 0 )
			info:CenterVertical()
			if tab.fetchColor then
				info:SetColor( tab.fetchColor( ply ) )
			end

			if tab.liveUpdate then
				function info:Think()
					self.lastThink = self.lastThink or CurTime()
					if self.lastThink + config.updateDelay < CurTime() then
						surface.SetFont( "bleur_scoreboard14bold" )
						local width, height = surface.GetTextSize( data[ tab.name ] or "" )
						self:SetFont( "bleur_scoreboard14bold" )
						self:SetColor( theme.header )
						if row.ply:IsValid() then
							self:SetText( tab.fetch( row.ply ) or "ERROR" )
						else
							self:SetText( "ERROR" )
						end
						self:SizeToContents()
						self:SetPos( 35 + tab.pos + ( tab.size / 2 ) - ( width / 2 ), 0 )
						self:CenterVertical()

						self.lastThink = CurTime()
					end
				end
			end
		end
	end
end
vgui.Register( "bleur_scoreboard", PANEL, "EditablePanel" )
/*---------------------------------------------------------------------------
	FUNCTIONALITY - DON'T TOUCH ANYTHING BELOW!
---------------------------------------------------------------------------*/
timer.Simple( 0.1, function()
	for i, v in pairs( hook.GetTable()["ScoreboardShow"] or {} )do
		hook.Remove( "ScoreboardShow", i)
	end

	for i, v in pairs( hook.GetTable()["ScoreboardHide"] or {} )do
		hook.Remove( "ScoreboardHide", i)
	end

	local scoreboard = nil
	hook.Add( "ScoreboardShow", "bleur_scoreboard_show", function()
		gui.EnableScreenClicker( true )

		scoreboard = vgui.Create( "bleur_scoreboard" )
		scoreboard:populate( tabs[ config.defaultSortingTab ].name )
		return true
	end )

	hook.Add( "ScoreboardHide", "bleur_scoreboard_hide", function()
		gui.EnableScreenClicker( false )
		
		if ( IsValid( scoreboard ) ) then
			scoreboard:MoveTo( ScrW() / 2 - (config.width /2 ), ScrH() , 0.25 , 0 , 5 , function( )
				scoreboard:Remove( )
			end )
		end

		-- scoreboard:Remove()
		return true
	end )
end )