# Keycard Module

Contains the functions needed to be able to create keycards for players

**NOTE**: There is known problem with the bKeypads where when you drop a keycard and pick it back up it will not work. This can be circumvented by removing Line 58 of sh_keycard_inventory.lua (which is `bKeypads_Keycards_Registry[keycardID] = bKeypads.Keycards:GetKeycardData(ply)`). 

## ***Developer Functions***
---

## Player:GiveKeycard()

### Description 
Allocates a keycard to the player based on the given keycard ID. This function is only available on the server realm.

### Arguments

| Data Type 	| Argument Name 	| Description                                                           	|
|-----------	|---------------	|-----------------------------------------------------------------------	|
| Table     	| levels       	    | A table with the (integer) ids of the keycards you wish to give           |
|               |                   | (e.g {1,2,3})                                                             |

### Examples

```lua
ply:GiveKeycard( {3, 5, 6} ) -- Gives the player keycards with the ids 3, 5 and 6
```

## Player:giveDefaultKeycards() 
Gives the player the keycards that are associated with their regiment and/or rank (if any). This function is only available on the server realm.

**NOTE**: This is based on the keycard key in the `level_bonuses` table in the [regiment data config](../../data/sh_regiments.lua). The keycard key must contain a table with `NAMES` of the keycards you wish to give the player. 

### Arguments

N/A


