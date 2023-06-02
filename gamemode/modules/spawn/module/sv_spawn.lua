function GM:PlayerInitialSpawn(ply, transition)
    if !transition then
        player_manager.SetPlayerClass(ply, "player_imperial" )

		-- Call currency setup function
		hook.Call( "PlayerCurrency", GAMEMODE, ply )
    end
end

function GM:PlayerSpawn(ply, transiton )
    print("main spawn")
    player_manager.OnPlayerSpawn( ply, transiton )
	player_manager.RunClass( ply, "Spawn" )

    if ( !transiton ) then
		-- Call item loadout function
		hook.Call( "PlayerLoadout", GAMEMODE, ply )
	end

	-- Set player model
	hook.Call( "PlayerSetModel", GAMEMODE, ply )

    ply:SetupHands()
end

function GM:PlayerSelectSpawn(ply, transition)
    print("Player Select Spawn called")
    -- ply:SetPos( Vector( -61, -89, -11663) )
    return self.BaseClass.PlayerSelectSpawn(self, ply, transition)
end