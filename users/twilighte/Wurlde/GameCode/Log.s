;Log.s

The game is based on Wurlde, a story created many years ago (around 1990).
Lucien and Jonny are the main characters. The shortened version of the intro follows..
Lucien and Jonny are best friends. They play in the hills overlooking the fishing village
they were brought up in. Both Lucien and Jonnies fathers are fisherman by trade.
One day they are playing in the hills when a great storm begins. Unlike previous
rain storms, these drop firerain over the land, scorching and burning anyone and
everything they touch. And so the village is burnt to cinder and so too is Jonny.
Lucien is the only survivor and he traverses the hillside to the cliff edge and down
into a tunnel that opens into a cavern that holds the only remaining fishing vessel
that was not taken by the storm. He climbs in and sails off into the sunset.
A sea storm takes his boat and he is washed up on the shores of Ritemoor, losing his
memory as with most of his health.
Through his journeys here on, sleep will reveal fragments of the above story. However only
in certain controlled places can he sleep.

Whilst Jonny was killed by the storm his spirit lives on and he is occasionally able
to make an appearance to report the foul work that brought about the storm.
That a sorcerer named Madrageth wrought great magic to send out both fire and sea storm
to destroy a wizard who had hidden in the village in a power struggle. The Fire storm
intended to destroy the village and the sea storm to prevent people escaping to the sea.
Madrageth has not noticed Lucien and this is Luciens edge to victory.

Some parts of the bigger picture are revealed through dream sequences, others through visions
of Jonny and others through the characters Lucien meets on his quest.

Lucien must now restore the health he is lacking by eating from the fruit tree and catching
fish. He may also gather butterflies if he combines the net with the stick.
He will make his way to the Escarpment where he can get passage to Sassubree via the
Witches castle.
The witches will interrogate him and experiment on him but he will escape back to the boat.
Lucien must then traverse further down stream to Sassubree.

In Sassubree he will be able to sell the fruit, Fish and Butterflies. He may then buy lodging,
ale, and things from the market.
One such object is the firestone which will disuade the witches from stopping him.
Another object is the Weathercock.
He may then travel peacefully to Ritemoor and collect more butterflies.
If he carries the Weathercock as he passes the windmill vanes, they will not hit him so he can
reach the fish and fruit tree.
He may also buy fish from the Jetty early in the morning and sell it to the market later in the
day. The later he sells it the higher price it will fetch.
He will also learn that a powerful and magical sword is held on Samson isle. He will need to raise
enough gold to buy passage from Keggs.
Early one morning Lucien and Keggs set off on a boat moored in Sassubree harbour. However they
hit a heavy storm and keggs is knocked overboard leaving Lucien to ride the storm.
On reaching Samson Isle Lucien will find the monastary and will attempt to steal the sword from the
monks.
The Monks use strange magic against Lucien but eventually Lucien wises up, gets the sword and returns
to the boat only to find it gone.
If he spoke enough to the occupants of Sassubree he will know somewhere on the island is likely to
be a pit dragon who likes toadstools, which is his way off the island and back to Sassubree.
The Dragon is hidden east of the monastary beyond a small local village and will need to befriend it
with toadstools from the dungeon in the monastary (The villagers will mention this).
He may also get lodging at the village to save the game.
Once befriended he flies the dragon. However again he faces a heavy storm and must guide the dragon to
safety. The dragon will fly over Sassubree and land by Sassubree Fort. Lucien will get off and the dragon
will take off again.
Occupants of Sassubree will now refer to him as the dragon rider and through keywords he has learnt on
samson isle will ?



Controls Overview
Bit	Operation	Std Keys	Joystick
0(kcL) 	Left          	Crsr LF         Left
1(kcR) 	Right         	Crsr RG         Right
2(kcU) 	Up            	Crsr UP         Up
3(kcD) 	Down          	Crsr DN         Down
4(kcA) 	Action		Left Ctrl	Primary Fire
5(kcI) 	Item Control  	Left Shift	Secondary Fire
6(kcM) 	Menu		Escape		-


Standing mode
L	Run Left/Turn Left
R	Run Right/Turn Right
U	Pickup/Jump
D	Drop/Duck
F	Action
LU	Leap Left
LR	Leap Right
Fh	Inventory

Running
LU	Running Jump Left
RU	Running Jump Right




Standing mode
L	Turn Left/Run Left
R	Turn Right/Run Right
U	
D
I	Add transient item to inventory
I L	Item Select Left
I R	Item Select Right
I U	Pickup Item
I D	Drop Item
I A	Use Current Item
A	Action (Interact with Background)
U L	Standing Jump Left
U R	Standing Jump Right

Run Mode
L	Turn Left/Continue running left
R	Turn Right/Continue running right
L U	Turn Left/Running Jump Left
R U	Turn Right/Running Jump Right



NORMAL MODE(From Stand Left or Stand Right)
== Movement ==
Left		kcL	Turn/Run Left
Right		kcR	Turn/Run Right
Up		kcU	Jump Up/Enter Building
Down		kcD	Crouch?
Up Left         	kcUL	Turn Left/Running Jump Left/Standing Jump Left
Up Right		kcUR	Turn Right/Running Jump Right/Standing Jump Right
Menu			Enter Main Menu
== Inventory ==
Shift		kcS	Catch and pocket Item/Inventory Key Mode
	Items caught are always placed in pocket before they can be eaten.
Shift Up		kcSU	Pickup Item
Shift Down	kcSD	Drop Item
Shift Left	kcSL	Navigate Pockets left
Shift Right	kcSR	Navigate Pockets Right
Shift Action    	kcSA    	Use Item/Eat Item
Shift Menu		Enter Item Menu(Combine,Examine)
== Action ==
Action		kcA	Interact Background/Talk to Character
Action Cursor		Combat (Type of combat is Based on selected item)
	Performing an action away from the scene will perform an escape tactic
	Performing an action towards the scene will perform an attack tactic(proactive)
	Performing an action Up will perform an avoidance tactic(reactive)
	Performing an action Down will perform a submissive tactic(surrender)
Action Menu		Enter Action Menu




Space          Resume game and Normal Mode

HANGING MODE
Up	       Climb Up onto Ledge
Down           Fall Down
Space          Suspend game and enter Item Mode

PAUSE MODE
Fire(L-Ctrl)   Exit game to Game Menu
Space          Resume game


************************* ScoreBoard *******************

Now we have a fresh new scoreboard.
>Areas
 - Top Left Window - Displays images of things the hero is about to face
 - Arrows - Defines possible exits and the colour determines danger(Red), Normal(Green), No exit(Black)
 - Ring - Hourglass - counts down time remaining, this may accelerate by certain magic
 - Attribute bars - Not sure of neccesity
 - Sword - Might

Need Heart and Health Bar


************************* Collision ********************
For outside maps their is no collision map unless specifically provided by SSC module in its
ScreenRun Call.
Y position is controlled by X position through a Floor Table which can be embedded in the Inlay
screen (08-0B) and extracted at ScreenInit time or held as a separate table.
The Floor Table is 40 bytes long and each byte defines maximum Y-Position and terrain features.
B0-5 00 Initial Value of table before extracting embedded attribute
     01-59 Maximum Y Position
     60 No thoroughfare
     61 Exit Left
     62 Exit Right
     63 Instant Death
B6-7 Screen Specific Collision Identifier (0-3)

For embedded data, 60-63 codes are interpolated into FloorTable by ScreenInit after extracting
embedded data, which is most likely to be done manually.

For each new hero position, the collision detection routine is parsed the Sprites Width, height,
X and Y Positions.
The Detection routine (using the floor table) determines the maximum height the sprite can be
based on the width bytes and the Sprites height.
(Previous version was based purely on left most X Position)

Since the collision routine is always in the SSC module, any detected terrain features will be
processed by the SSC module(because width is provided, there may be more than one feature
detected).

Some Features will require some action on behalf of the hero before the feature is affected.
The current action can be picked up from zero_page.

A Ceiling table also exists to set minimum height. This is optional so the embedding code is
different and is 1C.

Both Ceiling and floor tables are in lomem and the capturing of embedded codes routine is also
in lomem.

************************* Flying Insects ****************

Really need a sort of sine trajectory for insects with varying size, speed and angle after cycle.
a simple sin table may be adequate then capture random intersection to continue cycle from.

The land begins to tire
of human lack lustre

weeping willow
how befit the fountain stirs

************************** Land Contouring *********************
The hero always moves over the surface of the land and its ever changing contour.
The contour is held as a 40 byte table where each byte is the Y position at the X index in the
table.
However to keep the hero as close to the ground as possible means that every contour byte
must accommodate 3 bytes to the right because the hero frames are up to 4 bytes wide.
However this causes the hero to stand mid-air (to avoid corruption of ground).
Unfortunately because the Hero may be moving in either direction, it cannot be shifted so the
yposition of the countour byte must always accommodate 3 spare bytes to the right.


************************* Movement ******************
Jump Left/Right checks Floor and ceiling tables during the heros flight.

On key left, kbdleft is called which manages all running left, including frame update, screen
management, screen byte stepping, land contour management, etc.

Their is now a stage to decide on true movements. Ie. how many movements should the hero posess
without increasing memory and code too much.
Essentially the same level of control and movement as Prince of Persia i guess.
HERO ACTION                    FRAMES DONE
Stand Left                       YES
Stand Right                      YES
Right to Left Turn               YES
Left to Right Turn               YES
Pickup Left (To pickup)          YES (Using reduced Kneel Frames)
Pickup Right (To pickup)         YES (Using reduced Kneel Frames)
Run Left                         YES
Run Right                        YES
Bow Left                         YES
Bow Right                        YES
Running jump left                YES
Running jump right               YES
standing jump left               YES
standing jump right              YES
standing jump Up Facing left     YES (Progressing to Clamber left or fall left)
standing jump Up Facing Right    YES (Progressing to Clamber right or fall right)
cling and swing facing left      YES
cling and swing facing right     YES
climb up facing left             NO (Including Climb up, Climb down)*1
climb up facing right            NO (Including Climb up, Climb down)*1
use sword Left                   NO (Including shuffle forward, Strike, defend)
use sword right                  NO (Including shuffle forward, Strike, defend)
Death sequence			 YES
*1 Based on jump up or cling-swing




**************************** Level File *****************
Each Screen is considered a 'level'
Each Level is contained within a single source file such as sscm-om2s5.s
Each Level contains a set of data and a set of code routines specific to the screen

LevelRun is code always called in the same main loop as hero control
LevelExit is code always called as the hero exits the screen

LevelProse is a paragraph of text to describe the level.
LevelScreen is the screen data which must contain embedded ceiling and floor codes.

********************** Sword problem *******************
Possibly use Walk frames for Sword fighting frames, have sword naturally black (mask) with
tint of green and white shine wherever possible.


*********************** Game size Map ***************
The game is split into 5 outside areas, Maps 00 to 04 and a total of 33 screens.
Each area is set in a different part of Wurlde.

Map02 This is the first map and the hero is washed up on the far right shore.
      Lucien must find the spellbook to travel to maps 02,01,00 and 04
	Entrance to Windmill
	Entrance to Grain house
Map01 This is Sassubree town (Market stall, pub to save game, boat to Samson isle)
	Entrance to Fort
	Entrance to Pirates Arms
	Entrance to Market
	Entrance to Kissing Widow
	Entrance to boat
Map03 Samson isle (sword)
	Entrance to Priory Inside complex
Map00 Turn country (Wizards house)
	Entrance to Wizards house
	Entrance to Hallow
	Entrance to Church
Map04 This is the final quest (up the mountain, into the dwarven mines)
	Entrance to Dwarven mines
	Entrance to Cyan Castle



*************************** Seagulls *****************
Seagulls is a challenging sub-program.
I want the seagulls to fly, swoop, dive, land and woddle along and also with distance frames.

A random selection of sequence, where each sequence contains movements and frame pointers.
The random element ensures the flight pattern is always different.
Also each frame has associated shift patterns permitting any movements to be performed.

I'd really like to allow birds to both fly infront and behind tower in harbour1 but that is a
separate piece.



************************ Animating background behind Hero *********************
This is a very difficult but very desirable feature of Wurlde.
Simply plotting background changes to screen then plotting hero would produce too much flicker.

Method1
Plot the background changes to the background buffer.

**
In the beginning there was no light, nor darkness, just a void. A single moment of

***************** Ideas
Night time things become more treachorous

On certain empty screens have objects rise from ground then sink back down (maybe bog) that are
collectable.
Under the Lift cage lies something to collect.

Atop the mountain lies the final gate before the dwarven mines. This gate is controlled through
some very strong magic. The spell of which is little known. Their is a slight chance the same
spell that was spun may be subject to the presence of the great sword, so there is a small chance
the sword you find will fool the magic in releasing the door.

Mountain top: single well or grate.

BrokenSky
On entering this screen (left) the hero must pull the chain (which will trigger a sequence of chain
down then up). The cage will imediately tilt as it is pulled over the edge.
Whilst it is being moved into position, the hero is frozen (a single animation sequence will be
used) or will be involved in the animation.
Once over it will remain stationary allowing the hero to step onto it.

As the hero leans tilting the Cage, a ratchet may be heard which is the mechanism that drives it
forward. ie. the hero must lean left/right repeatedly at a close match to the mechanism speed in
order to progress up the cable. If no player action is taken, the cage will return to a centre
position and slide back down the cable (reversing the BG scroll) potentially back to its standing
position (but after the ground).
As the cage is swung and the ratchet drives the cage forward the rock cliff will byte scroll away
and the blue BG will smooth scroll DL.
Note the BG scroll is a parralax scroll, whereby the distant clouds remain static and only the
silhouette ground smooth scrolls.
If enough CPU & memory is left then trigger rain or flying things that must be hit with the
swinging cage.
Once the hero has reached the end of this 'level' the next screen will load with the cage already
'parked'. The hero may then exit the cage and progress forward.
The cage level is reversible. ie the hero may

To get up the mountain using the lift cage, the hero must use (crush) the black orb to turn
invisible. Failure to do so before the cage will attract the shadow-guards from further up
the mountain who will sweep down and devour the hero.
whilst invisible, pulling the cord by the cage will trigger the cage to be sent up the cable.
so the hero must quickly climb onto the cage with sword unsheathed (since this is the only
visible item so that he can see where he is).



An old man stands next to an old tree. He refuses to move and permit the heroes passing.
On asking him why he cannot move he replies "I have asked this tree to move but it doesn't
listen".
fire rain falling through trees and over tin roofs, and hero must run beneath avoiding every
drop.
at certain point, a crate with wheels must be mounted and this must be dispatched at exactly
the right point to avoid an intermittant firerain shower.
the final destination is a cave in a dell on the side of the downs.
This is where Lucien sees the apparition of his friend.

The gameplay then changes to b/w or minimal colour with flickering torch light down the cave
tunnel complex towards the boat moored in the seas cave.

The Mooring is an old stone jetty that only slightly jutts out from the cave and rises to the
cavern tunnel where Lucien will come from.

thin stone bridge with mountains in bg


'rolling' log over chasm.. Tree that requires something to make it fall over chasm and permit
passage.

Red blinking eyes in the dark

Falling snow (light snow oscillates pixel left/right) but then rages into hail storm shifting
hero back when attempting to run or even stand, only progression is crawl.

Wizards story.
Birist cannot be killed by normal means, he is the devil incarnate, he is the anti-life, the
evil within. He is the shadow that prevails all nights and he takes this form in life.

He dwells within the deepest caverns in a great hall. Only his minions venture beyond the
deep and his dark power has reached into the souls of most creatures in Wurlde.

They will devour you if you let them so beware of all living things. But remember that all except
Birist have been polluted, that they are innocent and a killing spree by you alone would only
attract the attention of Birist and would not be favoured by any, including me.

