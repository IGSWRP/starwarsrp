-- create day check file
if not file.Exists( "day.json", "DATA" ) then
	local time = os.time()

	local tbl = {}
	tbl["day"] = os.date( "%d", time) -- day in 00 format. e.g. 18 = 18th of a month

	local json = util.TableToJSON( tbl, true )
	file.Write( "day.json", json )
end

-- timer that runs every 5 mins to determine if the day has changed. If it has, run some functions
local function DayCheck()
	local json = file.Read( "day.json" )
	local tbl = util.JSONToTable( json )

	local time = os.time()

	if tbl["day"] ~= os.date( "%d", time ) then
		-- update day
		tbl["day"] = os.date( "%d", time )

		json = util.TableToJSON( tbl, true )
		file.Write( "day.json", json )

		MsgN("[IG] The day has advanced.")

		-- run functions
	end
end
timer.Create( "IG_DayTimer", 300, 0, DayCheck)