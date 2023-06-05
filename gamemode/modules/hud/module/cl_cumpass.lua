local compass_style = {
    heading = true,		-- Whether or not the precise bearing is displayed. (Default: true)
    compassX = 0.5,		-- This value is multiplied by users screen width. (Default: 0.5)
    compassY = 0.05,	-- This value is multiplied by users screen height. (Default: 0.05)
    width = 0.125,		-- This value is multiplied by users screen width. (Default: 0.25)
    height = 0.02,		-- This value is multiplied by users screen height. (Default: 0.03)
    spacing = 3.5,		-- This value changes the spacing between lines. (Default: 2.5)
    ratio = 2,			-- The is the ratio of the size of the letters and numbers text. (Default: 2)
    offset = 0,			-- The number of degrees the compass will offset by. (Default: 0)
    maxMarkerSize = 1,	-- Maximum size of the marker, note that this affects scaling (Default: 1)
    minMarkerSize = 0.5, -- Minimum size of the marker, note that this affects scaling (Default: 0.5)
    color = Color(255, 255, 255), -- The color of the compass.
}

local function getTextSize(font, text)
	surface.SetFont(font)
	local w, h = surface.GetTextSize(text)
	return w, h
end

surface.CreateFont("CompassNumbers", {
	font = "Roboto",
	size = math.Round((ScrH() * compass_style.height) / compass_style.ratio),
	antialias = true
})
surface.CreateFont("CompassLetters", {
	font = "Roboto",
	size = ScrH() * compass_style.height,
	antialias = true
})

local adv_compass_tbl = {
	[0] = "N",
	[45] = "NE",
	[90] = "E",
	[135] = "SE",
	[180] = "S",
	[225] = "SW",
	[270] = "W",
	[315] = "NW",
	[360] = "N"
}

hook.Add("HUDPaint", "HUDPaint_Compass", function()
    local ply = LocalPlayer()
    if true then

        local ang = ply:GetAngles()
        local compassX, compassY = ScrW() * compass_style.compassX, ScrH() * compass_style.compassY
        local width, height = ScrW() * compass_style.width, ScrH() * compass_style.height
        local cl_spacing = compass_style.spacing
        local ratio = compass_style.ratio
        local color = compass_style.color
        local minMarkerSize = ScrH() * (compass_style.minMarkerSize / 45)
        local maxMarkerSize = ScrH() * (compass_style.maxMarkerSize / 45)
        local heading = compass_style.heading
        local offset = compass_style.offset

        local spacing = (width * cl_spacing) / 360
        local numOfLines = width / spacing
        local fadeDistMultiplier = 1
        local fadeDistance = (width / 2) / fadeDistMultiplier

        surface.SetFont("CompassNumbers")

        for i = math.Round(-ang.y) % 360, (math.Round(-ang.y) % 360) + numOfLines do
            local x = ((compassX - (width / 2)) + (((i + ang.y) % 360) * spacing))
            local value = math.abs(x - compassX)
            local calc = 1 - ((value + (value - fadeDistance)) / (width / 2))
            local calculation = 255 * math.Clamp(calc, 0.001, 1)

            local i_offset = -(math.Round(i - offset - (numOfLines / 2))) % 360
            if i_offset % 15 == 0 and i_offset >= 0 then
                local a = i_offset
                local text = adv_compass_tbl[360 - (a % 360)] and adv_compass_tbl[360 - (a % 360)] or 360 - (a % 360)
                local font = type(text) == "string" and "CompassLetters" or "CompassNumbers"
                local w, h = getTextSize(font, text)

                surface.SetDrawColor(Color(color.r, color.g, color.b, calculation))
                surface.SetTextColor(Color(color.r, color.g, color.b, calculation))
                surface.SetFont(font)

                surface.DrawLine(x, compassY, x, compassY + height * 0.2)
                surface.DrawLine(x, compassY, x, compassY + height * 0.5)
                surface.SetTextPos(x - w / 2, compassY + height * 0.6)
                surface.DrawText(text)
            end
        end

        if compass_style.heading then
            -- Middle Triangle
            local triangleSize = 8
            local triangleHeight = compassY

            local triangle = {
                { x = compassX - triangleSize/2, y = triangleHeight - (triangleSize * 2) },
                { x = compassX + triangleSize/2, y = triangleHeight - (triangleSize * 2) },
                { x = compassX, y = triangleHeight - triangleSize },
            }
            surface.SetDrawColor(255, 255, 255)
            draw.NoTexture()
            surface.DrawPoly(triangle)

            if heading then
                local text = math.Round(-ang.y - offset) % 360
                local font = "CompassNumbers"
                local w, h = getTextSize(font, text)
                surface.SetFont(font)
                surface.SetTextColor(Color(255, 255, 255))
                surface.SetTextPos(compassX - w/2, compassY - h - (triangleSize * 2))
                surface.DrawText(text)
            end
        end
    end
end)
