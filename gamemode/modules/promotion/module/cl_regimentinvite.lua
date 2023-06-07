local invite_description = "%s has invited you to join their regiment!"

local PANEL = { }
PANEL.Player = nil

function PANEL:Init( )
    self:SetSize( 300 , 128 )
    self:SetPos( ScrW( ) , ScrH( ) / 2 - 160 )
end

function PANEL:SetPlayer(ply, regiment)
    self.Avatar = vgui.Create( "AvatarImage" , self )
    self.Avatar:SetSize( 64 , 64 )
    self.Avatar:SetPos( 8 , 32 )
    self.Avatar:SetPlayer( ply , 64 )

    self.Player = ply
    self.Enabled = true
    self.Regiment = regiment
    self.CreateTime = 15.9
    surface.SetFont( "Trebuchet18" )
    local bX , _ = surface.GetTextSize( string.format(invite_description, self.Player:Nick( ) ) )
    local dX , _ = surface.GetTextSize( self.Regiment )
    local wide = ( bX > dX and bX or dX ) + 88
    self:SetSize( wide , 86 )
    self:MoveTo( ScrW( ) - wide , ScrH( ) / 2 - 160 , 0.25 , 0 , 5 )
end

function PANEL:Paint( w , h )
    if ( self.Enabled ) then
        if ( not IsValid( self.Player ) ) then
            self:Remove( )

            return
        else
            -- util.DrawBlur( self , 2 , 4 )
            local col = (IG.Regiments[self.Player:GetRegiment()] or {}).colour or Color(155, 25, 25, 100)
            surface.SetDrawColor( col.r , col.g , col.b , 100 )
            surface.DrawRect( 0 , 0 , w , h )
            surface.SetDrawColor( 0 , 0 , 0 , 150 )
            surface.DrawOutlinedRect( 0 , 0 , w , h )
            local dx , _ = draw.SimpleText(string.format(invite_description, self.Player:Nick( ) ), "Trebuchet18", w - 8, 8, color_white, TEXT_ALIGN_RIGHT)
            draw.SimpleText(IG.Regiments[self.Regiment].name , "DermaLarge" , w - 8 - dx , 26 , color_white , TEXT_ALIGN_LEFT )
            self.Avatar:SetPos(w - 16 - dx - 64, 8)
            draw.SimpleText("( K ) To accept", "Trebuchet18" , w - 8 , 56 , Color(150, 255 , 50) , TEXT_ALIGN_RIGHT)
            draw.SimpleText("( L ) To refuse", "Trebuchet18" , w - 8 - 92 , 56 , Color(255, 100, 50) , TEXT_ALIGN_RIGHT)
            surface.SetDrawColor( util.GetProgressColor( 255 , ( self.CreateTime / 16 ) * 100 ) )
            surface.DrawRect( 1 , h - 5 , w - 2 , 4 )
            surface.SetDrawColor( Color( 0 , 0 , 0 , 100 ) )
            surface.DrawRect( 1 , h - 5 , w - 2 , 4 )
            surface.SetDrawColor( util.GetProgressColor( 255 , ( self.CreateTime / 16 ) * 100 ) )
            surface.DrawRect( 1 , h - 5 , ( self.CreateTime / 16 ) * w - 2 , 4 )

            if ( self.CreateTime < 0 and not self.Removing ) then
                self:MoveTo( ScrW( ) , ScrH( ) / 2 - 160 , 0.25 , 0 , 5 , function( )
                    self:Remove( )
                end )

                self.Removing = true
            else
                self.CreateTime = self.CreateTime - FrameTime( )
            end
        end
    end
end

function PANEL:Think( )
    if ( not vgui.CursorVisible( ) and not self.Removing ) then
        if ( input.IsKeyDown( KEY_K ) ) then
            net.Start( "Regiment.ReplyInvitation" )
            net.WriteEntity( self.Player )
            net.WriteBool( true )
            net.SendToServer( )
            self.CreateTime = -1
        end

        if ( input.IsKeyDown( KEY_L ) ) then
            self.CreateTime = -1
        end
    end
end

function PANEL:OnRemove( )
    if ( self.Removing and self.CreateTime ~= -1 ) then
        -- net.Start( "Regiment.ReplyInvitation" )
        -- net.WriteEntity( self.Player )
        -- net.WriteBool( false )
        -- net.SendToServer( )
    end
end

function util.GetProgressColor( a , am )
    local col = Color( 231 , 76 , 60 , a )

    if ( am > 30 ) then
        if ( am < 50 ) then
            col = Color( 230 , 126 , 34 , a )
        elseif ( am < 75 ) then
            col = Color( 241 , 196 , 15 , a )
        else
            col = Color( 46 , 204 , 113 , a )
        end
    end

    return col
end

derma.DefineControl("dRegimentInvitation", "Invite to regiment", PANEL, "DPanel")

local _invitation = nil

net.Receive("Regiment.SendInvitation", function()
    local ply = net.ReadEntity()
    local reg = net.ReadString()

    if _invitation then
        _invitation:Remove()
        _invitation = nil
    end
    _invitation = vgui.Create("dRegimentInvitation")
    _invitation:SetPlayer(ply, reg)
end)
