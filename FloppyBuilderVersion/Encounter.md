
# Encounter
"Encounter" is a text adventure game released in 1983 by Severn Software on multiple 8bit computers of the time, including the Oric 1 and Atmos.

The program itself is quite simple, 100% written in BASIC and sold on tapes.

## Encounter HD?
"Encounter HD" is an upgraded version of the original Encounter game, still running on the Oric 1 and Atmos but designed to run on flopies instead of tape, which allows the introduction of graphis and sound.

## Copyright and stuff
The original "Encounter" game may have been written by "Adrian Sheppard" but it had not been possible to get confirmation, and is copyright 1983 Severn Software.

"Encounter HD" was made by Mickaël Pointier (aka "Dbug from Defence Force"), it can be freely copied, and the "engine" reused and modified for your own games, but under no circumstance are you allowed to sell it for profit (building a real physical version and selling it for the price of the floppy is fine), or pretend you made the game.

Anyone adding a localization of the game is entitled to the work they did on it.

This new version is pretty much a 100% rewrite of the original game, what remains is the core story, the locations and how they connect to each other, and most of the original text.

## How to build and run
The program is designed to be built with the OSDK (current version is 1.20) which can be downloaded for free at https://osdk.org

On Windows, you just need to run **osdk_build.bat** to build the project and **osdk_execute.bat**, this will build the version and then launch it using the built-in Oricutron emulator.

After building, the various versions are located in the **build** subfolder:
* EncounterHD-EN.dsk
* EncounterHD-FR.dsk
* etc...

## Test on a real machine
The files in the **build** folder are in the Oric DSK format used by most emulators and also supported by devices such as **cumulus**.

Since it's a disk based game, you will not be able to use it on a tape drive, or tape emulators such as **Erebus** or **maxduino**.

If you own a **Cumana Reborn** or have a **Microdisc** drive with a **Gotek** or **HxC** floppy emulator, then you can use the HxC tool to convert the .DSK file into a .HFE which you can then copy to a USB drive and boot on the Oric.

To test the game on a real floppy things get complicated, but there are multiple methods availale:
* If you have a real disk controller, connect a real floppy drive and a floppy emulator, and copy the .HFE file to the real floppy
* If you have a old PC with a real DOS and a proper disk controller, you can use "writedsk" to create a physical floppy
* If you have a modern tools like Greaseweazle or Kryoflux, you can use them to generate physical floppies from emulator files


# Additional documentation:
You may also consult these pages
- [Game locations](documentation/locations.md)
- [Game Items](documentation/items.md)
- [Game solution](documentation/solution.md)
- [Localization](documentation/localization.md)
- [Scripting](documentation/scripting.md)
- [Audio](documentation/audio.md)