There is a sword, fabled to exist that can cut darkness and reveal the light. This sword is your
only means of banishing Birist from Wurlde, by showing him the light.
But just as this sword cuts light from the shadow, so it can also be wielded to cut darkness
from light and Birists minions have already captured it and hold it close to them deep in the
dwarven mines intending to use it at some point in the future.

The fable of the sword was so famous during one period of Wurlde history that fake swords were made
in honour of it.
My predeccesor was best known for his incarnation of this sword, wrought from great magic
and to all intent and purpose looking exactly the same.
Only the heart of the sword and its unimaginable power of slicing the very fabric of space differs
from the imposter.
This sword is held on an island close to Sasubree, within a vault and not known to Birist or his
minions. The island is known as Samson isle.

The way to defeat Birist is to acquire this sword.
Whilst hiding it in your posessions you must then travel to the dwarven mines whose entrance is
near the summit of the high Mountain.
Their you must descend and locate the real sword and replace it with its imposter.
You must then locate birist itself. Birist lies within a deep chamber, a sacrificial hall of old
and home to its presence. Eternal candles burn all around raising the temparature and throwing
great flickering shadows into the central hall. Their you will find the blackest
shadow, a swarming swathe of shape shifting blackness that can take any form it desires.
Strike hard with the sword and it will show the light to Birist and banish him to oblivion.
Strike too late and Birist will engulf you, swallowing you into its total eternal blackness.

I myself cannot attempt such a journey for i am old and weak.

To be able to avoid confrontation on your journey, you should invest in some defensive weapons.
Throughout the 200 years of my life i have seen many strange artifacts, some bestowing new strength
in the bearer, some changing the appearence of his apparral, some restoring his health and some
darker magical concoctions that bring death quickly to their victims.
Those are just a few of the objects i have seen, but be wary of creatures you deal with.
Not all will be as honest with what they sell.
Sassubree has some established places which provide more reliable artifacts whereas market stalls
and people you meet may try to sell you at far cheaper prices but may not be as reliable.

The water tablet (which is found in the fountain) can be used to replenish the hero's flagging
water level. Its closest simally is "dried water".

Casting spells?


********************* Game sequence
The Sven anim begins until hero is catapulted into space, falling thru space.
Gme title, options, etc.
On Game start the hero falls away shrinking to a small dot, then a planet approaches from side.
the camera changes many times here giving different views of hero falling into orbit and thru
atmosphere of Wurlde until final blackout and Hero awakes laying on shore of Wurlde.

Birist (The evil in Wurlde) is not initially aware of Lucian's (The hero) presence but someway thru
his quest, Birist discovers him, and physchological warfare and psychoanalysis insues in the form
of cut sequences of confrontations during dreams (when the hero saves to disc) and at certain
seminal events in the game.

	ldx xpos
	ldy ypos
	lda xloc,x
	clc
	adc ylocl,y
	sta

************ Bees
;Draw and navigate swarm of bees
;1) Bees naturally collect nector from the available flowers
;2) Bees are attracted to Red or Magenta
;3) Bees move in curves
;4) Bees do not move wings when landed

1) Figure 0 clockwise
2) Figure 0 Anticlockwise
3) Figure Hover Left
4) Figure Hover Right

Activity consists of stages
Stage 1 (Hover)
Bee follows any cyclic FIGURE wave scanning flowers diagonally in facing direction
if near left/right border then only follow figures 3 or 4 respectively.
Stage 2
Bee dives to shrubs to flower (Red or Magenta)
settle on flower and wait 5 then Stage 3
Stage 3
Bee rises random height (3-8)
Enters stage 1 again

*************** Snow
Snow is actually a weather particle driver
Snow can generate rain,snow,fire-rain,hail etc at 5 speeds in both directions and vertically
with oscillation(fluttering).
Note blue rain will have the occasional white through a bug, though not uncommon :)

Blue  -  Rain
Red   -  Fire Rain
White -  Snow
Yellow - Sand Storm
Colour cycle for magical curtain

Floor of particle based primarily on hero floortable

SnowSpeed
250 Storm Left
251
252
253
254
255 Shower left
0   Flutter Vertical
1   Shower Right
2
3
4
5   Storm Right
Other values are possible

No Proper initialisation yet, first fall is uniform :(
No lightning effects provided yet!
No gradual change of climate yet!



***************** Items
Items dropped or yet to collect are displayed at the start of each screen.
Item		Location		Use		Quantity in game
Green potion  				Health+6		4
red potion                              Health+10		4
blue potion   				Magic+4			4
green orb                               Magic Weapon		1
blue orb                                Magic Weapon		1
red orb                                 Magic Weapon		1
black orb                               Magic Weapon		1
scroll                                  Spells			1
red parcel                                                      1
green parcel                                                    1
yellow wand   	Found in field		Needed for spells
red wand                                Needed for Red Spells	1
magical knife                           Infinite Knife throws	1
food basket                             Maximum Health
sword
water tablet  See ideas                                                    1
bird in cage  Used in mines to detect presence of poisonous gas            1
map           Map of Wurlde                                                1
straw bale    Found in field                                               1
oil flask

Hero starts on seashore, so need shell.

They all appear as glowing inversed graphic either 2 rows above ground where they were dropped
or 2 rows above where they originally lay on the even line (Hero bitmap).
When the hero walks past them the text window will display a message, the item will be erased
by the plot routine but restored after by the item plot routine which runs concurrently.

Dropping an item on the skybridge or any other bridge will drop the item OFF the bridge.

Seagull behaviour

1)Seagulls fly away when hero approaches
2)Seagulls land where no hero and spare surface
3)



39x20
B0-4 Collision Value(32)
B5-7 Preferred Height in cell(0-5)

Collision values
0 No Collision
1 Impenetrable Wall/Floor
2 Left climbable Edge
3 Right climbable Edge
4 Falling platform?
5 Rising platform
6 Item

HeroDetectCollisionMap
	ldy HeroTestY2
	;Divide by 6
	ldx DivideBy6,y
	;Multiply by 39 and add CollisionMap base
	lda CollisionMapYLOCL,x
	;Add X
	clc
	adc HeroTestX2
	sta vector1+1
	lda CollisionMapYLOCH,x
	adc #00
	sta vector1+2
	;Fetch collisionmap entry
vector1	lda $dead
	pha
	;Extract Collision Value
	and #31
	sta CollisionValue
	;Extract Contour Map Index
	pla
	lsr
	lsr
	lsr
	lsr
	lsr
	;Use to index Contour map table
	tay
	lda CMContourTableLo,y


*Scoreboard*

Inventory
Health
Bladder?
Energy?


0000 System
0500 Game System		29696
7900 Level Data&Code		8192
9900 Std Charset		632
9B78 Spare			1160
A000 HIRES                      8000
BF40 Spare			40
BF68 Text Rows			120
BFE0 Spare			32
C000 ROM

79 Characters used for Text

3Kx8

*********** Screen allignment **********
Each screen must start with BG row so that alt lines are always Sprite and Even lines are BG.


*********** Menu system *********
When entering shops, stalls and inns the hero will be presented with a number of options.
These options should be displayed either in the text window or on screen.

The textbox will display "Please Choose"
The text window will display a description of the establishment.
A popup window will appear in the gameplay area providing the options available.

For example

		PLEASE CHOOSE

The quay side

************** Music for Wurlde ************
Must be freeform with variable pulsewidth tone/s for title.
Incidental music is normal pattern based
Game sfx == environment sounds

For Sassubree something around Scarborough fair with growing complexity.
For LittlePee something around Rosemary and Thyme with growing complexity.
For countryside environmental sounds like bird-song, tree wind, crow calling, dove sound, rustling.
For first cut-scene either the song from Night of the hunter river scene or similar haunting tune
For Sassubree and Ciro Castle something more stirring
For Samson isle monastary something around Baroque/Chant


Freeform music must permit the freeform variance of both the notes pitch, volume and period.
However the event of the note may still observe similar formats to tracker musics.
Only the period needs to be accurate beyond 64 rows.
Also the pitch and volume is somewhat limited to the hardware of the Machine.

Freeform is problematic because it invariably requires lots of memory in order to deliver unique music.

Note: Freeform may not exclude repetition.

One might begin with the three channel scheme where each channel is provided a 4 byte notation to
specify Note to start, pitch variation to start, Volume to start, Period of note and initial pulse
width.

Note range is 0-95
Pitch range might be 0-63
Volume is 0-15
Pulsewidth is 0-31
Period is 0-511 at 100mS increments?

Byte 0 Bits 0-6 Note
Byte 0 Bits 7   Pitch
Byte 1 Bits 0-4 Pitch
Byte 1 Bits 5-7 Volume
Byte 2 Bits 0   Volume
Byte 2 Bits 1-6 Pulsewidth
Byte 2 Bits 7   Period
Byte 3 Bits 0-7 Period
Pitch Effect
Volume Effect
Pulsewidth effect
effect period effect

All effects are relative to the original set in the note form
Variation of the note as it progresses might use some form of modification pattern?

using the ay eg for click
if possible to add sample drums?


At the very beginning of the main code at $500 is a bank of JMPs that point to some very
useful routines in the main code area. The location of each jump is always the same so a
simple JSR to the JMP is all that is required to access the routines.


MainCode	;Always $500
	jmp nl_screen

SSC	jsr $500+nl_screen

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

cbc01234567890123456789012345678901234cb	;35 virtual chars
cbc01234567890123456789012345678901234cb	;35 virtual chars
cbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb

32-63?
64-95
96-127

33-42

56-127 Virtual HIRES ($99C0-$9BFF)


************** Game Title ************
Game intro ends with hero falling (rotating) through 3d starfield.
Hero falls centre screen varying rotation and floating actions.
3D starfield is masked behind hero and mapped on even rows only.
Credits(below) use odd rows only.

Intro continues like this and with credits shown thus..
Credits fade in from blue to white dithering on darker colours.
when white, they remain for a second before fading again.
as they fade to blue/black and dither they also scroll left or right depending on top/bottom.

Each credit consists of title "Music" and Author "Twilighte" on next line.

The process must accommodate parallel fades, ie. next credit may appear before previous has
finished.

>>Music
Throughout title, music plays in background
Music starts with accurate freeform guitar solo using synthesised pulse width with volume.
Once solo ends, main music begins. This consists of EG clicks and LowSpeed Digidrums for
percussion, Synth pulse width for Bass and 2 remaining chip channels for melody.

Need to experiment with AY EG for synth pulse width. Will be much less cpu than chip volume
usage.

We might use a shortcut here by writing 13 to the envelope Cycle register
The shortcut is that the register value of 13 happens to be the same as the register number 13.
This means we do not need to reset CA2/CB2 between register and data writes.

In the code..
	lda #13
	sta via_porta
	lda #AY_Register
	sta via_pcr
	lda #AY_Value
	sta via_pcr

Based on a short period set, The action of writing to Register 13 will reset the waveform.
The value of 13 sets the EG to rise from 0 to 15 and remain high.
In its most basic form, the waveform will behave like a normal Sawtooth..

/|/|/|/|/|/|

But as the period register is decremented, the rise angle will become more acute giving the
waveform time to approach 15. This will be heard as a rise of volume.
As the period register is incremented, so the rise angle flattens, reducing the waveform
time to approach 15. This will be heard as a drop of volume.
Each write to 13 will trigger the full cycle which halves the cpu time required to generate the
waveform.
IRQ_1	;In both instances of the interrupt request, 2 occurrences are required
	;SynthPW requires positive and negative cycles
	;LoDigi requires lo and hi nibble extraction
	;IRQ 1 200-5Khz - Synth PW
	;IRQ 2 400Hz    - LoFi Digidrum

	;backup Accumulator
	sta irq_temp01
	;Redirect next irq
	lda #>IRQ_2
	sta sys_IRQHi

	;Detect IRQ
	bit via_ifr
	bvs skip1
	;Process Synth PW

	;Preserve Accumulator
	sta irq_temp01
	;Reset IRQ
	lda via_t1cl
	;Set Waveform
	lda #13
	sta via_porta
	;Set Register 13
	lda #AY_Register
	sta via_pcr
	;Store 13
	lda #AY_PortData
	sta via_pcr
	;Restore Accumulator
	lda irq_temp01
	rti
skip1	;Process LoSpeed Digidrum
	sta irq_temp01
	;Reset IRQ
	lda via_t1cl
	;Set Digi Register
	lda #Digi_Register
	sta via_porta
	lda #AY_Register
	sta via_PCR
	lda #AY_Inactive
	sta via_PCR
	;Fetch Sample
vector1	lda $dead
	;Extract High Nibble
	sta vector2+1	;This is the fastest way if routine resides in ZeroPage
vector2	lda $??00
	;Store Sample
	sta via_porta
	;Notify AY
	lda #AY_PortData
	sta via_pcr
	lda #AY_Inactive
	sta via_PCR
	;Process 50hz
	dec MusicCount
	beq Proc_Music
	;Restore Accumulator
	lda irq_temp01
	rti

Proc_Music


#define        via_portb                $0300
#define        via_t1cl                $0304
#define        via_t1ch                $0305
#define        via_t1ll                $0306
#define        via_t1lh                $0307
#define        via_t2ll                $0308
#define        via_t2ch                $0309
#define        via_sr                  $030A
#define        via_acr                 $030b
#define        via_pcr                 $030c
#define        via_ifr                 $030D
#define        via_ier                 $030E
#define        via_porta               $030f

#define	AY_RegisterIndex
#define	AY_RegisterValue




xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
All text should possibly be placed in the SSC module.
You will only ever use the menus when at particular screens.

Each SSC will hold a number of trigger positions which mark a collision with a background object.

A Table exists in the ssc header block which holds 8 records of 4 bytes each(32 byte table).

Byt 0   - Background Attribute
      Bits 0-3 (Background appearance time)
      	0  04:00                        tod_4AM
      	1  06:00                        tod_6AM
      	2  08:00                        tod_8AM
      	3  10:00                        tod_10AM
      	4  12:00 Midday			tod_Midday
      	5  14:00			tod_2PM
      	6  16:00			tod_4PM
      	7  18:00			tod_6PM
      	8  20:00			tod_8PM
      	9  22:00			tod_10PM
      	10 23:00			tod_11PM
      	11 00:00 Midnight		tod_Midnight
      	12 02:00			tod_2AM
      	15 Anytime			tod_Anytime
      Bits 4-6 (Background Type)
	0 Menu Entry (Inn, Market)      bgt_Menu
	1 Location Jump (Subgame)	bgt_Jump
	2 Feature (?)                   bgt_Feat
      Bit 6 -
      Bit 7
	1 Active Entry			rec_Active
Byt 1   - Xpos+Range
      Bits 0-1 Range 1-4
      Bits 2-7 Xpos 0-39
Byt 2-3 - Pointer to menu address




Who do you wish to speak to?

Inn keeper
Fisherman at bar
Fishermans Dog
Saucy wench

The Bar Tender turns to you..

Ask question
Ask for lodging
Buy beer
Buy food

The Saucy Wench turns to you..

Chat up
Ask about rumours

You stand in Sasubree market..
Select the stall you wish to visit

Stanleys Fish Stall
Arkies Artifacts
Smithies Metal Merchants
Maltherzars Inscents
Geffers ?
Halford
Muncaster
Kaufman

The Kaufman sells Kauf, a strange substance only found in Ciro country and used to boost Mana.

Welcome Traveller, can i help you?

Example sequence
Enter market
Which stall do you wish to visit?
 Stanleys Fish Stall
>Arkies Artifacts<
 Smithies Metal Merchants
 Maltherzars Inscents
Which item interests you?
 Sceptre
 Green Potion
 Trinkit
 Heavy Armour
>Strange stone<
The stone is strange because it glows
when held.
What would you like to do now?
 Ask about stone
 Buy stone
 Put Stone back
