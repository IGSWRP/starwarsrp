# DEFCON Module

Module contains DEFCON functionality.

## Functions
* [SERVER] `UpdateDefcon( ply, level )` - Sets the DEFCON level to the argument provided. Must be between 1 - 5, and the player must be an admin or IHC/Navy.

## Shared Variables

IG_DEFCON_SH is a table that contains the following variables.

* IG_DEFCON_SH.COLOURS[1 - 5] - DEFCON colours, 1 being red through to 5 which is blue.
* IG_DEFCON_SH.ROMAN[1 - 5] - DEFCON roman numerals, 1 being 'I' through to 5 which is 'V'.
