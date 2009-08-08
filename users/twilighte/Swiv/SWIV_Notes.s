;SWIV Notes

The original screen format was 168(7 blocks)x96.
However by reduced width and increasing rows we gain height(better than width) for the same bytes shifted.
The other advantage is that when plotting sprites to the screenbuffer they can use a single yoffset up to
13 rows instead of 10.
However the screenbuffer should be wider than 28 to permit scroll-ons and scroll-offs
possibly 4 wider, providing 2 bytes either side allowing for maximum 12 pixel width of enemy aircraft.

So ScreenBuffer new size is 24x158.


************************** For map editor ***************************
Keys
Cursors	Move with push scroll (Navigate right to reach info)
J/G	Grab
K/Space	Drop
-	Decrement Graphic block ID
=	Increment Graphic Block ID

N	Set Embedded code to Normal
B	Set Embedded code to Background Object
W	Set Embedded code to Wave Trigger
E	Set Embedded code to Multi-Part Sprite(Was EOL hence key)
X	Toggle showing Embedded Codes

P	Proceed to Printer menu
S	Save backup to Disk
ESC	Quit to basic
DEL	Delete (Block 1)

Memory
0500-4FFF - Basic Editor
5000-57FF - Map
5800-97FF - Map MC and Graphics

********************** Background and Screen Buffers in relation to Sprites *************
The background buffer may be used to deposit sprites onto.
Advantages
 * The sprite will appear beneath flying objects
 * The sprite will automatically move down
Disadvantages
 * The sprite cannot scroll off left/right without additional clipping code
 * The sprite must be inactive once it reaches bottom border (otherwise it will appear at top)
 * The background must be backed up if the sprite is to be moved
Likely candidates
 * Gun post
 * comouflaged Gun Post
 * Ground based vehicle
 * Train
 * Signals
 * Railway gates
 * Craters (destroyed landmarks)

The screen buffer is the prime destination for sprites
Advantage
 * Automatic border clipping due to 12 pixel border around buffer
 * No backup of background is required and deletion is not required either
Disadvantage
 * 
Likely candidates
 * Swiv
 * Aircraft
 * Bonuses
 * Flak(Bullets, rockets)
 * Explosions

************************* Map Format ***************************
Each map is 6x128 though only first 5 bytes are for map blocks.
Each Cell holds the BlockID and a special flag in B0-1..
B0-1
  0  Normal Map Block
  1  Background Object(Definition held in 6th byte)
  2  Wave Trigger(Definition held in 6th byte)
  3  Multi-part sprite(Definition held in 6th bytes)
B2-7 Map Block (0-63)
Only one type can exist per row though up to 5 of the same.

The interesting 6th byte
For sky Wave Trigger it is broken down as follows..
B0-1 Quantity(1-4)
B2-7 ScriptID(0-63)

For Ground Sprite it is broken down as follows..
B0-1 Number of Parts(1-4)
B2-7 ScriptID(0-63)

For Multi-part sky sprite it is broken down as follows..
B0-1 Number of Parts(1-4)
B2-7 ScriptID(0-63)

The first part of a Multipart sprite uses the specified ScriptID and the next part uses the next
ScriptID, etc. So if a scriptID of 4 was specified in a 4 part multisprite then the subsequent
parts would use ScriptID 5,6 and 7.

In this way each part can specify the First FrameID in each Script and permit Animations within
a multipart sprite.

When creating a sprite of more than one part the order of sprite graphics for each part
will depend on whether the sprite will appear from the top or from the bottom.



One could argue about why a background object should be marked since the graphic beneath
could be used to ident the object id etc. Well a good reason is for tanks and trains whereby
the graphic beneath will not always reflect the ground based object.
************************ 
Sprite must specify movement resolution
1 2 Pixel step(3 frames)
2 3 Pixel step(2 frames)
3 Sprite contains inverse and therefore given only 6 pixel step
Sprite must specify frame info
1) Number of frames
2) Frame start SpriteID


Rather than have waves and frames as separate entities it may be better to have just one list
were we can control them both. In this way the bomber could be shown to move to centre screen then flip
and return to top before flipping once more and exiting south.
Performing such a manouvre with waves AND frame sequence could be tricky.
The other advantage with a single list is it gets around the problem with tanks on ground and
concealed gunposts.
Also for the tank on ground we do not need to use excessive shift frames for diagonals, and it should be
easier using a single list to prevent the need for them.

