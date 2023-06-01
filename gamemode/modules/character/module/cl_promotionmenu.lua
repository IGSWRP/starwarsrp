function PromotionMenu()
    local cl = IG.Regiments[LocalPlayer():GetRegiment()].ranks[LocalPlayer():GetRank()].cl

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
    list:AddColumn("Rank #")
    list:AddColumn("Rank Name")

    local promote = function(ply)
        net.Start("PromotePlayer")
        net.WriteString(ply:SteamID64())
        net.SendToServer()
        frame:Close()
    end

    local demote = function(ply)
        net.Start("DemotePlayer")
        net.WriteString(ply:SteamID64())
        net.SendToServer()
        frame:Close()
    end

    list.OnRowRightClick = function(self, index, row)
        if cl < 2 then return end
        local player = players[index]

        if player:GetRank() < LocalPlayer():GetRank() then
            local menu = DermaMenu() 
            menu:AddOption("Promote", function() promote(player) end)
            -- Recruits can't be demoted any further
            if player:GetRegiment() ~= "RECRUIT" then
                menu:AddOption("Demote", function() demote(player) end)
            end
            menu:Open()
        end
    end

    local regiment = LocalPlayer():GetRegiment()
    for k,v in ipairs(player.GetAll()) do
        if v:GetRegiment() == regiment or v:GetRegiment() == "RECRUIT" then
            table.insert(players, v)
            list:AddLine(v:GetRPName(), IG.Regiments[v:GetRegiment()].name, v:GetRank(), IG.Regiments[v:GetRegiment()].ranks[v:GetRank()].name)
        end
    end

    list:SortByColumns(3, true, 2, true)
end

concommand.Add("promotion_menu", PromotionMenu)