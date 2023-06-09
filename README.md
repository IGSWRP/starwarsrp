![Imperial Gaming](./title.png)

# Star Wars RP Gamemode

Lightweight gamemode fit for purpose for Star Wars Roleplay.


## Modules

The gamemode code is split into modules:
* [character](./gamemode/modules/character/README.md)
* [chat](./gamemode/modules/chat/README.md)
* [currency](./gamemode/modules/currency/README.md)
* [hud](./gamemode/modules/hud/README.md)
* [name](./gamemode/modules/name/README.md)
* [spawn](./gamemode/modules/spawn/README.md)
* [promotion](./gamemode/modules/promotion/README.md)

### Module Loading

We don't automatically load every file in the gamemode, you have to use include() and AddCSLuaFile() manually.

* [gamemode/shared.lua](./gamemode/shared.lua)
    - This is the first thing loaded after cl_init.lua and init.lua
    - It loads our shared data and modules and we can control the load order
* [gamemode/modules/](./gamemode/modules/)
    - each module it's own directory
    - `sh_module.lua` as the entrypoint to load the module's files
    - Follow the naming convention of `sh_`, `cl_` and `sv_`
* [gamemode/data/](./gamemode/data/)
    - Statically defined tables that will be available to both the client and server
    - Can also include accessor funcs for the data
    - Don't need to worry about networking here

## Data

Jobs are defined in lua

* [gamemode/data/sh_ranks.lua](./gamemode/data/sh_ranks.lua)
    - Ranks are defined here so we don't have to duplicate them for each regiment
    - Group indexes (e.g. `["army"]`) are what the regiment data references
    - Rank indexes (e.g. `[1]`) are important as character data references this
    - `name` and `cl` are safe to change
* [gamemode/data/sh_regiments.lua](./gamemode/data/sh_regiments.lua)
    - Regiments are defined here
    - Indexes (e.g. `["ST"]`) are important as character data references this
    - `name` and the other values are safe to change
    - `ranks` must match an item in [sh_ranks.lua](./gamemode/data/sh_ranks.lua)
    - `classes` is a list of classes the regiment has access to
        + Class indexes (e.g. `["HEAVY"]`) are important as character data references this
        + Not limited to SPEC, HEAVY and SUPPORT
        + Any fields defined here will **override** existing regiment values for that class 
    - `level_bonuses` is a list of additions that each cl level gets
        + Level bonus indexes match the `cl` field of a rank, not the index of the rank
        + Don't bother adding a bonus for `[1]` as 1 is the minimum clearance level and it doesn't make sense for the default to get a bonus
        + Any fields define here will be **appended** to the existing regiment values for ranks of that cl level
        + Bonuses will be applied factorially, e.g. for `cl = 3` the bonuses from both `[3]` and `[2]` will be applied
    - `channel` is an optional field used for secure comms
        + If this value is not set, a regiment will defualt to having it's secure comms only visible within the regiment
        + Multiple regiments can have the same value for `channel`, e.g. ISB, DT and Inferno may all have `channel = compnor`

## Player Class

To split logic between player's characters and temporary event characters we use [Player Classes](https://wiki.facepunch.com/gmod/Player_Classes)

This allows us to easily customise the way different types of players spawn, manage their data and function differently.

The default player class is [player_imperial](./gamemode/player_class/player_imperial.lua), which is a persistent roleplay character that belongs to a regiment.

An event character and event master class is planned.