=======================================
            Encounter HD
    a 'modern' Oric adventure game
=======================================

This is a pre-configured setup with a Windows Emulator called Oricutron (see https://github.com/pete-gordon/oricutron)
You can press F1 to access the Emulator settings (like video mode, keyboard mappings, etc...) at any time.

== Links ==

Game homepage: https://encounter.defence-force.org
User manual:   https://defence-force.org/index.php?page=games&game=encounter&type=manual
Steam store:   https://store.steampowered.com/app/3319780/Encounter/
Itch.io store: https://defenceforce.itch.io/encounter


== Introduction ==
Encounter HD is a reinvention of a text adventure released on tape by Severn Software in 1983 for the Oric.
This new version shows what the use of a floppy disk, insane amount of development time, full knowledge of the hardware and software stack, and 40 years of experience can help create.

For those among you who don't know what an Oric is, it's a machine released in England around 1983, with typical specs of a low cost 8bit machine of the time:
- 1mhz 6502 processor
- 48 KB of ram
- 240x224 screen resolution using a fixed 8 colors palette (Red, Green, Blue, Yellow, Cyan, Magenta, Black, White)
- 3 channels square-wave tone generator AY-3-8912

and that's about it: No sprites, no blitter, no vsync, no double buffering, no dma

By adding a floppy drive to the system, you get an additional 16KB of RAM, plus obviously the floppy storage itself, which in this case are 3" floppies with a 360 KB storage capacity (2 sides, 42 tracks, 17 sectors per track, 256 bytes per sector)

If you have a real Oric computer, you can find the actual Oric game (in .DSK format) in the "Game" sub-folder


== Game design changes ==
The original game was mostly quite OK, but due to various reasons had some shortcomings which I tried to address in this version:
- There was a couple places where the game would kill the player without any way for them to know that would happen, you had to learn these situations by heart.
- There were a couple item combinations that seemed to have been planned by the designers but were only partly implemented.
- Due to being written in BASIC, there was no real time clock available, so they had to rely on a number of actions you could perform.
- There were no graphics (not even a title picture) and no audio (other than some calls to the BASIC SHOOT and EXPLODE commands)

To adapt the game to a more modern audience I fixed these, and obviously added a significant amount of graphics, audio, animations, transitions... but also added some alternative ways to pass some of the obstacles.

The original game was forcing you to use lethal force to pass some of the obstacles, this new version still support these, but you can now find a couple alternative ways to solve the problem without having to kill anything or anyone.


== Vocabulary ==
The game is not trying to have the most advanced text parser known from humankind, instead it's closer to a point'n click adventure like Day of the Tentacle or Zac Mc Krakken where you only have a few words you use in combinations to achieve what you want.

You are encouraged to go to the online user manual for a more comprehensive documentation (https://defence-force.org/index.php?page=games&game=encounter&type=manual) but here is a short version.

Here is the vocabulary list:

Directions:
- N to go north
- S to go south
- E to go east
- W to go west
- U to go up
- D to go down

You can also use the arrow keys to move along the four direction, and using CTRL you can also move UP and DOWN when possible.

Items related:
- TAKE or GET to put an item in your inventory
- DROP or PUT to drop an item in the location you are currently occupying
- OPEN and CLOSE to open or close items such as containers, windows, doors, curtains, etc...
- USE to activate some types of items
- READ to read items such as books, recipes, notes, newspapers, magazines, ...
- LOOK or EXAMINE or INSPECT to check specific elements for clues or details
- COMBINE is followed by two items which will be put together to create a new item, like for example COMBINE CAKE CANDLES to create a birthday cake
- SEARCH or FRISK to look inside a container or check a person's body for items

Note: To simplify the player's life, pressing the SHIFT key will show in inverted video all the important keywords on the items in the scene and the inventory, so if you wonder if you should type "birthday cake" or "cake", just press SHIFT and you will see which word matters.

Note #2: Pressing CTRL+BACKSPACE will erase the input field (CTRL+DEL if you are using a real Oric keyboard)

Meta commands:
- QUIT to quit the game
- HELP to display a list of all the known commands
- PAUSE to stop the chronograph until a key is pressed


== Time limit ==
You only have two hours (in game hours) to finish the mission. The game will notify you halfway through, so you should not be surprised by how far the time passes!
The time passes at a normal rate of one second per second, but when performing actions or moving from scene to scene, more time is discarded to simulate the time taken to do things.

When reaching a game over condition, whatever remaining time you had will be added to your score on the form of bonus points


== Achievements ==
There are 48 possible achievements in the game, some are in the game inside, some are more meta.

It is not possible to collect all the achievements in a single play through, so it is expected you will have to play the game a number of time to collect them all, but thanks to the relatively short game time, that should not destroy your social life!

If you are playing on Steam, the launcher will try to synchronize the game achievements with your Steam account.


== Scoring ==
The game is generous in the way it awards points. Pretty much any small action rewards you points, the more creative or complicated, the more points!

You may also lose points by encountering some of the losing conditions.

