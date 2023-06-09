local meta = FindMetaTable("Player")

local function safeText(text)
    return string.match(text, "^#([a-zA-Z_]+)$") and text .. " " or text
end

local function drawText(text, font, x, y, color, xAlign)
    return draw.DrawText(safeText(text), font, x, y, color, xAlign)
end

meta.drawPlayerInfo = function(self)
    local bone = self:LookupBone("ValveBiped.Bip01_Head1")
    local pos
    if bone then
        pos = self:GetBonePosition(bone)
    else
        pos = self:EyePos()
    end

    pos.z = pos.z + 15
    pos = pos:ToScreen()

    local rank, nick = self:GetRankName(), self:GetName()
    local col = IG.Regiments[self:GetRegiment()].colour
    local reg = self:GetRegimentName()
    local hp, maxhp = self:Health(), self:GetMaxHealth()

    drawText(((rank and rank .. " ") or "") .. nick, "TargetID", pos.x, pos.y + 1, col, 1)
    drawText(reg, "TargetID", pos.x, pos.y + 21, col, 1)
    drawText(string.format("%d%%", hp / maxhp * 100), "TargetID", pos.x, pos.y + 41, col, 1)
end

function GM:HUDDrawTargetID()
    local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if ( !trace.Hit ) then return end
	if ( !trace.HitNonWorld ) then return end

    if ( trace.Entity:IsPlayer() ) then
        if trace.HitPos:DistToSqr(trace.StartPos) < 20000 then
            if !trace.Entity:ShouldHideName() then
                trace.Entity:drawPlayerInfo()
            end
        end
	end
end

-- Hide death notices
function GM:AddDeathNotice( Attacker, team1, Inflictor, Victim, team2 ) end
