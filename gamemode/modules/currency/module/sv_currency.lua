util.AddNetworkString( "IG_UpdateCurrency" )

IG_CURRENCY = IG_CURRENCY or {}

local meta = FindMetaTable("Player")

if not sql.TableExists( "player_currency" ) then
	sql.Query( "CREATE TABLE IF NOT EXISTS player_currency (steamid TEXT NOT NULL, credits INTEGER, premium INTEGER, xp INTEGER, level INTEGER, PRIMARY KEY (steamid))" )
end

-- setup player currency if they dont have
function GM:PlayerCurrency( ply )
	local steamid = ply:SteamID64()

	local value = sql.QueryRow( "SELECT * FROM player_currency WHERE steamid = " .. sql.SQLStr( steamid ) .. ";" )
	if not value then
		sql.Query( "INSERT INTO player_currency (steamid, credits, premium, xp, level) VALUES(" .. sql.SQLStr( steamid ) .. ", 0, 0, 0, 1)" )

		IG_CURRENCY[steamid] = {
			["credits"] = 0,
			["premium"] = 0,
			["xp"] = 0,
			["level"] = 1
		}
	else
		IG_CURRENCY[steamid] = {
			["credits"] = tonumber(value["credits"]),
			["premium"] = tonumber(value["premium"]),
			["xp"] = tonumber(value["xp"]),
			["level"] = tonumber(value["level"])
		}
	end
end

-- clean up table when player leaves
local function PlayerLeave( ply )
	local steamid = ply:SteamID64()

	IG_CURRENCY[steamid] = nil
end
hook.Add( "PlayerDisconnected", "IG_CurrencyPlayerLeave", PlayerLeave )

-- meta functions
function meta:GetCredits()
	local steamid = self:SteamID64()
	local credits = IG_CURRENCY[steamid]["credits"]

	if not credits then return 0 end

	return credits
end

function meta:GetPremiumCurrency()
	local steamid = self:SteamID64()
	local premium = IG_CURRENCY[steamid]["premium"]

	if not premium then return 0 end

	return premium
end

function meta:GetXP()
	local steamid = self:SteamID64()
	local xp = IG_CURRENCY[steamid]["xp"]

	if not xp then return 0 end

	return xp, 10000
end

function meta:GetLevel()
	local steamid = self:SteamID64()
	local level = IG_CURRENCY[steamid]["level"]

	if not level then return 1 end

	return level
end

local function UpdateClient( _, ply )
	local credits = ply:GetCredits()
	local premium = ply:GetPremiumCurrency()
	local xp = ply:GetXP()
	local level = ply:GetLevel()

	net.Start( "IG_UpdateCurrency" )
	net.WriteUInt( credits, 32 )
	net.WriteUInt( premium, 32 )
	net.WriteUInt( xp, 14 )
	net.WriteUInt( level, 32 )
	net.Send( ply )
end
net.Receive( "IG_UpdateCurrency", UpdateClient)

function meta:AddCredits( amount )
	local steamid = self:SteamID64()
	local credits = self:GetCredits()

	if not isnumber( amount ) then return end
	if not credits then return end

	credits = credits + amount

	if ( credits < 0 ) then credits = 0 end

	sql.Query( "UPDATE player_currency SET credits = " .. SQLStr( credits ) .. " WHERE steamid = " .. SQLStr( steamid ) .. ";" )

	IG_CURRENCY[steamid]["credits"] = credits

	UpdateClient( _, self )

	return credits
end

function meta:AddPremiumCurrency( amount )
	local steamid = self:SteamID64()
	local premium = self:GetPremiumCurrency()

	if not isnumber( amount ) then return end
	if not premium then return end

	premium = premium + amount

	if ( premium < 0 ) then premium = 0 end

	sql.Query( "UPDATE player_currency SET premium = " .. SQLStr( premium ) .. " WHERE steamid = " .. SQLStr( steamid ) .. ";" )

	IG_CURRENCY[steamid]["premium"] = premium

	UpdateClient( _, self )

	return premium
end

function meta:AddXP( amount )
	local steamid = self:SteamID64()
	local xp = self:GetXP()
	local level = self:GetLevel()

	if not isnumber( amount ) then return end
	if not xp then return end
	if not level then return end

	xp = xp + amount

	if ( xp < 0 ) then
		xp = 10000 + xp

		if ( level > 1 ) then
			level = level - 1
		else
			xp = 0
		end
	end

	if ( xp > 10000 ) then
		xp = xp - 10000

		level = level + 1
	end

	sql.Query( "UPDATE player_currency SET xp, level = " .. SQLStr( xp ) .. ", " .. SQLStr( level ) .. " WHERE steamid = " .. SQLStr( steamid ) .. ";" )

	IG_CURRENCY[steamid]["xp"] = xp
	IG_CURRENCY[steamid]["level"] = level

	UpdateClient( _, self )

	return xp, level
end