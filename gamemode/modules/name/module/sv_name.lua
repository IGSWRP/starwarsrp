local meta = FindMetaTable("Player")

function meta:SetPlayerName(name)
    self:SetRPName(name)

    player_manager.RunClass(self, "SaveCharacterData")
end

local sub = string.sub

hook.Add("PlayerSay", "IG.ChangeName", function(ply, text)
    local prefix = sub(text, 1, 1)
    if prefix ~= "/" then return end
    if string.match(sub(text, 2, 2), "[a-z]") == nil then return end

    local cmd = sub(text, 2)
    local text

    if string.StartsWith(cmd, "setname") then
        text = sub(cmd, #"setname" + 2)
    elseif string.StartsWith(cmd, "name") then
        text = sub(cmd, #"name" + 2)
    else
        return 
    end
    
    if string.len(text) < 2 then
        ply:ChatPrint("That name is too short")
        return ""
    elseif string.len(text) > 32 then
        ply:ChatPrint("That name is too long")

        return ""
    end

    ply:SetPlayerName(text)

    ply:ChatPrint("Set name to " .. text)
    return ""
end)
