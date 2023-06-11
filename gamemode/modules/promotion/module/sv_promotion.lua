local meta = FindMetaTable("Player")

-- We don't really garbage collect this unless this file is reloaded, but it shouldn't be a large table anyway
-- Note that events will be invalidated if unlucky enough to have reloaded this file while an invite is out
local RegimentInvites = {}
for k,v in pairs(IG.Regiments) do
    RegimentInvites[k] = {}
end

util.AddNetworkString("PromotePlayer")

net.Receive("PromotePlayer", function(_, ply)
    if IG.Regiments[ply:GetRegiment()].ranks[ply:GetRank()].cl < 2 then return end

    local target = net.ReadEntity()

    if !target then
        print("recieved net message with non-existent player")
        return
    end

    if !ply:CanPromote(target) then
        print(ply:SteamID64(), "attempted to promote", target:SteamID64())
        return
    end

    if target:GetRegiment() == "RECRUIT" then
        local regiment = "ST"
        target:SetRegiment(regiment)
    else
        local rank = target:GetRank() + 1
        if !IG.Regiments[target:GetRegiment()].ranks[rank] then return end
        target:SetRank(rank)
    end

    player_manager.RunClass(target, "SaveCharacterData")
end)

util.AddNetworkString("DemotePlayer")

net.Receive("DemotePlayer", function(_, ply)
    if IG.Regiments[ply:GetRegiment()].ranks[ply:GetRank()].cl < 2 or ply:GetRegiment() == "RECRUIT" then return end

    local target = net.ReadEntity()

    if !target then
        print("recieved net message with non-existent player")
        return
    end

    if !ply:CanDemote(target) then
        print(ply:SteamID64(), "attempted to demote", target:SteamID64())
        return
    end

    local weapons_old = target:AvailableWeapons()
    local rank = target:GetRank() - 1
    if rank == 0 then -- set to recruit if they're the minimum rank
        local rank = 1
        local regiment = "RECRUIT"
        local class = ""
        target:SetRank(rank)
        target:SetRegiment(regiment)
        target:SetRegimentClass(class)
    else
        target:SetRank(rank)
    end

    player_manager.RunClass(target, "SaveCharacterData")

    -- Get rid of any weapons they shouldn't have access to anymore
    local weapons_new = target:AvailableWeapons()
    for i=1, #weapons_old do
        if !table.HasValue(weapons_new, weapons_old[i]) then
            target:StripWeapon(weapons_old[i])
        end
    end
end)

util.AddNetworkString("SetPlayersClass")

net.Receive("SetPlayersClass", function(_, ply)
    local target = net.ReadEntity()
    local class = net.ReadString()

    if !target then
        print("recieved net message with non-existent player")
        return
    end

    if !ply:CanSetClass(target) then
        print(ply:SteamID64(), "attempted to set class of", target:SteamID64())
        return
    end

    local weapons_old = target:AvailableWeapons()

    target:SetRegimentClass(class)
    player_manager.RunClass(target, "SaveCharacterData")
    
    local weapons_new = target:AvailableWeapons()

    for i=1, #weapons_old do
        if !table.HasValue(weapons_new, weapons_old[i]) then
            target:StripWeapon(weapons_old[i])
        end
    end
end)

util.AddNetworkString("Regiment.SendInvitation")

net.Receive("Regiment.SendInvitation", function(_, ply)
    local target = net.ReadEntity()

    if !target then
        print("recieved net message with non-existent player")
        return
    end

    if !ply:CanInvite(target) then
        print(ply:SteamID64(), "attempted to invite", target:SteamID64())
        return
    end
    
    RegimentInvites[ply:GetRegiment()][target:AccountID()] = os.time()

    net.Start("Regiment.SendInvitation")
    net.WriteEntity(ply)
    net.WriteString(ply:GetRegiment())
    net.Send(target)
end)

util.AddNetworkString("Regiment.ReplyInvitation")

net.Receive("Regiment.ReplyInvitation", function(_, ply)
    local inviter = net.ReadEntity()
    local accepted = net.ReadBool()

    if !inviter then
        print("recieved net message with non-existent player")
        return
    end

    if !inviter:CanInvite(ply) then
        print(inviter:SteamID64(), "attempted to accept invalid invite", ply:SteamID64())
        return
    end

    if !accepted then
        inviter:ChatPrint(ply:GetName() .. " declined")
        return
    end

    -- invites expire after 1 minute
    if RegimentInvites[inviter:GetRegiment()][ply:AccountID()] and (os.difftime(os.time(), RegimentInvites[inviter:GetRegiment()][ply:AccountID()]) < 60) then
        local weapons_old = ply:AvailableWeapons()

        ply:SetRegiment(inviter:GetRegiment())
        ply:SetRank(math.max(ply:GetRank() - 2, 1))
        ply:SetRegimentClass("")
        player_manager.RunClass(ply, "SaveCharacterData")
        
        local weapons_new = ply:AvailableWeapons()

        for i=1, #weapons_old do
            if !table.HasValue(weapons_new, weapons_old[i]) then
                ply:StripWeapon(weapons_old[i])
            end
        end

        inviter:ChatPrint(ply:GetName() .. " has joined your regiment!")
    else
        print(ply:SteamID64() .. " attempted to use an invalid invite")
        inviter:ChatPrint(ply:GetName() .. " attempted to use an invalid regiment invite")
    end
end)

util.AddNetworkString("EditPlayer")

net.Receive("EditPlayer", function(_, ply)
    if !ply:IsAdmin() then return end

    local target = net.ReadEntity()
    local regiment = net.ReadString()
    local rank = net.ReadUInt(8)
    local class = net.ReadString()

    if !target then
        print("recieved net message with non-existent player")
        return
    end

    local weapons_old = target:AvailableWeapons()

    target:SetRegiment(regiment)
    target:SetRank(rank)
    target:SetRegimentClass(class)
    player_manager.RunClass(target, "SaveCharacterData")
    
    local weapons_new = target:AvailableWeapons()

    for i=1, #weapons_old do
        if !table.HasValue(weapons_new, weapons_old[i]) then
            target:StripWeapon(weapons_old[i])
        end
    end
end)
