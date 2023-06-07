local function EditPlayer(ply)
    local selected_reg
    local selected_rank
    local selected_class

    local frame = vgui.Create("DFrame")
    frame:SetSize(420, 160)
    frame:SetMinHeight(160)
    frame:SetMinWidth(320)
    frame:SetTitle("Edit Player")
    frame:SetPos(gui.MousePos())
    frame:SetVisible(true)
    frame:MakePopup()
    frame:SetSizable(true)

    local props = vgui.Create( "DProperties", frame )
    props:Dock(FILL)

    local regiment = props:CreateRow(ply:GetName(), "Regiment")
    local rank = props:CreateRow(ply:GetName(), "Rank")
    local class = props:CreateRow(ply:GetName(), "Class")
    
    regiment:Setup("Combo", {})
    for k,v in pairs(IG.Regiments) do
        if v.enabled == false then continue end
        regiment:AddChoice(v.name, k, ply:GetRegiment() == k)
        if ply:GetRegiment() == k then selected_reg = k end
    end

    local function populate_ranks()
        rank:Setup("Combo", {})
        if !selected_reg then return end

        local ranks = IG.Regiments[selected_reg].ranks
        for i=1, #ranks do
            rank:AddChoice(string.format("%02d | %s", i, ranks[i].name or "N/A"), i, ply:GetRank() == i or #ranks == 1)
            if ply:GetRank() == i or #ranks == 1 then selected_rank = i end
        end
    end
    populate_ranks()

    local function populate_class()
        class:Setup("Combo", {})
        if !selected_reg then return end

        class:AddChoice("", "", ply:GetRegimentClass() == "" or ply:GetRegiment() ~= selected_reg)
        if ply:GetRegimentClass() == "" or ply:GetRegiment() ~= selected_reg then selected_class = "" end

        local classes = IG.Regiments[selected_reg].classes
        if !classes then return end
        for k,v in pairs(classes) do
            class:AddChoice(v.name, k, ply:GetRegimentClass() == k)
            if ply:GetRegimentClass() == k then selected_class = k end
        end
    end
    populate_class()

    regiment.DataChanged = function(self, data)
        selected_reg = data
        populate_ranks()
        populate_class()
    end

    rank.DataChanged = function(self, data)
        selected_rank = data
    end

    class.DataChanged = function(self, data)
        selected_class = data
    end

    local submit = vgui.Create("DButton", frame)
    submit:SetText("Submit")
    submit:Dock(BOTTOM)
    function submit:DoClick()
        
        if !selected_reg or !selected_rank or !selected_class then return end

        net.Start("EditPlayer")
        net.WriteEntity(ply)
        net.WriteString(selected_reg)
        net.WriteUInt(selected_rank, 8)
        net.WriteString(selected_class)
        net.SendToServer()
        frame:Close()
    end
end

local function PromotionMenu()
    local players = {}

    local frame = vgui.Create("DFrame")
    frame:SetSize(1024, 720)
    frame:SetTitle("Promotion Menu")
    frame:Center()
    frame:SetVisible(true)
    frame:MakePopup()
    frame:SetSizable(true)

    local list = vgui.Create("DListView", frame)
    list:Dock(FILL)
    list:SetMultiSelect(false)
    list:AddColumn("Name")
    list:AddColumn("Regiment")
    list:AddColumn("Rank"):SetMaxWidth(40)
    list:AddColumn("Rank Name")
    list:AddColumn("Class")

    local promote = function(ply)
        net.Start("PromotePlayer")
        net.WriteEntity(ply)
        net.SendToServer()
    end

    local demote = function(ply)
        net.Start("DemotePlayer")
        net.WriteEntity(ply)
        net.SendToServer()
    end

    local setClass = function(ply, class)
        net.Start("SetPlayersClass")
        net.WriteEntity(ply)
        net.WriteString(class)
        net.SendToServer()
    end

    local invite = function(ply)
        net.Start("Regiment.SendInvitation")
        net.WriteEntity(ply)
        net.SendToServer()
    end

    list.OnRowRightClick = function(self, index, row)
        local player = players[index]
        local menu = DermaMenu()

        if LocalPlayer():CanPromote(player) then
            menu:AddOption("Promote", function() promote(player) end):SetIcon("icon16/arrow_up.png")
        end

        if LocalPlayer():CanDemote(player) then
            menu:AddOption("Demote", function() demote(player) end):SetIcon("icon16/arrow_down.png")
        end

        if LocalPlayer():CanSetClass(player) then
            local subMenu, _ = menu:AddSubMenu("Set Class")

            local classes = (IG.Regiments[player:GetRegiment()] or {}).classes

            subMenu:AddOption("Remove", function() setClass(player, "") end):SetIcon("icon16/cross.png")

            for k,v in pairs(classes) do
                subMenu:AddOption(v.name, function() setClass(player, k) end):SetIcon("icon16/arrow_right.png")
            end
        end

        if LocalPlayer():CanInvite(player) then
            menu:AddOption("Invite", function() invite(player) end):SetIcon("icon16/email.png")
        end

        if LocalPlayer():IsAdmin() then
            menu:AddOption("Edit", function()
                EditPlayer(player)
            end)
        end

        menu:Open()
    end

    local regiment = LocalPlayer():GetRegiment()
    for k,v in ipairs(player.GetAll()) do
        if v:GetRegiment() == regiment or v:GetRegiment() == "RECRUIT" or LocalPlayer():IsAdmin() and v:GetRegiment() ~= "EVENT" then
            table.insert(players, v)
            local line = list:AddLine(v:GetRPName(), v:GetRegimentName() or "INVALID", v:GetRank(), v:GetRankName() or "N/A", v:GetClassName() or "INVALID")
            line.Think = function()
                line:SetColumnText(1, v:GetRPName())
                line:SetColumnText(2, v:GetRegimentName() or "INVALID")
                line:SetColumnText(3, v:GetRank())
                line:SetColumnText(4, v:GetRankName() or "N/A")
                line:SetColumnText(5, v:GetClassName() or "INVALID")
            end
        end
    end

    list:SortByColumns(2, false, 3, true, 1, false)

    if LocalPlayer().CanRunEvent and LocalPlayer():CanRunEvent() then
        local bottombar = vgui.Create("DPanel", frame)
        bottombar:SetSize(0, 25)
        bottombar:Dock(BOTTOM)
        bottombar:DockMargin(0,5,0,0)

        local event_button = vgui.Create("DButton", bottombar)
        event_button:SetSize(110, 0)
        event_button:SetText("Join Event")
        event_button:SetIcon("icon16/door_in.png")
        event_button:SetContentAlignment(4)
        event_button:Dock(RIGHT)
        event_button.DoClick = function()
            net.Start("JoinEvent")
            net.SendToServer()

            frame:Close()
        end
    end
end

concommand.Add("promotion_menu", PromotionMenu)