>Steel stone<
How are you going to steel it?
>Pocket it when Merchant is not looking<
 Run away with it
 Threaten Merchant with weapon
 Claim he stole it from you

The Merchant appears to have
picked you out as a suspicious
character. You can not find a
suitable moment to hide it.

or

It just so happens that the
Merchant is away from his stall
right now, and you easily slide
it into your pocket with no one
the wiser.

or

The item slips from your grasp as
soon as the thought enters your
mind. It ends up exactly where you
picked it up from!

or

It is too large to conceal in your
pocket.


Old Leather Satchel - Increases pockets from 2 to 10
Brass Lantern - Needs oil and ?
Lantern Oil
Bed Pan
Coals
Wooden Cross - Red Herring in this world

The game starts on map02 on the rightmost screen (shore).
The hero passes the field before reaching the bogmire.
He must navigate the mire by using the correct sequence of rising stepping stones.
He will then pass the windmill and old millhouse before finally the butterfly bank and
first screen.
Alternative1: He must then mount the Oryx and ride across the wasteland to arrive at Templeweave.
Alternative2: He must take flight in the basket beneath the balloon, to land at Templeweave.



Problems
q: How do we get from map to map?
a: By Land(Horse),sea(boat) or sky(?)




ITEM PURPOSE

ioGreenPotion		Maximum Health Boost
ioRedPotion
ioBluePotion
ioGreenRock
ioBlueRock  		Seems only to shield the attention of the Banit Witches!
ioRedRock
ioBlueSphere
ioScroll		Spells
ioRedParcel
ioGreenParcel
ioYellowWand
ioRedWand		Mana focuser(requires spells)
ioKnife			Magical knife, infinite throws
ioSandBowl
ioGreenSword
ioBlueTablet
ioBirdcage		Detects gas in Dwarven Mines
ioWhiteParchment	Dark Spells(Those that destroy)
ioTobacco		If used with pipe and spark can increase mana
ioSparkFlask		The flint on its stern will produce a spark (use with tobacco and pipe)
Map			Opens map in infopanel to show current position(No inventory gfx).
Lemon Bread             Eat for health
Fish			Eat for health or sell on market
Fruit			Eat for health or sell on market
Stick			Combine with Fish net to make butterfly net
Fish Net		Combine with Stick to make Butterfly net
Butterfly Net		Used to capture Butterflies in Map02
Pipe			If tobacco and spark is used can increase mana
Old Leather Satchel	Increases pouches from two to ten(No inventory gfx)

something to allow hero to see in dark better?

Combining two objects can either be done manually or with the wand.
Manually combining objects takes time and persistance whereas the wand makes the change immediate.
However combining incompatable objects together with the wand will produce spurious results..

You combine the Map with the Lemon Bread using the wand producing a conjealed lump of multicolour goo.
However eating the goo has the strange effect of suddenly having a photographic memory of the map



Need to cover actions

What do you want to do with the *?

Combine with another Item (Or Adapt *)
Use the *
Eat the *
Drop the *
Sell or Barter the *
Examine the *











The butterflies are by far the most valuable items. They can be sold at the market.





Provide common routines that replace ROM routines are other things in one sector.


*********** Screen Changes ************
When a hero visits a screen, he may change a particular feature of that screen. This
will need to be remembered for the next time he visits the same screen.
This is held in the Player File.


lpOldCastle
 .byt "The old castle lies on the bank of "
 .byt "the ancient river Sass and at the  "
 .byt "edge of old Sassubree harbour town "
 .byt "in the heart of Calgaroth.",128
lpOldBakery
 .byt "The Bakery and slaughter house used"
 .byt "to serve the whole of Calgaroth and"
 .byt "became famous for it. The quality  "
 .byt "of its produce was legendary from a"
 .byt "simple lemonbread to the best meat "
 .byt "in the wald.",128
lpPublicHouse
 .byt "The Pirates Tavern is the ideal    "
 .byt "place for rumours and gossip even  "
 .byt "in these hard times. It also serves"
 .byt "a restbite for weary travellers and"
 .byt "the facilities are not found better"
 .byt "elsewhere.",128
lpMarketSquare
 .byt "Sasubree market is the best place  "
 .byt "for fresh produce from around      "
 .byt "Calgaroth. Market stalls also serve"
 .byt "up artifacts from time to time. Be "
 .byt "sure to return every new moon for  "
 .byt "bargains.",128
lpHarbour1
 .byt "The Harbour watch tower is always  "
 .byt "manned day and night, ensuring the "
 .byt "safety of Sasubreeans.             "
 .byt "The Kissing Wench is another public"
 .byt "house serving fisherman and sailors"
 .byt "from the harbour.",128
lpHarbour2
 .byt "The quay side is the best place to "
 .byt "find fresh sea produce especially  "
 .byt "early on a new moon.",128
lpJettyEnd
 .byt "Boats are moored here and fisherman"
 .byt "may be bought to take travellers to"
 .byt "some of the more remote islands    "
 .byt "around Calgaroth.",128
TestText
 .byt "Out amongst the stars..            "
 .byt "A lit church bereft of audience    "
 .byt "So still and quiet the weld        "
 .byt "How brightly shines the silence    "
 .byt "how sweet an ambience beheld.      "
 .byt "                                   "
 .byt "But is all as it seems?            "


COMBINE Stick WITH Fish Net
You fashion a Fly net!
HOLD Fly Net
You now hold the Fly Net, to use it
perform Action whilst standing.

COMBINE Pipe WITH Stick
The Pipe and stick cannot be
combined.

ENTER Market
You enter Sassubree Market.
There are Stalls at the Green, Red
and Blue areas.
At near dusk the market is still a
busy place.

ENTER Green Market
You see Balthazar's incense stall
and Sophia's Grocery stall

ENTER Incense
"Welcome to my stall, please ask
if something interests you."

LOOK
You see some josticks, a small case
and pendants hanging from a velvit
drape.

EXAMINE Pendants
One pendant catches your eye as it
contains a large crystal that seems
to continuelly swirl as if alive.

REQUEST Pendant
"Aha so this pendant interests you
does it? it is very nice is it not?
"To you my dear friend i should like
to offer it to you at 30 Grotes."

OFFER 20 Grotes FOR Pendant
"You drive a hard bargain but on
this occasion i will sell it to you
for that price."
You exchange 20 Grotes for Pendant.

EXIT Market
You walk away and return to the Town
square.

********* New Mini Script Language for Cut Scenes in Wurlde **************

The new miniscript language is designed to optimise memory and speed of
graphical overlay effects.
WMSL will reside in overlay together with resource graphics.

At the language level WMSL is composed of a set of mnemonic instructions
that are followed by a number of parameters.
At the graphics level WMSL provides a means to take flat graphics and ?

A Graphic stack should be created by the developer that consists of
graphic bitmaps and masks.
Work areas in WMSL can either be defined (memory addresses) by the developer
(l,h)or auto-assigned(0,0) based on the width and height of the graphic.
The memory address that Auto assignment should begin from should be set by
the developer (SETALLOC) if auto assignment is to be used.
(The address range(4000-FDFF) is such that it permits a high address of 0
as a trigger to auto-allocate)

At the beginning of running an WMSL script the engine will scan the
Script and build a list of unique widths found.
Multiplication tables will then be generated for each width.
This is the first step in accelerating the speed of operation.

As each line of code is interpreted, a list of memory addresses for
each new line will be compiled. Because of this a limit of up to 64
lines of code can exist in a single script.
This will accelerated any branches or jumps in the code and also make
it easier to calculate where branches and jumps refer to.

XOffset or YOffset may refer to a value or a variable. The values range
0-127 withthe top bit indicating either Variable(1) or Value(0)

Overview of commands

Cmd   Description		Parameters

000 *SETALL       Set All Buffer Params     BufferID+VFlag,Width,Height,Low Address,High Address
001 *SETV0        Set Variable 0(0-31)      Value
033 *SETALLOC     Set Allocated Memory      Low Address,High Address
034 *TRANSFERV0   Transfer Variable  	    VariableID
066 *INCADDRESS   Add to Buffer Address     BufferID+VFlag,Value to add
067 *INCV0        Increment Variable        Value to increment by
099 *DECADDRESS   Subtract Buffer Address   BufferID+VFlag,Value to subtract
100 *DECV0        Decrement Variable        Value to decrement by
132 *BRANCHBACK   Branch back on condition  Condition,Param1,Param2,Row
133 *BRANCHFORTH  Branch forth on condition Condition,Param1,Param2,Row
134 *MOVE         Move Buffer Data	    DestinationID+VFlag,XOffset,YOffset,SourceID+VFlag
135 *SCROLLLEFT6  Byte(Text) Scroll Left    BufferID+VFlag,ScrollOn Byte
136 *SCROLLRIGHT6 Byte(Text) Scroll Right   BufferID+VFlag,ScrollOn Byte
137 *SCROLLUP1    Byte Scroll Up	    BufferID+VFlag,ScrollOn Byte
138 *SCROLLDOWN1  Byte Scroll Down   	    BufferID+VFlag,ScrollOn Byte
139 *SCROLLLEFT1  Bit Scroll Left	    BufferID+VFlag,ScrollOn Bit
140 *SCROLLRIGHT1 Bit Scroll Right	    BufferID+VFlag,ScrollOn Bit
141 *MASKMOVE     Move with Mask            DestinationID+VFlag,SourceID+VFlag,MaskID+VFlag
142 *DELAY        Delay the sequence	    Seconds,Milliseconds
143 *FILL         Fill the Buffer	    BufferID+VFlag,Value
144 *BIT          Set Bits in Buffer        BufferID+VFlag,Bit Value,Bit Mask
145 *RANDOMV0     Random Variable	    Scope(0-Scope)
177 *END	        End of Script
178 *SUBROUTINE   Set Subroutine	    Subroutine ID
179 *CALL         Call Subroutine           Subroutine ID
________________________________
|   _____________________      |
|   |                   |      |
|   | Visible           |      |
|   |      Area         |      |
|   |                   |      |
|   ---------------------      |
| Graphic Buffer               |
--------------------------------
Each Graphic buffer also contains a visible area which may be optionally
used in all instruction Buffer fields(VFlag).

A Buffer consists of an area of memory that is ordered by location, width and height.
Each buffer may also have a visible area.

********* Commands in Detail ***************

000 *SETALL       Set All Buffer Params     BufferID+VFlag,Width,Height,Low Address,High Address
Description: Sets all visible Buffer parameters.
 Parameters: BufferID (1-31) +VFlag(0 or 32)
	   Width (1-127)
	   Height (1-127)
	   Low Address (0-255)
	   High Address (0-255)
      Notes: If the VFlag is used (+32) then the Visible area parameters
      	   in the Buffer are set. Address fields become offset fields.

001 *SETV0        Set Variable 0(0-31)      Value
Description: Assigns a value to a variable
 Parameters: Value(0-255)
      Notes: The Variable number is included in the statement which may
	   Range SETV0 to SETV31. Because these are labels they may
	   be named differently.

033 *SETALLOC     Set Allocated Memory      Low Address,High Address
Description: Set Memory location that auto allocated memory starts from
 Parameters: Low Address (0-255)
	   High Address (0-255)
      Notes:

034 *TRANSFERV0   Transfer Variable  	    VariableID
Description: Transfers one variable value to another
 Parameters: Destination VariableID(1-32)
      Notes: The Source Variable ID is included in the statement which may
	   Range SETV0 to SETV31. Because these are labels they may
	   be named differently.

066 *INCADDRESS   Add to Buffer Address     BufferID+VFlag,Value to add
Description: Increment the Buffer Address by the value supplied
 Parameters: BufferID (1-31) +VFlag(32)
	   Value(0-127) or Variable(0-31)
      Notes: If the VFlag is used (+32) then the value is added to the
      	   Visible Offset within the Buffer.

067 *INCV0        Increment Variable        Value to increment by
Description: Increment Variable Value by the value supplied
 Parameters: Value (0-127) or Variable(0-31)
      Notes:

099 *DECADDRESS   Subtract Buffer Address   BufferID+VFlag,Value to subtract
Description: Decrement the Buffer Address by the Value supplied
 Parameters: BufferID (1-31) +VFlag(32)
	   Value (0-127) or Variable(0-31)
      Notes: If the VFlag is used (+32) then the value is subtracted from the
	   Visible Offset within the Buffer.

100 *DECV0        Decrement Variable        Value to decrement by
Description: Decrement Variable Value by the value supplied
 Parameters: Value (0-127) or Variable(0-31)
      Notes:

132 *BRANCHBACK   Branch back on condition  Condition,Param1,Param2,Row
Description: Branch back a number of rows on met condition
 Parameters: Condition (0-11)
		0  Branch on Param1(Variable) equal to Param2(Variable)
		1  Branch on Param1(Variable) Less than Param2(Variable)
		2  Branch on Param1(Variable) More than Param2(Variable)
		3  Branch on Param1(Variable) Not Equal to Param2(Variable)
		4  Branch on Param1(Variable) Less or Equal to Param2(Variable)
		5  Branch on Param1(Variable) More or Equal to Param2(Variable)
		6  Branch on Param1(Variable) equal to Param2(Value)
		7  Branch on Param1(Variable) Less than Param2(Value)
		8  Branch on Param1(Variable) More than Param2(Value)
		9  Branch on Param1(Variable) Not Equal to Param2(Value)
		10 Branch on Param1(Variable) Less or Equal to Param2(Value)
		11 Branch on Param1(Variable) More or Equal to Param2(Value)
	   Param1 Variable (0-31) or Value (0-127)
	   Param2 Variable (0-31) or Value (0-127)
	   Number of rows to jump back (1-127)
      Notes:
133 *BRANCHFORTH  Branch forth on condition Condition,Param1,Param2,Row
Description: Branch forward a number of rows on met condition
 Parameters: Condition (0-11)
		0  Branch on Param1(Variable) equal to Param2(Variable)
		1  Branch on Param1(Variable) Less than Param2(Variable)
		2  Branch on Param1(Variable) More than Param2(Variable)
		3  Branch on Param1(Variable) Not Equal to Param2(Variable)
		4  Branch on Param1(Variable) Less or Equal to Param2(Variable)
		5  Branch on Param1(Variable) More or Equal to Param2(Variable)
		6  Branch on Param1(Variable) equal to Param2(Value)
		7  Branch on Param1(Variable) Less than Param2(Value)
		8  Branch on Param1(Variable) More than Param2(Value)
		9  Branch on Param1(Variable) Not Equal to Param2(Value)
		10 Branch on Param1(Variable) Less or Equal to Param2(Value)
		11 Branch on Param1(Variable) More or Equal to Param2(Value)
	   Param1 Variable (0-31) or Value (0-127)
	   Param2 Variable (0-31) or Value (0-127)
	   Number of rows to jump forward (1-127)
      Notes:
134 *MOVE         Move Buffer Data	    DestinationID+VFlag,SourceID+VFlag
Description: Moves Data from one buffer to the other with optional offsets
 Parameters: DestinationID (0-31) +VFlag(32)
	   SourceID (0-31) +VFlag(32)
      Notes: If the VFlag is used (+32) then the Visible Area of the
      	   Buffer is used in the move operation.

135 *SCROLLLEFT6  Byte(Text) Scroll Left    BufferID+VFlag,ScrollOn Byte
Description: Byte Scrolls a Buffer Left.
 Parameters: BufferID (0-31) +VFlag(32)
	   ScrollOnByte (0-255)
      Notes: Bytes fall off the left. ScrollOnByte appears on the right.
	   If the VFlag is used (+32) then only the Visible area of the buffer
	   is scrolled.

136 *SCROLLRIGHT6 Byte(Text) Scroll Right   BufferID,ScrollOn Byte
Description: Byte Scrolls a Buffer Right.
 Parameters: BufferID
	   ScrollOnByte
      Notes: Bytes fall off the Right. ScrollOnByte appears on the left.
	   If the VFlag is used (+32) then only the Visible area of the buffer
	   is scrolled.

