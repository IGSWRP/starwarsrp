local meta = FindMetaTable("Player")

function meta:AvailableModels()
    local reg = IG.Regiments[self:GetRegiment()]
    local models = table.Copy(reg.models)

    local class = self:GetRegimentClass()
    if class then
        table.Add(models, ((reg.classes or {})[class] or {}).models)
    end

    if reg.level_bonuses then
        for i=1, (reg.ranks[self:GetRank()] or {}).cl or 1 do
            local bonus_models = (reg.level_bonuses[i] or {}).models or {}
            table.Add(models, bonus_models)
        end
    end

    return models
end

function meta:AvailableWeapons()
    local reg = IG.Regiments[self:GetRegiment()]
    local weapons = table.Copy(reg.weapons)

    local class = self:GetRegimentClass()
    if class then
        table.Add(weapons, ((reg.classes or {})[class] or {}).weapons)
    end

    if reg.level_bonuses then
        for i=1, (reg.ranks[self:GetRank()] or {}).cl or 1 do
            local bonus_weapons = (reg.level_bonuses[i] or {}).weapons or {}
            table.Add(weapons, bonus_weapons)
        end
    end

    return weapons
end