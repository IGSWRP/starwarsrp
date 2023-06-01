# Name Module

The name module manages player names.

## Networking

Player Classes must implement the `RPName` NetworkVar to use this module

## Persistence

Uses the character module for the persistence of character names.

Might switch this to call a hook in the player class.

## Nametags

We override the default nametags that show when you hover over a player in base gmod.

This nametag shows the following details:
* Rank
* Name
* Regiment
    - coloured
* Health % (not raw health value)

Nametags can be hidden using the `ply:ShouldHideName()` function defined in [sh_name.lua](module/sh_name.lua).

This may be done when you want a nametag to be hidden to avoid metagaming, e.g. when a player is cloaked or undercover.