GM.Name = "starwarsrp"
GM.Author = "Twist"
GM.Email = "N/A"
GM.Website = "imperialgaming.io"
DeriveGamemode("sandbox")

local IncludeFiles = function(root)
    local _, folders = file.Find(root .. "*", "LUA")

    for i = 1, #folders do
        if SERVER then
            for _, file in SortedPairs(file.Find(root .. folders[i] .. "/sv*.lua", "LUA")) do
                include(root .. folders[i] .. "/" .. file)
            end
        end

        for _, file in SortedPairs(file.Find(root .. folders[i] .. "/sh*.lua", "LUA")) do
            if SERVER then
                AddCSLuaFile(root .. folders[i] .. "/" .. file)
                include(root .. folders[i] .. "/" .. file)
            else
                include(root .. folders[i] .. "/" .. file)
            end
        end

        for _, file in SortedPairs(file.Find(root .. folders[i] .. "/cl*.lua", "LUA")) do
            if SERVER then
                AddCSLuaFile(root .. folders[i] .. "/" .. file)
            else
                include(root .. folders[i] .. "/" .. file)
            end
        end
    end
end

IncludeFiles( GM.FolderName .. "/gamemode/modules/" )
