# The endgame you've been waiting for! 🕰️⚰️

![logo](logo.png)

TIHYD (pronounced **TIDE**) is a mod that focuses on adding fully configurable character aging functionality. As a mod that will rarely be experienced, it is guaranteed to test commitment to favorite characters.
  
_The repository folder structure is in accordance with the PZ Steam Workshop guidelines._

## Installation 🛠️ 

- Clone the repository:

  ```shell
  git clone https://github.com/Dy0gu/TIHYD.git
  ```

- For a local Build 42 installation, copy `TIHYD/Contents/mods/TIHYD` into `~/Zomboid/mods/`.
- For Workshop development and uploading, copy the outer `TIHYD` folder into `~/Zomboid/Workshop/` instead. Do not keep duplicate local and Workshop copies enabled.

The mod uses Build 42's versioned layout: reusable Lua, sandbox options, and translations live in `common/media/`, while Build 42 metadata, the poster, and the character-creation UI adapter live in `42/`. This layout does not provide Build 41 support.
  
## Usage ▶️ 

- Launch the game and activate the mod in the respective panel.
- Choose **Starting age** (18–90) on the character appearance screen. Each new character starts with a random selection; the appearance screen's **Random** button also randomizes age. The selection is saved per character, not shared through sandbox settings.
- Existing characters keep their current age when first migrated to per-character aging data. Characters created without the age selector receive a random starting age.
- Set **Days per year** in the mod's sandbox options to choose how many in-game survival days count as one year of character age (default: **365**, range: **1–1000**). This is useful with mods such as **Surviving Through Seasons** that change the length of a year; it changes TIHYD's aging calculation, not the game's calendar or day length. Changing the setting in an existing save recalculates age from total survival time.

### Character-creation compatibility

The Build 42 adapter chains the existing `createNameAndGender`, `setVisible`, and `onRandomCharacter` methods rather than replacing the vanilla screen. It participates in the existing scrolling/resizing layout and appends a controller navigation row. Mods that replace these methods without chaining, replace the identity panel, or independently overwrite character age can still conflict. The profession/traits Random button and outfit-only randomization do not change age.

Hook references: [Build 42.20.2 vanilla character-creation source](https://github.com/Project-Zomboid-Community-Modding/ProjectZomboid-Vanilla-Lua/blob/8a906692ac56f9d40c078d654eea6c70491cbc62/client/OptionScreens/CharacterCreationMain.lua), [OnCreatePlayer event](https://pzwiki.net/wiki/OnCreatePlayer), and [Umbrella SurvivorDesc API](https://github.com/PZ-Umbrella/Umbrella/blob/main/library/java/zombie/characters/SurvivorDesc.lua).

Before release, test new characters, Random, going Back and returning, replacement characters after death, loading existing saves, multiple local players, controller navigation, and any character-creation mods you use. Multiplayer authority/synchronization is not implemented by this client-side UI change.

## Development typings

[Umbrella](https://github.com/PZ-Umbrella/Umbrella) is included as a Git submodule in `umbrella/` for local editor support. `.emmyrc.json` references `umbrella/library`. Only its URL and pinned commit are tracked by this repository; its source lives in the upstream repository. It is outside the `TIHYD/` Workshop package and is not shipped with the mod.

For a fresh development checkout:

```shell
git clone --recurse-submodules https://github.com/Dy0gu/TIHYD.git
```

For an existing checkout:

```shell
git submodule update --init --recursive
```

Use an EmmyLua-compatible language server in your editor to load the typings. Players do not need the submodule to use the mod.

## Acknowledgments ©️

Thank you to all the contributors behind the [Umbrella](https://github.com/asledgehammer/Umbrella) collection, which provides EmmyLua typings for the Project Zomboid API, massively speeding up development time!
