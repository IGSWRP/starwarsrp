local meta = FindMetaTable("Player")

function meta:CanRunEvent()
    return self:IsAdmin()
end