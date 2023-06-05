# Spawn Module

## Persistence

Spawn data is store in SQLite under the `regiment_spawns` table

| Column    | Type    | Description                 | Default               | Constraint    |
|-----------|---------|-----------------------------|-----------------------|---------------|
| map       | TEXT    | Player's SteamID64          | `game.CurrentMap()`   | Primary Key   |
| regiment  | TEXT    | Regiment's Identifier       |                       | Primary Key   |
| x         | INTEGER | Vector `x` position         |                       |               |
| y         | INTEGER | Vector `y` position         |                       |               |
| z         | INTEGER | Vector `z` position         |                       |               |

## Setting spawn points

Spawns and assigned per regiment, and can be set using the `Set Spawn` toolgun tool.

To use it, simply set a regiment, point and click at the floor where you want it to be.

## Collision detection

Instead of no-colliding players, the approach we take is to run a collision check at spawn and move the player in a random part of the grid and run the check again.

In the following example, x is the spawn point and each box is 35 units.

If a collision is detected, the player will move to a random box and the check will run again.

This check and move operation can happen a maximum number of times (currently 20), and was tempted to work well with 128 players all respawning at the same time.

|   |   |   |   |   |
|---|---|---|---|---|
| o | o | o | o | o |
| o | o | o | o | o |
| o | o | x | o | o |
| o | o | o | o | o |
| o | o | o | o | o |
