
- [Localization](#localization)
  - [osdk\_config.bat](#osdk_configbat)
  - [floppy builder script](#floppy-builder-script)
  - [Text](#text)
  - [Character set](#character-set)
  - [Fonts](#fonts)
  - [Images](#images)
  - [Selective build](#selective-build)

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

> Note: While trying to implement additional language, some limitations were found and the system had to be tweaked to fix a chicken and egg problem in the way the files are processed, so there's now a new version of Link65 and while that syntax is still supported there is a new one that solves the problem:
>
> #pragma osdk replace_characters_if LANGUAGE_FR : é:{ è:} ê:| à:@ î:i ô:^   
> #pragma osdk replace_characters_if LANGUAGE_NO : æ:{ ø:} å:| Æ:A Ø:O Å:A é:e


### Fonts
The game uses a number of fonts, some hand modified, but some are just standard TTF rendered without anti-aliasing.
- The "Handwritten note" uses "Segoe Print" size 8
- The "Tombstone" uses "Century Gothic" size 10
- The label on the bottom of the polaroid frames in the achievements is "Segoe Print" size 20, bold, in vector resized to fit
- The "THE END" text uses Haettenschweiler with reduced kerning, is then sheared vertically, the top half of each later filled in dark gray and color reduced with Burkes error diffusion method  
- The "A 8-Bit Noir Adventure" subtitle uses "Britanic Bold" in italics
- The Typewriter font in the trailer is "Another Typewriter"
- Elements on the final page of the trailer use "Spartan Black" italics

### Images
The game contains a certain number of images that have text that needs translating.

The method is similar as for the fonts, with multiple versions of the image with _fr, _no, etc... and the asset building script converts and include the proper one.

Here is a list of the images and the actual text they contain:

- Tombstone: "Anyway, what I gave to the Oric community was always smaller than what I took for myself"
- Newspaper: "STILL MISSING" and "SAVED!!!"
- Rough map: "check / tunnel / Church / Market / PARK HERE / 2 HOURS MAX!"
- Outro sequence photos: "MANOR / MISSING/ RESCUED"
- Girl rescued: "THANK YOU!!!"
- End logo "THE END"
- Handwritten note: "Hi son,I moved all your dangerous stuff into the basement's safe. Ask mum for the key if you need anything but be careful and put them back when you are done with your experimentsI don't want the house to burn down! Dad"
- Chemistry recipes: "See chap 3, p237
If you mix saltpetre and sulfur you get gunpowder. Put it in a container, add
a fuse and you get explosives! / page 385 / Acid acts slowly and thus must be contained for the duration of the dissolving process.  Use of protective equipment is recommended" + "petrol?" "metallic?"



That one is not translated but probably should have been
- Thug: "NOW YOU DIE!"


 
### Selective build
Since testing things gets frustrating when you have to go through a sequence of irrelevant things before accessing what you want, the system allows disabling a number of things.

You can edit **params.h** and comment out a bunch of defines to enable or disables parts of the game and intro.
