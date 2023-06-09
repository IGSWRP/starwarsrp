util.AddNetworkString( "IG_UpdateCurrency" )

local IGCurrency = IGCurrency or {}

local meta = FindMetaTable("Player")

if not sql.TableExists( "player_currency" ) then
	sql.Query( "CREATE TABLE IF NOT EXISTS player_currency (steamid TEXT NOT NULL, credits INTEGER, premium INTEGER, PRIMARY KEY (steamid))" )
end

-- setup player currency if they dont have
function GM:PlayerCurrency( ply )
	local steamid = ply:SteamID64()

	local value = sql.QueryRow( "SELECT * FROM player_currency WHERE steamid = " .. sql.SQLStr( steamid ) .. ";" )
	if not value then
		sql.Query( "INSERT INTO player_currency (steamid, credits, premium) VALUES(" .. sql.SQLStr( steamid ) .. ", 0, 0)" )

		IGCurrency[steamid] = {
			[1] = 0,
			[2] = 0
		}
	else
		IGCurrency[steamid] = {
			[1] = tonumber(value["credits"]),
			[2] = tonumber(value["premium"])
		}
	end
end

-- meta functions
function meta:GetCredits()
	local steamid = self:SteamID64()
	local credits = IGCurrency[steamid][1]

	if not credits then return 0 end

	return credits
end

function meta:GetPremiumCurrency()
	local steamid = self:SteamID64()
	local premium = IGCurrency[steamid][2]

	if not premium then return 0 end

	return premium
end

local function UpdateClient( _, ply )
	local credits = ply:GetCredits()
	local premium = ply:GetPremiumCurrency()

	net.Start( "IG_UpdateCurrency" )
	net.WriteUInt( credits, 32 )
	net.WriteUInt( premium, 32 )
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

	IGCurrency[steamid][1] = credits

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

	IGCurrency[steamid][2] = premium

	UpdateClient( _, self )

	return premium
end

concommand.Add("cum", function(ply)
	print(ply:GetCredits())
	print(ply:GetPremiumCurrency())
end)