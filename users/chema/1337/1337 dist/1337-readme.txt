=======================================
	       1337
    	   The Oric Game
=======================================

Website: 1337.defence-force.org.
Forum: forum.defence-force.org - "Games" forum.

Version 1.20
October 2010

José María (Chema) Enguita
Email: enguita@gmail.com


INTRODUCTION
============

Here is the 1.20 version (I hope it is also final) of 1337, the  Elite-like game 
for your Oric+Microdisc and Telestrat computers. See below for a changelog. 
The version number appears for over half a second whenever you boot the 
game disk (intro or game).

This is NOT an Elite clone, but a game inspired in Elite with some features that 
make it unique. It took more than two years to develop, and it is quite probable 
that there are several bugs lurking around, even if the group of beta-testers 
did an explendid job. Don't hesitate to contact me or posting any bug you 
find on the Defence Force forums (forum.defence-force.org).


PLAYING 1337
============

1337 includes an small tutorial to introduce new players to the game basics,
and it shouldn't be difficult for anybody knowing about Elite to grasp how
to play 1337.

However, along with the game disk, there are also three manuals which you could
find useful.

-The Space Traders Flight Training Manual (1337-manual.pdf). Extensive technical
manual which includes all the game features and details.

-The Observer's Guide to Ships in Service (1337-shipguide.pdf). A Collection of 
the usual ships you might find, along with its technical characteristics.

-The Quickstart Guide (1337-quickstart.pdf), a summary of the controls and basic
game mechanics.

To run the game, simply boot your Oric with the game disk (virtually or physically). 
Sedoric will load and launch the intro first (if you are using a Telestrat, you must 
use the Stratoric cartridge).

Watch the intro. When it ends the system is rebooted and the game will launch. You can skip
it by pressing ESC, but it is so beautiful that who would ever want to skip it?

You are encouraged to read through the manuals, but if you feel lazy, you can have 
a look at the quickstart guide and start playing. Use the other manuals for reference
when needed.


UNIVERSE
========

1337 shares the universe with Elite (there might be small changes due to slightly
differences in the implementation of the generator), so you can search the Internet
for maps and information which you can use in 1337 too.


MISSIONS
========

Does 1337 include any of Elite's secret missions? The answer is yes. But even better
than that: it includes a whole mission pack with more than 10 missions to solve inside
a plot. The player will get involved in this plot when his rating is halfway (more or less)
between "poor" and "average".

Of course I cannot prevent actions that make the mission pack impossible to complete (or
at least very hard to complete). As a general rule of thumb don't jump to another galaxy
unless you are told to.

You can ignore the missions or continue playing after completing the mission pack, as you
would do in the original Elite game, making profit, equipping your ship and trying to get
the rank of Elite. The open-ended spirit is still there...


REPORTING BUGS & COMMENTS
=========================

Any thoughts, comments, questions, bugs or whatever, are more than welcome. Post them in 
the Oric Forums (forum.defence-force.org) or email me at enguita@gmail.com


CHANGELOG
=========

Version 1.20
------------

- Corrected a bug which makes keyboard inactive on real machines.
- The game is now Telestrat compatible (at least in the emulators) with the stratoric cartridge.
- Corrected a typo in the string "Message Ends" (was "Mesage ends").
- Corrected the tables in manuals where the key to launch a missile was said to be 'M' instead of 'F'.

Thanks to Fabrice Frances for spotting the keyboard bug and helping me to solve it. Also for his aid in supporting the Telestrat. Thanks to Maximus and Syntax Error for spotting the typos.


Version 1.10
------------

Several bugs have been corrected in version 1.10 (versions 1.0x were all intermediate working versions sent only to testers, so if you have any of these, upgrade to 1.10).

Here is the list:

- Under certain circumstances, buying equipment resulted in your cash increasing erratically. Related to a ship not having lasers listed in equipment.
- Mission of Stolen Hi-Tech might become impossible to solve.
- Zantor's mission could end up with success, even when he is killed.
- Wrong data in mission event table after loading a slot where you have finished the 
mission pack caused the game to hang up.
- Impossible to buy fuel or missiles at planets with techlevel 0.
- Cargo seems to increase by 10 tons randomly.
- Pressing A or ENTER at the load/save screen with no slot selected, uses the last one.

Thanks to Shaun Bebbington and Maximus for spotting these bugs and helping me in making this new version.

Version 1.00
------------

Initial version


IMPORTING SAVED GAMES TO VERSION 1.10
=====================================

For importing you saved game into this new version, follow the next steps:

1. Boot the game with the new version
2. Start a new game, you will be directed to the status page (2).
3. Exchange the game disk and insert the old version, where you saved your games.
4. Press 0 to access the load/save page. Your saved game slots will appear.
5. Select the slot you want to import and load the game. You are directed back to the status page.
6. Exchange disks again, inserting the new version.
7. Get back to the load/save page, which now will appear empty.
8. Save your game.

You can use this method for importing saved games from other disks, so it would be a good idea to make copies of your game disk as you progress in the game, to prevent accidental ereasing of your saved slots, disk damages or just to have more than 8 saved games.

Please beware that your game status is fully imported, meaning that if you have any inconsistence, it will remain there. For instance, if you experienced the bug where your weapons (lasers) were removed and you don't have them, you should buy them now. This will increase your cash, which should not happen, but only this time. Take is as a gift for the inconvenience.

If you experienced the bug where your cargo capacity increased, it will also remain so, which may create problems later on. It would be better if you do not import such slots. If you want to keep a saved game, but it include such inconsistency, don't hesitate to send me your old disk, and I can fix the saved game for you.

Please report any further bug that you encounter (in the forums or directly emailing me at enguita@gmail.com). I will try to fix them as soon as possible

Happy playing!!!

-- Chema