137 *SCROLLUP1    Byte Scroll Up	    BufferID,ScrollOn Byte
Description: Scrolls a Buffer Up.
 Parameters: BufferID
	   ScrollOnByte
      Notes: Bytes fall off the Top. ScrollOnByte appears on the bottom.
	   If the VFlag is used (+32) then only the Visible area of the buffer
	   is scrolled.

138 *SCROLLDOWN1  Byte Scroll Down   	    BufferID,ScrollOn Byte
Description: Scrolls a Buffer Down
 Parameters: BufferID
	   ScrollOnByte
      Notes: Bytes fall off the Bottom. ScrollOnByte appears on the Top.
	   If the VFlag is used (+32) then only the Visible area of the buffer
	   is scrolled.

139 *SCROLLLEFT1  Bit Scroll Left	    BufferID,ScrollOn Bit
Description: Bit Scrolls a Buffer Left.
 Parameters: BufferID
	   ScrollOnBit (Bit0)
      Notes: Bits fall off the Left. ScrollOnBit appears on the Right.
	   If the VFlag is used (+32) then only the Visible area of the buffer
	   is scrolled.

140 *SCROLLRIGHT1 Bit Scroll Right	    BufferID,ScrollOn Bit
Description: Bit Scrolls a Buffer Right
 Parameters: BufferID
	   ScrollOnBit (Bit0)
      Notes: Bits fall off the Right. ScrollOnBit appears on the Left.
	   If the VFlag is used (+32) then only the Visible area of the buffer
	   is scrolled.

141 *MASKMOVE     Move with Mask            DestinationID,XOffset,YOffset,SourceID,MaskID
Description: Copies the buffer from Source to Destination using the Mask
 Parameters: DestinationID
	   SourceID
	   MaskID
      Notes: If the VFlag is used (+32) then only the Visible area of the buffers
	   are used.

142 *DELAY        Delay the sequence	    Seconds,Milliseconds
Description: Delays the sequence by a number of milliseconds
 Parameters: Seconds Value (0-127) or Variable (0-31)
	   Milliseconds Value (0-99) or Variable (0-31)
      Notes: The code is usually executed every 100th of a second depending
	   on the speed of operation.
	   The delay in calling the engine may be delayed using Seconds
	   then milliseconds provided.

143 *FILL         Fill the Buffer	    BufferID,Value
Description: Fills a buffer with the specific value.
 Parameters: BufferID
	   Value (0-255)
      Notes: If the VFlag is used (+32) then only the Visible area of the buffer
	   is Filled.


144 *BIT          Set Bits in Buffer        BufferID,Bit Value,Bit Mask
Description:
 Parameters:
      Notes: If the VFlag is used (+32) then only the Visible area of the buffer
	   is scrolled.

145 *RANDOMV0     Random Variable	    Scope(0-Scope)
Description:
 Parameters:
      Notes:
177 *END	        End of Script
Description:
 Parameters:
      Notes:

;Scroll the boat graphic from right to left behind a river bank mask.
;Set up Boat work areas
; Set ID0 to Boat bitmap
*SETALL BoatBitmap_ID,<Boat_Bitmap,>Boat_Bitmap,11,16
; Set ID1 to Boat_bitmap work area(We scroll there)
*SETALL BoatBMWork_ID,0,0,12,16	;0,0 flags auto buffer allocation
; Fill the area with 64
*FILL BoatBMWork_ID,64
; Copy the bitmap to this buffer offsetting it to reserve leftmost column
*MOVE BoatBitmap_ID,BoatBMWork_ID,1,0

;Set up Riverbank work area
; Set up the full screen width River bank mask
*SETALL RiverBankMask_ID,<Riverbank_Mask,>Riverbank_Mask,40,20

;Set Screen Location
; Set screen location
*SETALL Screen_ID,<$A000+40*100,>$A000+40*100,40,20

;Set Variable0 to X position of Boat
*SETV0 30

;Set Bit counter
*SETV1 6

; Perform Copy from BoatBMWork_ID bitmap to Screen_ID masked with
; RiverbankMask_ID Mask offset by Variable0(x) and 5(y)
*MASKMOVE IDBankMask,IDBoatBitmap,Variable0,5

;Now smooth scroll boat work area left
*SCROLLLEFT1 BoatBitmap_ID,0

;Progress the bit
*DECV1 1

;Test counter
*BRANCHBACK Morethan,Variable1,0,3

;Move Boat one byte left
*DECV0 1

;Test Counter
*BRANCHON Not,Variable0,10,6

*END

Total Script == 59 Bytes
Specifying mask will allign the bitmap to the top left of the mask.
XOffset and YOffset provide a means of offsetting the bitmap within
the mask area.
These parameters are also provided for the MOVE command to allow
the bitmap to be offset within the work area and permit columns or rows
to be reserved for scroll-on areas.


************************ Map of Map *****************************

6 Maps in total..
1 Map01 Sassubree
2 Map02 Windmill games
3 Map00 Wizards House
4 Map03 Samson Isle
5 Map04 Mountain approach

The hero starts on map 02 and by river boat takes the hero to Map01 and
Sassubree Harbour.
From Sassubree harbour he may travel by Sea boat to Map03 and Samson Isle.
From Sassubree harbour he may travel by Dragon to Map00 and the Wizards house.
From Sassubree harbour he may travel by Horseback to Map04 and the mountain.

Plot..
The game consists of a number of quests that need to be completed before the final
quest begins.
The game also consists of some sub games.
Quest1 : Raise capital enough to buy passage to Samson Isle
The butterflies, Bok Fish and Fruit found in Ritemoor can be sold for a profit at
the market. This is meant as the means to get money at the start of a new game.
Through talking to characters in the taverns and many houses in Sassubree, it will
be found that buying fish early in the morning from the fisherman can be sold to
market for a profit.
Quest2 : Riding the Storm
Once enough money is collected, Lucien can seek passage to Samson isle from Keggs.
Keggs has a small fishing boat on the jetty and early in the morning both venture
out towards Samson isle. Unfortunately the boat hits a massive swell which knocks
Keggs overboard and Lucien is left to attempt to guide the boat through the storm
and to Samson isle (Subquest1).
The more energy he uses, the more his health will diminish.
Quest3 :
Once Lucien reaches Samson isle, he will be washed up on the beach, tired and low on health.
However this position will be saved to Disc.
Nearby are resources where he can get food. Otherwise he may have posessions
left to replenish his health.
venturing forth into the undergrowth he will discover the monastary, entering it
on the second screen.
The rooms within are




Through rumours the hero will learn the bigger challenge ahead of him. He must
first travel to Samson Isle and collect the fake sword from the abbey their. He
must also collect some fungus only grown in the woods.

Samson Isle is also frequented by a Dragon with a fancy for Fungus. The hero can
use the Fungus to gain flight from the dragon and travel to Map00 where he will
find the last Wizard. The wizard will then place him on one or more quests ending
with the ultimate quest of replacing the sword in the mountain chamber with his
own.

To assist the hero, the dragon may be used to get to each map.

Each quest will earn the hero money, which he may use to buy magical artifacts,
weapons, potions and lodging (to save the game), etc.

On returning to Sassubree new rumours will be spreading about a horse that runs
faster than the wind. It will also be rumoured the horse seems to always instinctively
take the rider to were he is destined to travel seemingly without being guided.

Some joke is made about a drunk being returned to the pub after leaving it late one
night.

The Hero must earn enough money to purchase this horse.
The price of the horse rises as the hero accumulates more money. The hero must
sacrifice items he has in order to complete the deal.

The Horse will take the Hero to the foothills of the Mountain where the final quest
begins.

Riding Horseback, travelling by sea boat and Dragon flight are subgames the hero
must play and pass unscathed in order to progress to the next Map.

Riding Horseback consists of the Hero riding on the back of a horse and like Wrath of
a Demon, the hero must jump over rocks, duck under branches, pick up health potions
and swipe at attacking creatures with a parralax landscape scrolling behind and
infront of horse and hero.

The Sea boat will enter a storm and similar to the Viking ship in Myth, the hero
must keep the boat afloat by pulling hard at the ropes, keeping control of the helm
and steering away from the tretcherous rocks.

The Dragon may be guided up and down. The hero must avoid attacking giant wasps,
Terradactils, etc. and may use the dragons fire breath to kill the adversaries.


MAP02 >> MAP01 >> MAP03 >> MAP00 >> MAP04

Title is displayed when map is visited. However if the hero moves infront
of a detected location the name will be displayed instantly in this window.
However would the name of each collision be better displayed in gamecode?
;Rather than holding everything in one floor table, lets be logical
;and store to two tables.
;Lets also use codes 32-63 and inverse instead of odd codes.
;$A0-$BF will indicate a floor and ceiling limit.
;$20-$3F will indicate collision.
;In this way both collision and floor level can be specified in single location.

MAP02 (7 SSCs)
scn50-moat2-scn14-scn23-bogmire-scn51-scn71
MAP01 (7 SSCs)
scn04-scn12-scn32-scn22-harbour1-harbour2-jettyend2
MAP03 (? SSCs)
wood-scn44-priory2-?
MAP00 (8 SSCs)
scn03-boulders2-bridge2-hallow1-well-wizhouse-fountain-scn64
MAP04 (8 SSCs)
scn02-scn53-scn21-?-boulders-skybridge-brokensky-atop

Ceiling marker bytes will be code $A0 - Thats 128(Ceiling)+0(No collision)
Floor marker bytes will be code $A0 - That is second $A0 for column
Collision bytes will be codes $20-$3F or $A0-$BF if occupying same pos as floor/ceiling
Default Collision is..
;00 20 A0 No Collision
;01 21 A1 Left Exit
;02 22 A2 Right Exit
;03 23 A3 Wall
;04 24 A4 Death
;05 25 A5-AF Background Collision
;Ground types (For footsteps)


SCN50 - Boat boarding is A5, creek code is A6
MOAT2 - creek code is A6
SCN14 - mill door is A5
SCN23 - Windmill door is A5, Church door is A6
SCN71 - Tree is A5

SCN04 - Entrance is A5
SCN12 - Ground window A5, Door A6
SCN32 - Sign A5, Gate A6, Garden A7, Windows A8, Inn A9
SCN22 - Market A5, Front Exit A6, Arch A7
harbour1 - Gully bridge A5, Steps A6
harbour2 - left fish bucket A5, right fish exit A6
jettyend2 - moored boat A5

Text window displays this message..
"Welcome to the Kissing Widow."
"4 characters populate the bar."
"Please select who you wish to"
"speak to."

Inlay displays a list of the 4 characters.
Each entry displays the characters face, health, mana, Name, Title, up to 10
items (which may include hidden items (?)), "I" flag (which reflects that character
wants to talk and may have new information), Gender flag and Grotes.

On selecting the character, the screen scrolls selected character to top, and the
text window then displays..

"You are looking at NYLOT."
"What do you wish to talk about?"

Under the Character is displayed a list of subjects based on the character.

"Ask about rumours"
"Query Items NYLOT holds"
"Sell item owned"
"Ask NYLOT to hold item for you"

On selecting Ask about rumours, the text window will display the text..

"Well, i have heard rumours of"
"a black stone that deters Witches."


"Black Stone" is added to the inventory of catch phrases, and a low bell sounds
to reflect the importance.
The cursor then returns to the list of subjects.

On selecting "Query.." the list of questions is replaced with a list of the characters
items he or she posesses.
Some items may just be a question mark to indicate that NYLOT is unwilling to reveal
the item.
Each item is shown as a picture, its health, its price (if willing to sell) and mana
properties and a description about its known properties.

Selecting an item like the "green potion" will attempt to buy that item.




For Inns and Market perhaps an alternative would be to provide a separate
inlay or even overlay existing inlay with market menu and text then use
bottom window for text input?

Enter Inn..

*****************+*****************
You enter the Pirates Arms.
The Inn is heavy with the musty
scent of old ale and old men. A
Rather butch female stands at the
bar. The bar is filled with a motly
group of misfits, most of them
drunk!			    /

  ******** Pirates Arms *********
What do you want to do?
>Speak to someone     <
 Sit quietly in corner
 Attack someone
 Exit Inn
 ******* Sassubree Market *******
What do you want to do?
>Visit Stall
 Set up shop
 Exit Market

Who do you wish to speak to?
>Speak to Drunk       <
 Speak to visitor
 Speak to Innkeeper
 Speak to Barmaid
 Speak to Pirates Mate
 Speak to Someone else..


What do you want to say?
>Chat to Drunk        <
 Compliment Drunk
 Insult Drunk

The Drunk ignores you.

What do you want to say?
 Chat to Drunk
>Compliment Drunk     <
 Insult Drunk

The Drunk turns and promptly
falls to the floor unconcious.


QuestionText
 .byt "What do you want to do?"
 .byt "Who do you wish to speak to?"
 .byt "What do you want to say?"


Ask about Rumours
Ask Question
Ask about items
Lend guest item
Recover item from guest
Compliment guest
Buy guest Ale


Find Pipe in SSC-OM2S2
Buy Tobacco in Sassubree Market
Buy Fire Sticks in Sassubree Market
Use Pipe with tobacco and FireSticks (Would be cool to have it animated!)
Drink Beer but don't feel effects

How do we combine?
We USE multiple items.
Will also work thus..
Use Fish Net with Stick and Cat Gut
to make Butterfly Net

The combination is taken, not the sequence of combining items, so
the combination of three items can be matched to a result.

Need controls to
Select multiple
Examine Item

CONTROL MENU
Combine items
Examine Item

L
R
U
D
A Action key
I Inventory key
M Manage Key


I   Catch Item to Inventory
I+L Move item selector Left
I+R Move item selector Right
I+U Pickup Item
I+D Drop Selected Item
I+A Use Item

A   Interact background/Catch and eat item/Use item
L   Move Left
R   Move Right
U   Enter Building
D
U+L Standing Jump Left (or running jump)
U+R Standing Jump Right (or running jump)
A+L Combat
A+R Combat
A+U Combat
A+D Combat

Rather than "Seek Transport" the hero should chat to fisherman who should
at some point mention his boat by the quayside where "Boat" becomes a
keyword. The hero should then immediately ask about "Samson Isle" (another
keyword he will need). This will then trigger the fisherman to either ask
if the hero seeks transport (Yes/No) or that the fisherman would not go
there for any money.

"Man, the swells that brew in those deep, deep waters near Samson must be
strived by a larger vessel than mine."

"I have never travelled that far.. it will cost you some for my time and
potentially my risk"

Keywords
Keywords are important words picked up during conversation that may
be enquired about. Enquiring on a keyword may bring forth further
keywords and may eventually lead to useful information or even a
quest or passage.

Keywords are embedded in the character conversation text as codes
from 128 to 191.
The codes refer to a specific keyword (held in keyword text) which
replaces the code before being inserted in the text with a bell.
New keywords(0-63) are added to a keywordsLearnt list indexed by
KeywordsLearntIndex which starts at 255 (BMI no keywords learnt).
Once each keyword has been used in a conversation and they have
triggered a further response they are deemed redundant and are
marked complete by setting the top bit in the KeywordsLearnt list.

LocationWelcomeTextLo
 .byt <WelcomeText_KissingWidowTavern
 .byt <WelcomeText_PiratesArmsInn
 .byt <WelcomeText_MarketGreenZone
 .byt <WelcomeText_MarketCyanZone
 .byt <WelcomeText_MarketMagentaZone
 .byt <WelcomeText_MarketYellowZone
 .byt <WelcomeText_MarketBlueZone
 .byt <WelcomeText_Bakery
 .byt <WelcomeText_MillHouse
 .byt <WelcomeText_Windmill
 .byt <WelcomeText_WizardsHouse
 .byt <WelcomeText_BanitWitchesCastle
 .byt <WelcomeText_TurnChurch
