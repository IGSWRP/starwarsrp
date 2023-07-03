# Bodygroups Module

The bodygroups module allows players to swap between models they have available, and edit their body groups.

This module is referred to as "bodyworks" and it was my first addon, written to replace bodygroupr.

## Storage

All storage is done client side in json files under `data/`.

* `data/bodyworks/data.json`
    * array
        * key: model
        * value: skin and bodygroups, seperated by `|`
        * there's also an item with the key `current_model` with just the model as value
* `data/bodyworks/presets.json`
    * array
        * key: preset id
        * value: model, skin and bodygroups, seperated by `|`

These files can be nuked by players in the very rare scenario it's been corrupted by running `cl_bodyworks_reset`.

## Previous Model

Bodyworks savds the previous model that has been swapped to, and will attempt to load it the first time a player loads in, and each time the SetModel is called on the player class.

It won't always be a model that the player owns, in which case the bodygroups for their current model will be loaded instead.

Only a single previous model is saved at a time, so it doesn't take into account what character you have loaded.

## Swapping Models

All models from the player's regiment data (accounting for rank and class too) or event preset are shown as swaps.

Presets are also shown.

## Presets

These can be saved using the `+` button in the bodyworks UI.

These will display even if they aren't currently available to the player, but they won't be able to be swapped to.

Presets can be removed by clicking the `x` button on them.

Presets are mainly useful for models with a lot of bodygroups or event masters, but most of the time they won't be necessary.
