local function EventMenu()
    local players = {}

    local frame = vgui.Create("DFrame")
    frame:SetSize(1024, 720)
    frame:SetTitle("Event Menu")
    frame:Center()
    frame:SetVisible(true)
    frame:MakePopup()
    frame:SetSizable(true)
end

concommand.Add("event_menu", EventMenu)
