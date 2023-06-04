# Character Module

The character module manages persistent character data.
This module is required by the [player_imperial](../../player_class/player_imperial.lua) class.

## Persistence

Character data is store in SQLite under the `character_data` table

| Column    | Type    | Description                 | Default           | Constraint    |
|-----------|---------|-----------------------------|-------------------|---------------|
| steamid   | TEXT    | Player's SteamID64          | `ply:SteamID64()` | Primary Key   |
| slot      | INTEGER | Character Slot Number       | 1                 | Primary Key   |
| name      | TEXT    | Character RP Name           | `ply:Nick()`      |               |
| regiment  | TEXT    | Regiment Identifier         | RECRUIT           |               |
| class     | TEXT    | Regiment Class Identifier   |                   |               |
| rank      | INTEGER | Rank Number                 | 1                 |               |

This data can be retrieved using `ply:GetCharacterData(slot)`

## Multiple Characters

Only a single character is loaded for each player at a time, but multiple can be persisted to the database.

This is done using the composite primary key of `steamid` and `slot`.

To retrieve any character data from the database, you must provide both.

Most players will only have a single character, but to keep track of which one they've selected we have an in-memory table `IG.SelectedCharacter`.

This table is a simple kv pair, with the key being the steamid, and the value being the slot they've selected, defaulting to `1`.

## Job Code

The job code for regiments and ranks are stored in [sh_regiments.lua](../../data/sh_regiments.lua) and [sh_ranks.lua](../../data/sh_ranks.lua).

Details on the job data can be found in the main [README](../../../README.md).

`regiment`, `class` and `rank` must match identifiers specified in the job data, otherwise the character data will be invalid.