LocationWelcomeTextHi
 .byt >WelcomeText_KissingWidowTavern
 .byt >WelcomeText_PiratesArmsInn
 .byt >WelcomeText_MarketGreenZone
 .byt >WelcomeText_MarketCyanZone
 .byt >WelcomeText_MarketMagentaZone
 .byt >WelcomeText_MarketYellowZone
 .byt >WelcomeText_MarketBlueZone
 .byt >WelcomeText_Bakery
 .byt >WelcomeText_MillHouse
 .byt >WelcomeText_Windmill
 .byt >WelcomeText_WizardsHouse
 .byt >WelcomeText_BanitWitchesCastle
 .byt >WelcomeText_TurnChurch

;Character 13,32,65-90,97-122
WelcomeText_KissingWidowTavern
;       ***********************************
 .byt "You enter the Kissing Widow Tavern.",13
 .byt "Musty aromas of rotten fish and",13
 .byt "tobacco hit your throat.",13
 .byt "Select a Character you want to",13
 .byt "converse with..",0
WelcomeText_PiratesArmsInn
 .byt "Welcome to the Pirates Arms!",13
 .byt "The large room has rows of benches",13
 .byt "ending with a bar at the far end.",13
 .byt "Select the Character you want to",13
 .byt "talk to..",0
WelcomeText_MarketGreenZone
 .byt "There are a few Food Stalls here.",13
 .byt "Selling Bread, Fish, Meat, Tobacco,",13
 .byt "Milk, Eggs and Poultry.",13
 .byt "Select the stall holder you wish to",13
 .byt "converse with..",0
WelcomeText_MarketCyanZone
 .byt "Here stand many stalls selling many",13
 .byt "wares ranging from Weapons to Pots,",13
 .byt "Herbs to Cloaks and Artifacts to",13
 .byt "Strange Potions.",13
 .byt "Select the stall holder you wish to",13
 .byt "converse with..",0
WelcomeText_MarketMagentaZone
 .byt "Chairs, Benches, Grandfather clocks",13
 .byt "and wood of all different sizes are",13
 .byt "stacked as high as the eye can see.",13
 .byt "These stalls are a hive of activity",13
 .byt "today. Select which stallholder to",13
 .byt "Visit..",0
WelcomeText_MarketYellowZone
 .byt "Grain sacks are stacked high,Stalls",13
 .byt "selling every variety of bread,",13
 .byt "Pulses, Rice, Potatoes and strange",13
 .byt "Pink root vegetables can be seen.",13
 .byt "Select a stallholder to visit..",0
WelcomeText_MarketBlueZone
 .byt "Alcoholic and pure Juices are sold",13
 .byt "here every day. From Apple to Meat",13
 .byt "and from Goat urine to Dragons",13
 .byt "Blood, or so the label says!",13
 .byt "Select the stall holder you wish to",13
 .byt "converse with..",0
WelcomeText_Bakery
 .byt "The best place to go for reduced",13
 .byt "Prices, cheaper than Sassubree",13
 .byt "Market and much fresher.",13
 .byt "Select the Character you wish to",13
 .byt "talk to..",0
WelcomeText_MillHouse
 .byt "The Mill house holds grain from",13
 .byt "Last years crop. Apples, onions",13
 .byt "and other strange fruits and",13
 .byt "vegatables hang from the high",13
 .byt "Ceiling.",13
 .byt "Select the Character you wish to",13
 .byt "talk to..",0
WelcomeText_Windmill
 .byt "The mill is like the inside of",13
 .byt "some enormous wooden clock.",13
 .byt "Constantly turning, grinding,",13
 .byt "processing the grain to flour.",13
 .byt "Select the Character you wish to",13
 .byt "talk to..",0
WelcomeText_WizardsHouse
 .byt "All is quiet, all is calm. As if",13
 .byt "the franetic outside world was",13
 .byt "a lifetime away. Strange charms",13
 .byt "and glowing orbs hang from above.",13
 .byt "Select the Character you wish to",13
 .byt "talk to..",0
WelcomeText_BanitWitchesCastle
 .byt "You shudder as Lithe figures peer",13
 .byt "at you through glib eyes behind",13
 .byt "half closed doors. Strange sounds",13
 .byt "enter your mind and scream on exit.",13
 .byt "Select the Character you wish to",13
 .byt "talk to..",0
WelcomeText_TurnChurch
 .byt "Turn church seems out of place in",13
 .byt "this Wurlde, Such familiar the",13
 .byt "architecture with tall arches and",13
 .byt "Fonts and Crosses, very strange.",13
 .byt "Select the Character you wish to",13
 .byt "talk to..",0

http://www.defence-force.org/ftp/forum/twilighte/wurlde/demos/caloricwurlde.zip

The birdcage could be a dual purpose item.
1) If dropped in a dark place, could distract or divert the enemy
2) If carried in the mines, is an early warning device for detecting gas

>Rumours? to Barton

The text is passed through source thus..

"The wonder of",128,"was within her heart"

128 is keyword for Merideth which needs to exist before determining
line lengths..

1) Transfer source data to buffer inserting embedded keywords

This then gives us..

"The wonder of MERIDETH was within her heart"

Now looking at example window width of 16..

 012345679012345
"The wonder of MERIDETH was within her heart"

We must scan for each space looking for when it sits beyond the window width

"The_" ok
"The wonder_" ok
"The wonder of_" ok
"The wonder of MERIDETH_" here

then set a carriage return flag by replacing the space with a 13.
Next we start from the next line and scan across again..

 012345679012345
"The wonder of",13
"MERIDETH was",13
"within her",13
"heart"


2) Insert carriage returns

Now we are ready to display text to window.


;OptionSet
; 0) Character interaction options or Hero Options
; 1) Learnt Keyword list
; 2) Price haggling options
; 3) Yes/No/Cancel


Optionset0 displayed
textwindow displays "Selection option.."
"Rumours?" to Keesha
"I heard there has been seen a pit dragon over samson isle"
>"Samson isle" added to learnt keywords
>"Pit Dragon" added to learnt keywords
Returns to optionset 0
>"Ask about Subject"

"Ask about Subject" to Ribald
Optionset1 displayed
text window displays "Select Keyword.." (LR resets to optionset0 and neighbour)
"Pit Dragon" to keesha
text window displays "Pit Dragons used to be reverred beasts of the wild but have"
text window displays "now been used by Birist in the Dwarven mines"
>"Birist" added to learnt keywords
>"Dwarven mines" added to learnt keywords
Optionset1 displayed

ESC

Optionset0 displayed
"Seek Lodging" to Barton
text window displays "Lodging costs 100 Grotes. You do not have enough."

After money got..
"Seek Lodging" to Barton
text window displays "After paying for lodging, a hearty meal, a slumbered sleep and a hearty breakfast
text window displays "you feel revived and ready for the next day"

Refresh occupants
Optionset0 displayed

"Combine items" with Hero
text window displays "Select first item.."
Option list remains
flashing cursor in items displayed.
Navigate to select first item then press Action or Esc to abort and return optionlist0
cursor for Item(Briar pipe) selected turns blue and remains

text window displays "Select second item.."
Option list remains
flashing cursor in items displayed.
Navigate to select second item then press Action or Esc to abort back to first item
cursor for item(Tobacco) selected turns green and remains

text window displays "Select third item.."
Option list remains
flashing cursor in items displayed.
Navigate to select third item(Fire stick) then press Action or Esc to abort back to first item
text window displays "You cannot combine these items."
Returns to selecting third item

or..

text window displays "You created a smoking pipe"
Briar pipe, tobbacco and firestick vanish and replaced with smoking pipe.
Item cursors erased
optionSet0 displayed

"Examine items" to hero or character
text window displays "Select item.."
flashing cursor in items displayed.
Each item shows description in Description window
Esc to exit
OptionSet0 displayed
Reset to character description?

"Buy item" to character
text window displays "Select item you wish to buy.."
flashing cursor in items displayed.
Each item shows description in Description window
Press Action to buy or Esc to exit to optionset0
"You do not have enough Grotes to buy this item."

or when item shown..

text window displays "You exchange grotes for item"
Item vanishes from Ribald items and appears in pocket

or when item shown as "?"..
text window displays "Ribald is unwilling to sell you this item."

in all cases OptionSet0 is displayed.

"Sell item" to character
text window displays "Select item you wish to sell.."
flashing cursor in hero pockets.
Each item shows description in hero window.
Press Action to Sell or Esc to exit to optionset0
text window displays "I'll buy that for 15 Grotes, says Ribald"

OptionSet2 displayed..
"Accept 15 Grotes"
"Haggle Price"
"Compliment"
"Buy Ale"

??????

"Compliment" to Ribald
"


Reformatting text
This process involves formatting text so that no word is broken over a line
width.

The first way is to scan from position 1 onwards recording and overwriting the
position of a space in the sentence.
Once the line width is reached, the last position of a space is restored, the
space is replaced with a carriage return character and the process begins again
from the next position.

To illustrate this..

The line..
"Jumping Jack flash wrote this."
 |Line width ---->|

The scan then does this..
 >>>>>>>>>>>>>>>>>
"Jumping Jack flash wrote this."

And restores to space, continueing...

"Jumping Jack/"
 >>>>>>>>>>>>>>>>>|
"flash wrote this."

However in this example the scan involves 34 duty cycles to complete even
though the sentence is just 30 characters long.

The more efficient way is to scan back from the line width like this..
	    <<<<|
"Jumping Jack flash wrote this."

Replace with CR on the first occurrence of a space and continue..

"Jumping Jack/"
                  |
"flash wrote this."

In this way we only actually scan 5 duty cycles!


Currently we have three routines..
Convert to pure text (Expand any embedded codes to text)
Reformat to Formatted (Insert carriage returns at or before line widths)
Render text (Display text to screen window)

Convert to Pure text is best kept separate but the latter two could be
consolidated to provide a more efficient engine (Faster, smaller)
Also include clear to end of line and optional clear to end of window.

It is of little point to include a word wrap routine if the text is known.
Even if embedded text or Gold is to be represented in a row, it should be
easy enough to calculate the text length by hand and save many bytes of code.


Currently the plan is to hold all conversations in main memory, thereby allowing
conversing to exist at any point of the game and also allowing characters to
freely move around the map.

However it would be easier to keep characters in specific locations but if the need
arises that they be absent.

This would greatly reduce the memory overhead. So onto the next problem of how SSC
should hold this data and how Game memory should have access to this data.

That each character is confined to a specific location means that a particular SSC
will hold a specific number of characters in itself including all conversation ever
made by the character. This may mean the conversations can be more diverse and not
so limited by memory.

For example in Sassubree and the SSC for the Market Square, their is little
happening on screen (visual effects) but potentially many stallholder characters
with many tales to tell within. A new flag in Playerfile for each character will
set whether they are present or not. The SSC will decide through conditions the
characters presence.

SSC will also contain the face gfx of the character, a description of the character,
the characters name and a number of rumours that may be dependant on heros posessions.

Text from other SSC may refer to characters in another SSC but the name will
have to be given rather than embedded. However this may give rise to a more diverse
naming of the character. For example "Old Tom.." may refer to "Tom Bombadill".

However the Characters Gold, his posessions, gender, allegiance, health, mana and
drunk level will still be held in the player file so the number of characters within
the whole game still cannot exceed 32.

The SSC needs a new Character header describing the possible characters within the
SSC..

MAIN HEADER
CharacterCount		.dsb 1
CharacterHeaderVector	.dsb 2	;Refers to first character header
InteractionsCount		.dsb 1
InteractionsVector		.dsb 2

;Message text will always appear in bottom text window so 35 characters per line.
;RumourMongeringLevel(1,2,4,8) or 128 for Interaction,required stuff,"]",Message Text,"]"
;For required stuff..
;0-31 	Only if the hero posesses the specified object will the character deliver this message
;128-143	Only the Character of specified Group will deliver this message
;144-175	Only specified Character will deliver this message
;176-207	Only if the hero posesses the specified keyword will the character deliver this message
;208-223	Only when the character is at the specified Health level will he deliver this message
;224-239  Only at the specified level of drunkedness(0-15) will the character deliver this message
;240-255	Only if the hero posesses the specified Grotes(100-1600) will the character deliver this message

;The response may then contain embedded codes that correspond to those in the main memory EmbeddedText.
;These may either be ways to optimise text size or for keyword specifying.
Interaction0	;General Rumour for any Mongering level (Only Facts!)
 .byt 15
 .byt "]"
 .byt "Sorry, i don't know]"
Interaction1
 .byt 1		;General Rumour for Mongering level 1 (
 .byt "]"


CHARACTER HEADER (Up to 6 Characters x 10 Bytes)
CharacterID		.dsb 1	;ID(0-31) of Character (x8 to index Playerfile CharacterBlocks)
Name Text Vector		.dsb 2	;"]" terminated name vector in SSC
Character Description Vector	.dsb 2	;"]" terminated Character Description in SSC
Face Graphic Vector		.dsb 2	;3x15 Face Graphic Vector


CHARACTER INTERACTION
List of other characters required to be present(32-63), The Keyword
being asked about (64-95), items that must be posessed by hero(96-127), Grotes that must be posessed?,
level of toxicity(Drunk) required and consequence of response?
terminated with 0.
The response Text terminated with Top bit of last character set (128).

For example..
"Ribald" is the Ships mate on the "Pirates Curse" sailing ship moored just outside
Sassubree. He frequents the Kissing Widow Tavern and is only willing to provide
passage to Samson Isle if the hero holds the Solice Key, if Kobla (Pirate Captain)
is present and is given 100 Grotes.

7+32,7+64,31+96,0,"I can take you there but it will cost you 100 Gold"+128

How do we progress to completing the deal?

Give character 100 Gold?

* There needs to be some rule for redundant keywords otherwise the list will easily exceed 12!



Each character may be..
1)asked a question on a keyword
	This depends on the keyword and may also depend on items
	the hero posesses and other characters present.
2)asked for rumours
	The Rumour Monger level will be read from PF and the
	appropriate Response given.
3)asked for lodging (Innkeeper only)
	If the PF says Innkeeper is not a friend or the hero
	doesn't have enough Grotes then lodging is refused.
	Otherwise lodging will be given.
4)asked to hold something
	If the character has space he will always take item.
5)asked to release something
	This depends on Heros Allegiance?
6)asked to buy something
	Depends on characters Gold, his mood?, Health.
7)asked to sell something
	Depends on characters Gold, his mood?, Health.
8)Compliment
	This may affect the characters allegiances and ultimately
	may lead to sex, new information or a willingness to show
	previously hidden posessions.
9)Insult
	This will upset the character and may lead to a change of
	allegiance depending on his group, gender, mana and health.
10)Buy Beer
	This will have the same benefits as complimenting the
	character but to a greater degree.

Some items held by hero or creature may be hidden.
Once a creature reaches their intoxicated limit they will reveal hidden items
at a rate of one hidden item per intoxication level over their limit.

This simply means buying them ale until they reach their limit then switching
off the objects hidden property.
However doing this alone will mean the item is "permanently" revealed.

So we have a second flag to indicate if this item is normally hidden.
So when the characters toxic level returns within their limit a quick scan of
there items can hide all items that should be hidden.

Some characters will refuse to drink unless the hero drinks with them.

This is the same for the hero's items too. If the hero gets too drunk he too
will begin revealing his items.

In addition the hero will lose some control over selecting items (the key
controls will change, like up becomes down).
It could be nice to also change options as the hero gets more drunk..
"Rumours?" >> "Rumooo" >> "blah blah"
"Compliment" >> "be nice" >> "compllll"
"Buy item" >> "Buy thing" >> "blah blah"
Once the heros limit is reached, all options change to "blah blah", all keys
reversed. If the hero manages to buy again he will be thrown out or arrested
if the steward is here.

