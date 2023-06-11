TOOL.Category = "Admin"
TOOL.Name = "#tool.event_spawn.name"
TOOL.ConfigName = ""

TOOL.ClientConVar["preset"] = ""

if ( CLIENT ) then -- We can only use language.Add on client
	language.Add( "tool.event_spawn.name", "Event Spawns" ) -- Add translation
    language.Add("tool.event_spawn.desc", "Sets a temp spawn point for an event preset")
    language.Add("tool.event_spawn.0", "Left click to select a spawn point.")
    local last_refresh = IG.LastEventPresetLoad or os.time()
end

function TOOL:LeftClick( trace )
    if CLIENT or !self:GetOwner():IsAdmin() then return false end
    
    local spawn = trace.HitPos

    -- nudge the spawn off the ground a little bit
    spawn[3] = spawn[3] + 10

    IG.EventPresetSpawns[self:GetClientInfo("preset")] = spawn

    self:GetOwner():ChatPrint("Set event spawn for " .. self:GetClientInfo("preset"))

	return true
end

function TOOL:Think()
    if (CLIENT) then
        if last_refresh ~= IG.LastEventPresetLoad then
            last_refresh = IG.LastEventPresetLoad
            self:RebuildControlPanel()
        end
    end
end

function TOOL.BuildCPanel( CPanel )
    for k,v in pairs(IG.EventPresets) do
        if CLIENT then
            language.Add( "tool.event_spawn." .. k, k)
        end
        list.Set( "Presets", "#tool.event_spawn." .. k, { event_spawn_preset = k } )
    end

	CPanel:AddControl( "Header", { Description = "#tool.event_spawn.desc" } )
    CPanel:AddControl( "ListBox", { Label = "Preset", Options = list.Get( "Presets" ) } )
end

