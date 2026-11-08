# AGENTS

- Keep option tooltips brief and consistent with the existing style, avoiding unnecessary technical details.

- When updating or adding new translations, do so in all supported languages.

- Do not add notes of changes you make to the README file unless directed.

- Check existing implementations and conventions before introducing a new pattern or dependency.

- To solve incompatibilities or get implementation details from other mods, use SteamCMD to download the Workshop content of the mod to a temporary directory and analyze how it works:

  ```sh
  steamcmd +force_install_dir /tmp/tihyd +login anonymous +workshop_download_item 108600 <workshop_id> +quit
  ```
 
- When instructed, add content to the appropriate section of `src/workshop.txt`, following the existing writing style and length.
