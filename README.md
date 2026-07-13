# Lifesteal Mod

## Why does VoxeLibre work with the mod, but not Mineclonia?

- This is due to the `hudbars` mod in Mineclonia incorrectly rendering the player's healthbar, which is fixed in VoxeLibre.
- Enabling the mod when using Mineclonia will return a warning by the mod.
  - **Enable at your own risk.**

## Features

- When you die, you lose a heart.
- When you kill a player, you gain the heart.
  - If you have already reached the maximum amount of hearts, the heart will turn into an item and enter your inventory if your inventory has room, otherwise the heart will spawn on the ground.
- When a player goes to zero hearts, the player is banned from the server.
- You can withdraw hearts using the  `/withdraw [<hearts>]` command.
  - The command requires the `withdraw` privilege.
- You can bring a banned player back through using a revive lantern.
- Hearts and revive lanterns are craftable.

## API

### Functions

- `lifesteal_mod.update(player, hpMax)`
  - `player`: PlayerRef
  - `hpMax`: int
  - If hpMax is specified, `player`'s `hp_max` will be set to `hpMax`.
  - Updates `player`'s `hp_max` and updated the hud accordingly.
- `lifesteal_mod.getHearts(pName)`
- `lifesteal_mod.setHearts(pName, num)`
- `lifesteal_mod.cleanHPList() -> int`
  - Returns how many entries were cleared.
  - Clears up entries that have a value of 0.
    - The mod assumes that players with 0 HP are dead and banned.
  - Used for freeing up storage space.
- `lifesteal_mod.banPlayer(pName)`
- `lifesteal_mod.unbanPlayer(pName)`
- `lifesteal_mod.isBanned(pName) -> boolean`
  - Checks to see if `pName` is in the banlist.
- `lifesteal_mod.listContains(pName) -> boolean`
  - Alias of `lifesteal_mod.isBanned`.
- `lifesteal_mod.tryToKick(player) -> boolean`
  - Returns `true` on success, `false` for failure.
  - `player`: PlayerRef
- `lifesteal_mod.kickAndBan(pName)`
  - `pName`: string
- `lifesteal_mod.revive(pName) -> boolean`
  - Returns `true` on success, `false` for failure.
  - `pName`: string
  - Attempts to revive `pName`. The amount of hearts `pName` will then be given is dependent on `lifesteal_mod.HP_REVIVE`.
- `lifesteal_mod.chatSendPlayer(pName, text, color)`
  - Tries to send `text` to `pName` with color `color`.
- `lifesteal_mod.hasHealthBoost(player) -> boolean`
  - Returns `true` on success, `false` for failure.
  - `player`: PlayerRef
  - Checks to see if `player` has the `health_boost` effect.
  - The check only occurs when using VoxeLibre, all other games will always return `false`.

### Constants

- `lifesteal_mod.HP_NEWPLAYER -> int`
  - Amount of HP a new player will be given.
- `lifesteal_mod.HP_REVIVE -> int`
  - Amount of HP a revived player will be given.
- `lifesteal_mod.HP_MAX -> int`
  - Maximum amount of HP one player can have.
- `lifesteal_mod.DEATH_MESSAGE_DEFAULT -> string`
  - Default message returned when someone is dead.
- `lifesteal_mod.CURRENT_GAME -> string`
  - The current game running.
- `lifesteal_mod.HUDBARS -> boolean`
  - Checks if `hudbars` is enabled.
- `lifesteal_mod.VL_HUDBARS -> boolean`
  - Checks if `vl_hudbars` is enabled.

## Miscellaneous

- Most versions before 3.0.0 depend on `hudbars`.

> Inspired by the Minecraft Lifesteal SMP.
