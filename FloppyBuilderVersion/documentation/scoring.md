> [!WARNING]  
> This page contains potential spoilers for the game.  
> If you plan to play the game, you should probably refrain to go farther!
>
> For more information, you can safely read [Encounter.md](../Encounter.md)

- [Intro](#intro)

# Why scoring?
Contrarily to most action games, adventure games tend to be played only once: When they are "solved", there are no other incentives to play them.

The original Encounter game had a scoring system where some of your actions would grand you some points, and at the end of the game the score would be shown, the idea being to try to motivate the player to do better next time, maybe by trying alternative ways of doing things.

Quite a few other games have done that over the time, like for example Lucas Art with the [Indy Quotient](https://indianajones.fandom.com/wiki/Indy_Quotient), Sierra On-Line's [Torin's Passage](https://www.sierrachest.com/index.php?a=games&id=190&fld=walkthrough&pid=100) and [King's Quest](http://www.sierraplanet.net/kqgames/kings-quest-i/kq1-walkthrough/kq1-original-point-list/) points.

Similar ideas can be found in other games:
- Collecting stars in Super Mario 64
- Finding all the secrets in a level (ex: Duke Nukem)
- Beating the "par time" in Doom

A modern equivalent would be **Achievements** and **Badges** in games where you have to perform a certain number of actions ("destroyed 500 barrels", "collected 100.000 gold") or have done specific things ("finished the game in hard mode", "found the golden sword of awesomeness") to unlock badges visible on the game page, motivating the player to try the game again to complete the collection and eventually reach the "100%" status.

Obviously a 64KB Oric and a floppy disk is not going to be able to achieve miraculously large ammounts of book keeping, but we can still embrace what the original game did and somewhat extend it.

# Scoring
In the original game, the score is impacted by the following actions:
-  25 - "Dog eats meat"
-  50 - "You have speared the dog"
-  50 - "The dog is dead"
-  50 - "CROAK"
-  50 - "Messy"
-  50 - "KRUNCH"
-  50 - "G-A-S-P !!!"
-  50 - "I've found a pistol.It is not loaded"
- 100 - "Okay, gunpowder ready"
- 100 - "Okay, fuse ready"
- 100 - "Girl breaks window and slides down rope"
- 200 - "Acid in the bottle burns small hole in the door"
- 200 - "The safe is open"
- 200 - "Alarm stops ringing"
- 200 - "and you have made it - WELL DONE"
- 200 - "Bomb ready"

Since the game was on tape, the score was just printed on screen, but the new version being on disk now asks the name of the player and saves the score to disk with a sorted list of scores, names, and how far the player was able to go before reaching the game over sequence.

The plan is to have more options available to the player, mostly non-lethal ones requiring a bit of creativity, and rewarding more points.

# Achievement
In addition to the scoring system, the idea is to add achievements to the game to motivate the player when they try new things or get curious.
The idea is to reward:
- Creative problem solving
- Exploration
- Curiosity

Implementation wise, the code will just manage some bit-fields to indicate that something has been unlocked and these will be saved on disk.

