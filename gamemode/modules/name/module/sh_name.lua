local meta = FindMetaTable("Player")

if not meta.OldNick then
    meta.OldNick = meta.Nick
end

function meta:GetPlayerName()
    return self.GetRPName and self:GetRPName() or "Unknown"
end

function meta:Nick()
    return self:GetPlayerName()
end

function meta:GetName()
    return self:GetPlayerName()
end

function meta:Name()
    return self:GetPlayerName()
end

function meta:ShouldHideName()
    -- check for cloak and shiz
    
    return false
end