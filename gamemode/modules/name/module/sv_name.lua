local meta = FindMetaTable("Player")

function meta:SetPlayerName(name)
    self:SetRPName(name)

    -- TODO: database
end