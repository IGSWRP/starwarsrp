local meta = FindMetaTable("Player")

function meta:CanAffordCredits( amount )
	if not isnumber(amount) then return false end
	if amount <= 0 then return true end

	return self:GetCredits() - amount >= 0
end

function meta:CanAffordPremium( amount )
	if not isnumber(amount) then return false end
	if amount <= 0 then return true end

	return self:GetPremiumCurrency() - amount >= 0
end