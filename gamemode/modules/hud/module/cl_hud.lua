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

--[[
   _____ _          __          __            _    _ _    _ _____  
  / ____| |         \ \        / /           | |  | | |  | |  __ \ 
 | (___ | |_ __ _ _ _\ \  /\  / /_ _ _ __ ___| |__| | |  | | |  | |
  \___ \| __/ _` | '__\ \/  \/ / _` | '__/ __|  __  | |  | | |  | |
  ____) | || (_| | |   \  /\  / (_| | |  \__ \ |  | | |__| | |__| |
 |_____/ \__\__,_|_|    \/  \/ \__,_|_|  |___/_|  |_|\____/|_____/ 
                                                                                                                          
        Created by Summe https://steamcommunity.com/id/DerSumme/
        Purchased content: https://discord.gg/k6YdMwj9w2                          
]]--

local THEME = {
    blurBackgroundColor = Color(24,24,24,63),
    grey = Color(248,248,248,84),
    greyBackground = Color(34,34,34,20),
    whiteText = Color(255,255,255),
    hpBar = Color(255,255,255),
    hpBarDamage = Color(255,0,0),
    hpBarBackground = Color(34,34,34,93),
    apBar = Color(142,153,255),
    money = Color(180,255,177),
}

local function CreateFont(name, size, weight, italic)
    local tbl = {
		font = "Roboto",
		size = size + 2,
		weight = weight or 500,
		extended = true,
		italic = italic or false,
	}

    surface.CreateFont(name, tbl)

	return name
end

local blur = Material("pp/blurscreen")

local function DrawBlur( x, y, w, h, layers, density, alpha )
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, layers do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		render.SetScissorRect( x, y, x + w, y + h, true )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		render.SetScissorRect( 0, 0, 0, 0, false )
	end
end

CreateFont("StarWarsHUD.HPCount", ScrH() * .015, 300, false)
CreateFont("StarWarsHUD.AmmoCount", ScrH() * .011, 300, false)
CreateFont("StarWarsHUD.Name", ScrH() * .02, 300, false)
CreateFont("StarWarsHUD.Credits", ScrH() * .017, 300, false)

local barColor = THEME.hpBarDamage

local Color_ = Color
local lerp_ = Lerp
local COLORMeta = FindMetaTable("Color")

function COLORMeta:Lerp(t, to)
    self.r = lerp_(t, self.r, to.r)
    self.g = lerp_(t, self.g, to.g)
    self.b = lerp_(t, self.b, to.b)
    self.a = lerp_(t, self.a, to.a)
    return self
end

local function LerpColor(t, from, to)
    return Color_(from.r, from.g, from.b, from.a):Lerp(t, to)
end

hook.Add("HUDPaint", "StarWarsHUD.DrawMain", function()
    if not LocalPlayer():Alive() then return end

    local scrw, scrh = ScrW(), ScrH()

    local hudStartPos = {
        x = scrw * .02,
        y = scrh * .89,
    }

    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y, scrw * .164, scrh * .04, THEME.blurBackgroundColor)
    DrawBlur(hudStartPos.x, hudStartPos.y, scrw * .164, scrh * .04, 4, 3, 255)

    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y, scrw * .17, scrh * .0025, THEME.grey)
    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y + scrh * .04, scrw * .17, scrh * .0025, THEME.grey)
    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y - scrh * .025, scrw * .0015, scrh * .095, THEME.grey)
    draw.RoundedBox(0, hudStartPos.x + scrw * .13, hudStartPos.y, scrw * .0015, scrh * .04, THEME.grey)

    for i = 0, 2 do
        draw.RoundedBox(0, hudStartPos.x + scrw * .163, hudStartPos.y + (scrh * .0155 * i), scrw * .0015, scrh * .01, THEME.grey)
    end

    local hp, maxHp = LocalPlayer():Health(), LocalPlayer():GetMaxHealth()
    local quotient = math.Clamp(hp/maxHp, 0, 1)

    if barColor != THEME.hpBar then
        barColor = LerpColor(FrameTime() * 1, barColor, THEME.hpBar)
    end

    draw.RoundedBox(3, hudStartPos.x + scrw * .0045, hudStartPos.y + scrh * .0065, (scrw * .12225), scrh * .029, THEME.hpBarBackground)
    draw.RoundedBox(3, hudStartPos.x + scrw * .0045, hudStartPos.y + scrh * .0065, (scrw * .12225) * quotient, scrh * .029, barColor)

    local ap, maxAp = LocalPlayer():Armor(), false and LocalPlayer():GetMaxArmor() or 255
    local quotient = math.Clamp(ap/maxAp, 0, 1)

    draw.RoundedBox(3, hudStartPos.x + scrw * .0045, hudStartPos.y + scrh * .03, (scrw * .12225) * quotient, scrh * .0057, THEME.apBar)

    draw.DrawText(hp, "StarWarsHUD.HPCount", hudStartPos.x + scrw * .1465, hudStartPos.y + scrh * .0063, THEME.whiteText, TEXT_ALIGN_CENTER)
    -- draw.DrawText(ap, "StarWarsHUD.AmmoCount", hudStartPos.x + scrw * .1468, hudStartPos.y + scrh * .022, THEME.whiteText, TEXT_ALIGN_CENTER)

	
	local displayname = ((LocalPlayer():GetRankName() .. " ") or "") .. LocalPlayer():Name()

    draw.DrawText(displayname, "StarWarsHUD.Name", hudStartPos.x + scrw * .005, hudStartPos.y - scrh * .023, THEME.whiteText, TEXT_ALIGN_LEFT)

    draw.DrawText(LocalPlayer():GetRegimentName() or "#REGIMENT", "StarWarsHUD.Name", hudStartPos.x + scrw * .005, hudStartPos.y + scrh * .043, THEME.whiteText, TEXT_ALIGN_LEFT)

    draw.DrawText("₹" .. LocalPlayer():GetCredits(), "StarWarsHUD.Credits", hudStartPos.x + scrw * .1615, hudStartPos.y - scrh * .022, THEME.money, TEXT_ALIGN_RIGHT)