Stepping out of the pub then back in again will decrease his toxic level by 2
each time.

Every time the hero acquires new information or items through drinking, he
gains an extra point to his toxic limit (up to 14).

KOBLA
Kobla will not accept a drink unless the hero drinks with him.
Koblas limit is 14
Luciens limit is 3
Lucien (Hero) must acquire as much information from other pub goers through
drinking in order to equal Koblas limit before he is able to 'crack' him.

*************** In game Sound Effects **************
Wind sound can be accomplished through the knock on effect of rustling tree
leaves which appear to be very similar to high pitch noise.
Put together with combined 2/3 channel volume to accomplish pseudo 8 bit res.

Bird song can be accomplished through high pitch tone sequences.

Seashore waves through same method as wind except different noise pitch and
louder variation of 8 bit res volume.

Rain through same as wind with random high pitch plinks from tone & EG.

Thunder through deep noise.


Smooth scrolling

	;Fetch next screen byte
	lda screen,y
	;Rotate right so that new bit is in B7, Set B6 goes to B5 and B0 into carry
	ror
	;Use 256 number to index shift right table
	tax
	lda ShiftRight,x
	;and store back to screen
	sta screen,y	;==16 cycles
	iny

	;using conventional shift right
	lda screen,y	;4
	and #63		;2
	bcc skip1		;4/4
	ora #64
skip1	lsr		;2
	ora #64		;2
	sta screen,y	;4 == 18 cycles


	;Fetch next screen byte
	lda screen,y
	;Rotate left so that new bit is in B0, set b6 to b7 and b5(shifted out bit) to B6
	rol
	;Capture B6 because we know B7 will be set
	cmp #64+128
	;Use 256 number to index shift left table (will wipe B7, set B6 and fetch shifted value)
	tax
	lda ShiftLeft,x
	;and store back to screen
	sta screen,y

	;Using conventional scroll left
	lda screen,y
	rol
	cmp #64+128
	and #63
	ora #64
	sta screen,y



come away, o human child!
To the waters and the wild
With a faery, hand in hand,
For the world's more full of weeping
than you can understand.


On the mill screen have nats or bugs flying around in swarms, following circular paths interweaving with one
another.
They may bite, not sure yet.

0 Map00 Homeland and Wizards house  Converted
1 Map01 Sassubree and game save     Converted
2 Map02 Ritemoor and game start     Converted
3 Map03 Samson isle
4 Map04 Mount Ciro
5
6 Held by creature
7 Held by hero


	lda hi2
	bmi skip1
	lda lo1
	sec
	sbc lo2
	lda hi1
	and #127
	sbc hi2
	bcc 1<2 or bcs 1>=2 or beq 1=2
	|||
	
skip1	lda lo1
	sec
	sbc lo2
	lda hi1
	sbc hi2
	bcc 1<2 or bcs 1>=2 or beq 1=2
	|||
	
	
A utility to convert tap files (saved by hide in euphoric) into xa .s files
and copy them to ssc directory.
The utility initially provides a means to open a tap file but will then allow
this file to be renamed and will store both original and new name in a list for
quick conversion later.

Quick Sequences of Volume&Pitch

B0-3 Volume
B4-7 

Pitch == 0-255 (Hi byte set low)
Volume == 0-15
Control == 0-15 (+ Data byte in some instances)

Pitch , (Volume + Control)

Control
0 - Normal
1 - Delay (+1

Sound Effects

Each SSC is given the opportunity to set the range of sound effects appropriate
for its screen, which effects directly affect its screen (high volume) and those
that effect adjacent screens (low volume) and the allocation of effects to channels.

For example, the Wood Cabin on Samson Isle may require some bird song and rustling
of trees which are intermittent but the source exists on the screen.
The adjacent screen has the shore so waves crashing on the shore are required.
The ground surface is mixed chalk and grass so the footsteps need to reflect the
different surfaces. This could be encoded into the floor table.



Boat ride to Samson Isle
The biggest hurdle here is how to do the storm. If we adopt the Myth technique and have
the waves never seen, it would not be accurate in that the boat never tips but a realistic
storm can still be accomplished using lightning graphic, lighting changes to dark skies and
heavy rain (especially if the rain appears like Pulsoids in streaks rather than particles).
I am not sure if the boat could be tipped, such graphics would need to be simple and possibly
use a similar technique of rendering as the windmill vanes.
The floor height table could be changed dynamically though so the hero still appears to run
up and down its length. However the boat size may be small if the moored rocking boat is used.
But perhaps we also need to use the surf idea used in the modern remake of Myth. That is a
single large particle wave that washes over the boat repeatedly.
I think regardless what we do we may still need some waves.

Thinking about it, the boat ride may involve two 16K's, one leaving Sassubree and facing the
heavy storm and the other using the birds-eye view as the boat approaches the long sands of
Samson isle recreating Baron Munchausen Moon boat sequence.

For sound, departing Sassubree should use a suitable music then no music as the storm rises.
For the Moon boat sequence, perhaps a suitable tune was used in film? something emotive to
'after the storm' and no sfx.

For gameplay, the hero is provided lots of controls for navigating the boat through the storm
but this is a red herring since he needs only lower the sails and keep low.
However we might place some wraithes over the boat who try to destroy it.
For the second 16K there is no gameplay but the stars to rippling water to sand sequence.


*=$9C00

MapID		;9C00
 .byt 0
ScreenID		;9C01
 .byt 5
HeroSelectedPocket	;9C02
 .byt 0
HeroHealth	;9C03
 .byt 15	;0-15
HeroToxicLevel	;9C04
 .byt 0
HeroToxicLimit	;9C05
 .byt 4
HeroMana		;9C06
 .byt 0
HeroGrotes	;9C07,9C08,9C09
 .byt 1,0,0	;10000 == 01 00 00
Controller	;9C0A
 .byt 0
KeywordsLearntIndex	.byt 255
;123-152 Keyword	;9C0C-9C2B
KeywordsLearnt
 .dsb 32,0
;Object tables (3x80) = 240

;Character Blocks (4*32) = 128

Nylot_Tribesman	;0
 .byt cbHealth12+cbMana9
 .byt cbMale+cbLocation15+cbFriend
 .byt cbRumourSet0+cbGroup7
 .byt cbToxicLevel0+cbToxicLimit5
 .byt IQ7
 .byt 0,1,1
Drummond_InnKeeper	;1
 .byt cbHealth14+cbMana0
 .byt cbMale+cbInfo+cbLocation1+cbFriend
 .byt cbRumourSet0+cbGroup0
 .byt cbToxicLevel0+cbToxicLimit15
 .byt IQ11
 .byt 0,0,0
Lief_Wench	;2
 .byt cbHealth10+cbMana5
 .byt cbFemale+cbInfo+cbLocation1+cbFriend
 .byt cbRumourSet0+cbGroup1
 .byt cbToxicLevel0+cbToxicLimit15
 .byt IQ4
 .byt 0,9,9
Derb_Baker	;3
 .byt cbHealth15+cbMana2
 .byt cbMale+cbLocation7+cbFriend
 .byt cbRumourSet1+cbGroup2
 .byt cbToxicLevel0+cbToxicLimit8
 .byt IQ6
 .byt 0,0,0
Jumbee_Cobbler	;4
 .byt cbHealth10+cbMana0
 .byt cbMale+cbLocation4+cbFriend
 .byt cbRumourSet3+cbGroup3
 .byt cbToxicLevel0+cbToxicLimit10
 .byt IQ3
 .byt 0,0,9+9*16
Barton_InnKeeper	;5
 .byt cbHealth14+cbMana1
 .byt cbMale+cbInfo+cbLocation0+cbFriend
 .byt cbRumourSet1+cbGroup0
 .byt cbToxicLevel0+cbToxicLimit15
 .byt IQ10
 .byt 0,9,9
Keesha_Wench	;6
 .byt cbHealth12+cbMana3
 .byt cbFemale+cbLocation0+cbFriend
 .byt cbRumourSet0+cbGroup1
 .byt cbToxicLevel0+cbToxicLimit15
 .byt IQ12
 .byt 0,0,0
Kobla_Pirate	;7
 .byt cbHealth14+cbMana8
 .byt cbMale+cbLocation0+cbFriend
 .byt cbRumourSet2+cbGroup4
 .byt cbToxicLevel0+cbToxicLimit12
 .byt IQ14
 .byt 8,8,8
Ribald_Fisherman	;8
 .byt cbHealth7+cbMana0
 .byt cbMale+cbLocation0+cbFriend
 .byt cbRumourSet2+cbGroup12
 .byt cbToxicLevel5+cbToxicLimit9
 .byt IQ4
 .byt 0,0,0
Rangard_Fisherman	;9
 .byt cbHealth10+cbMana1
 .byt cbMale+cbLocation1+cbFriend
 .byt cbRumourSet1+cbGroup5
 .byt cbToxicLevel0+cbToxicLimit10
 .byt IQ12
 .byt 0,0,0
Keggs_Fisherman	;10
 .byt cbHealth7+cbMana0
 .byt cbMale+cbLocation0+cbFriend
 .byt cbRumourSet0+cbGroup5
 .byt cbToxicLevel0+cbToxicLimit8
 .byt IQ7
 .byt 0,0,0
Tygor_Peasant	;11
 .byt cbHealth3+cbMana2
 .byt cbFemale+cbLocation5+cbFriend
 .byt cbRumourSet1+cbGroup6
 .byt cbToxicLevel0+cbToxicLimit7
 .byt IQ3
 .byt 0,0,0
Retnig_Peasant	;12
 .byt cbHealth5+cbMana8
 .byt cbMale+cbLocation1+cbFriend
 .byt cbRumourSet3+cbGroup6
 .byt cbToxicLevel0+cbToxicLimit9
 .byt IQ3
 .byt 0,0,0
Yltendoq_Priest	;13
 .byt cbHealth4+cbMana13
 .byt cbMale+cbLocation12+cbFriend
 .byt cbRumourSet0+cbGroup13
 .byt cbToxicLevel0+cbToxicLimit4
 .byt IQ7
 .byt 0,0,0
Mardon_Peasant	;14
 .byt cbHealth15+cbMana10
 .byt cbMale+cbLocation1+cbFriend
 .byt cbRumourSet3+cbGroup6
 .byt cbToxicLevel0+cbToxicLimit10
 .byt IQ13
 .byt 8,8,8
Lintu_Child	;15
 .byt cbHealth13+cbMana12
 .byt cbFemale+cbLocation2+cbFriend
 .byt cbRumourSet3+cbGroup9
 .byt cbToxicLevel0+cbToxicLimit2
 .byt IQ5
 .byt 0,0,0
;Tell Temple about artifact lost beneath the waves, leave and return to map
;and he will posess it (after diving to fetch it).
Temple_Child	;16
 .byt cbHealth15+cbMana13
 .byt cbMale+cbLocation4+cbFriend
 .byt cbRumourSet3+cbGroup9
 .byt cbToxicLevel0+cbToxicLimit2
 .byt IQ6
 .byt 0,0,1
Tallard_Steward	;17
 .byt cbHealth14+cbMana0
 .byt cbMale+cbLocation1+cbFriend
 .byt cbRumourSet0+cbGroup10
 .byt cbToxicLevel0+cbToxicLimit6
 .byt IQ2
 .byt 1,9,3
Kinda_Bakerboy	;18
 .byt cbHealth12+cbMana3
 .byt cbMale+cbLocation7+cbFriend
 .byt cbRumourSet0+cbGroup9
 .byt cbToxicLevel0+cbToxicLimit8
 .byt IQ4
 .byt 0,0,0
Abbot_Clergy	;19
 .byt cbHealth8+cbMana0
 .byt cbMale+cbLocation6+cbFriend
 .byt cbRumourSet0+cbGroup13
 .byt cbToxicLevel0+cbToxicLimit5
 .byt IQ3
 .byt 0,0,0
Priest_Clergy	;20
 .byt cbHealth9+cbMana0
 .byt cbMale+cbLocation12+cbFriend
 .byt cbRumourSet0+cbGroup13
 .byt cbToxicLevel0+cbToxicLimit4
 .byt IQ5
 .byt 0,0,0
Jiro_Child	;21
 .byt cbHealth15+cbMana14		;0
 .byt cbMale+cbLocation10+cbFriend      ;1
 .byt cbRumourSet0+cbGroup9             ;2
 .byt cbToxicLevel0+cbToxicLimit15      ;3
 .byt IQ12                            	;4
 .byt 0,0,0                             ;5,6,7
OldTom_Farmer	;22
 .byt cbHealth5+cbMana0
 .byt cbMale+cbLocation8+cbFriend
 .byt cbRumourSet0+cbGroup11
 .byt cbToxicLevel8+cbToxicLimit8
 .byt IQ12
 .byt 0,0,0
Witch1_Witch	;23
 .byt cbHealth14+cbMana8
 .byt cbFemale+cbLocation8
 .byt cbRumourSet0+cbGroup14
 .byt cbToxicLevel2+cbToxicLimit15
 .byt IQ12
 .byt 0,0,0
Witch2_Witch	;24
 .byt cbHealth14+cbMana8
 .byt cbFemale+cbLocation8
 .byt cbRumourSet0+cbGroup14
 .byt cbToxicLevel2+cbToxicLimit15
 .byt IQ12
 .byt 0,0,0
Witch3_Witch	;25
 .byt cbHealth14+cbMana8
 .byt cbFemale+cbLocation8
 .byt cbRumourSet0+cbGroup14
 .byt cbToxicLevel2+cbToxicLimit15
 .byt IQ12
 .byt 0,0,0
Erth_Wizard	;26
 .byt cbHealth12+cbMana15
 .byt cbMale+cbLocation10
 .byt cbRumourSet0+cbGroup14
 .byt cbToxicLevel0+cbToxicLimit15
 .byt IQ15
 .byt 0,0,0
Munk_Clergy	;27
 .byt cbHealth15+cbMana5
 .byt cbMale+cbLocation5
 .byt cbRumourSet0+cbGroup13
 .byt cbToxicLevel2+cbToxicLimit14
 .byt IQ3
 .byt 0,0,0
Spare_Character1	;28
 .byt 0,cbUnused,0,0,0,0,0,0
Triffith_Dealer	;29
 .byt cbHealth12+cbMana0
 .byt cbMale+cbLocation2
 .byt cbRumourSet0+cbGroup8
 .byt cbToxicLevel0+cbToxicLimit10
 .byt IQ10
 .byt 0,0,0
Callum_Dealer	;30
 .byt cbHealth12+cbMana2
 .byt cbMale+cbLocation2
 .byt cbRumourSet0+cbGroup8
 .byt cbToxicLevel0+cbToxicLimit15
 .byt IQ11
 .byt 0,0,0
Spare_Character2	;31
 .byt 0,cbUnused,0,0,0,0,0,0     ;25
;9DCC
;GroupID corresponds to the group the character is associated with and is displayed
;below the Characters name in the Character Selection Form.
;Group may have a bearing regards whether they can be trusted (to hold items)
;00 InnKeeper
;01 Wench
;02 Baker
;03 Cobbler
;04 Pirate
;05 Fisherman
;06 Serf/Peasant
;07 Tribesman
;08 Dealer
;09 Child
;10 Steward
;11 Farmer
;12 Lord
;13 Clergyman
;14 Witch
;15 Wizard

;LocationID corresponds to the place the Character resides
;00 Kissing Widow Tavern, Sassubree
;	Barton, Keesahe Kobla(Nights), Ribald(Nights), Keggs(Evenings), Retnig
;01 Pirates Arms Inn, Sassubree
;	Drummond, Lief, Rangard(Evenings), Tygor, Tallard, Mardon
;02 Market, Sassubree
;	Jumbee, Lintu, Temple, Merideth(Every 5th Day), Triffith(Every 3rd Day),Callum(Every 7th Day)
;03 
;04 Log Cabin, Samson Isle
;	Mouse
;05 Monastery, Samson Isle
;	Prest
;	Munk
;06 LittlePee, Mount Ciro
;	Nylot
;07 Sassubree Bakery, Sassubree
;	Derb, Kinda(Nights)
;08 Mill House, Ritemoor
;	Old Tom(Days)
;09 Windmill, Ritemoor
;	Jiles
;10 Wizards House, Homeland
;	Jiro, Erth
;11 ?Banit Witches Castle, Ritemoor
;	Witch1
;	Witch2
;	Witch3
;12 Tirn Church, Homeland
;	Yltendoq
;14 Fishy Place, Sasubree
;	Rangard(Mornings), Keggs(Mornings), Kinda (Mornings)
;15

;Remainder unused
 .dsb 256-(*&255)

; .byt >gfxNylot
; .byt >gfxDrummond
; .byt >gfxLief
; .byt >gfxDerb
; .byt >gfxJumbee
; .byt >gfxBarton
; .byt >gfxKeesha
; .byt >gfxKobla
; .byt >gfxRibald
; .byt >gfxRangard
; .byt >gfxKeggs
; .byt >gfxTygor
; .byt >gfxRetnig
; .byt >gfxYltendoq
; .byt >gfxMardon
; .byt >gfxLintu
; .byt >gfxTemple
; .byt >gfxTallard
; .byt >gfxKinda
; .byt >gfxMerideth
; .byt >gfxPrest
; .byt >gfxJiro
; .byt >gfxOldTom
;Jiles
;Erth
;Munk




	
Need some way of convincing Keggs to go to Samson isle, to all it is a suicide attempt.
Even after convincing him, he drowns so how to excuse this to Ribald and the other fisherman
on your return to Sassubree?
One way is first to get Keggs drunk, then listen to his sorrows. He will admit some surprising facts
which will trigger a keyword. At the prospect of redeeming himself by joining Lucien on his quest,
he agrees. Also perhaps as a means of getting away (and possibly some suicidal thoughts!) but
Lucien must travel immediately.
On returning to Sassubree you may be asked to explain yourself since Keggs is now dead and you
were the last to be seen with him.
You reply by asking about the keyword, this triggers the inquisitor to retract his questions!

His misdemeanor?
He commited an atrocity that others have never forgiven him for, the atrocity was the lighting
of the fire that caused the death of the children, the keyword being "old clay pipe".
;      ***********************************
When keggs is asked about "Samson isle" at kissing widow
;      ***********************************
 .byt "I am nothing without the OLD CLAY PIPE.
 .byt "I won't talk about anything else until??
 
When keggs is asked about "Old Clay Pipe" at kissing widow?
 .byt "Many seasons ago i laboured on land"
 .byt "as a farmer. Back then my wife used"
 .byt "to smoke an OLD CLAY PIPE which was"
 .byt "the source of most arguments."
 .byt "On one such occasion, i threw that"
 .byt "pipe out the window not realising a"
 .byt "spark would light the YONDER STRAW."
When Keggs is asked about "YONDER STRAW" at kissing widow
 .byt "I didn't know children were playing"
 .byt "in the shed. They should have known"
 .byt "better! Both me and PERGA raced to"
 .byt "try and save them, but my wife was"
 .byt "caught in the blaze. I escaped but"
 .byt "only just in time as the whole barn"
 .byt "collapsed in on itself crushing all"
When Keggs is asked about "Perga" at kissing widow
;      ***********************************
 .byt "I found her the following day lying%"
 .byt "in the wreckage and carried her to%"
 .byt "the sea shore where she now rests.%"
 .byt "When i finally returned to clear up%"
 .byt "the wreckage heavy rain had churned%"
 .byt "the old ruin into a sodden heap and%"
 .byt "to this day a wretched BOGMIRE.]"
Need some quest to convince Keggs to help Lucien get to Samson isle.
lucien needs to get the old clay pipe in Ritemoor but i think it
does not befit keggs to sell him it. It is better that Lucien drops
the pipe at Pergas grave which triggers Perga to pay Keggs a visit
in the form of a dream and prompt keggs to offer his life to Lucien!

When keggs is asked about "BOGMIRE" at kissing widow
 .byt "A treachorous place that is best to%"
 .byt "avoid. I tried to find the old pipe%"
 .byt "since i had vowed to Perga that she%"
 .byt "would lay to rest with it.But every%"
 .byt "attempt was in vein as i sank to my%"
 .byt "waist in the blackest tar,and a few%"
 .byt "steps further would have taken me!]"
When Lucien finds the pipe he goes to the seashore, locates the unmarked grave
and drops the pipe their. This triggers Perga to pay keggs a visit.
When keggs is asked about samson isle (and subgame Pergas pipe is completed) at kissing widow
;      ***********************************
 .byt "I had a dream last night,or perhaps%"
 .byt "even a vision. Perga came to me and%"
 .byt "told me your good deed.She urged me%"
 .byt "to give my life to you and if i do%"
 .byt "this she will forgive me. I posess%"
 .byt "a boat that can take us both to the%"
 .byt "island.We will need SUPPLIES though]"
When keggs is asked about "supplies" at kissing widow
;      ***********************************
 .byt "We need fresh water and food enough%"
 .byt "to give us strength to face swells%"
 .byt "that even Kobla would balk at. Also%"
 .byt "we will need to take Fruit to keep%"
 .byt "the scurvy at bay.I can pay for the%"
 .byt "rigging to make the boat sea worthy%"
 .byt "so meet me later at the Jetty end."

*************** Money *******************
Money is a big part of progressing in the game. Money is dealt with in Grotes, the
Wurlde currency.

The hero can hold up to 999,999 Grotes before his purse is exhausted.
So the accumulation of wealth must be slow but give the impression he is making
some headway.

All item prices are held in the playerfile.
The average price for lodging in modern times would be 40 pounds.
So let us assume its 40 Grotes and apply the same rule to other items.

The prices vary depending on the time of day which can be directly related
to the base price (held in data.s perhaps) and the sunmoonindex
For example for the Glant fish..
The very best price the item can be sold for will be late afternoon at the market(10).
The very best price the item can be bought for will be early in the morning from the quayside(5).
This would give a profit of 100% for each fish. If the maximum 10 fish were bought (50 Grotes)
they could be sold for 100 Grotes at the market giving enough grotes to buy lodging.

So based on the sunmoonindex in conjunction with when The fisherman start the day (04:00 (0))

0		04:00 XX1 5
1		06:00 XX1 6
2		08:00 XX1 7
3		10:00 XX1 8
4  Noon		12:00 X1X 9
5		13:30 X1X 10               
6		15:00 X1X 11              
7		16:30 X1X 12              
8		18:00 1XX 13                
9		20:00 1XX 14                
10		22:00 1XX 15               
11 Midnight	00:00 1XX 16       
12                  02:00 XX1 17

So whilst the price rises to 17 Grotes at 2am there will be no one in the market at that
time, infact the latest time would be 16:30 and at 12 Grotes thats about right.

What decides whether a character is willing to buy an item?
The group of the character decides.
Bit0 Artifacts
Bit1 Weaponry
Bit2 Fish
Bit3 Bread
Bit4 Other Food
Bit5 Limited to trade

Publican	Has no need for items, may buy food		011100
Pirate    will not buy fish, may buy items or bread	011011
Baker     Won't buy bread				010111
Cobbler   Will only buy food				011100
Labourer  Will only buy food				011100
Fisherman Won't buy fish or weapons			011001
Serf      Will buy anything*				011111
Tribesman May buy anything				011111
Dealer    Will only buy items of his trade or food	111111
Child     Will not buy fish*         			011011
Steward   Won't buy artifacts				011110
Farmer    Will only buy food				011100
-
Clergy    Will not buy anything			000000
Witch     Will buy artifacts				000001
Wizard    Will buy artifacts				000001
*Both Child and Serf are usually very short of money
So each group could be assigned a 32bit (4 Byte) reference where each bit refers to
a unique object he may buy. This information need not be held in playerfile :)

