local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
    ["CHudAmmo"] = true, 
}

hook.Add("HUDShouldDraw", "HideHUD", function(name)
	if (hide[name]) then
		return false
	end
end)

hook.Add("HUDPaint", "IGDrawHud", function()

end);