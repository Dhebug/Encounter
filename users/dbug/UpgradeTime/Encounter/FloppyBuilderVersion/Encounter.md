
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

## Localization
Don't expect industry standard localization tools with translation memory: You will have to edit source files to change or add text.

That being said, there is a system in place to facilitate things:
### osdk_config.bat
The configuration file has two environment variables used to help with localization:
* BUILD_LANGUAGES contains a comma separated list of the country codes of all the version to build
* TEST_LANGUAGE contains the country code of the version to run

This is the current default, which builds the English and French versions, and runs the French one
> SET BUILD_LANGUAGES=EN,FR  
> SET TEST_LANGUAGE=FR  

If not specified, the default version on the game is English.

This allows partial localization to still work, so it can be done incrementally: The parts with #ifdef LANGUAGE_xx will be used when available, and the default code path will use the #else if not availale. 

### floppy builder script
The FloppyBuilder system uses a text file providing the list of all the files required to build a version.

The system has been slightly expanded by using a **master file** containing conditional commands to select various versions a file

Example: Here we can select a different bitmap font for French (using accentued characters)
> #ifdef `LANGUAGE_FR`  
> AddFile ..\build\files\font_6x8_mystery_fr.fnt  
> #else `// LANGUAGE_EN`  
> AddFile ..\build\files\font_6x8_mystery.fnt  
> #endif  

### Text
The localization of texts follows the same principe.

As much as possible, texts have been extracted in their own files called xxxx_text, and you can find all the places where localization should happe by searching for the LANGUAGE_EN

Example:

>;  
>; Leaderboard  
>;  
>#ifdef `LANGUAGE_FR`   
>_Text_Leaderboard                .byt 16+1,3,"            Classement",0  
>#else `// LANGUAGE_EN`  
>_Text_Leaderboard                .byt 16+1,3,"            Leaderboard",0  
>#endif  

### Character set
The Oric computers only have 96 displayable characters (standard 7bit ASCII from 32 to 127), which is insufficient to encode all the accents and special characters used in various languages.

The usual method is to sacrifice some characters (like the unused punctuation or symbols like {|}@£...) and redefine them so they appear as different characters.

This works perfectly, but it's relatively uncomfortable to have to type "|tre" instead of "être" or "mang{" instead of "mangé".

To solve this issue, it is possible to define substitution strings rules for each language.

For French, the current mapping is the following:

>#ifdef LANGUAGE_FR  
>#pragma osdk replace_characters : é:{ è:} ê:| à:@  
>#endif  

and empty "#pragma osdk replace_characters" cancels the replacement rule.

### Selective build
Since testing things gets frustrating when you have to go through a sequence of irrelevant things before accessing what you want, the system allows disabling a number of things.

You can edit **params.h** and comment out a bunch of defines to enable or disables parts of the game and intro.


