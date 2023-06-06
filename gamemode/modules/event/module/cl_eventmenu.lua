local function EventMenu()
    local players = {}

    local frame = vgui.Create("DFrame")
    frame:SetSize(1024, 720)
    frame:SetTitle("Event Menu")
    frame:Center()
    frame:SetVisible(true)
    frame:MakePopup()
    frame:SetSizable(true)

    local topbar = vgui.Create("DPanel", frame)
    topbar:SetSize(0, 25)
    topbar:Dock(TOP)
    topbar:DockMargin(0,0,0,5)

    local preset_label = vgui.Create( "DLabel", topbar )
    preset_label:SetSize(50, 0)
    preset_label:SetText("Preset:")
    preset_label:Dock(LEFT)
    preset_label:DockMargin(5, 0, 0, 0)

    local preset_default = vgui.Create( "DComboBox", topbar )
    preset_default:SetSize(125, 0 )
    preset_default:SetValue("Choose a default")
    preset_default:AddChoice( "Rebel" )
    preset_default:AddChoice( "Rebel Commander" )
    preset_default:AddChoice( "CIS Droid" )
    preset_default:Dock(LEFT)
    preset_default:DockMargin(0, 0, 5, 0)
    preset_default.OnSelect = function( self, index, value )
        print( value .. " was selected at index " .. index )
    end

    local preset_edit = vgui.Create("DButton", topbar)
    preset_edit:SetSize(25, 0)
    preset_edit:SetText("")
    preset_edit:SetImage("icon16/database_edit.png")
    preset_edit:Dock(LEFT)

    local invite_button = vgui.Create("DButton", topbar)
    invite_button:SetSize(75, 0)
    invite_button:SetText("Invite")
    invite_button:SetContentAlignment(4)
    invite_button:SetImage("icon16/user_add.png")
    invite_button:Dock(RIGHT)


    local list = vgui.Create("DListView", frame)
    list:Dock(FILL)
    list:SetMultiSelect(false)
    list:AddColumn("Name")
    list:AddColumn("Preset")

    for k,v in ipairs(player.GetAll()) do
        if v:GetRegiment() == "EVENT" then
            table.insert(players, v)
            local line = list:AddLine(v:GetRPName(), "Rebel Commander")
            line.Think = function()
                line:SetColumnText(1, v:GetRPName())
            end
        end
    end

    list:SortByColumns(2, true, 1, true)
end

concommand.Add("event_menu", EventMenu)
