IG_CURRENCY = IG_CURRENCY or { ["credits"] = 0, ["premium"]  = 0, ["xp"] = 0, ["level"] = 1 }

local meta = FindMetaTable("Player")

function meta:GetCredits()
	if (self != LocalPlayer()) then return 0 end

	return IG_CURRENCY["credits"] or 0
end

function meta:GetPremiumCurrency()
	if (self != LocalPlayer()) then return 0 end

	return IG_CURRENCY["premium"] or 0
end

function meta:GetXP()
	if (self != LocalPlayer()) then return 0 end

	return IG_CURRENCY["xp"] or 0, 10000
end

function meta:GetLevel()
	if (self != LocalPlayer()) then return 1 end

	return IG_CURRENCY["level"] or 1
end

local function UpdateCurrency()
	local credits = net.ReadUInt( 32 ) or 0
	local premium = net.ReadUInt( 32 ) or 0
	local xp = net.ReadUInt( 14 ) or 0
	local level = net.ReadUInt( 32 ) or 1

	IG_CURRENCY["credits"] = credits
	IG_CURRENCY["premium"] = premium
	IG_CURRENCY["xp"] = xp
	IG_CURRENCY["level"] = level
end
net.Receive( "IG_UpdateCurrency", UpdateCurrency)