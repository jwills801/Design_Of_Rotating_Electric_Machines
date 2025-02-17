ME8287: Design of Rotating Electric Machines

Taught by Dr. Eric Severson at UMN in Spring of 2025

[Course lectures](https://www.youtube.com/watch?v=TRBvtFGsFsM&list=PLOsHXWYsyqDUraHJP_uUDSjMLPFoJtz4q) are on youtube.

All course reports and assignments are done in a single [overleaf project](https://www.overleaf.com/read/gymzjkxtydbz#ebe693).

The workflow should follow the guidlines from [Severson's group](https://github.com/Severson-Group/severson_group_git). I am also trying to use github issues in the same way as they do in their group. I do most of the git things in terminal, but use VS Code to settle merge conflicts.

This repository uses a package called devenv to make a unique software enviorment just for this repo. I folowed the instructions in https://github.com/adam-gaia/smellgoodcode in smellgoodcode/src/intro.md under devenv. Wine is installed only in this repo because of the additions made in the devenv.nix file. The FEMM application was installed using wine by first downloading the 32 bit .exe file from their website and using the command:
wine <path-to-femm-installer.exe>

To run FEMM later, we can type:
wine wineprefix/drive_c/femm42/bin/femm.exe

To run in matlab, we had to add some lines to the startup.m file 

addpath('/full/path/to/mfiles/')

% add path (found from the terminal command: find /nix/store -name "libz.so.1") to libz in matlabs enviornment.
setenv('LD_LIBRARY_PATH', '/nix/store/7mkhnqiwy5alizb185m3ixa3c7k1jhgn-devenv-profile/lib/libz.so.1:$LD_LIBRARY_PATH'); 
setenv('WINEPREFIX', '/full/path/to/wineprefix');

Also, I've been starting matlab from within the devenv enviornment, but I'm not sure if that's necessary. In matlab, we can open femm by system('/nix/store/nbq8laq2p99q21aak2m9qj5sqlpw1c76-wine-wow-9.0/bin/wine /full/path/to/wineprefix/drive_c/femm42/bin/femm.exe'); The first part of the command inside of system is the path to wine (found from which -wine in terminal). The second part of the command is the full system path to femm.exe.