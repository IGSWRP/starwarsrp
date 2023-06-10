-- modified from https://github.com/FPtje/DarkRP/blob/4410e4cc970e0fe9cf7f7c6c6025c116c665ae26/gamemode/modules/base/sv_gamemode_functions.lua

local voiceDistance = 550 * 550
local DrpCanHear = {}
local floor = math.floor -- Caching floor as we will need to use it a lot
-- Grid based position check
local grid
-- Translate player to grid coordinates. The first table maps players to x
-- coordinates, the second table maps players to y coordinates.
local plyToGrid = {
    {},
    {}
}

local voiceCheckTimeDelay = 0.3
timer.Create("CanHearPlayersVoice", voiceCheckTimeDelay, 0, function()
    local players = player.GetHumans()

    -- Clear old values
    plyToGrid[1] = {}
    plyToGrid[2] = {}
    grid = {}

    local plyPos = {}
    local eyePos = {}

    -- Get the grid position of every player O(N)
    for _, ply in ipairs(players) do
        local pos = ply:GetPos()
        plyPos[ply] = pos
        eyePos[ply] = ply:EyePos()
        local x = floor(pos.x / voiceDistance)
        local y = floor(pos.y / voiceDistance)

        local row = grid[x] or {}
        local cell = row[y] or {}

        table.insert(cell, ply)
        row[y] = cell
        grid[x] = row

        plyToGrid[1][ply] = x
        plyToGrid[2][ply] = y

        DrpCanHear[ply] = {} -- Initialize output variable
    end

    -- Check all neighbouring cells for every player.
    -- We are only checking in 1 direction to avoid duplicate check of cells
    for _, ply1 in ipairs(players) do
        local gridX = plyToGrid[1][ply1]
        local gridY = plyToGrid[2][ply1]
        local ply1Pos = plyPos[ply1]
        local ply1EyePos = eyePos[ply1]

        for i = 0, 3 do
            local vOffset = 1 - ((i >= 3) and 1 or 0)
            local hOffset = -(i % 3-1)
            local x = gridX + hOffset
            local y = gridY + vOffset

            local row = grid[x]
            if not row then continue end

            local cell = row[y]
            if not cell then continue end

            for _, ply2 in ipairs(cell) do
                local canTalk =
                    ply1Pos:DistToSqr(plyPos[ply2]) < voiceDistance --and -- voiceradius is on and the two are within hearing distance
                        --(not dynv or IsInRoom(ply1EyePos, eyePos[ply2], ply2)) -- Dynamic voice is on and players are in the same room

                DrpCanHear[ply1][ply2] = canTalk
                DrpCanHear[ply2][ply1] = canTalk -- Take advantage of the symmetry
            end
        end
    end

    -- Doing a pass-through inside every cell to compute the interactions inside of the cells.
    -- Each grid check is O(N(N+1)/2) where N is the number of players inside the cell.
    for _, row in pairs(grid) do
        for _, cell in pairs(row) do
            local count = #cell
            for i = 1, count do
                local ply1 = cell[i]
                for j = i + 1, count do
                    local ply2 = cell[j]
                    local canTalk =
                        plyPos[ply1]:DistToSqr(plyPos[ply2]) < voiceDistance --and -- voiceradius is on and the two are within hearing distance
                            --(not dynv or IsInRoom(eyePos[ply1], eyePos[ply2], ply2)) -- Dynamic voice is on and players are in the same room

                    DrpCanHear[ply1][ply2] = canTalk
                    DrpCanHear[ply2][ply1] = canTalk -- Take advantage of the symmetry
                end
            end
        end
    end
end)

hook.Add("PlayerDisconnect", "CanHear", function(ply)
    DrpCanHear[ply] = nil -- Clear to avoid memory leaks
end)

function GM:PlayerCanHearPlayersVoice(listener, talker)
    return DrpCanHear[listener][talker] == true, true
end