The 'Script' is provided with a header and Script Sequence sections..
Header..
+00 Distance between each craft(0-63) (Set B7 to ensure x/y is not changed by +01)
+01 Start Y (Start X specified by column in map)

Script Sequence..
0	End (keep displaying last frame)
1-3	Move East(1,2,3)
4-6	Move South
7-9	Move West
10-12	Move North

13	Use this frame for E
14	Use this frame for SE
15	Use this frame for S
16	Use this frame for SW
17	Use this frame for W
18	Use this frame for NW
19	Use this frame for N
20	Use this frame for NE
	
21	Turn clockwise (Relies on codes 13-20 being known)
22	Turn until in direction of hero (Relies on codes 13-20 being known)
23-38	Fire trajectile(Trajectile specified as 0-15)

39-47	Display current frame and Pause(1-9)
48-63	jump back on condition(1-16)
64-79	jump forward on Condition(1-16)
80-143	Set Counter(1-64)
144-239	Set FrameID(0-95)
240	Set loop condition to counter timeout
241	Set loop condition to not facing hero (Relies on codes 13-20 being known)
242	Set loop condition to not facing east (Relies on codes 13-20 being known)
243	Set loop condition to facing hero (Relies on codes 13-20 being known)
244	Set loop condition to facing east (Relies on codes 13-20 being known)
245	Remove loop conditions
246	Turn anticlockwise (Relies on codes 13-20 being known)
247
-253	-
255	End (Don't plot anymore)


So for concealed gunpost one would do this..
;Begin with opening of the hatch phase
144+?	;set frame to closed hatch
39	;Display frame and pause for one game cycle
144+?	;set frame to opening hatch1
39
144+?	;set frame to opening hatch2
39
144+?	;set frame to opening hatch3
39
;Then specify facing frames (which could just have easily gone at start but that we want to initially
;face east and the last entry does this).
144+?	;set frame to gun facing SE
13	;this frame for facing SE
144+?	;set frame to gun facing S
13	;this frame for facing S
144+?	;set frame to gun facing SW
13	;this frame for facing SW
144+?	;set frame to gun facing W
13	;this frame for facing W
144+?	;set frame to gun facing NW
13	;this frame for facing NW
144+?	;set frame to gun facing N
13	;this frame for facing N
144+?	;set frame to gun facing NE
13	;this frame for facing NE
144+?	;set frame to gun facing E
13	;this frame for facing E
39
;Rotate turret to face hero
80+?	;Set counter to 20 (Sets the number of rounds of ammo rather than the duration)
241	;Set loop condition to facing hero
22	;Turn in direction of hero
39+3	;Display and pause 3
48+?	;loop to code 22 (But since condition is facing hero don't dec counter!)
;Fire turret counting down 20 rounds of ammo
240	;Set loop condition to counter timeout
23+?	;Fire trajectile
39+3	;Display and pause 3
48+?	;Loop to code 241 until counter timeout
;Is turret facing east?
244	;Set loop condition to facing east
48+?	;skip to close up hatch(if already facing east)
;Now turn turret until facing east again
242	;set loop condition to not facing east
21	;Turn clockwise
39	;display
48+?	;jump back whilst not facing east(21)
;Now close up hatch again
144+?	;set frame to closing hatch0
39	;Display frame and pause for one game cycle
144+?	;set frame to closing hatch1
39
144+?	;set frame to closing hatch2
39
144+?	;set frame to closing hatch3
39
255	;End

49 Bytes :)

For bomber one would do this..
144+?	;Set frame to bomber facing S




Add conditional loops like AYT in order to do things like moving bomber down x steps before flipping
 



************************ Wave Pattern format ************************
Each Wave can be up to 256 long and 252 steps.
Bit7 set in the data determines an End to the wave.
HEADER..
Distance between each craft
StartX
StartY
Reserved (For smooth move flags)

DATA..
B0-1 Step Size
B2-3 Still,Up,Down,Home
B4-5 Still,Left,Right,Home
B6   Fire weapon
B7   Exit on current Steps

For the code, rather than have a counter counting the distance between each craft in the wave
we use a as many initial counters as quantity of craft are. each counter is set primarily to the initial
delay plus the distance apart.
So for a wave consisting of 4 planes 10 units apart and an initial delay of 20..
Plane1 count == 20		20
Plane2 count == 20+10	30
Plane3 count == 20+10+10	40
Plane4 count == 20+10+10+10	50



************ Map 01 Waves and ground objects *************
Wave Triggers
WaveId 0/SpriteID 0 - Aircraft(1) moving constant speed down (no fire)
WaveID 1/SpriteID 1 - Helis(3) moving down right(no fire)
WaveID 2/SpriteID 1 - Helis(3) moving down left(no fire)
WaveID 3/SpriteID 2 - Stun Heli(1) moving to centre then firing missiles in all dir then exit down

Ground Objects
ObjectID 0 - Coloured Gunpost
ObjectID 1 - Scrub concealed gunpost
ObjectID 2 - Train
ObjectID 3 - Port concealed gunpost
ObjectID 4 - Surfacing Submarine
ObjectID 5 - Hanger Tank

Map01 needs angles for canal


************* Collisions ************
possible projectiles

hero forward cannon
hero retro fire down-left
hero retro fire down-right
hero sidewinders
hero splay-pattern 1
hero splay-pattern 2
hero splay-pattern 3
hero orb
hero homing missile ?
powerup #1
powerup #2
ground-air missile
air-air bullets


The ideal way of handling collision is to use a collision map, and to do this sprites are limited
to 6x6 steps. Not so great and higher res than spectrums 8x8 in r-type.
on this basis, bg sprites would still move down in 2 pixel steps but a separate YLOC would divide
to 6.
This does require a massive overhaul on existing code but benefits include speed, memory and outway
cost of res and time to erase/write to collision map.
The Collision Map would be based on the screen buffer which is 24x158 which would be 24x27(648).

Each map byte is split into bg(4) and air(4) to accomodate air craft over ground craft.
So the aircraft are limited to 16 and the ground craft to 16.
Only the projectiles detect collision, so may be high res if required.

Collision map for sprite collision detection
Just before placing hero sprite on screen buffer the routine will compare bgb to sb with hero gfx
if sb differs from bb then hero/air collision

if sprites were stored in blocks 24 wide then they could be indexed with (),y rather than self 
modified addressing. This reduces memory footprint for code and for the same or faster speed.


Because we store a unique id in the collision map we can begin to say there can be a maximum of 15
concurrently active air based crafts and 15 concurrently active ground based sprites.


******************* Controls ***********************
Player1	Player2
Keyboard	Pase1
Pase1	Pase2
Pase2	Pase1
Pase1	Keyboard
Keyboard	IJKa
IJKa	IJKb
IJKb	IJKa
IJKa	Keyboard



******************** Displaying sprites taller than 11 rows.. **************
The EOL sprite trigger in the Map will be changed to a bigger sprite trigger.

The first part of a Multipart sprite uses the specified ScriptID and the next part uses the next
ScriptID, etc. So if a scriptID of 4 was specified in a 4 part multisprite then the subsequent
parts would use ScriptID 5,6 and 7.

In this way each part can specify the First FrameID in each Script and permit Animations within
a multipart sprite.

When creating a sprite of more than one part the order of sprite graphics for each part
will depend on whether the sprite will appear from the top or from the bottom.

On a Wave Trigger the Multi-part sky sprite will assign the specified ScriptID and an On-Delay of zero
to the first sprite (which will extract the frameID from the first entry). The next part will select the
next ScriptID (+1), etc.

The EOL is known as the limits of the map rather than a flag.

******************** Collision footprint of Bigger or oddly shaped Sprite ***************
The problem is the bigger sprite Dragonfly is not square and therefore shooting at it will hit it on sides
of the square where it is not present. We possibly need a footprint template that is drawn in the collision
map. This would increase accuracy, speed up the collision rendering and detection processes.
However it would require alot of extra work.

******************** Sound **************************
Sound Effects must operate outside of IRQ so that they are processed only when required.




The first step was to recede the collision detection to just deal on one plane(ie. 0-255) but then perhaps
instead of just storing a unique ID (which may cause issues later in level as accumulatively the sequence number
will cycle 255 and return the same id as the players crafts) we should hold some info in lower 2 bits..

B0-1 Sprite Type
      0 Reserved for No Collision
      1 Player A Craft
      2 Player B Craft
      3 Sprite (Data is UniqueID 0-63)
B2-7 Data for Type

projectiles

************** Expanded scripts
Scripts should be expanded to provide new commands. Infact for smaller footprint, the actual command
should be a separate byte to the data. This will save on memory and not too much more cpu..

+0 Command
+1 Data

Currently we have a range table and a vector table. We wouldnt need to worry particularly about the
extra size difference if the jump command had an 8 bit parameter :P

We also need to specify a script offset to the explosion script, so that the train(for example) could
specifically explode rather than restore the bg.

If the projectiles had their own sprite code then we could optimise based on no shadow,no
collision map and limited size (1x6).

*************** Bonuses **********************
Each nibble contains a bonus so only two can be set..
0 Blank
1 bmpBonus_Health
2 bmpBonus_Life
3 bmpBonus_DoubleCannon
4 bmpBonus_Splay
5 bmpBonus_Sidewinders
6 bmpBonus_Retros
7 bmpBonus_SmartBomb
8 bmpBonus_Missile
9 bmpBonus_Laser
A bmpBonus_SpeedUp
B bmpBonus_Invisibility
C bmpBonus_Shield
D bmpBonus_Orb
E -
F -


*************** Whats left *****************
* Completion of Sequence issues bonuses
* Bonuses
* Bluprint Weapons
* Groups and multipart sprites
* Health and extra lives
* Dynamic ink Setting?
* Enemy Projectiles
* EOL Monster
* Levels
* Game Over
* Hiscores
* Sound Effects
* Title
* Control, Player and Game Selection
* Title Music



	lda KeyColumn,x
	sta VIA_PORTA
	lda KeyRow,x
	sta VIA_PORTB
	lda #$FD
	sta VIA_PCR
	lda #$DD
	sta VIA_PCR
	;12

***************** Levels *****************
* - Antarctica
* - Southern Ocean
* - Kerguelen Plateau
* - Mount Ross
* - Indian Ocean
* - Milky way
* - 
* - The Hive

************** Scenario ***************
NASA report the approach of a meteorite to earch 10 times the size
of new york.
a month later NASA report again that for a completely unnown reason
the meteorite disintigrated at a precise location in space.
At the same location a week later gravitational distortions are
detected. The patterns of these distortions are matched to those
picked up from the military research station on Kerguelen island
during Project O (a top secret experiment in antigravity propulsion
technology).
A few weeks pass and then all hell breaks loose as the gravitational
disturbance spikes releasing what appears to be a UFO. This approaches
earth and establishes simultaneous contact with all the leading superpowers.
The UFO claims to have travelled 20million lightyears from the Gamma
cluster desparately searching for an intelligent species to help rid
its own colony of a silicon based lifeform that is destorying them.
However as the conversation curtails it becomes apparent that the ufo
is unmanned and is acting as a distress beacon.
The russians
The Americans immediately believe it to be sending out distress calls not
just to earth but everywhere else and if they 


NASA - 23rd September 1998 20:07
Dear Sirs,
 As of 20th September our operators have advised us
the afformentioned unidentified sattellite is in
actual fact a meteorite. It is estimated to be around
20 feet in diameter. Previous reports suggested it was
much larger but we have discovered that for reasons
unknown as yet it literally disintegrated at a precise
co-ordinate in space.

The coordinate has been given the name Turberoos because
we have records dating back to 1912 of similar meteorites
disintigrating in that area.
However there are no anomolies known to exist there. To
all intent and purpose this is normal space. No gravitational
deviance has been sensed on our instruments, no photon emissions
or radio interference.

SETI - 17th April 2000 03:04
News Flash.. Reports are coming in across the globe that
The SETI site in Banroot, Florida yesterday evening picked
up the first extra terrestrial broadcast we have known.

"A series of low amplitude alpha waves were picked up" said
Brian Kemps, the astronomer leading the team "and
through the usual triangulation processes we can announce
their origin is in the Turberoos cluster.". This is not
the first time SETI have called in a Hoax though. 7 previous
reports were discounted as radio interference due to refractive
guidance systems in play.

Melony Gump, Astrologist and researcher at the SETI site said 
in an interview with Terence Hogg on News Tonight "The transmission
lasted exactly 2 minutes, 12 ceconds. We believe the code is a variation
of old morse and we are currently analysing the transmission to understand
its meaning. This may take some time".

NASA - 18th May 2000 12:32
It was unfortunate to hear that SETI did not observe standard protocol
and report this transmission to NASA personell before reporting it
to the world. However, as the weeks have passed it would appear the
hype has subsided and instead of the world turning alien mad they have
returned to some state of normality.
I have briefed the president on the current situation and he has applied
the usual pressure to investigate this matter with the utmost urgency.

NASA - 1st November 2000 07:45
We have reports from our remote Kerguelen outpost of gravitational distortions
emminating from the Turberoos anomoly. I have also just heard from Madras
that Leonard Patel of the university of Mumbai has also independantly reported
the same anomoly from research station 17845. We are currently
monitoring the situation and will report to HQ as soon as we get more information.

Fabrice Landstraum - Mount Ross,Kerguelen 2nd November
We can now confirm the patterns received from the gravitational distortions
from the Turberoos cluster are the same as those witnessed from Mount Ross
Observatory from the Project O experiment last July on Kerguelen.
Project O was a Top secret military operation and we fear the military may
be involved again. We (at Ross Observatory) have contacted higher authority to
seek their advice but as yet we have had no response
The low frequency tremors are still being felt to this day and i fear that
our once abundant population of king penguins may finally be diminishing.

News Tonight - 4th November 19:45
News has just come in that the eminant scientist and astrologer Fabrice Landstraum
was found dead yesterday by scientists near The Ross Kemp Observatory on Kerguelen.
Fabrice Landstraum was the world reknowned expert in astral 
His cause of death appears to be suicide. Because of the remoteness of the Kerguelen
islands we have been unable to place a reporter on site. In his place however we have
been issued the following statement from the French Milirary investigating the accident.

"At approximately 


Lt. Jaque Frances, Kerguelen Plateau, Kerguelen - 5th November


**************** Different Ground sprite technique *****************
Instead of having two separate loops for the control of ground and air based sprite
we could have just the one loop and just manage the sprite list better.

We know that the lower indexed sprites will always appear infront of the higher indexed
ones because of the order they are processed (last to first).
This primary means that players (which are always 0 and 1 currently) always appear
higher than anything else.

If we wanted to plot a ground sprite we should place it end the end of the
list which is simple.
However if we wanted to place an air sprite we should choose an index after the
players and before the ground sprites, then insert (shift data up). However
its possibly quite a heafty shift process when alot of sprites are on screen.


******************** Sprite Hitpoints and health ************
Everytime the sprite is hit Sprite_Health is decremented
When its health reaches 255 it explodes and Sprite_Hitpoints are added to Players score

*******************************
Why do we store the sprite dimensions when we spawn a new sprite?
Why don't we simply fetch the dimensions when we display the sprite indexing by Sprite_ID?
Doing the latter would permit dynamic frame sizes


Rapid Weapon Materialiser

Add script com Noplot so we can restore river for River concealed gunpost
Problem: Split sprite can only display x10 rows since 11th will overlap with next (Yellow)

Overview
Alien craft crash lands in Alacari Dessert
Military capture it and corden off Area51
It takes 100 years for military scientists to understand the technology
They duplicate it in the form of a second craft
They discover the occupant, one Griffith Thring brought a message to earth warning
them of the impending arrival of the Mogons, an alien race intent on the conquering of all
collonised planets.
Towards the late 21st century all countries unify into a single superstate called Europa.
Military forces are ?taken apart? and the two alien craft left are transported to Kerguelen
island and buried in a bunker 10 miles beneath ground. The Mogons are forgotten about.

Triffith Thring (an explorer and survivalist) happens upon Kerguelen the very same day
that the Mogons finally make themselves known. They arrive completely unanounced (much to
the annoyance of satellite 4591 (which happened to be due a routine sat-wash that same moment).
The Mogons didn't even introduce themselves before firing energy beams at planet earth.

The energy beam is intended to withdraw all precious metals from the planet. This takes time.
Unbeknownst to the Mogons though, the craft are composed of the precious metal Einstinium
and as the Energy beam penetrates the tactonic plates both craft are brought to the surface.
The Former craft (triffith recalls) appeared to power up (for an instance) and shoot a strange
energy wave straight back at the energy beam. Suddenly the energy beam is disingaged and fleets
of enemy craft are let loose by the Mogons.

The craft then beams up Triffith (and optionally a herbologist called Pierre Rambot) and so the
journey begins.

The craft must now 
Triffith (at this point) has discovered the military bunker but the door is sealed.
As the Mogons penetrate the tactonic plates, earthquakes form throughout the world including
the bunker. The first wave ceases and Triffith spies an opening in the bunker. He steps
inside and descends in a reinforced lift.

 

StoryBoard
Chapter1 - 

