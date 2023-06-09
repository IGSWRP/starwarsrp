IGCurrency = IGCurrency or { ["credits"] = 0, ["premium"]  = 0, ["xp"] = 0, ["level"] = 1 }

local meta = FindMetaTable("Player")

function meta:GetCredits()
	if (self != LocalPlayer()) then return 0 end

	return IGCurrency["credits"] or 0
end

function meta:GetPremiumCurrency()
	if (self != LocalPlayer()) then return 0 end

	return IGCurrency["premium"] or 0
end

function meta:GetXP()
	if (self != LocalPlayer()) then return 0 end

	return IGCurrency["xp"] or 0, 10000
end

function meta:GetLevel()
	if (self != LocalPlayer()) then return 1 end

	return IGCurrency["level"] or 1
end

local function UpdateCurrency()
	local credits = net.ReadUInt( 32 ) or 0
	local premium = net.ReadUInt( 32 ) or 0
	local xp = net.ReadUInt( 14 ) or 0
	local level = net.ReadUInt( 32 ) or 1

	IGCurrency["credits"] = credits
	IGCurrency["premium"] = premium
	IGCurrency["xp"] = xp
	IGCurrency["level"] = level
end
net.Receive( "IG_UpdateCurrency", UpdateCurrency)

local function ReadyNetworking()
	print("hey")
	net.Start( "IG_UpdateCurrency" )
	net.SendToServer()
end
hook.Add( "InitPostEntity", "CurrencyReadyNetworking", ReadyNetworking)