util.AddNetworkString( "IG_LoginMenu" )
util.AddNetworkString( "IG_LoginClaim" )

IG_LOGINBONUS = IG_LOGINBONUS or {}

-- create player login bonus table
if not sql.TableExists( "player_loginbonus" ) then
	sql.Query( "CREATE TABLE IF NOT EXISTS player_loginbonus (steamid TEXT NOT NULL, day INTEGER, streak INTEGER, longest_streak INTEGER, last_day INTEGER, claimed_day INTEGER, claimed_streak INTEGER, PRIMARY KEY (steamid))" )
end

-- create file to track the servers current 'day'
if not file.IsDir( "ig_loginbonus", "DATA" ) then
	file.CreateDir( "ig_loginbonus" )
end

if not file.Exists( "ig_loginbonus/day.txt", "DATA" ) then
	file.Write( "ig_loginbonus/day.txt", "2" )
end

function GM:PlayerLoginBonus( ply )
	-- store and load player data
	local steamid = ply:SteamID64()
	local last_day = file.Read( "ig_loginbonus/day.txt", "DATA" ) or "1"

	local value = sql.QueryRow( "SELECT * FROM player_loginbonus WHERE steamid = " .. sql.SQLStr( steamid ) .. ";" )
	if not value then
		sql.Query( "INSERT INTO player_loginbonus (steamid, day, streak, longest_streak, last_day, claimed_day, claimed_streak) VALUES(" .. sql.SQLStr( steamid ) .. ", 1, 1, 1, " .. sql.SQLStr( last_day ) .. ", 0, 0 )" )

		IG_LOGINBONUS[steamid] = {
			["day"] = 1,
			["streak"] = 1,
			["longest_streak"] = 1,
			["last_day"] = last_day,
			["claimed_day"] = 0,
			["claimed_streak"] = 0
		}
	else
		IG_LOGINBONUS[steamid] = {
			["day"] = tonumber(value["day"]),
			["streak"] = tonumber(value["streak"]),
			["longest_streak"] = tonumber(value["longest_streak"]),
			["last_day"] = tonumber(value["last_day"]),
			["claimed_day"] = tobool(value["claimed_day"]),
			["claimed_streak"] = tobool(value["claimed_streak"])
		}
	end

	-- check if the day has not changed
	if tonumber( IG_LOGINBONUS[steamid]["last_day"] ) == tonumber( last_day ) then return end

	-- player has logged in consecutively
	if tonumber( IG_LOGINBONUS[steamid]["last_day"] ) == tonumber( last_day ) - 1 then
		if tonumber( IG_LOGINBONUS[steamid]["day"] ) + 1 == 8 then
			-- one week has passed
			IG_LOGINBONUS[steamid]["day"] = 1
		else
			-- update day as normal
			IG_LOGINBONUS[steamid]["day"] = IG_LOGINBONUS[steamid]["day"] + 1
		end

		-- check if streak is the longest
		IG_LOGINBONUS[steamid]["streak"] = IG_LOGINBONUS[steamid]["streak"] + 1
		if tonumber( IG_LOGINBONUS[steamid]["streak"] ) > tonumber( IG_LOGINBONUS[steamid]["longest_streak"] ) then
			IG_LOGINBONUS[steamid]["longest_streak"] = IG_LOGINBONUS[steamid]["streak"]
		end
	else
		-- player has missed a day
		IG_LOGINBONUS[steamid]["day"] = 1
		IG_LOGINBONUS[steamid]["streak"] = 1
	end

	-- reset claims
	IG_LOGINBONUS[steamid]["claimed_day"] = false
	IG_LOGINBONUS[steamid]["claimed_streak"] = false

	-- update player day
	IG_LOGINBONUS[steamid]["last_day"] = last_day

	-- save all values
	sql.Query( "UPDATE player_loginbonus SET day = " .. sql.SQLStr(IG_LOGINBONUS[steamid]["day"])
	.. ", streak = " .. sql.SQLStr(IG_LOGINBONUS[steamid]["streak"])
	.. ", longest_streak = " .. sql.SQLStr(IG_LOGINBONUS[steamid]["longest_streak"])
	.. ", last_day = " .. sql.SQLStr(IG_LOGINBONUS[steamid]["last_day"])
	.. ", claimed_day = 0"
	.. ", claimed_streak = 0"
	.. " WHERE steamid = " .. SQLStr( steamid ) .. ";" )
