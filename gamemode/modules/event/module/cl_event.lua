IG.EventPresets = IG.EventPresets or {}
IG.LastEventPresetLoad = IG.LastEventPresetLoad or os.time()

net.Receive("EditPreset", function()    
    local name = net.ReadString()
    local health = net.ReadUInt(16)
    local models = net.ReadString()
    local weps = net.ReadString()

    IG.EventPresets[name] = { health = health, models = string.Explode(",", models), weapons = string.Explode(",", weps) }
    IG.LastEventPresetLoad = os.time()
end)

net.Receive("SyncPresets", function()    
    local presets_json = net.ReadString()

    IG.EventPresets = util.JSONToTable(presets_json)

    LocalPlayer():ChatPrint("Loaded " .. table.Count(IG.EventPresets) .. " Event Preset(s)")
    IG.LastEventPresetLoad = os.time()
end)