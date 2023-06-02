util.AddNetworkString( "IG_UpdateCurrency" )

local meta = FindMetaTable("Player")

if not sql.TableExists( "player_currency" ) then
	sql.Query( "CREATE TABLE IF NOT EXISTS player_currency (steamid TEXT NOT NULL, credits INTEGER, premium INTEGER, PRIMARY KEY (steamid))" )
end

-- setup player currency if they dont have
function GM:PlayerCurrency( ply )
	local steamid = ply:SteamID64()

	if not (sql.QueryRow( "SELECT * FROM player_currency WHERE steamid = " .. sql.SQLStr( steamid ) .. ";" )) then
		print(sql.Query( "INSERT INTO player_currency (steamid, credits, premium) VALUES(" .. sql.SQLStr( steamid ) .. ", 0, 0)" ))
	end
end

-- meta functions
function meta:GetCredits()
	local steamid = self:SteamID64()
	local credits = sql.QueryValue( "SELECT credits FROM player_currency WHERE steamid = " .. sql.SQLStr( steamid ) .. ";" )

	if not credits then return "0" end

	return credits
end

function meta:GetPremiumCurrency()
	local steamid = self:SteamID64()
	local premium = sql.QueryValue( "SELECT premium FROM player_currency WHERE steamid = " .. sql.SQLStr( steamid ) .. ";" )

	if not premium then return "0" end

	return premium
end

local function UpdateClient( _, ply )
	local credits = ply:GetCredits()
	local premium = ply:GetPremiumCurrency()

	net.Start( "IG_UpdateCurrency" )
	net.WriteString( credits )
	net.WriteString( premium )
	net.Send( ply )
end
net.Receive( "IG_UpdateCurrency", UpdateClient)

function meta:AddCredits( amount )
	local steamid = self:SteamID64()
	local credits = self:GetCredits()

	if not isnumber( amount ) then return end
	if not credits then return end

	credits = credits + amount

	sql.Query( "UPDATE player_currency SET credits = " .. SQLStr( credits ) .. " WHERE steamid = " .. SQLStr( steamid ) .. ";" )

	UpdateClient( _, self )

	return credits
end

function meta:AddPremiumCurrency( amount )
	local steamid = self:SteamID64()
	local premium = self:GetPremiumCurrency()

	if not isnumber( amount ) then return end
	if not premium then return end

	premium = premium + amount

	sql.Query( "UPDATE player_currency SET premium = " .. SQLStr( premium ) .. " WHERE steamid = " .. SQLStr( steamid ) .. ";" )

	UpdateClient( _, self )

	return premium
end