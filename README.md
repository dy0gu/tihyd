# The endgame you've been waiting for! 🕰️⚰️

TIHYD (/taɪd/) is a mod that focuses on adding fully configurable character
aging functionality to Project Zomboid.

## Installation 🛠️

- Clone the repository:

  ```shell
  git clone https://github.com/dy0gu/tihyd.git
  ```

- Add a local development copy of the mod to the game by copying `src/Contents/mods/TIHYD`
  into the `~/Zomboid/mods` folder, this copy takes priority over the subscribed workshop version.

  The final structure should look like this:

  ```text
  ~/Zomboid/mods/TIHYD/
  └── common/
  └── ...
  ```

## Usage ▶️

- Launch the game and activate the mod in the respective panel.

    - If the mod is not showing in-game, ensure the file structure is correct.
    
- Choose your starting age on the character appearance screen and configure
  aging in the sandbox options.

- To test changes to the mod I recommend adding `-debug` to the launch options so you can
  speed up the game time, and set the `daysInAYear` sandbox option to 1 day.

## Release 🚀

1. Merge the release pull request on GitHub.

2. Download `TIHYD.zip` from the published release.

3. Copy the `TIHYD` folder inside the ZIP to `~/Zomboid/Workshop`. 

    The final structure should look like this:
  
    ```text
    ~/Zomboid/Workshop/TIHYD/
    ├── Contents/
    │   └── mods/
    │       └── TIHYD/
    ├── preview.png
    └── workshop.txt
    ```

5. Launch Project Zomboid through Steam using the account that owns the Workshop
   item. 

6. Open the in-game mod uploader by going to **Workshop → Create and update items**, then select **TIHYD**. If you don't see the mod as an option, the file structure of the previous steps may be incorrect.

7. Review the detected metadata and confirm everything looks correct.

8. Continue to the upload screen and accept the workshop legal agreement if
   prompted.

9. Wait for success, then verify the [Workshop page][workshop], subscribe to it
   and test the downloaded update. 

   Remove any local copies from `~/Zomboid/mods/` and `~/Zomboid/Workshop/` to
   see the subscribed Workshop version. Copies in `mods` take priority over
   copies in `Workshop`, and both take priority over the subscribed version.

[workshop]: https://steamcommunity.com/sharedfiles/filedetails/?id=3013368173

## Acknowledgments ©️

Thank you to all the contributors behind the
[Umbrella](https://github.com/PZ-Umbrella/Umbrella) collection, which provides
EmmyLua typings for the Project Zomboid API, massively speeding up development
time!
