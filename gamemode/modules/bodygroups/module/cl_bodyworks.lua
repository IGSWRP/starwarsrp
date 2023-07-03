-- Fire's body group and swap model manager
IG.BODYWORKS = {}

function IG.BODYWORKS:OpenMenu()
    print("Opened bodyworks")
    local save_data = {}
    local saved_json = file.Read("bodyworks/data.json")
    if saved_json != nil then
        save_data = util.JSONToTable(saved_json)
    end
    local selected_preset = ""

    local frame = vgui.Create("DFrame")
    frame:SetSize(1000, 720)
    frame:SetTitle("Models")
    frame:Center()
    frame:SetVisible(true)
    frame:MakePopup()
    frame:ShowCloseButton(false)
    local header_blue = Color(2, 115, 255)
    local dark_grey = Color( 39, 39, 39)
    local light_grey = Color( 52, 52, 52)
    frame.Paint = function( self, w, h )
        draw.RoundedBox(5, 0, 0, w, h, light_grey)
        draw.RoundedBox(5, 0, 0, 84, h, dark_grey)
    end

    close_button = vgui.Create("DButton", frame)
    close_button:SetIcon('icon16/cross.png')
    close_button:SetPos(977, 0)
    close_button:SetText("")
    close_button:SetSize(24, 24)
    close_button.Paint = function(self, w, h) end
    close_button.DoClick = function()
        frame:Close()
    end

    local models = player_manager.RunClass(LocalPlayer(), "GetModels")
    
    local player_model = vgui.Create("DModelPanel", frame)
    player_model:SetPos(100, 35)
    player_model:SetSize( player_model:GetParent():GetWide()*(2/3) - 8, player_model:GetParent():GetTall() - 40 )
    player_model:SetModel(LocalPlayer():GetModel()) -- you can only change colors on playermodels
    player_model.Angles = angle_zero
    player_model.Entity:SetSkin(LocalPlayer():GetSkin())
    for k = 0, player_model.Entity:GetNumBodyGroups() - 1 do
        if (player_model.Entity:GetBodygroupCount(k) <= 1) then continue end
        player_model.Entity:SetBodygroup(k, LocalPlayer():GetBodygroup(k))
    end
    
    function player_model:DragMousePress()
        self.PressX, self.PressY = gui.MousePos()
        self.Pressed = true
    end
    
    function player_model:DragMouseRelease() self.Pressed = false end
    
    local taunt = player_model.Entity:LookupSequence("taunt_dance")
    
    function player_model:LayoutEntity(ent)
        player_model:RunAnimation()
    
        if ( self.Pressed ) then
            local mx = gui.MousePos()
            self.Angles = self.Angles - Angle( 0, ( ( self.PressX or mx ) - mx ) / 2, 0 )
    
            self.PressX, self.PressY = gui.MousePos()
        end
    
        ent:SetAngles( self.Angles )
    end
    
    local function UpdateBodyGroups(pnl, val)
        if pnl.type == "bgroup" then
            pnl.model.Entity:SetBodygroup( pnl.typenum, math.Round( val ) )
        end
        if pnl.type == "skin" then
            pnl.model.Entity:SetSkin( math.Round( val ) )
        end
    end
    
    local bglist = vgui.Create("DPanelList", frame)
    bglist:SetSize(300, 500)
    bglist:SetPos(690, 25)
    bglist:SetPadding(10)
    
    bglist.Paint = function( self, w, h )
        draw.RoundedBox(5, 0, 0, w + 5, h, dark_grey)
    end
    
    local function RenderBodyGroups(model)
        bglist:Clear()
        local skin = model.Entity:GetSkin()
        skincount = model.Entity:SkinCount()
        if (skincount > 1) then
            local bgroup = vgui.Create("DNumSlider")
            bgroup:SetMinMax(0, skincount - 1)
            bgroup:SetDecimals(0)
            bgroup:SetText("Skin")
            bgroup:SetValue(skin)
            bgroup.type = "skin"
            bgroup.model = model
            bgroup:SetDecimals(0)
            bgroup.OnValueChanged = UpdateBodyGroups
            bglist:AddItem(bgroup)
        end
        local bodygroups = model.Entity:GetBodyGroups()
    
        for k, v in ipairs(bodygroups) do
            
            if v.num < 2 then continue end
    
            local bgroup = vgui.Create("DNumSlider")
            bgroup:SetMinMax(0, v.num - 1)
            bgroup.type = "bgroup"
            bgroup:SetDecimals(0)
            bgroup:SetText(v.name)
            bgroup:SetValue(model.Entity:GetBodygroup(v.id))
            bgroup.typenum = v.id
            bgroup.model = model
            bgroup:SetDecimals(0)
            bgroup.OnValueChanged = UpdateBodyGroups
            bglist:AddItem(bgroup)
        end
    end
    
    RenderBodyGroups(player_model)
    
    local scroll = vgui.Create( "DScrollPanel", frame) -- Create the Scroll panel
    scroll:SetSize(100, 719)

    local scrollbar = scroll:GetVBar()
    function scrollbar:Paint(w, h) end
    function scrollbar.btnUp:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, dark_grey)
    end
    function scrollbar.btnDown:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, dark_grey)
    end
    function scrollbar.btnGrip:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, dark_grey)
    end

    local mlist = vgui.Create("DIconLayout", scroll)
    mlist:SetSize(84, 719)
    mlist:SetPos(0, 5)
    mlist:SetBorder(10)
    mlist:SetSpaceY(10)

    for k, v in ipairs(models) do
        local other_mdlbox = mlist:Add("DPanel")
        
        other_mdlbox:SetSize(64, 64)
        other_mdlbox.Paint = function( self, w, h )
            draw.RoundedBox( 5, 0, 0, w, h, light_grey )
        end
        local other_mdl = vgui.Create("DModelPanel", other_mdlbox)
        other_mdl:SetSize(64, 64)
        other_mdl:SetModel(v)
        other_mdl.model = v

        local prev_data = save_data[other_mdl.model]
        if prev_data != nil then
            vals = string.Explode("|", prev_data)
            other_mdl.Entity:SetSkin(tonumber(vals[1]))
            other_mdl.Entity:SetBodyGroups(vals[2])
        end

        local target_bone = other_mdl.Entity:LookupBone("ValveBiped.Bip01_Head1")
        if(target_bone != nil) then
            local eyepos = other_mdl.Entity:GetBonePosition(target_bone)
            eyepos:Add(Vector(0, 0, 3))	-- Move up slightly
            other_mdl:SetLookAt(eyepos)
            other_mdl:SetCamPos(eyepos-Vector(-16, 0, 0))	-- Move cam in front of eyes
            other_mdl.Entity:SetAngles(Angle(0, 10, 0))
        else
            local mn, mx = other_mdl.Entity:GetRenderBounds()
            local size = 0
            size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
            size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
            size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

            other_mdl:SetFOV( 45 )
            other_mdl:SetCamPos( Vector( size, size, size ) )
            other_mdl:SetLookAt( (mn + mx) * 0.5 )
            other_mdl.Entity:SetAngles(Angle(0, 69, 0))
        end

        function other_mdl:LayoutEntity(ent) return end
    
        other_mdl.DoClick = function(other_mdl)
            player_model:SetModel(other_mdl.model)
            local prev_data = save_data[other_mdl.model]
            if prev_data != nil then
                vals = string.Explode("|", prev_data)
                player_model.Entity:SetSkin(tonumber(vals[1]))
                player_model.Entity:SetBodyGroups(vals[2])
            end
            RenderBodyGroups(player_model)
            selected_preset = ""
        end
    end

    local preset_data = {}
    local preset_json = file.Read("bodyworks/presets.json")

    if preset_json != nil then
        preset_data = util.JSONToTable(preset_json)
        for k, v in pairs(preset_data) do
            local vals = string.Explode("|", v)
            local pref_mdlbox = mlist:Add("DPanel")
            
            pref_mdlbox:SetSize(64, 64)
            pref_mdlbox.Paint = function(self, w, h)
                draw.RoundedBox(5, 0, 0, w, h, light_grey)
            end

            local pref_mdl = vgui.Create("DModelPanel", pref_mdlbox)
            pref_mdl:SetSize(64, 64)
            pref_mdl:SetModel(vals[1])
            pref_mdl.model = vals[1]
            pref_mdl.Entity:SetSkin(tonumber(vals[2]))
            pref_mdl.Entity:SetBodyGroups(vals[3])

            local target_bone = pref_mdl.Entity:LookupBone("ValveBiped.Bip01_Head1")
            if(target_bone != nil) then
                local eyepos = pref_mdl.Entity:GetBonePosition(target_bone)
                eyepos:Add(Vector(0, 0, 3))	-- Move up slightly
                pref_mdl:SetLookAt(eyepos)
                pref_mdl:SetCamPos(eyepos-Vector(-16, 0, 0))	-- Move cam in front of eyes
                pref_mdl.Entity:SetAngles(Angle(0, 10, 0))
            else
                local mn, mx = pref_mdl.Entity:GetRenderBounds()
                local size = 0
                size = math.max( size, math.abs(mn.x) + math.abs(mx.x) )
                size = math.max( size, math.abs(mn.y) + math.abs(mx.y) )
                size = math.max( size, math.abs(mn.z) + math.abs(mx.z) )

                pref_mdl:SetFOV( 45 )
                pref_mdl:SetCamPos( Vector( size, size, size ) )
                pref_mdl:SetLookAt( (mn + mx) * 0.5 )
                pref_mdl.Entity:SetAngles(Angle(0, 69, 0))
            end

            function pref_mdl:LayoutEntity(ent) return end
        
            pref_mdl.DoClick = function(pref_mdl)
                player_model:SetModel(pref_mdl.model)
                player_model.Entity:SetSkin(tonumber(vals[2]))
                player_model.Entity:SetBodyGroups(vals[3])
                RenderBodyGroups(player_model)
                selected_preset = k
            end

            remove_button = vgui.Create("DButton", pref_mdlbox)
            remove_button:SetIcon('icon16/cross.png')
            remove_button:SetPos(42, 0)
            remove_button:SetText("")
            remove_button:SetSize(24, 24)
            remove_button.Paint = function(self, w, h) end

            remove_button.DoClick = function()
                preset_data[k] = nil
                preset_json = util.TableToJSON(preset_data)
                if not file.Exists("bodyworks", "DATA") then
                    file.CreateDir("bodyworks")
                end
                file.Write("bodyworks/presets.json", preset_json)
                frame:Close()
            end

        end
    end

    local add_preset = mlist:Add("DButton")
    add_preset:SetSize(64, 64)
    add_preset:SetText("")
    add_preset.Paint = function( self, w, h )
        draw.RoundedBox( 5, 0, 0, w, h, light_grey)
        draw.RoundedBox(0, 30, 16, 4, 32, dark_grey)
        draw.RoundedBox(0, 16, 30, 32, 4, dark_grey)
    end
    add_preset.DoClick = function()
        local bg_string = ""
        for k = 0, player_model.Entity:GetNumBodyGroups() - 1 do
            bg_string = bg_string .. player_model.Entity:GetBodygroup(k)
        end
        local random_string = ""
        for i = 1, 5 do
            random_string = random_string .. string.char(math.random(97, 122))
        end
        preset_data["preset#" .. random_string] = player_model:GetModel() .. "|" .. player_model.Entity:GetSkin() .. "|" .. bg_string
        preset_json = util.TableToJSON(preset_data)
        if not file.Exists("bodyworks", "DATA") then
            file.CreateDir("bodyworks")
        end
        file.Write("bodyworks/presets.json", preset_json)
        frame:Close()
    end

    save_button = vgui.Create("DButton", frame)
    save_button:SetText("")
    save_button:SetPos(707, 620)
    save_button:SetSize(269, 69)
    -- save_button:SetTextColor(dark_grey)
    save_button.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, header_blue)
        draw.DrawText("Apply", "Trebuchet24", w / 2, h / 3.5, Color(255,255,255), TEXT_ALIGN_CENTER)
    end
    save_button.DoClick = function()
        local save_model = player_model:GetModel()
        local save_skin = player_model.Entity:GetSkin()
        local save_bodygroups = {}
        local stringToSend = ""
        for k = 0, player_model.Entity:GetNumBodyGroups() - 1 do
            stringToSend = stringToSend .. player_model.Entity:GetBodygroup(k)
            table.insert(save_bodygroups, k, player_model.Entity:GetBodygroup(k))
        end
        net.Start("bodyworks_apply")
        net.WriteString(player_model:GetModel())
        net.WriteUInt(player_model.Entity:GetSkin(), 5)
        net.WriteString(stringToSend)
		net.SendToServer()
        if selected_preset != "" then
            save_data.current_model = selected_preset
            preset_data[selected_preset] = save_model .. "|" .. save_skin .. "|" .. stringToSend
            preset_json = util.TableToJSON(preset_data)
            if not file.Exists("bodyworks", "DATA") then
                file.CreateDir("bodyworks")
            end
            file.Write("bodyworks/presets.json", preset_json)
            
        else
            save_data.current_model = save_model
            save_data[save_model] = save_skin .. "|" .. stringToSend
        end

        save_json = util.TableToJSON(save_data)
        if not file.Exists("bodyworks", "DATA") then
            file.CreateDir("bodyworks")
        end
        file.Write("bodyworks/data.json", save_json)
        frame:Close()
    end
