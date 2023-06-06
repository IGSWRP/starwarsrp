local sub = string.sub

hook.Add("PlayerSay", "IG.Event", function(ply, text)
    if !ply:IsAdmin() then
        ply:ChatPrint("You do not have permission")
        return ""
    end
    
    local prefix = sub(text, 1, 1)
    if prefix ~= "/" then return end

    local cmd = sub(text, 2)

    if cmd == "event" then
        player_manager.SetPlayerClass(ply, "player_event")
        ply:StripWeapons()
        ply:Spawn()
        ply:ChatPrint("Switched to event character")
    elseif cmd == "imperial" then
        player_manager.SetPlayerClass(ply, "player_imperial")
        ply:StripWeapons()
        ply:Spawn()
        ply:ChatPrint("No longer playing as event character")
    else
        return
    end

    return ""
end)