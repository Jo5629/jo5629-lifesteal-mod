# Lifesteal Mod

## API

### Functions

- `lifesteal_mod.update(player, hpMax)`
  - `player`: PlayerRef
  - `hpMax`: int
  - If hpMax is specified, `player`'s `hp_max` will be set to `hpMax`.
- `lifesteal_mod.getHearts(pName)`
- `lifesteal_mod.setHearts(pName, num)`
- `lifesteal_mod.banPlayer(pName)`
- `lifesteal_mod.unbanPlayer(pName)`
- `lifesteal_mod.listContains(pName)`
  - Checks to see if `pName` is in the banlist.
- `lifesteal_mod.tryToKick(player) -> boolean`
  - Returns `true` on success, `false` for failure.
  - `player`: PlayerRef
- `lifesteal_mod.kickAndBan(pName)`
  - `pName`: string
- `lifesteal_mod.revive(pName)`
  - `pName`: string
- `lifesteal_mod.chatsendPlayer(pName, text, color)`
  - Tries to send `text` to `pName` with color `color`.
- `lifesteal_mod.hasHealthBoost(player) -> boolean`
  - Returns `true` on success, `false` for failure.
  - Checks to see if `player` has the `health_boost` effect.
  - Works in VoxeLibre only.

### Constants

- `lifesteal_mod.HP_MAX_NEWPLAYER -> int`
  - Amount of HP a new player will be given.
- `lifesteal_mod.HP_REVIVE -> int`
  - Amount of HP a revived player will be given.
- `lifesteal_mod.HP_MAX -> int`
  - The maximum amount of HP one player can have.
- `lifesteal_mod.DEATH_MESSAGE_DEFAULT -> string`
  - The message returned when someone is dead.
- `lifesteal_mod.CURRENT_GAME -> string`
  - The current game running.
- `lifesteal_mod.HUDBARS -> boolean`
  - Boolean for if `hudbars` is enabled.
- `lifesteal_mod.VL_HUDBARS -> boolean`
  - Boolean for if `vl_hudbars` is enabled.
