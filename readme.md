# Introduction
"Encounter" is a text adventure game released in 1983 by Severn Software on multiple 8bit computers of the time, including the Oric 1 and Atmos.

The program itself is quite simple, 100% written in BASIC and sold on tapes, and this repository is my attempt at improving the game:
- If you are looking for The **Upgrade Time Episodes** containing snapshots of the work done on the BASIC source code while I was making [YouTube videos](https://www.youtube.com/playlist?list=PLuBEOCYVlum9cOkshSXEkOxALYoe3LVXz) about it, then please check this [other repository](https://github.com/Dhebug/Encounter-BASIC-version-)
- Here you will find the **FloppyBuilderVersion** version (aka "Encounter HD"), started from scratch to use C and assembler instead

The game is not finished and still being worked on.

If you are interested by the topic, you can read this [blog post](https://blog.defence-force.org/index.php?page=articles&ref=ART85) which also links to a few related videos on my youtube channel

# Current state
Here is more or less the current state of the game: 
## Mars 2024 demo
This video shows the state of the game, including the intro and end credits sequences.

[![Video](https://img.youtube.com/vi/3C0Pc7iNHjg/0.jpg)](https://www.youtube.com/watch?v=3C0Pc7iNHjg)

## 15 August 2023
This earlier video contains comments about what is shown.

[![Video](https://img.youtube.com/vi/WaXdzZ_ehY8/0.jpg)](https://www.youtube.com/watch?v=WaXdzZ_ehY8)


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
- [Design](documentation/design.md)
- [Game solution](documentation/solution.md)
- [Scoring](documentation/scoring.md)
- [Localization](documentation/localization.md)
- [Scripting](documentation/scripting.md)
- [Audio](documentation/audio.md)
- [Memory](documentation/memory.md)
