# The endgame you've been waiting for! 🕰️⚰️

TIHYD (/taɪd/) is a mod that focuses on adding fully configurable character
aging functionality to Project Zomboid.

## Installation 🛠️

- Clone the repository:

  ```shell
  git clone https://github.com/dy0gu/tihyd.git
  ```

- Add a local development copy to the game by copying `src/Contents/mods/TIHYD`
  into the `~/Zomboid/mods` folder. The final structure should be
  `~/Zomboid/mods/TIHYD` for the mod to load correctly.

## Usage ▶️

- Launch the game and activate the mod in the respective panel.
- Choose your starting age on the character appearance screen and configure
  aging in the sandbox options.

## Release 🚀

Publish updates through Project Zomboid's in-game Workshop uploader:

1. Copy the contents of `src` into `~/Zomboid/Workshop/TIHYD`, creating the
   `TIHYD` folder if necessary. The final structure should look like this:

   ```text
   ~/Zomboid/Workshop/TIHYD/
   ├── Contents/
   │   └── mods/
   │       └── TIHYD/
   ├── preview.png
   └── workshop.txt
   ```

2. Launch Project Zomboid through Steam using the account that owns the Workshop
   item. Open **Workshop → Create and update items**, then select **TIHYD**.
   If you don't see this option, ensure the file structure from the first step
   is correct.

3. Review the detected metadata and confirm everything looks correct.

4. Continue to the upload screen and accept the workshop legal agreement if
   prompted.

5. Wait for success, then verify the [Workshop page][workshop]
   and test the downloaded update. Disable the local development copy in
   `~/Zomboid/mods/` when testing the Workshop version to avoid conflicts.

[workshop]: https://steamcommunity.com/sharedfiles/filedetails/?id=3013368173

## Acknowledgments ©️

Thank you to all the contributors behind the
[Umbrella](https://github.com/PZ-Umbrella/Umbrella) collection, which provides
EmmyLua typings for the Project Zomboid API, massively speeding up development
time!
