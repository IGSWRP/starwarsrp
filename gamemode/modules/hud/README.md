# HUD Module

This contains most of the hud elements for players

## HUD

The main HUD is in [cl_hud.lua](./module/cl_hud.lua).

We use hooks rather than overriding functions, the only HUD function that we override is `HUDDrawTargetID` in the name module's [cl_nametags.lua](../name/module/cl_nametags.lua).

`HUDShouldDraw` controls what default hud elements we want to hide/disable.

`HUDPaint` is used for each HUD element we want to draw on the player's screen.

## Commands

Players can use the following console commands to edit their HUD

`mellowcholy_sway` controls the intensity of the sway effect. [0 - 5] (DEFAULT: 0.5)

`mellowcholy_scanlines` determines if scanlines should be shown on HUD elements. [0 - 1] (DEFAULT: 1)

`mellowcholy_glow` determines if certain text and icons should glow on HUD elemtns. [0 - 1] (DEFAULT: 1)

## Addons used

* [mCompass](https://steamcommunity.com/sharedfiles/filedetails/?id=1452363997)
* [Bleur Scoreboard](https://www.gmodstore.com/market/view/bleur-scoreboard-intuitional-scoreboard-for-all-your-needs)
