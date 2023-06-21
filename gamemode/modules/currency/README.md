# Currency Module

This currency module manages both roleplay currency (credits) and external, paid currency (premium currency).
Currency is shared between one player's characters.

It also contains the login bonus menu when players join the game.

## Persistence

Currency data is stored in SQLite under the `player_currency` table

| Column    | Type    | Description                 | Default           | Constraint    |
|-----------|---------|-----------------------------|-------------------|---------------|
| steamid   | TEXT    | Player's SteamID64          | `ply:SteamID64()` | Primary Key   |
| credits   | INTEGER | Player's Roleplay Credits   | 0                 |               |
| premium   | INTEGER | Player's Premium Currency   | 0                 |               |
| xp        | INTEGER | Player's XP (max 10000)     | 0                 |               |
| level     | INTEGER | Player's Level              | 1                 |               |

Login bonus data is stored in SQLite under the `player_loginbonus` table

| Column         | Type    | Description                 | Default            | Constraint    |
|----------------|---------|-----------------------------|--------------------|---------------|
| steamid        | TEXT    | Player's SteamID64          | `ply:SteamID64()`  | Primary Key   |
| day            | INTEGER | Player's Current Day        | 1                  |               |
| streak         | INTEGER | Player's Current Streak     | 1                  |               |
| longest_streak | INTEGER | Player's XP (max 10000)     | 1                  |               |
| last_day       | INTEGER | Player's Last Login Day     | Server's Day Value |               |
| claimed_day    | INTEGER | Player's Day Boolean        | 0                  |               |
| claimed_streak | INTEGER | Player's Streak Boolean     | 0                  |               |

## Functions

This data can be retrieved and modified using the following functions.
* [SHARED] `ply:GetCredits()` - Returns an integer of the player's roleplay credits. Clientside will only return the correct amount when using LocalPlayer(). Any other entity will return 0.
* [SHARED] `ply:GetPremiumCurrency()` - Returns an integer of the player's premium currency. Clientside will only return the correct amount when using LocalPlayer(). Any other entity will return 0.
* [SHARED] `ply:GetXP()` - Returns an integer of the player's current XP, aswell as the max amount of XP. Clientside will only return the correct amount when using LocalPlayer(). Any other entity will return 0.
* [SHARED] `ply:GetLevel()` - Returns an integer of the player's current level. Clientside will only return the correct amount when using LocalPlayer(). Any other entity will return 1.

* [SHARED] `ply:CanAffordCredits( int )` - Returns a boolean depending if the player has roleplay credits more than or equal to the argument. Clientside will only return the correct amount when using LocalPlayer(). Any other entity will return false.
* [SHARED] `ply:CanAffordPremium( int )` - Returns a boolean depending if the player has premium currency more than or equal to the argument. Clientside will only return the correct amount when using LocalPlayer(). Any other entity will return false.

* [SERVER] `ply:AddCredits( int )` - Adds the argument on to the player's roleplay credits. Use a negative number to subtract. Returns new amount.
* [SERVER] `ply:AddPremiumCurrency( int )` - Adds the argument on to the player's premium currency. Use a negative number to subtract. Returns new amount.
* [SERVER] `ply:AddXP( int )` - Adds the argument on to the player's xp. Use a negative number to subtract. Returns new xp and level.