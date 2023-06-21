util.AddNetworkString( "IG_LoginMenu" )

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
	IG_LOGINBONUS[steamid]["claimed_day"] = 0
	IG_LOGINBONUS[steamid]["claimed_streak"] = 0

	-- update player day
	IG_LOGINBONUS[steamid]["last_day"] = last_day

	-- save all values
	sql.Query( "UPDATE player_loginbonus SET day = " .. sql.SQLStr(IG_LOGINBONUS[steamid]["day"])
	.. ", streak = " .. sql.SQLStr(IG_LOGINBONUS[steamid]["streak"])
	.. ", longest_streak = " .. sql.SQLStr(IG_LOGINBONUS[steamid]["longest_streak"])
	.. ", last_day = " .. sql.SQLStr(IG_LOGINBONUS[steamid]["last_day"])
	.. ", claimed_day = " .. sql.SQLStr(IG_LOGINBONUS[steamid]["claimed_day"])
	.. ", claimed_streak = " .. sql.SQLStr(IG_LOGINBONUS[steamid]["claimed_streak"])
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