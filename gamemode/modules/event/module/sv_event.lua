IG.EventPresets = IG.EventPresets or {}

local meta = FindMetaTable("Player")

util.AddNetworkString("SyncPresets")

function meta:SwitchToEvent(preset)
    if self:CanRunEvent() then
        local event_json = util.TableToJSON(IG.EventPresets) or "{}"
        net.Start("SyncPresets")
        net.WriteString(event_json)
        net.Send(self)
    end

    player_manager.SetPlayerClass(self, "player_event")
    self:StripWeapons()
    if preset then
        self:SetEventPreset(preset)
        player_manager.RunClass(self, "Spawn")
        player_manager.RunClass(self, "SetModel")
        player_manager.RunClass(self, "Loadout")
    end
    self:Spawn()
    self:ChatPrint("Switched to event character")
end

function meta:SwitchFromEvent()
    player_manager.SetPlayerClass(self, "player_imperial")
    self:StripWeapons()
    self:Spawn()
    self:ChatPrint("No longer playing as event character")
end

local sub = string.sub
hook.Add("PlayerSay", "IG.Event", function(ply, text)
    if !ply:CanRunEvent() then
        ply:ChatPrint("You do not have permission")
        return ""
    end
    
    local prefix = sub(text, 1, 1)
    if prefix ~= "/" then return end

    local cmd = sub(text, 2)

    if cmd == "event" then
        ply:SwitchToEvent()
    elseif cmd == "imperial" then
        ply:SwitchFromEvent()
    else
        return
    end

    return ""
end)

util.AddNetworkString("EditPreset")

net.Receive("EditPreset", function(_, ply)
    if !ply:CanRunEvent() then return end
    
    local name = net.ReadString()
    local health = net.ReadUInt(16)
    local models = net.ReadString()
    local weps = net.ReadString()

    IG.EventPresets[name] = { health = health, models = string.Explode(",", models), weapons = string.Explode(",", weps) }
    
    -- Network the change back to EM(s)
    for _, v in ipairs(player.GetHumans()) do
        if ply:CanRunEvent() and ply:GetRegiment() == "EVENT" then
            net.Start("EditPreset")
            net.WriteString(name)
            net.WriteUInt(health, 16)
            net.WriteString(models)
            net.WriteString(weps)
            net.Send(v)
        end
    end
end)

util.AddNetworkString("SetPlayersPreset")

net.Receive("SetPlayersPreset", function(_, ply)
    if !ply:CanRunEvent() then return end

    local target = net.ReadEntity()
    local preset = net.ReadString()

    if !target then
        print("recieved net message with non-existent player")
        return
    end

    -- This won't fully apply until they respawn
    target:SetEventPreset(preset)
end)

util.AddNetworkString("Event.SendInvitation")

net.Receive("Event.SendInvitation", function(_, ply)
    if !ply:CanRunEvent() then return end

    local preset = net.ReadString()

    -- TODO: Check if invite was sent

    for k,v in ipairs(player.GetHumans()) do
        if v:GetRegiment() == "EVENT" then continue end
        -- TODO: Check for a blacklist or something
        net.Start("Event.SendInvitation")
        net.WriteEntity(ply)
        net.WriteString(preset)
        net.Send(v)
    end
end)

util.AddNetworkString("Event.ReplyInvitation")

net.Receive("Event.ReplyInvitation", function(_, ply)
    local inviter = net.ReadEntity()
    local preset = net.ReadString()
    local accepted = net.ReadBool()

    if !inviter then
        print("recieved net message with non-existent player")
        return
    end

    if !inviter:CanRunEvent() then
        print(inviter:SteamID64(), "attempted to accept invalid invite", ply:SteamID64())
        return
    end

    -- incase they've already been set
    if ply:GetRegiment() == "EVENT" then return end

    -- TODO: Check that the invite was actually sent

    -- we don't actually implement denying an invite yet but whatever
    if !accepted then
        inviter:ChatPrint(ply:GetName() .. " declined")
        return
    end

    ply:SwitchToEvent(preset)

    inviter:ChatPrint(ply:GetName() .. " has joined the event!")
end)

util.AddNetworkString("SetEventPlayer")

net.Receive("SetEventPlayer", function(_, ply)
    if !ply:CanRunEvent() then return end

    local target = net.ReadEntity()
    local preset = net.ReadString()

    if !target then
        print("recieved net message with non-existent player")
        return
    end

    target:SwitchToEvent(preset)
end)

util.AddNetworkString("RespawnEventPlayer")

net.Receive("RespawnEventPlayer", function(_, ply)
    if !ply:CanRunEvent() then return end

    local target = net.ReadEntity()

    if !target then
        print("recieved net message with non-existent player")
        return
    end

    print(target:GetClassID())

    target:StripWeapons()
    player_manager.RunClass(target, "Spawn")
    player_manager.RunClass(target, "SetModel")
    player_manager.RunClass(target, "Loadout")
end)

util.AddNetworkString("KickEventPlayer")

net.Receive("KickEventPlayer", function(_, ply)
    if !ply:CanRunEvent() then return end

    local target = net.ReadEntity()

    if !target then
        print("recieved net message with non-existent player")
        return
    end

    target:SwitchFromEvent()
end)

util.AddNetworkString("RewardEventPlayer")

net.Receive("RewardEventPlayer", function(_, ply)
    if !ply:CanRunEvent() then return end

    local target = net.ReadEntity()

    if !target then
        print("recieved net message with non-existent player")
        return
    end

    local credits = 1000

    target:AddCredits(credits)
    target:ChatPrint("You were awarded " .. credits .. " credits for your participation")

    target:SwitchFromEvent()
end)

util.AddNetworkString("LeaveEvent")

net.Receive("LeaveEvent", function(_, ply)
    ply:SwitchFromEvent()
end)

util.AddNetworkString("JoinEvent")

net.Receive("JoinEvent", function(_, ply)
    ply:SwitchToEvent()
end)