end

local function AdvanceDay( ply )
	-- make sure only the console is running the command
	if IsValid( ply ) then return end

	-- increment the day
	local last_day = file.Read( "ig_loginbonus/day.txt", "DATA" ) or "1"

	last_day = tonumber( last_day ) + 1
	file.Write( "ig_loginbonus/day.txt", tostring( last_day ) )

	-- update all players
	for _, v in ipairs( player.GetAll() ) do
		hook.Call( "PlayerLoginBonus", GAMEMODE, v )
	end
end
concommand.Add( "ig_loginbonus", AdvanceDay )

local ig_blue = Color( 46, 135, 255 )

local function ClaimReward( _, ply )
	local steamid = ply:SteamID64()
	local claim_streak = net.ReadBool()

	if claim_streak == nil then return end

	if claim_streak then
		-- streak claim
		if IG_LOGINBONUS[steamid]["claimed_streak"] then return end
		if IG_LOGINREWARD[IG_LOGINBONUS[steamid]["streak"]] == nil then return end

		-- set claimed and save
		IG_LOGINBONUS[steamid]["claimed_streak"] = true
		sql.Query( "UPDATE player_loginbonus SET claimed_streak = 1 WHERE steamid = " .. sql.SQLStr( steamid ) .. ";")

		-- award credits and xp
		local credits = IG_LOGINREWARD[IG_LOGINBONUS[steamid]["streak"]]["credit"]
		local xp = IG_LOGINREWARD[IG_LOGINBONUS[steamid]["streak"]]["xp"]

		ply:AddCredits( credits )
		ply:AddXP( xp )

		-- inform player
		local message = {
			ig_blue,
			"[LOGIN BONUS - STREAK: " .. IG_LOGINBONUS[steamid]["streak"] .. "] ",
			color_white,
			"You have received: ",
			ig_blue,
			credits .. " credits ",
			color_white,
			"and ",
			ig_blue,
			xp .. " xp",
			color_white,
			"."
		}

		ply:PrettyChatPrint( message )
	else
		-- regular claim
		if IG_LOGINBONUS[steamid]["claimed_day"] then return end
		if IG_LOGINREWARD[IG_LOGINBONUS[steamid]["day"]] == nil then return end

		-- set claimed and save
		IG_LOGINBONUS[steamid]["claimed_day"] = true
		sql.Query( "UPDATE player_loginbonus SET claimed_day = 1 WHERE steamid = " .. sql.SQLStr( steamid ) .. ";")

		-- award credits and xp
		local credits = IG_LOGINREWARD[IG_LOGINBONUS[steamid]["day"]]["credit"]
		local xp = IG_LOGINREWARD[IG_LOGINBONUS[steamid]["day"]]["xp"]

		ply:AddCredits( credits )
		ply:AddXP( xp )

		-- inform player
		local message = {
			ig_blue,
			"[LOGIN BONUS - DAY: " .. IG_LOGINBONUS[steamid]["day"] .. "] ",
			color_white,
			"You have received: ",
			ig_blue,
			credits .. " credits ",
			color_white,
			"and ",
			ig_blue,
			xp .. " xp",
			color_white,
			"."
		}

		ply:PrettyChatPrint( message )
	end
end
net.Receive( "IG_LoginClaim", ClaimReward )

function OpenLoginMenu( _, ply )
	local steamid = ply:SteamID64()

	net.Start( "IG_LoginMenu" )
	net.WriteUInt( IG_LOGINBONUS[steamid]["day"], 3 )
	net.WriteUInt( IG_LOGINBONUS[steamid]["streak"], 11 )
	net.WriteUInt( IG_LOGINBONUS[steamid]["longest_streak"], 11 )
	net.WriteBool( IG_LOGINBONUS[steamid]["claimed_day"] )
	net.WriteBool( IG_LOGINBONUS[steamid]["claimed_streak"] )
	net.Send( ply )
end
net.Receive( "IG_LoginMenu", OpenLoginMenu )