Or we could split the objects into 8 or less groups such as Fish, weapons, health, bread, etc.
then have a single byte applied to each character group or even each character!

So dealers, we must have dealers trading Food, Weaponry and artifacts.
Merideth sells artifacts
Callum sells Weaponry
Triffith sells food

Bit0 Artifacts
Bit1 Weaponry
Bit2 Fish
Bit3 Bread
Bit4 Other Food

Price_RedApple    Bit4
Price_FishNet     Bit0
Price_PotionRed   Bit0
Price_PotionGreen Bit0
Price_PotionBlue  Bit0
Price_FishBok     Bit2
Price_FishGlant   Bit2
Price_Stick       Bit0
Price_Rock        Bit0
Price_Sphere      Bit0
Price_Scroll      Bit0
Price_Parcel      Bit0
Price_WhiteWand   Bit0
Price_BlackWand   Bit0
Price_Knife       Bit1
Price_FishStew    Bit4
Price_Sword       Bit1
Price_Tablet      Bit0
Price_Birdcage    Bit0
Price_Parchment   Bit0
Price_OldBriar    Bit0
Price_Flask       Bit0
Price_Butterfly   Bit4
Price_Ale         Bit4
Price_BreadBlak   Bit3
Price_BreadLem    Bit3
Price_Toadstool   Bit4
Price_Lodging     Bit
Price_Spare2      Bit
Price_Spare3      Bit
Price_Spare4      Bit
Price_Spare5      Bit

Unless we use something a little more clever.
For example a markup price.

The fisherman sells the fish for 10 grotes (base price) to the market.
The market marks it up with a profit margin of 200% (20 Grotes).
For non dealers, the same profit margin represents the maximum they are willing to buy for.

Now instead of manually setting a profit margin you barter with them starting at a profit
margin of 300%.
The level at which they buy will be lower than their profit margin, which over time you
will learn. Also their profit margin will decrease as the day progresses.

So you buy fish from the fisherman at 10 Grotes each.
You then attempt to sell on the market for 30 grotes, but their profit margin is 200% (20 Grotes)
although this margin is not shown.
They will offer 10 Grotes(The base price they bought the item for), you will offer 25,
they will offer 15, you will offer 20, they will offer 17, you will accept.
If you continue, they will stop when their profit margin is less than 10%

At this point if you have multiples of the same item you are given the option to sell more than one
items at this price.

This will give them a profit margin and you'll have sold with 7 Grotes profit(for each item).

Also on leaving the character selector and returning again, your asking price will be restored.