end)

gameevent.Listen( "player_hurt" )
hook.Add( "player_hurt", "player_hurt_example", function( data ) 
    if data.userid == LocalPlayer():UserID() then
        barColor = THEME.hpBarDamage
    end
end )

CreateFont("StarWarsHUD.WeaponXS", ScrH() * .01, 300, false)
CreateFont("StarWarsHUD.WeaponS", ScrH() * .013, 300, false)

hook.Add("HUDPaint", "StarWarsHUD.WeaponInfo", function()
    if not LocalPlayer():Alive() then return end
    
    local scrw, scrh = ScrW(), ScrH()

    local hudStartPos = {
        x = scrw * .86,
        y = scrh * .92,
    }

    draw.RoundedBox(0, hudStartPos.x + scrw * .005, hudStartPos.y, scrw * .091, scrh * .0395, THEME.blurBackgroundColor)
    DrawBlur(hudStartPos.x + scrw * .005, hudStartPos.y, scrw * .091, scrh * .0395, 4, 5, 255)

    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y, scrw * .1, scrh * .0025, THEME.grey)
    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y + scrh * .04, scrw * .1, scrh * .0025, THEME.grey)

    for i = 0, 2 do
        draw.RoundedBox(0, hudStartPos.x + scrw * .095, hudStartPos.y + (scrh * .0155 * i), scrw * .0015, scrh * .01, THEME.grey)
        draw.RoundedBox(0, hudStartPos.x + scrw * .005, hudStartPos.y + (scrh * .0155 * i), scrw * .0015, scrh * .01, THEME.grey)
    end

    local weaponObj = LocalPlayer():GetActiveWeapon()
    if not IsValid(weaponObj) then return end

    local printName = weaponObj:GetPrintName() or "Weapon"
    local font = "StarWarsHUD.Name"

    if #printName > 30 then
        font = "StarWarsHUD.WeaponXS"
    elseif #printName > 15 then
        font = "StarWarsHUD.WeaponS"
    end

    local ammoCurrent = weaponObj:Clip1()
    if ammoCurrent < 0 then
        draw.SimpleText(weaponObj.PrintName or "Weapon", font, hudStartPos.x + scrw * .05, hudStartPos.y + scrh * .019, THEME.whiteText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        local ammoType = weaponObj:GetPrimaryAmmoType()
        local ammoMax = LocalPlayer():GetAmmoCount(ammoType)
        draw.SimpleText(weaponObj.PrintName or "Weapon", font, hudStartPos.x + scrw * .01, hudStartPos.y + scrh * .019, THEME.whiteText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.DrawText(ammoCurrent, "StarWarsHUD.HPCount", hudStartPos.x + scrw * .088, hudStartPos.y + scrh * .0063, THEME.whiteText, TEXT_ALIGN_RIGHT)
        draw.DrawText(ammoMax, "StarWarsHUD.AmmoCount", hudStartPos.x + scrw * .088, hudStartPos.y + scrh * .02, THEME.whiteText, TEXT_ALIGN_RIGHT)
    end
end)


-- CreateFont("StarWarsHUD.OHName", 20, 300, false)
-- CreateFont("StarWarsHUD.OHRank", 12, 300, false)

-- local greyAlpha = ColorAlpha(THEME.grey, 50)

-- hook.Add("HUDPaint", "StarWarsHUD.OverHead", function()
--     trace = LocalPlayer():GetEyeTrace()
--     ent = trace.Entity

--     if not IsValid(ent) then return end
--     if not ent:IsPlayer() then return end
--     if LocalPlayer():GetPos():Distance(ent:GetPos()) > 400 then return end
--     if ent:ShouldHideName() then return end

--     local ply = ent

--     local pos = ply:EyePos()
--     pos.z = pos.z + 25
--     pos = pos:ToScreen()

--     local displayname = ((ply:GetRankName() .. " ") or "") .. ply:Name()
--     -- local name = ply:Name()

--     local scrw, scrh = ScrW(), ScrH()

--     surface.SetDrawColor(THEME.whiteText)
--     surface.SetFont("StarWarsHUD.Name")
--     local ts = surface.GetTextSize(displayname)
--     local width = scrw * .03 + ts

--     DrawBlur(pos.x - width/2, pos.y, width, scrh * .034, 4, 5, 255)

--     draw.RoundedBox(0, pos.x - width/2, pos.y - scrh * .001, width, scrh * .0025, greyAlpha)

--     draw.DrawText(displayname, "StarWarsHUD.OHName", pos.x, pos.y, THEME.whiteText, TEXT_ALIGN_CENTER)
--     draw.DrawText(ply:GetRegimentName() or "#REGIMENT", "StarWarsHUD.OHRank", pos.x, pos.y + scrh * .018, THEME.whiteText, TEXT_ALIGN_CENTER)

--     draw.RoundedBox(0, pos.x - width/2, pos.y + scrh * .033, width, scrh * .0025, greyAlpha)

--     for i = 0, 2 do
--         draw.RoundedBox(0, pos.x - width * .45, pos.y - scrh * .003 + (scrh * .0153 * i), scrw * .0015, scrh * .01, greyAlpha)
--         draw.RoundedBox(0, pos.x + width * .435, pos.y - scrh * .003 + (scrh * .0153 * i), scrw * .0015, scrh * .01, greyAlpha)
--     end
-- end)