local function EditPreset(preset_name)
    local frame = vgui.Create("DFrame")
    frame:SetSize(720, 510)
    frame:SetTitle((preset_name and "Edit") or "Add" .. " preset")
    frame:SetPos(gui.MousePos())
    frame:SetVisible(true)
    frame:MakePopup()
    frame:SetSizable()

    local sheet = vgui.Create("DPropertySheet", frame)
    sheet:Dock(FILL)

    local detail_panel = vgui.Create("DPanel", sheet)

    local detail_props = vgui.Create( "DProperties", detail_panel)
    detail_props:Dock(FILL)
    local name_row = detail_props:CreateRow("", "Name")
    name_row:Setup("Generic")
    if false then -- disable editing existing name
        name_row:SetValue(preset_name)
        name_row:SetEnabled(false)
    end
    local health_row = detail_props:CreateRow("", "Health")
    health_row:Setup("Int", { min = 100, max = 1000})
    health_row:SetValue(100)

    local model_panel = vgui.Create("DPanel", sheet)

    local model_list = vgui.Create("DListView", model_panel)
    model_list:Dock(LEFT)
    model_list:SetSize(280, 0)
    model_list:SetMultiSelect(false)
    model_list:AddColumn("Model")
    
    local model_picker = vgui.Create("DPanel", model_panel)
    model_picker:Dock(RIGHT)
    model_picker:SetSize(400, 0)

    local model_search = vgui.Create("DTextEntry", model_picker)
    model_search:Dock(TOP)
    model_search:DockMargin(0, 0, 0, 5)
    model_search:SetPlaceholderText( "#spawnmenu.quick_filter" )
    model_search:SetUpdateOnType(true)
    
    local model_scroll = vgui.Create("DScrollPanel", model_picker)
    model_scroll:Dock( FILL )

    local model_icons = vgui.Create("DIconLayout", model_scroll)
    model_icons:Dock(FILL)
    
    for name, model in pairs(player_manager.AllValidModels()) do
        local icon = model_icons:Add("SpawnIcon")
        icon:SetModel(model)
        icon:SetSize(64,64)
        icon:SetTooltip(name)
        icon.playermodel = name
        icon.model_path = model
        icon.DoClick = function()
            local model_line = model_list:AddLine(model)
            model_line.OnRightClick = function()
                model_list:RemoveLine(model_line:GetID())
            end
        end
    end

    model_search.OnValueChange = function(s, str)
        for id, pnl in pairs(model_icons:GetChildren()) do
            if str ~= "" and ( !pnl.playermodel:find( str, 1, true ) && !pnl.model_path:find( str, 1, true ) ) then
                pnl:SetVisible(false)
            else
                pnl:SetVisible(true)
            end
        end
        model_icons:Layout()
    end

    local weapon_panel = vgui.Create("DPanel", sheet)

    local weapon_list = vgui.Create("DListView", weapon_panel)
    weapon_list:Dock(LEFT)
    weapon_list:SetSize(280, 0)
    weapon_list:SetMultiSelect(false)
    weapon_list:AddColumn("Weapon")
    
    local weapon_picker = vgui.Create("DPanel", weapon_panel)
    weapon_picker:Dock(RIGHT)
    weapon_picker:SetSize(400, 0)

    local weapon_search = vgui.Create("DTextEntry", weapon_picker)
    weapon_search:Dock(TOP)
    weapon_search:DockMargin(0, 0, 0, 5)
    weapon_search:SetPlaceholderText( "#spawnmenu.quick_filter" )
    weapon_search:SetUpdateOnType(true)
    
    local weapon_scroll = vgui.Create("DScrollPanel", weapon_picker)
    weapon_scroll:Dock( FILL )

    local weapon_icons = vgui.Create("DIconLayout", weapon_scroll)
    weapon_icons:Dock(FILL)
    
    for _, weapon in pairs(weapons.GetList()) do
        if string.EndsWith(weapon.ClassName, "_base") then continue end
        local icon = weapon_icons:Add("DImageButton")
        icon:SetImage(string.format("materials/entities/%s.png", weapon.ClassName))
        icon:SetSize(96,96)
        icon:SetTooltip(weapon.PrintName)
        icon.playerweapon = weapon.PrintName or ""
        icon.weapon_path = weapon.ClassName
        icon.DoClick = function()
            local weapon_line = weapon_list:AddLine(weapon.ClassName)
            weapon_line.OnRightClick = function()
                weapon_list:RemoveLine(weapon_line:GetID())
            end
        end
    end

    weapon_search.OnValueChange = function(s, str)
        for id, pnl in pairs(weapon_icons:GetChildren()) do
            if str ~= "" and ( !pnl.playerweapon:find( str, 1, true ) && !pnl.weapon_path:find( str, 1, true ) ) then
                pnl:SetVisible(false)
            else
                pnl:SetVisible(true)
            end
        end
        weapon_icons:Layout()
    end

    sheet:AddSheet("Details", detail_panel, "icon16/information.png")
    sheet:AddSheet("Models", model_panel, "icon16/user_suit.png")
    sheet:AddSheet("Weapons", weapon_panel, "icon16/gun.png")

    local bottombar = vgui.Create("DPanel", frame)
    bottombar:SetSize(0, 25)
    bottombar:Dock(BOTTOM)
    bottombar:DockMargin(0,5,0,0)

    local submit_button = vgui.Create("DButton", bottombar)
    submit_button:SetSize(100, 0)
    submit_button:SetText("Submit")
    submit_button:Dock(RIGHT)
end

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
    preset_edit.DoClick = function()
        EditPreset("test")
    end

    local preset_add = vgui.Create("DButton", topbar)
    preset_add:SetSize(25, 0)
    preset_add:SetText("")
    preset_add:SetImage("icon16/database_add.png")
    preset_add:Dock(LEFT)
    preset_add.DoClick = function()
        EditPreset()
    end

    local invite_button = vgui.Create("DButton", topbar)
    invite_button:SetSize(75, 0)
    invite_button:SetText("Invite")
    invite_button:SetContentAlignment(4)
    invite_button:SetImage("icon16/user_add.png")
    invite_button:Dock(RIGHT)
    invite_button:DockMargin(5, 0, 0, 0)

    local options_button = vgui.Create("DButton", topbar)
    options_button:SetSize(85, 0)
    options_button:SetText("Options")
    options_button:SetContentAlignment(4)
    options_button:SetImage("icon16/cog.png")
    options_button:Dock(RIGHT)

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