Can only sell multiple to dealer (Check character doesn't have item already)


Lucien is selling the * to ?
The current price is 10 grotes
but Triffith will not accept this
figure.
Please select option

*****************
*** Haggling ****
Current:10 Grotes <Default is always base price but may reduce to 1

Lower this Price
Raise this Price
Haggle with this
Request Price
Barter with this
Abort
****************
Bought Price:10
      Profit:00

For fishermans fish, he sells for 10 Grotes which is displayed as the default
The fisherman won't sell below this price.
Lucien selects HAGGLE and the Fisherman agrees.
Lucien selects BARTER and the Fisherman will sell you the fish for 10 grotes

For Triffith(Dealer at market), 10 grotes is displayed.
Lucien raises the price to 30 and selects HAGGLE.
Triffith won't accept. Lucien lowers to 28 and selects haggle but triffith won't accept.
Lucien selects REQUEST PRICE and Triffith will choose a random value between his profit
margin and the base price. In triffith's case thats between 10 and 20 Grotes and for example
is 13.
Lucien raises 13 to 21 and HAGGLES. Triffith won't accept. Lucien lowers to 19 and Triffith
will accept. Lucien then selects BARTER and the deal is done.
If lucien has more of the same, he may barter for 19.

This gives lucien 9 Grotes profit and Triffith 1 Grote profit.

The characters profit margin applies to Dealers only. For normal folk the profit margin is
the characters intuition which may vary from character to character.
The Profit margin is calculated as follows..
x == The individuals profit margin entity
b == Base price
Markup Price = b +(b/x)

So for Triffiths Fish, he'll have a pme of 1 (100% Profit) and Fish base price is 10 Grotes
Markup Price = 10 + (10/1) = 20 Grotes

For Glant Fish the base is 5 so his markup will be 10 Grotes
For Merideth's Green Elixir the base is 25 and his pme is 2 which makes his markup 37 Grotes

"Publican"
 lodging
 ale
"Pirate"
"Baker"
 lem bread
 blak loaf
"Cobbler"
"Labourer"
"Fisherman"
"Peasant"
"Tribesman"
"Grocer"	  ?
  Apples
  Blak Loaf
  Lem Bread
  Toadstool
"Carpenter" 
  Netting
  wood
  Bow?
  Quills?
  Ebony Wand  
  old briar?
"Steward"
"Antiquary" Merideth
  Potion +
  Elixir +
  Fusion +
  Emerald +
  Diamond +
  Scroll +
  Ivory Wand
  Tablet
  Parchment +

"FishMongr"
  Bok Fish +
  Glant Fish +
"Clergy"
"Sorcerer"
"IronSmith" Triffith
  Knife +
  Sword +
  Bird Cage
  
When the hero sells items the infopanel cursor should be shown rather than the form cursor.
Therefore only the item shortname can be displayed.
  



A dealer buys for a base value and sells for his or her markup price.
However as the day wears on, the availability of stock decreases and so the dealer is willing
to raise his base value to meet demand. This is where the hero comes in. Since the hero can buy
from one character and sell to another.

When Lucien sells item to Character, The characters markup fraction(mun) is sought which ranges 1.5
to 3, the base sales price(bsp) and Characters Random Element(cre) is also sought.

The value offered by the buyer is (((mun x bsp)-bsp)/cre)+bsp
This value is fixed over the course of one day.

The cre is a 3 bit value which operates on ((mun x bsp)-bsp) as follows
Bit0 /2
Bit1 /4
Bit2 /8


For example if cre was 1(/2) and mun was 1.5 and bsp was 10..
(mun x bsp)-bsp == 5 / cre == 1 + bsp == 11

Another example if cre was 2, mun was 3 and bsp was 30..
(mun x bsp)-bsp == 60 / 4 == 15 + bsp == 45

Example based on max, cre 0, mun 3, bsp 30..
(mun x bsp) - bsp == 60 / 1 == 60 + 30 == 90

When lucien buys an item from a seller the seller always gives the markup price and will not waver.

One of my major problems at the moment is that the hero management seems way too convoluted.
It is a complex procedure to display the sprite with many rules but it is made worse by the
use of special tables for input control of the hero.
The only current reason why we need such bulky and complex tables and code is to satisfy
the action of performing a running jump through the same key combination as a standing jump.
The difference being that one key is pressed before the other.



Another problem is the vast number of tables that are used to offset the hero in order to correctly
syncronise his position on the screen and to the floor collision tables.
The main problem here is that every screen is bitmapped and does not conform to a fixed grid
of collision areas. Creating collision maps for every screen would take an awfully long time.
Also somewhere in the code we adjust X in order to synchronise on the fly with BG bitmap memory,
This single change makes things really tricky to manage.
The heroes feet position also change between facing left or right.
It looks smooth on screen but it took weeks of debugging to get it to the stage we are today!
The other major headache is the amount of flicker the hero generates. This has been reduced
by adding rules like don't delete hero if he hasn't moved but it is still not as silky as i
would have liked.
Sometimes he fluidly moves across the screen, but at times he flickers like hell!
I guess vsync will remove this.



















You walk into the market and see that Triffith is selling the Glant for 20 Grotes and you know
that you bought it for 10 Grotes, so you attempt to sell and he'll give you his best offer that
day. the offer is set every day as a random value between the base price and his markup price.

A characters markup price is 1.5,2,2.5 or 3 times the base price.
For Glant(base price 5) the min markup is 7 and max is 15.
For Sword(base price 30) the min markup is 45 and max is 90.

	lda BasePrice
	lsr
	sta TempHalf
	lda BasePrice
	sed
	clc
	adc BasePrice
	sta TempDouble
	adc BasePrice
	cld
	sta TempTriple
	
	lda CharacterMarkup	;0-3
	tax
	and #2
	beq skip1
	dex?
	;Calc fracs(0.5)
	lda BasePrice
	lsr
skip1	;Calc units(1,2,3)
	sed
	clc
loop1	adc BasePrice
	dex
	bpl loop1
	

0 1 2 3
x   x
	 

To Simplify this, we might have two entities in the playerfile character lists.
One adjusts the base value as the buying price and one adjusts the base value as the selling price.
These two entities could be held as two 2 bit values but both would hold the same fractional
possibilities..
0 x 1.25
1 x 1.5
2 x 1.75
3 x 2

However since each character has his or her own selling and buying fractions the hero could
easily locate the best people to buy from(Dealers) and the best people to sell to(customers).
In addition we must also prevent the buyer buying his own trade (fisherman buys fish!).

The problem with Keggs or Rangard or Kinda selling fish at Fishy Plaice.
The problem here is the fish are tied to the character, not to the location so that
whilst you may trade fish with them at fishy plaice, when they go to the pub they still
posess the fish troughs. Even worse when kinda goes to work in the bakery he'll still
have the fish troughs!
The resolve is to tie the fish Troughs to just one character and that character only ever
appears at Fishy Plaice. That character being Rangard.

SSCM-OM0S0.S Turn Church, Homeland
SSCM-OM0S1.S A Hillside
SSCM-OM0S2.S Old Bridge
SSCM-OM0S3.S Hallowed Door
SSCM-OM0S4.S Graveyard
SSCM-OM0S5.S Wizards House
SSCM-OM0S6.S Monument
SSCM-OM0S7.S The Cliff Top

SSCM-OM1S0.S Banit Castle, Sassubree
SSCM-OM1S1.S Olde Bakery
SSCM-OM1S2.S Pirates Arms
SSCM-OM1S3.S Market Square
SSCM-OM1S4.S Kissing Widow
SSCM-OM1S5.S Fishy Plaice
SSCM-OM1S6.S Harbour End

SSCM-OM2S0.S Escarpment, Ritemoor
SSCM-OM2S1.S Butterflies
SSCM-OM2S2.S Mill House
SSCM-OM2S3.S Windmill
SSCM-OM2S4.S The Bog Mire
SSCM-OM2S5.S The Long Road
SSCM-OM2S6.S The Sea Shore

SSCM-OM3S0.S Samson Sands, Samson Isle
SSCM-OM3S1.S Log Cabin
SSCM-OM3S2.S Pine Rivine
SSCM-OM3S3.S Moths Lantern
SSCM-OM3S4.S The Monastery
SSCM-OM3S5.S Boulderdash
SSCM-OM3S6.S The Great Pit

SSCM-OM4S0.S Ciro Castle, Ciro Mountain
SSCM-OM4S1.S Littlepee
SSCM-OM4S2.S Pee Bridge
SSCM-OM4S3.S Ciro Rise
SSCM-OM4S4.S Ciro Mountain
SSCM-OM4S5.S The Skybridge
SSCM-OM4S6.S Broken Path
SSCM-OM4S7.S Topledge

SSCM-IM0S0.S Hallowed (3D Dungeon)

SSCM-IM1S0.S Banit Castle
SSCM-IM1S1.S 
SSCM-IM1S2.S 
SSCM-IM1S3.S 
SSCM-IM1S4.S 
SSCM-IM1S5.S 

SSCM-IM2S0.S Ciro Castle 
SSCM-IM2S1.S
SSCM-IM2S2.S 
SSCM-IM2S3.S 
SSCM-IM2S4.S 
SSCM-IM2S5.S 
SSCM-IM2S6.S 
SSCM-IM2S7.S 

SSCM-IM3S0.S Monastery
SSCM-IM3S1.S
SSCM-IM3S2.S 
SSCM-IM3S3.S 
SSCM-IM3S4.S 
SSCM-IM3S5.S 
SSCM-IM3S6.S 
SSCM-IM3S7.S 

SSCM-IM4S1.S Dwarven Mines
SSCM-IM4S1.S
SSCM-IM4S2.S 
SSCM-IM4S3.S 
SSCM-IM4S4.S 
SSCM-IM4S5.S 
SSCM-IM4S6.S 
SSCM-IM4S7.S 

How to get 'back' passed the windmill?
Lucien buys the grease(Flask) from Lief(Publican) and visits Old Tom(Mill House, Rightmoor).
Old Tom(Because grease is posessed) will mention that the windmill is in dire need
or rebuilding and needs grease. Lucien sells him the grease and the mill vanes will be
absent each visit to the windmill.

In order to make this believable, old tom should mention the disrepair in a general chitchat
to Lucien and also mention that the lack of grease is the reason why it has not been started.
Then the hero will be on an excellent footing to locate the grease and return to Old Tom.

Problem: Ribald suddenly offers 45 Grotes for the Glant for no apparent reason (he is drunk?)
         Did it again tonight, no time to debug tho
         
When Lucien completes pergas pipe subgame but has done Temples Great Horn or got the items
required for the journey, the Parchment may burn in the heroes pocket and words of wisdom
might be displayed to remind the hero what he's doing wrong.

************************* Health *******************************
Health is quite a big area of the Wurlde game.

The health bar is situated in the top left and ranges low(no health(0) and potential death)
to High(Full Health(22)).
The game currently deals with a health range between 0 and 15 because the form bar for hero
health ranges that and the character health levels also range it.
However 15 is not spread over the remaining 7 at the moment.

Two choices here
1) Spread 0-15 over 0-22 range but this could look awkward as step size will vary
2)>Redesign Health bar to comply 0-15
3) Redesign Health bar to comply 0-31

However this is kind of low priority to the other issues with Health.
The major one is what to do when the hero reaches Zero health and dies!
Instant death bg collisions will jump here too

1) The hero should collapse to a lying position with SFX
2) The game over code should load ($400-$98FF) and will contain:
	Game Over screen
	Solemn music
	Calculation of score based on items collected, game progression, subgames completed, etc.
	Display of score with breakdown of calculation
	High score entry of name (If applicable)
3) Player file reset(except high scores, etc) and saved
4) Game title load (which will also display highscores)

When the hero health falls to life theatening levels (3 or lower) then the Heart graphic will pulsate
and the health bar level will flash.

Also health management needs sorting out..

1x	Running and moving won't affect health!
2x	Elixir will restore Health to full
3x	Potion will add 10 to health
4x	Food will add 5 to health(Fish Stew, Fish)
5x	Fruit and Bread will add 2 to health
6	Lodging at a Tavern will restore heath to full
7	Spells cast on hero will drain his health depending on the spell cast
8x	The Quagmire basin will drain the heroes health at the rate of 1 every game cycle
9x	Collision with the windmill vanes will drain the heroes health at the rate of 1 every game cycle
I'm not sure of the relevance of Character health or Mana even since you never directly interact
with them apart from in the Form.


***************************** Mana ********************************
Mana is Magic power and the factors that govern its levels are alot simpler than Health.
The Mana levels also fall inline 0-15 and also suffer same problems as Health in Inventory.

Spell casting will drain mana depending on Spell cast and the receiver of the spell
The Vial will raise mana by 5.
Erth and other magical creatures may bestow mana upon you.

***************************** Spell Casting **************************
Jiro will train Lucien in the art of Spell Casting.
Basically the player must memorise sequences of elven words and the emphasis placed
on each word but not the actual words themselves.
Each Elven word is represented by 



Must refresh keywords list after new keyword is found.
We might just add the line and increase the rows?

Must impliment Use Item so we can replenish health and start on hand weapons
		I+A
00 "Fruit]"         Eat		"Lucien devours the Fruit and feels restored"
01 "Netting]"       -
02 "Potion]"        Drink               "Lucien quaffs the potion and feels restored"
03 "Elixir]"	Drink		"Lucien quaffs the potion and feels restored"
04 "Vial]"          Drink		"Lucien quaffs the Vial and feels more focused"
05 "Bok Fish]"      Eat		"Lucien devours the fish and feels restored"
06 "Wood]"          -
07 "Emerald]"	-
08 "Butterfly]"     -
09 "Scroll]"        Use		"On opening the scroll spidery runes alight and spread across the land"
10 "AquaStone]"     Use		"The stone requires water before it is of any use"
11 "Mire Note]"	Read		"The note reads.."
12 "IvoryWand]"     -		Brings up list of elven words
13 "EbonyWand]"     -		Brings up list of elven words
14 "Knife]"         Use Weapon	"The knife is thrown but magicly reappears in Luciens hand again"
15 "Fish Stew]"     Eat		"Lucien devours the fish stew which is tasty"
16 "Sword]"         Use Weapon	
17 "Tablet]"	-
18 "Bird Cage]"     Use
19 "Parchment]"     -
20 "Old Briar]"     Smoke?
21 "GreasePot]"     -
22 "Grog]"          Drink
23 "Glant]"         Eat
24 "Lodging]"       -
25 "Blak Loaf]"     Eat
26 "Lem Bread]"     Eat
27 "Funghi]"        Eat
28 "Bow]"           Use Weapon
29 "Arrows]"        Use Weapon
30 "GreatHorn]"     Blow
31 "SpellBook]"     Read

***************** Casting Spells ************************
This is one of the most interesting aspect of the game.

Spells cannot be performed until Lucien has met Erth in Homeland and has bought either or both wands
in Sassubree.
Erth and Jiro will then teach Lucien how to focus energy and use the wands.

Spells may be used as weapons but also in self defence, healing and good will.
Apart from visual spells the hero will be seen to cast the spell by animating him using the
black or white wand in either direction.

The Ebony wand is used for destruction such as weapons
The Ivory wand is used for restoration such as self defence,healing and others
Erth will tell this to Lucien

Jiro will take Lucien to a place to test his skills and teach him some essential words that
will invoke the spells.
On learning these spells Erth will pass him the spellbook which will contain many more spells.
Mana is drained for each spell. Potions will boost mana but meditation can too.

Light is very significant in Wurlde. From Luciens first arrival on the shores of Riteland
he was made aware of the ever-twilight that was cast upon the land by Madragath. The
reason was not to dampen the spirits of the residents but to allow the beast spirits to
freelly dwell and traverse above and below the land.
Counter-measures refer to retrospective actions from the enemy. If they sense a mage at work
they may flee in order to report to their master. So due dilligence is required not to set off
alarm bells unless absolutely required.

?	Ivory  	Defence level I	Will invoke a glowing light around Lucien for 10 seconds
				The light is similar to a glowing light in that it will
				only affect the hero. Shadows will not be dispersed but
				will avoid the glow similar to the detraction of two
				opposing magnets.
				The glow has little effect at its lowest ebb.
				Based on the low mana required to initiate the spell it
				will not be recognised as a magical action.
?	Ivory  	Defence level II	Will invoke a strong light around lucien for 1 minute
				The cast is much greater casting out almost a foot of
				light beyond the hero. Unlike level 1 the glow is will
				not pulsate.
				But still not enough to trigger the enemy to assume a mage.
?	Ivory  	Defence level III	Will invoke invincibility for 10 Seconds
				Rather than a glow, the hero will himself appear as
				white within. All shadows that are physically touched
				by the hero will be dissolved.
				Again Defence spells do not alert 
?	Ivory  	Cast sunlight	dissolves shadows and blinds enemies for a while
				This is a Light casting spell. Casting light upon the
				open field for a short time.
?	?	Shape Shift	Lucien may turn into either an inanimate or living object
				He can only shape shift if the destined shape has already been
				trained in. For birds this requires extensive flying lessons.
				
?	Ivory  	Teleport level I	Lucien can suddenly vanish and reappear elsewhere within 10 paces

?	Ivory  	Teleport level II	Lucien can suddenly vanish and reappear elsewhere on screen
?	Ivory  	Invisibility	Lucien will become invisible for 1 Minute
?	Ivory  	Meditation	Lucien will invoke meditation until his mana is restored
				During this time Lucien must remain still or the spell is broken
?	Ivory  	Water Rain	Lucien call call upon the weather to rain.
?	Ivory	Slow Time		Time will be slowed whilst lucien may still move in normal time
?	Ivory	Flight		Lucien will fly for a short time before falling to the ground

?	Ebony  	Wind of change	Lucien will cast a distortion effect knocking back any enemy
?	Ebony  	Lava flow		Lucien will invoke such heat as to turn the ground to lava
?	Ebony  	Plant life	Lucien will call upon nature to entwine his enemy in vines
?	Ebony  	Fire Rain		Lucien can call upon the weather to shower fire rain for 30 seconds
?	Ebony	Lightning		Lightning will strike random places on the ground.
?	?	Earth Golem	Raises the dead with a single creature that fights on your behalf
?	?	Save Game		A Spell to save the game aswell as at inns(needed since homeland -
				and Ciro Mountain won't neccesarily have Inns.

*************** Pergas Pipe **************
1) Need the boat placed at Sassubree Castle to enable Lucien to get back to Ritemoor
2) Need to 1) sort Grease Subgame to remove windmill vanes or 2) remove and have vanes turn anticlockwise


Jetty areas need more splashing white waves in foreground
Kissing widow needs tower flag and splash? animated, stars/castle light blinked, gulls?!
Market square needs flags on stall roofs, blinking castle lights, birds in distance
Pirates arms needs church light blink, lighthouse blink, smoke for chimney, distant birds
Olde Bakery needs river ripple anims, rising/falling bakery crate, distant birds
Banit Castle needs moored boat, distant birds


******************* The Sea ******************
The sea is a sub-game that involves a rowing boat navigating an increasingly turbulant
sea in order to reach Samson isle.
The boat is displayed on the horizon, half in water and half in sky. As the water level
inclines and declines so the boat rotates to reflect the same gradient.
The Sea turbulance appears in the form of ever increasing waves. Waves in their simplest
form are a sine wave. However to create a dynamic sea, we use two overlaid sine waves of
differing frequencies.
If a math operation seeks the highest of the sine waves at the x intersection and (as well
as plotting the pixel) records the y position at x, it should be possible to only erase and
plot neccesary pixels. I am just concerned that at bit level, the waves will not be fast
enough.

Only the height of the swell needs to be filled. This could either be done as an operation
(slow) or by sampling a graphic(complex).
However the overall level of the sea should also rise and fall.
I can't see how this could be done through pure graphic.

Once the wave effect is done, the next stage is to gradually add surf, rain, lightning and
eddie currents to create a growing storm effect. The most active point being massive swells
with heavy torrential rain beating at almost a horizontal shear angle (to show the wind).

-------------- The Boat ------------
The boat consists of a rowing boat, boat surf, hero and oar and Surf, all byte alligned.
The rowing boat is 11 frames(13(78)x16 bitmap block) for each gradient(2.3K).
The rowing boat surf is synchronised with the oar serf and is ?
The oar and hero is 16 frames (6(36)x27 bitmap and mask) for the rowing sequence(2.6K).
The surf may be part of the oar and hero since both are synchronised to how they affect
the water.

Two screen buffers are used.

The primary buffer holds the sea swells.

The secondary buffer takes the first then overlays the various parts of the boat before
being sent to the screen.

This allows each boat part frame to be a different size without worrying about deleting
previous frame. Allignment is handled in animation routine.

The buffer is 40x32(1280) and resides with gfx in 16K still
The HeroOar and Boat Angles both use the byte offset to store the gfx which saves bytes
,speed and complexity. The step being based on the 40 wide screen buffer.

First byte is offset from TL base.
