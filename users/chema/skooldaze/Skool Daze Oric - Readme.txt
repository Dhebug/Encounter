=======================================
	     Skool Daze
    	   The Oric Game
=======================================

Website: skooldaze.defence-force.org.
Forum: forum.defence-force.org - "Games" forum.

Version 1.00
April 2012

José María (Chema) Enguita
Email: enguita@gmail.com


INTRODUCTION
============

Here it is!. At last we have an Oric version of the fabulous game 
Skool Daze by David S. Reidy and Keith Warrington and first published 
by Microsphere for the ZX Spectrum. 

I made an enormous effort to keep the game size to fit in a 48K Oric
without the need of a disk drive this time. It should run on Oric-1, Atmos,
and Telestrat with the Stratoric cartridge. 

I tried to keep it as faithful to the original as possible, which has been
a really difficult task due to the Oric 6 pixels per byte display. You can
follow the development progress in the Defence Force forums.

Some small differences exist, though. A few of them are intentional, others 
just due to slightly different code. Anyway the gaming experience should
be the same than in the original Spectrum version.


LOADING SKOOL DAZE
==================

If you want to load Skool Daze on a real Oric, just convert it to wav
first, using tap2wav or tap2cd (Check for those on Fabrice France's site
and read the instructions).

However, along with the release of this game, you should find a 
pre-generated wav file with a custom fast loader. It is only valid for 
1.1 ROMS, beware.

We have tested the loading process on different machines and with different
tools and it is quite reliable once the appropriate volume setting is found.

If the loading is aborted (usually with an 'Errors found' message, though it
might not be visible if already in HIRES mode, just the Ready prompt) try
altering the volume until the game loads and auto starts. 

If you are using a modified ROM with 60Hz and you want to generate the wav
file from the tape image yourself, you should get to HIRES mode *before*
loading the game, so it does not set the HIRES 50Hz mode. Just issue a 
HIRES:CLOAD"" command and it should work. As the pre-generated wav file
switches to HIRES using a ROM call before loading the screen, it should 
work with modified ROMs.


INSTRUCTIONS
============

In the role of our hero, Eric (or any other name you decide to
call him and the rest of the cast), you know that inside the
staffroom safe are kept the school reports.  And, being Eric, you
realise that you must at all costs remove your report before it
comes to the attention of the Headmaster.

The combination to the safe consists of four letters, each master
knowing one letter and the Headmaster's letter always coming
first.  To get hold of the combination, you first have to hit all
the shields hanging on the school walls.  Trouble is, this isn't
as easy as it looks.  Some of them can be hit by jumping up.
Others are more difficult.  You could try and hit a shield by
bouncing a pellet off a master's head whilst he is sitting on the
ground.  Or, being Eric, you may decide to knock over one of t
he boys and, whilst he's flattened, clamber up on him so that you
can jump higher.

OK.  So all the shields are upside-down, disorientating the
poor masters.  Knock them over now and, before they can stop
themselves, they'll reveal their letter of the code.  All except
for the history master, of course, who because of his great age
and poor eyesight can't be trusted to remember.  His letter has
been implanted into his mind hypnotically.  To make him reveal
it, you must find out the year he was born (which, in case you
were wondering, changes each game).  Then, creep into a room
before he gets there and, if the board is clean, write it on the
blackboard.  When he goes into that room and sees his birthdate
he will, as if by post-hypnotic suggestion, give away his letter.

Now that you know all the letters of the combination, all you
have to do is work out which order they go in.  You know that the
Headmaster's letter is always first, but as for the other three
.... you'll just have to try the various possibilities.  Find a
clean blackboard and write out a combination.

Rush back to the staffroom and jump up to reach the safe with
your hand.  If nothing happens, then the combination must be
wrong, so you'd better find another clean blackboard and try a
different one.

With the safe open, your troubles still aren't over, as the
upside-down shields are rather a giveaway.  You now have to hit 
all of them again.

Done it?  Congratulations!  You are now allowed, along with all
your friends, to move on to the next class at school.  But
remember, there will be reports at the end of this term .....


School Rules
------------

Boys shall attend lessons as shown in the timetable at the bottom
of the screen.  (Remember that because you cheated in the exams
last year, you always go to the same lessons as the swot.)

Boys do not score points by attending lessons, but may be given
lines if caught in the wrong place.

Boys who acquire over 10,000 lines shall be expelled immediately
from the school.

Boys are not allowed to enter the staffroom or the Headmaster's
study.  Take care.

At playtime, boys are supposed to be playing and not in any of
the classrooms.

Boys shall not hit their schoolmates.

Boys shall not fire catapults.

Boys are expected to walk quietly in the corridors - they are not
for running or sitting in.

School dinners are compulsory.

Boys will be neat and polite at all times.


The Keys
--------

Cursors - move
S - sit/stand
H - hit
W - write (on blackboard)
J - jump
F - fire catapult
C - change colour combination (two in color and one on b&w)
A - Audio off/on


Scoring
-------

Hitting the shields - score depends on difficulty
Hitting all 15 shields - scores a bonus
Opening the safe after getting the combination - scores a bonus
Hitting the shields after opening the safe - score depends on
difficulty
Lines given to the swot or bully - their lines add to your score
Hitting the bully by punching him or with a catapult - if you
dare!


Cheating
--------

You can find tips and tricks for this game in many sites in the web.

World of Spectrum (www.worldofspectrum.org) has a lot of information 
about this game (yes, including cheats).

The only thing I will provide here is the list of battles and years,
so you don't need to wait until you find the correct pair in the
question/answer sessions with Mr Creak.

1066    Hastings
1265    Evesham
1314    Bannockburn
1346    Crecy
1356    Poitiers
1403    Shrewsbury
1415    Agincourt
1485    Bosworth
1513    Flodden
1571    Lepanto
1014    Clontarf 
1685    Sedgemoor
1746    Culloden
1775    Lexington
1781    York town
1805    Trafalgar
1815    Waterloo
1812    Borodino
1836    San Jacinto
1863    Gettysburg
1854    Balaclava



REPORTING BUGS & COMMENTS
=========================

Any thoughts, comments, questions, bugs or whatever, are more than welcome. 
Post them in the Oric Forums (forum.defence-force.org) or email me at 
enguita@gmail.com


CREDITS
=======

The copyright in the original ZX Spectrum game code and graphics for both 
Skool Daze and Back to Skool is held by Microsphere Computer Services Ltd.

The rights for this game currently belong to Alternative Software Ltd. 
Elite Systems Ltd. has recently produced an incredible version of the 
original Spectrum game for iPod with dedicated controls and other 
extras. Check it out!

This version of Skool Daze would have never seen the light without the help
of the Oric community. 

Thanks to Symoon for providing the first approach of the loading screen,
and Dbug for his work in refining it, and also for his ideas about how to 
reduce the code size.

Thanks to Symoon, Dbug, Twilighte, Anti/rad and all the rest of the oricians
who tested the game and provided feedback and ideas. 

Special thanks to Richard Dymond (SkoolKid) for the incredible work he
did in commenting the disassembly of the original game 
(http://pyskool.ca/disassemblies/skool_daze/), which was an invaluable
source of information.


CHANGELOG
=========

Version 1.00
------------
Initial version


Please report any further bug that you encounter (in the forums or directly 
emailing me at enguita@gmail.com). I will try to fix them as soon as possible

Happy playing!!!

-- Chema


