TOOL.Category = "Admin"
TOOL.Name = "#tool.set_spawn.name"
TOOL.ConfigName = ""

TOOL.ClientConVar["regiment"] = "RECRUIT"

if ( CLIENT ) then -- We can only use language.Add on client
	language.Add( "tool.set_spawn.name", "Set Spawn" ) -- Add translation
    language.Add("tool.set_spawn.desc", "Sets a permanent spawn point for a regiment")
    language.Add("tool.set_spawn.0", "Left click to select a spawn point.")
end

function TOOL:LeftClick( trace )
    if CLIENT or !self:GetOwner():IsAdmin() then return false end
    
    local spawn = trace.HitPos

    -- nudge the spawn off the ground a little bit
    spawn[3] = spawn[3] + 10

    local result = IG.Spawns.SetSpawn(self:GetClientInfo("regiment"), trace.HitPos)

    if result then
        self:GetOwner():ChatPrint("Set spawn for " .. IG.Regiments[self:GetClientInfo("regiment")].name)
    end

	return true
end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.set_spawn.desc" } )
    CPanel:AddControl( "ListBox", { Label = "Regiment", Options = list.Get( "Regiments" ) } )
end

for k,v in pairs(IG.Regiments) do
    if CLIENT then
        language.Add( "tool.set_spawn." .. k, v.name)
    end
    list.Set( "Regiments", "#tool.set_spawn." .. k, { set_spawn_regiment = k } )
end