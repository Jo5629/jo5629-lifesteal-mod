# Lifesteal Mod

| Game | Supported? |
| --- | --- |
| Minetest Game | ✔️ Fully Supported |
| VoxeLibre | ➖ Supported only in versions `0.91.0+` |
| Mineclonia | ❌ Not Supported |
| Other Games | Unknown |

## Why is Mineclonia not supported, but VoxeLibre is?

- As of [Mineclonia 0.122.2](https://codeberg.org/mineclonia/mineclonia/releases/tag/0.122.2), the `hudbars` mod incorrectly renders the player's healthbar.
  - This issue is fixed in [VoxeLibre 0.91.0](https://git.minetest.land/VoxeLibre/VoxeLibre/src/branch/master/releasenotes/0_91-the-sneaky-release.md#hudbars-update).
  - If you want to use Mineclonia, **enable at your own risk. Undesirable functionality may occur.**

## Features

- When you die, you lose a heart.
- When you kill a player, you gain the heart.
  - If you have already reached the maximum amount of hearts, the heart will turn into an item and enter your inventory if your inventory has room, otherwise the heart will spawn on the ground.
- When a player goes to zero hearts, the player is banned from the server.
- You can withdraw hearts using the  `/withdraw [<hearts>]` command.
  - The command requires the `withdraw` privilege.
- Combat Mode
  - If Player A punches Player B, Player B will enter combat mode.
  - If Player B dies and is in combat mode, Player A will receive the heart.
  - If combat logging is enabled, Player B leaves the game, and Player B is in combat mode, Player B will lose the heart and Player A will receive it.
- You can bring a banned player back through using a revive lantern.
- Depending on the game, hearts and revive lanterns are craftable.
- **Some functionality will be disabled if `enable_damage` is disabled or not found.**

## API

### Functions

- `lifesteal_mod.update(player, hpMax)`
  - `player`: PlayerRef
  - `hpMax`: int
  - If hpMax is specified, `player`'s `hp_max` will be set to `hpMax`.
  - Updates `player`'s `hp_max` and updated the hud accordingly.
- `lifesteal_mod.getHearts(pName)`
- `lifesteal_mod.setHearts(pName, num)`
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
- `lifesteal_mod.cleanHPList() -> int`
  - Returns how many entries were cleared.
  - Clears up entries that have a value of 0.
    - The mod assumes that players with 0 HP are dead and banned.
  - Used to free up storage space.
- `lifesteal_mod.clamp(num, min, max)`

### Constants

- `lifesteal_mod.HP_NEWPLAYER -> int`
  - Amount of HP a new player will be given.
- `lifesteal_mod.HP_REVIVE -> int`
  - Amount of HP a revived player will be given.
- `lifesteal_mod.HP_MAX -> int`
  - Maximum amount of HP one player can have.
- `lifesteal_mod.COMBAT_TIMER -> float`
- `lifesteal_mod.ENABLE_COMBAT_LOGGING -> bool`
- `lifesteal_mod.NOTIFY_COMBAT_MODE -> bool`
- `lifesteal_mod.DEATH_MESSAGE_DEFAULT -> string`
  - Default message returned when someone is dead.
- `lifesteal_mod.CURRENT_GAME -> string`
  - The current game running.
- `lifesteal_mod.HUDBARS -> boolean`
  - Checks if `hudbars` is enabled.
- `lifesteal_mod.VL_HUDBARS -> boolean`
  - Checks if `vl_hudbars` is enabled.
- `lifesteal_mod.DAMAGE_ENABLED -> boolean`
- `lifesteal_mod.PREFIX -> string`
  - Mainly used for messages for the player and `debug.txt`.

## Miscellaneous

- Most versions before `3.0.0` depend on `hudbars`.

> Inspired by the Minecraft Lifesteal SMP.
