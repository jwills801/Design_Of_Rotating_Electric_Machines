ME8287: Design of Rotating Electric Machines
Taught by Dr. Eric Severson at UMN in Spring of 2025
Course lectures can be found at [link]{https://www.youtube.com/watch?v=TRBvtFGsFsM&list=PLOsHXWYsyqDUraHJP_uUDSjMLPFoJtz4q}

The workflow should follow the guidlines from https://github.com/Severson-Group/severson_group_git. I am also trying to use github issues in the same way as they do in their group. I do most of the git things in terminal, but use VS Code to settle merge conflicts.

This repository uses a package called devenv to make a unique software enviorment just for this repo. I folowed the instructions in https://github.com/adam-gaia/smellgoodcode in smellgoodcode/src/intro.md under devenv. Steps to Set Up Wine with devenv and direnv
1. Navigate to Your Project Directory
2. Initialize the Environment with devenv
>> devenv init
This will create a .envrc file and a devenv.nix file in your project directory.
3. Modify .envrc to Load devenv

Ensure your .envrc file contains the following:

use devenv
export WINEPREFIX=$(pwd)/wineprefix
export WINEARCH=win64

After editing, reload the environment:

direnv allow

4. Edit devenv.nix to Include Wine

Open the devenv.nix file and modify it to include Wine in the environment:

{ pkgs, ... }: {
  packages = with pkgs; [
    wineWowPackages.stable  # Provides Wine with 32-bit and 64-bit support
  ];

  env = {
    WINEPREFIX = "$(pwd)/wineprefix";
    WINEARCH = "win64";
  };

  scripts.femm = {
    description = "Run FEMM using Wine";
    exec = "wine $WINEPREFIX/drive_c/Program\\ Files/FEMM42/bin/femm.exe";
  };
}

5. Activate the Environment

Once you've configured devenv.nix, run:

devenv shell

This will set up an environment where Wine is isolated to your project directory.
6. Install and Run FEMM

Download FEMM and install it inside your isolated environment:

wine <path-to-femm-installer.exe>

To run FEMM later, use the provided script:

devenv run femm
