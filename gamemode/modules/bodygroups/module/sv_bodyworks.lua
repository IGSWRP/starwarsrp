-- Fire's body group and swap model manager
print("Initializing IG Fire's Model Manager")

util.AddNetworkString("bodyworks_apply")
util.AddNetworkString("bodyworks_open")
util.AddNetworkString("bodyworks_load")

net.Receive("bodyworks_apply", function(len, ply)
    local model = net.ReadString()
    local skin = net.ReadUInt(5)
    local bodygroups = net.ReadString()

    local models = player_manager.RunClass(ply, "GetModels")

    if !table.HasValue(models, model) then
        print("Model not in default list for regiment")
        if model != ply:GetModel() then
            print("Player attempting to switch to un-owned model, rejecting..")
            return
        end
    end

    ply:SetModel(model)
    ply:SetSkin(skin)
    ply:SetBodyGroups(bodygroups)
    ply:SetupHands()
end)
