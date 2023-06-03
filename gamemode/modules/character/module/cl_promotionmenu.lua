local function PromotionMenu()
    local players = {}

    local frame = vgui.Create("DFrame")
    frame:SetSize(1024, 720)
    frame:SetTitle("Promotion Menu")
    frame:Center()
    frame:SetVisible(true)
    frame:MakePopup()

    list = vgui.Create("DListView", frame)
    list:SetPos(0, 25)
    list:SetSize(1024, 695)
    list:SetMultiSelect(false)
    list:AddColumn("Name")
    list:AddColumn("Regiment")
    list:AddColumn("Rank"):SetMaxWidth(30)
    list:AddColumn("Rank Name")
    list:AddColumn("Class")

    local promote = function(ply)
        net.Start("PromotePlayer")
        net.WriteString(ply:SteamID64() or "90071996842377216")
        net.SendToServer()
        frame:Close()
    end

    local demote = function(ply)
        net.Start("DemotePlayer")
        net.WriteString(ply:SteamID64() or "90071996842377216")
        net.SendToServer()
        frame:Close()
    end

    local setClass = function(ply, class)
        net.Start("SetPlayersClass")
        net.WriteString(ply:SteamID64() or "90071996842377216")
        net.WriteString(class)
        net.SendToServer()
        frame:Close()
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

        menu:Open()
    end

    local regiment = LocalPlayer():GetRegiment()
    for k,v in ipairs(player.GetAll()) do
        if v:GetRegiment() == regiment or v:GetRegiment() == "RECRUIT" or LocalPlayer():IsAdmin() then
            table.insert(players, v)
            list:AddLine(v:GetRPName(), v:GetRegimentName() or "INVALID", v:GetRank(), v:GetRankName() or "INVALID", v:GetClassName() or "INVALID")
        end
    end

    list:SortByColumns(3, true, 2, true)
end

concommand.Add("promotion_menu", PromotionMenu)