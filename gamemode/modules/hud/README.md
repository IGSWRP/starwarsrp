# HUD Module

This contains most of the hud elements for players

## HUD

The main HUD is in [cl_hud.lua](./module/cl_hud.lua).

We use hooks rather than overriding functions, the only HUD function that we override is `HUDDrawTargetID` in the name module's [cl_nametags.lua](../name/module/cl_nametags.lua).

`HUDShouldDraw` controls what default hud elements we want to hide/disable.

`HUDPaint` is used for each HUD element we want to draw on the player's screen.

## Addons used

Most of the HUD elements are copied and modified from existing addons:

The main modification done is to remove depenency on any additional files.

* [Summe's Star Wars Battlefront II HUD](https://www.youtube.com/watch?v=4EiOP7GXH28)
* [mCompass](https://steamcommunity.com/sharedfiles/filedetails/?id=1452363997)
* [Bleur Scoreboard](https://www.gmodstore.com/market/view/bleur-scoreboard-intuitional-scoreboard-for-all-your-needs)
