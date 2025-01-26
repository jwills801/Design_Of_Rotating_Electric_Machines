ME8287: Design of Rotating Electric Machines
Taught by Dr. Eric Severson at UMN in Spring of 2025
Course lectures can be found at [link](https://www.youtube.com/watch?v=TRBvtFGsFsM&list=PLOsHXWYsyqDUraHJP_uUDSjMLPFoJtz4q)

The workflow should follow the guidlines from [Severson's group](https://github.com/Severson-Group/severson_group_git). I am also trying to use github issues in the same way as they do in their group. I do most of the git things in terminal, but use VS Code to settle merge conflicts.

This repository uses a package called devenv to make a unique software enviorment just for this repo. I folowed the instructions in https://github.com/adam-gaia/smellgoodcode in smellgoodcode/src/intro.md under devenv. Wine is installed only in this repo because of the additions made in the devenv.nix file. The FEMM application was installed using wine by first downloading the 32 bit .exe file from their website and using the command:
wine <path-to-femm-installer.exe>
To run FEMM later, we can type:
wine wineprefix/drive_c/femm42/bin/femm.exe
