# Currency Module

This currency module manages both roleplay currency (credits) and external, paid currency (premium currency).
Currency is shared between one player's characters.

## Persistence

Currency data is store in SQLite under the `player_currency` table

| Column    | Type    | Description                 | Default           | Constraint    |
|-----------|---------|-----------------------------|-------------------|---------------|
| steamid   | TEXT    | Player's SteamID64          | `ply:SteamID64()` | Primary Key   |
| credits   | INTEGER | Player's Roleplay Credits   | 0                 |               |
| premium   | INTEGER | Player's Premium Currency   | 0                 |               |

## Functions

This data can be retrieved and modified using the following functions.
[SHARED] `ply:GetCredits()` - Returns an integer of the player's roleplay credits. Clientside will only return the correct amount when using LocalPlayer(). Any other entity will return 0.
[SHARED] `ply:GetPremiumCurrency()` - Returns an integer of the player's premium currency. Clientside will only return the correct amount when using LocalPlayer(). Any other entity will return 0.

[SHARED] `ply:CanAffordCredits(int)` - Returns a boolean depending if the player has roleplay credits more than or equal to the argument. Clientside will only return the correct amount when using LocalPlayer(). Any other entity will return false.
[SHARED] `ply:CanAffordPremium(int)` - Returns a boolean depending if the player has premium currency more than or equal to the argument. Clientside will only return the correct amount when using LocalPlayer(). Any other entity will return false.

[SERVER] `ply:AddCredits(int)` - Adds the argument on to the player's roleplay credits. Use a negative number to subtract.
[SERVER] `ply:AddPremiumCurrency(int)` - Adds the argument on to the player's premium currency. Use a negative number to subtract.