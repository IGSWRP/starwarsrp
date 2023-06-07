local meta = FindMetaTable("Player")

function meta:CanPromote(ply)
    if IG.Regiments[self:GetRegiment()].ranks[self:GetRank()].cl < 2 or self:GetRank() <= ply:GetRank() then
        return false
    end

    if ply:GetRegiment() == self:GetRegiment() and IG.Regiments[ply:GetRegiment()].ranks[ply:GetRank() + 1] then
        return true
    end

    if ply:GetRegiment() == "RECRUIT" then
        return true
    end

    return false
end

function meta:CanDemote(ply)
    if IG.Regiments[self:GetRegiment()].ranks[self:GetRank()].cl < 2 or self:GetRank() <= ply:GetRank() then
        return false
    end

    if ply:GetRegiment() == self:GetRegiment() then
        return true
    end

    return false
end

function meta:CanSetClass(ply)
    if self:IsAdmin() and ply:GetRegiment() == "BH" then
        return true
    end

    if IG.Regiments[self:GetRegiment()].ranks[self:GetRank()].cl < 3 or self:GetRank() <= ply:GetRank() then
        return false
    end

    if not (IG.Regiments[ply:GetRegiment()] or {}).classes then
        return false
    end

    if ply:GetRegiment() == self:GetRegiment() then
        return true
    end

    return false
end

function meta:CanInvite(ply)
    if IG.Regiments[self:GetRegiment()].enabled == false then
        return false
    end

    if IG.Regiments[self:GetRegiment()].ranks[self:GetRank()].cl < 3 then
        return false
    end

    if ply:GetRegiment() == "RECRUIT" then
        return false
    end

    if self:GetRegiment() == ply:GetRegiment() then
        return false
    end

    if self:GetRank() <= ply:GetRank() then
        return false
    end

    return true
end