end

function IG.BODYWORKS:LoadPrevious()
    print("Attempting to load bodygroups for model")

    local saved_json = file.Read("bodyworks/data.json")
    if saved_json == nil then
        print("No saved data for bodyworks found, skipping init of model")
        return
    end

    local save_data = util.JSONToTable(saved_json)

    local init_model = ""
    local init_skin = ""
    local init_bodygroups = ""

    local valid_models = player_manager.RunClass(LocalPlayer(), "GetModels")

    if (save_data.current_model == nil or !table.HasValue(valid_models, save_data.current_model) and !string.StartWith(save_data.current_model, "preset#")) then
        local current_model = LocalPlayer():GetModel()

        local current_model_data = save_data[current_model]
        if current_model_data == nil then
            print("No saved data found for cuurrent model, skipping bodygroups")
            return
        end
        local vals = string.Explode("|", current_model_data)
        init_model = current_model
        init_skin = vals[1]
        init_bodygroups = vals[2]
    else
        if string.StartWith(save_data.current_model, "preset#") then
            local preset_json = file.Read("bodyworks/presets.json")
            if preset_json == nil then
                print("No presets for bodyworks found when preset defined")
                return
            end
            local preset_data = util.JSONToTable(preset_json)
            local prev_data = preset_data[save_data.current_model]
            if prev_data == nil then
                -- unlikely that someone's previous model is set to a preset but they don't have that preset anymore
                print("No saved preset found, skipping init of model")
                return
            end
            local vals = string.Explode("|", prev_data)
            init_model = vals[1]
            init_skin = vals[2]
            init_bodygroups = vals[3]

            if !table.HasValue(valid_models, init_model) then
                print("Skipping invalid preset")
                local current_model = LocalPlayer():GetModel()

                local current_model_data = save_data[current_model]
                if current_model_data == nil then
                    print("No saved data found for cuurrent model, skipping bodygroups")
                    return
                end
                local vals = string.Explode("|", current_model_data)
                init_model = current_model
                init_skin = vals[1]
                init_bodygroups = vals[2]
            end
        else
            local prev_data = save_data[save_data.current_model]
            if prev_data == nil then
                -- also unlikely
                print("No saved data found for bodyworks model, skipping init of model")
                return
            end
            local vals = string.Explode("|", prev_data)
            init_model = save_data.current_model
            init_skin = vals[1]
            init_bodygroups = vals[2]
        end
    end

	net.Start("bodyworks_apply")
    net.WriteString(init_model)
    net.WriteUInt(tonumber(init_skin), 5)
    net.WriteString(init_bodygroups)
    net.SendToServer()
end

concommand.Add("cl_modelmenu", function()
	IG.BODYWORKS:OpenMenu()
end)

net.Receive("bodyworks_open", function(len, ply)
    IG.BODYWORKS:OpenMenu()
end)

concommand.Add("cl_bodyworks_reset", function()
	if not file.Exists("bodyworks", "DATA") then
        file.CreateDir("bodyworks")
    end
    file.Write("bodyworks/data.json", "{}")
    file.Write("bodyworks/presets.json", "{}")
end)

list.Set("DesktopWindows", "Bodyworks", {
	title = "Bodyworks",
	icon = "icon64/playermodel.png",
	init = function( icon, window )
		IG.BODYWORKS:OpenMenu()
	end
})

net.Receive("bodyworks_load", function(len, ply)
    IG.BODYWORKS:LoadPrevious()
end)

hook.Add("InitPostEntity", "InitPlayerSpawnModel", function(ply)
    IG.BODYWORKS:LoadPrevious()
end)
