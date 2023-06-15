surface.CreateFont( "Display_Text", {
	font = "anakinmono", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 18,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local black = Color( 18, 18, 18, 200 )

local runtime = RealTime()
local text = ""
local drawn_text = ""

local PANEL = { }
PANEL.Message = nil

function PANEL:Init( )
    self:SetSize( 420 , 75 )
    self:SetPos( ScrW( ) / 2 - 210 , -100)
    runtime = RealTime()
    text = ""
    drawn_text = ""
end

function PANEL:SetMessage(message)
    self.Message = message
    self.Enabled = true
    self.CreateTime = string.len(message) * 0.06 + 9

    self:MoveTo( ScrW( ) / 2 - 210 , 140 , 0.25 , 0 , 5 )
end

function PANEL:Paint( w , h )
    if ( self.Enabled ) then
        mellowcholy.blur(5, 0, 0, w, h)
        surface.SetDrawColor( black )
        surface.DrawRect( 0, 0, w, h )

        draw.DrawText("⧨ALERT⧩ Imperial Transmission ⧨ALERT⧩", "Display_Text", 210, 5, color_white, TEXT_ALIGN_CENTER)

        draw.DrawText(drawn_text, "Display_Text", 7, 50, color_white, TEXT_ALIGN_LEFT)

        local order_message = self.Message

        if RealTime() > runtime then
            if #text < #order_message then
                drawn_text = drawn_text .. order_message[#text + 1]
                text = text .. order_message[#text + 1]
                
                if #text % 37 == 0 then
                    drawn_text = drawn_text .. "\n"
                    self:SetSize(420, 75 + 18 * (#text/37))
                end

                surface.PlaySound("transmission/beep.wav")
            end

            runtime = RealTime() + 0.05
        end

        if ( self.CreateTime < 0 and not self.Removing ) then
            surface.PlaySound("transmission/close.wav")
            self:MoveTo( ScrW( ) / 2 - 210 , -150 , 0.25 , 0 , 5 , function( )
                self:Remove( )
            end )

            self.Removing = true
        else
            self.CreateTime = self.CreateTime - FrameTime( )
        end

        mellowcholy.scanline( 0, 0, w, h, h )
    end
end

function PANEL:OnRemove( )
    if ( self.Removing and self.CreateTime ~= -1 ) then end
end

vgui.Register("dOrders", PANEL, "DPanel")

local _orders = nil

net.Receive("Orders", function()
    local message = net.ReadString()

    if _orders then
        _orders:Remove()
        _orders = nil
    end
    _orders = vgui.Create("dOrders")
    _orders:SetMessage(message)
    surface.PlaySound("transmission/launch.wav")

    timer.Create( "OfficerSound", 1, 1, function()
		surface.PlaySound("transmission/officer.wav")
	end)
end)
