local compass_style = {
    heading = true,		-- Whether or not the precise bearing is displayed. (Default: true)
    compassX = 0.5,		-- This value is multiplied by users screen width. (Default: 0.5)
    compassY = 0.05,	-- This value is multiplied by users screen height. (Default: 0.05)
    width = 0.25,		-- This value is multiplied by users screen width. (Default: 0.25)
    height = 0.03,		-- This value is multiplied by users screen height. (Default: 0.03)
    spacing = 2.5,		-- This value changes the spacing between lines. (Default: 2.5)
    ratio = 2,			-- The is the ratio of the size of the letters and numbers text. (Default: 2)
    offset = 0,			-- The number of degrees the compass will offset by. (Default: 0)
    maxMarkerSize = 1,	-- Maximum size of the marker, note that this affects scaling (Default: 1)
    minMarkerSize = 0.5, -- Minimum size of the marker, note that this affects scaling (Default: 0.5)
    color = Color(255, 255, 255), -- The color of the compass.
    style = "pubg",
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

        spacing = (width * cl_spacing) / 360
        numOfLines = width / spacing
        fadeDistMultiplier = 1
        fadeDistance = (width / 2) / fadeDistMultiplier

        surface.SetFont("CompassNumbers")

        if compass_style.style == "squad" then
            local text = math.Round(360 - ((ang.y - offset) % 360))
            local font = "CompassNumbers"
            compassBearingTextW, compassBearingTextH = getTextSize(font, text)
            surface.SetFont(font)
            surface.SetTextColor(Color(255, 255, 255))
            surface.SetTextPos(compassX - compassBearingTextW / 2, compassY)
            surface.DrawText(text)
        end

        for i = math.Round(-ang.y) % 360, (math.Round(-ang.y) % 360) + numOfLines do
            -- DEBUGGING LINES
            -- local compassStart = compassX - width / 2
            -- local compassEnd = compassX + width / 2
            -- surface.SetDrawColor(Color(0, 255, 0))
            -- surface.DrawLine(compassStart, compassY, compassStart, compassY + height * 2)
            -- surface.DrawLine(compassEnd, compassY, compassEnd, compassY + height * 2)

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

                if compass_style.style == "pubg" then
                    surface.DrawLine(x, compassY, x, compassY + height * 0.2)
                    surface.DrawLine(x, compassY, x, compassY + height * 0.5)
                    surface.SetTextPos(x - w / 2, compassY + height * 0.6)
                    surface.DrawText(text)
                elseif compass_style.style == "fortnite" then
                    if font == "CompassNumbers" then
                        surface.DrawLine(x, compassY, x, compassY + height * 0.2)
                        surface.DrawLine(x, compassY, x, compassY + height * 0.3)
                        surface.SetTextPos(x - w / 2, compassY + height * 0.5)
                        surface.DrawText(text)
                    elseif font == "CompassLetters" then
                        surface.SetTextPos(x - w / 2, compassY)
                        surface.DrawText(text)
                    end
                elseif compass_style.style == "squad" then
                    local mask1 = {compassX - width/2 - fadeDistance, compassY, width / 2 + fadeDistance - (compassBearingTextW / 1.5), height * 2}
                    local mask2 = {compassX + (compassBearingTextW / 1.5), compassY, width / 2 + fadeDistance - (compassBearingTextW / 1.5), height * 2}
                    local col = Color(color.r, color.g, color.b, calculation)
                    local line = {x, compassY, x, compassY + height * 0.5}
                    custom_compass_DrawLineFunc(mask1, mask2, line, col)
                    surface.SetTextPos(x - w / 2, compassY + height * 0.55)
                    surface.DrawText(text)
                end

                if compass_style.style == "squad" then
                    local mask1 = {compassX - width/2 - fadeDistance, compassY, width/2 + fadeDistance - (compassBearingTextW / 1.5), height * 2}
                    local mask2 = {compassX + (compassBearingTextW / 1.5), compassY, width/2 + fadeDistance - (compassBearingTextW / 1.5), height * 2}
                    local col = Color(color.r, color.g, color.b, calculation)

                    local line = {x, compassY, x, compassY + height * 0.5}
                    custom_compass_DrawLineFunc(mask1, mask2, line, col)
                end
            end

            if compass_style.style == "squad" then
                if i_offset % 5 == 0 and i_offset % 15 != 0 then
                    local mask1 = {compassX - width/2 - fadeDistance, compassY, width/2 + fadeDistance - (compassBearingTextW / 1.5), height}
                    local mask2 = {compassX + (compassBearingTextW / 1.5), compassY, width/2 + fadeDistance - (compassBearingTextW / 1.5), height}
                    local col = Color(color.r, color.g, color.b, calculation)

                    local line = {x, compassY, x, compassY + height * 0.25}
                    custom_compass_DrawLineFunc(mask1, mask2, line, col)
                end
            end
        end

        if compass_style.heading and compass_style.style != "squad" then
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
