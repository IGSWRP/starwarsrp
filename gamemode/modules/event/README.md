# Event Module

This module contains everything to do with event characters.

It is similar to the character module, but is used by the [player_event](../../player_class/player_event.lua) class.

## Persistence

There is currently **no** persistence of data to do with event characters, as they are temporary characters.

Any change to character data, including name, preset etc. will not persist to the database while players are set to the player_event class.

Note that some changes to player data, like currency, will persist.

## Event Menu

Similar to the promotion menu, event characters can open the event menu with F2.

This menu can be used by event characters to see who else is playing as an event character, and choose to leave the event.

This menu is even more useful for admins, where they can use the menu to:
* create presets
* edit presets
* set default preset for when you invite players
* send an open invite to become an event character
* set indivual players to event characters
* assign event character's presets
* remove event characters
* reward event characters

## Preets

Presets are like temporary jobs or regiments that admins can setup in game.

Presets currenty have these fields:
* Name
* Health
* Models
* Weapons
