if (!bKeypads) then
    print("[IG-Keypads] ===============================/!\================================")
    print("[IG-Keypads] bKeypads are not installed, please install them to use this module !")
    print("[IG-Keypads] Refusing to load keycards module !")
    print("[IG-Keypads] ===============================/!\================================")
    return 
end

AddCSLuaFile("module/cl_givekeycard.lua")
if (SERVER) then
    include("module/sv_givekeycard.lua")
elseif (CLIENT) then
    include("module/cl_givekeycard.lua")
end

