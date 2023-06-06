DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

function PLAYER:SaveCharacterData() return end -- noop

function PLAYER:ShowTeam()
    self.Player:ConCommand("event_menu")
end

function PLAYER:SetupDataTables()
    local ply = self.Player

    ply:NetworkVar("String", 0, "RPName")

    -- We don't need to network these as they'll always be the same
    function ply:GetRegiment() return "EVENT" end
    function ply:GetRank() return 1 end
    function ply:GetRegimentClass() return "" end
end

player_manager.RegisterClass("player_event", PLAYER, "player_default")