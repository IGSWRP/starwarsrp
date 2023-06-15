if !sql.TableExists("regiment_spawns") then
    print("Creating regiment_spawns table")
    -- I think that having an index on (map, regiment) means we don't need one on (map) but idk
    sql.Query( "CREATE TABLE IF NOT EXISTS regiment_spawns (map TEXT NOT NULL, regiment INTEGER NOT NULL, x INTEGER, y INTEGER, z INTEGER, PRIMARY KEY (map, regiment))" )
end

local function LoadSpawns()
    print("Loading spawns")
    local spawns = {}

    -- Limit to 128 results in case someone goes full retard in saving data
    local results = sql.Query(string.format("SELECT * FROM regiment_spawns WHERE map = %s LIMIT 128", sql.SQLStr(game.GetMap()))) or {}

    for i=1, #results do
        spawns[results[i].regiment] = Vector(results[i].x, results[i].y, results[i].z)        
    end

    if #results >= 100 then
        print("Reaching limit on maximum number of spawns for map")
    end

    return spawns
end

-- Only load the spawns once
IG.Spawns = IG.Spawns or LoadSpawns()

local function SaveSpawn(regiment, pos)
    return sql.Query(string.format("REPLACE INTO regiment_spawns ( map, regiment, x, y, z) VALUES (%s, %s, %i, %i, %i)", sql.SQLStr(game.GetMap()), sql.SQLStr(regiment), pos[1], pos[2], pos[3])) ~= false
end

function IG.Spawns.SetSpawn(regiment, pos)
    print("Setting new spawn point", regiment, pos)
    IG.Spawns[regiment] = pos

    if !SaveSpawn(regiment, pos) then
        print("Error saving spawn", regiment, pos)
        return false
    end

    return true
end

function GM:PlayerInitialSpawn(ply, transition)
    if !transition then
        player_manager.SetPlayerClass(ply, "player_imperial" )

		-- Call currency setup function
		hook.Call( "PlayerCurrency", GAMEMODE, ply )
    end
end

function GM:PlayerSpawn(ply, transiton )
    player_manager.OnPlayerSpawn( ply, transiton )
	player_manager.RunClass( ply, "Spawn" )

    if ( !transiton ) then
		-- Call item loadout function
		hook.Call( "PlayerLoadout", GAMEMODE, ply )
	end

	-- Set player model
	hook.Call( "PlayerSetModel", GAMEMODE, ply )

    -- limit the number of tries so we don't accidentally break away into an infinite loop
    -- the higher the limit, the better for mass respawns
    for i=1,20 do
        local pos = ply:GetPos()
        local tr = util.TraceEntity({ start = pos, endpos = pos, filter = ply, mask = MASK_PLAYERSOLID }, ply)
        if tr.Hit then
            for i=1,2 do
                -- can also tweak this formula for placement distance between players
                pos[i] = pos[i] + (35 * math.random(-2,2))
            end
            ply:SetPos(pos)
        else
            break
        end
    end    
end
