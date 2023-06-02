local IGCurrency = IGCurrency or { [1] = "0", [2]  = "0" }

local meta = FindMetaTable("Player")

function meta:GetCredits()
	if (self != LocalPlayer()) then return "0" end

	return IGCurrency[1]
end

function meta:GetPremiumCurrency()
	if (self != LocalPlayer()) then return "0" end

	return IGCurrency[2]
end

local function UpdateCurrency()
	local credits = net.ReadString() or "0"
	local premium = net.ReadString() or "0"

	IGCurrency[1] = credits
	IGCurrency[2] = premium
end
net.Receive( "IG_UpdateCurrency", UpdateCurrency)

local function ReadyNetworking()
	net.Start( "IG_UpdateCurrency" )
	net.SendToServer()
end
hook.Add( "InitPostEntity", "CurrencyReadyNetworking", ReadyNetworking)