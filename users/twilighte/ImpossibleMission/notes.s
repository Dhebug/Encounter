;>>>>>>>>>>>>>>>>> Controls

;Whilst on Game screen or in Lift Foyer
;Left		Run Left
;Right		Run Right
;Up		Log into Simon Console, Log into Terminal, Move lift up, Search Furniture
;Down		Move Lift Down
;Fire1		Jump (Whether Running or not)
;Fire2 or ESC	Go to Pocket Computer

SFX:
Footsteps			- Noise Fade
Sparks			- zzzz zzzz zzzz
Lift moving		- Low to High.. to Low
death			- Bzzz Bzz Bz
Go to Pocket Computer	- Short F#3

;Whilst in Pocket Computer
;Left		Navigate Button Left
;Right		Navigate Button Right
;Up		Navigate Button Up
;Down		Navigate Button Down
;Fire		Press Button
;Fire2 or ESC	Exit Console

SFX:
Exit from Pocket Computer	- Short F#5
End of Puzzle piece memory	- Short E-2
Telephone menu		- Tone (Possibly E/F Dual)
Dial Option		- Tone Dialling pattern




;Whilst in Phone Menu
;Up		Move Cursor up
;Down		Move Cursor Down
;Fire		Select Option
;Fire2 or ESC	Exit Menu(Or select Hang Up)

;Whilst in simon console
;Left		Navigate Button Left
;Right		Navigate Button Right
;Up		Navigate Button Up
;Down		Navigate Button Down
;Fire		Press Button
;Fire2 or ESC	Exit Simon Console

;Whilst on Terminal
;Up		Navigate menu up
;Down		Navigate menu down
;Fire		Select Menu Item
;Fire2 or ESC	Exit Terminal

;>>>>>>>>>>> Wrist Console
;Once a slide is correctly combined, correct colour and correct orientation the system will automatically
;accept the slide, clear all parts from list and issue a Password letter.

;Up to 4 parts are required to complete a slide.

;In the left of the window are shown up to 3 collected puzzle pieces. This list can be moved through using the
;nav keys. When a puzzle piece is selected (Fire) it moves to the next free slot to the right.
;The player can then move to it and select it (fire). The player can then manipulate it using the buttons.
;Any two puzzle pieces (to be combined) must exist in the right window. The player can attempt to overlay them
;by pressing Select2 (Fire2) whilst over another piece. If the pieces can be combined 
;To Crack each puzzle
;Column 1..
;Move up list of slides
;Move down list of slides
;Go to Phone Menu

;Column 2..
;Flip Vertically
;?
;Change slide to Red

;Column 3..
;Flip horizontally
;?
;Change slide to Green

;Column 4..
;?
;Pause Game
;Change slide to Blue

MirrorX
Flip
Red
Green
Blue


Select a slide from the left list (3 shown with top/bottom arrows indicating more) by moving selector UP or DOWN
(push scroll).
Press and Hold FIRE1 and press RIGHT to move slide out of list and into one of the next free work slot.
(If no slot is available then sfx)
Move to work slide and press fire to select it.
Move to right button block and select MirrorX button, Flip, Red, Green or Blue to manipulate the selected slide.
move to work area and press FIRE1+LEFT to move back to list.

If they match a sfx and letter will be issued else an sfx.
move to work area and press FIRE1+LEFT to move slide back into list (can also move merged slide back to list).





	ldx #00
loop1	ldy ScreenOffset1,x
	lda (screen),y
	ldy ScreenOffset2,x
	sta (screen),y
	dex
	bne loop1

For puzzle pieces there are 4 pieces to each puzzle and 7 puzzles in the game so 28 slides.
Each piece is 4x8 and also posess a colour attribute (0-2) which could be embedded in the graphic.
So 896 Bytes in total
The 7 puzzles are held as 7 slides which are compared (by value) against any new merge selected.

For lift platforms

For Main Shaft
Plot static lift and cables
Scroll one side	


Changes
1) use 8 platform levels
2) Use a 6K(40x150) bg buffer and mask all sprites on that
3) increase ethan height and create vertical bounds to detect collisions
4) delete individual furniture (after searching) on screen and strip buffers


Each Puzzle piece is 24(4)x8
4 Puzzle Pieces make a Punch Card
7 Punch cards make the Password


how do we ensure puzzle pieces are spread over most rooms?
by embedding flag in each room furniture to say puzzle piece is here
or..
there are 28 puzzle pieces in total and 31 rooms
the 31 rooms also include 2 coderooms and 1 control room (both of which do not contain puzzles).
Which means only 28 rooms need to have puzzle pieces so one puzzle piece per room.

explore possibility of glowing position in map display












01)Ethan exits the room.
02)eye closes room
03)StrongholdEthanX/Y reads from score screen map the corridors (or refreshes when in new area).
04)Shaft, lift and corridors drawn to bgb.
05)eye opens shaft (from bgb to screen)
06)Ethan now navigates corridor to lift or another room
07)Ethan moves down in lift
08)Lift(and ethan) scroll down in screen whilst eye closes screen
09)StrongholdEthanY moves down and reflects in map. new parts of complex shown as lift moves to new areas
10)Lift approaches new level. If down still pressed then continue lift otherwise..
11)Ethan reaches new level.
12)New level corridors read from screen map.
13)Jump to 04

10/07/09
Last night wrote nice routine to scroll lift sides so like original. However as a consequence the corridors,
earth and lift walls really need to be broken down into 6x6 hires characters and help in maps for easy recall
as the screen scrolls.
This also means we should use the same character set to hold letters and numbers for text.




 .byt 128+$04,128+62,128+$03,128+58,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byt 128+$02,128+65,128+$00,128+57,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byt 128+$05,128+63,128+$01,128+58,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byt $FF,128+61,128+$06,128+58,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 .byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF


Any Ethan movement begins with a
		 In Room			In Lift Shaft
1)Delete ethan	-Restore BG from bgb	Restore BG from ethan bgb
2)move Ethan
3)Check collision map
4)plot ethan	-Plot Ethan		Capture bg to ethan bgb and Plot Ethan

So the DeleteEthan


** Must feed more memory efficient way to describe Robot patterns **
Also implement sight sensors
 .byt SPARK	;Always same period
 
;If facing right, Move through turn frames until facing Left
;If facing left already proceed to next command
 .byt TURNLEFT	
 
;If facing left, Move through turn frames until facing Right
;If facing Right already proceed to next command
 .byt TURNRIGHT

;Move in current direction x number of steps. If x is zero then move to end of rail.
 .byt MOVE
 .byt 0
 
;Turn three quarters in opposite direction to current direction and sense by sight
;The parameter specifies the index to jump to when it detects Ethan on the same level.
 .byt TURNTOSENSE
 .byt lblSkip
 

Sight sensor
Senses hero by sight, essentially looks at line of sight, one pixel or collision row in line with robots
head. When Ethan lands on same level Robot will see him but if he jumps robot will momentarily not see him.


Hero movement
Standing & Searching:
sense ground and place sprite up from ground

Running:
On foot down sense ground

Jumping:
Sense platform below

Room Lifts:
Disregard above

Convert Collision map and routines to address 40 width collision map


Rather than setting each frames y step, we should set each frames y-offset from the current platform up.

Also attempt mirror code for left movement

;Mirroring ethan is fairly easy. Ethan is always 3 bytes wide so
;1)left is mirrored for right
;2)Right is mirrored for left
;3)Middle is mirrored for middle
;Since all Ethan sprites are bunched together in one block of memory, we can simply mirror the block rather
;than each frame. The dimension of the block (less searching frames)is 3x508.
;So perform in 2 x 254 row chunks

Problem..
Robots and Sparks are stored in the collision map but move so may wipe out Furniture and other collisions.
Thus normal background collision should use just B0-4(0-31) whilst robots and sparks use B5-7(8).

The jump frames start with two frames of 3x3 then six frames of 2x2 then a final four frames of 3x3 and rest.
The 2x2 frames miss the half height platform.
So the behaviour should be that the jump should not move right until the third frame by which time the
search is 2x2. Then on the 9th frame of 3x3 if platform detected then move up.
This also serves the somersault over a robot in the first 2 frames.

Mods
1)Modify third frame of jump so that it is no more than 3x2 and at max height.
2)Mod frames 6 and 7 to clip foot and therefore comply with 3x2.
3)Modify first two frame xsteps to 0

Ground detection
Needs to be expanded to detect centre/left if facing left and centre/right if facing right

;We could place an extra byte in entrance that holds the puzzle piece (or 128 for none)
;Then of each furniture id..
;B0-4 FurnitureID
;B5   This furniture holds Bonus
;B6   This furniture holds puzzle piece
;B7   Furniture plundered
;It also means the idea of a difficulty level could work by adjusting the number of bonuses!

Problem
The Lift shaft section works but is very inefficient with memory and requires special routines
to display Ethan.

First things first we use the collision map as the screen map whilst moving the lift!
we scroll the collision map, refresh top/bottom and render full scn directly from it.

Easy but the difficult bit is how to know what next to plot in top/bottom?
Its known by a distance counter, this is calculated from the corridors in the complex-map.

And also alligning lift to corridor intersection when its reached?
Again a second distance counter can be triggered when a new corridor is sensed at top/bot scn

and how to convert screen map back into collision map when corridor reached?
the scn-map should be easy enough to convert back.

Infact we should take it one step further and only hold rooms in room-map!!

Problem
How do we do the puzzle area?
We have one work slot.

The work slot is given a list of up to 4 puzzle pieces. Initially the work area is empty so the list is 255.

When the player pressing fire in the memory the memory puzzle piece is transferred into the work list,
deleted from the memory list and displayed in the work area.

The player may then mirror or flip the piece to attempt to match it to another piece in the memory list.
Once a match is found the player selects the merge button on the left. If the merge is successful the new
piece is removed from the memory list, added to the work list and merged with the work area piece.

When the player selects the Delete button all pieces in the work list are moved back over into the memory
list and the on-screen work piece is deleted.

When 4 pieces exist in work list (a complete punch card) and the correct orientation and colour has been
selected the work list is erased (resetting the index to 255) and the next letter of the final passcode
is issued and displayed in the score key field.

012345678901234
=>Enough pieces 
  for a puzzle?
  Correct Work
  orientation
  Hang up

  
Bit0-1 Colour
Bit2 Flip
Bit3 Mirror

090909..
Currently terminal is plotted to bg then zoomed to screen using sped up eyeopener.
The restoration of screen uses plot room again which destroys last robot positions and Ethan.

The better way is to have 2 new special commands to plot direct to screen then call upon them
in terminal room. the call should not corrupt collision map so when the terminal is finished
with we restore the screen from the bg buffer, plot robots and lifts and then resume where we
left off.

Droids
Rather than hold movement in script why not have a bit for each type of movement then on game start
set the behaviours by fetching a random 8 bit number.

0 Pause at 10 Paces
1 Pause at 5 Paces
2 Look back (Only with B0-1 set)
3 Speed
4 Spark
5 Repeat at bounds
6 Sound sensor (Senses Ethan wherever he is in the room) - Triggers second behaviour parameter
7 Light Sensor (Only sense Ethan when facing him on same level) - Triggers second behaviour parameter

Provide two variables.. one for normal behaviour and the other for when Ethan is detected.



B7 Nibble2 Bit2
B6 Nibble2 Bit1
B5 Nibble2 Bit0
B4 Nibble2 End Flag
B3 Nibble1 Bit2
B2 Nibble1 Bit1
B1 Nibble1 Bit0
B0 Nibble1 End Flag

ExtractNibble1
	and #15
	lsr
	;Carry holds End flag
	
ExtractNibble2
	lsr
	lsr
	lsr
	lsr
	lsr
	;Carry holds End flag

Every sample has a lead out of 256 End Flags
zpPlaySamples
	stx
	sty
	sta
	ldy Sample8BitIndex
vector1	ldx Sample1,y
	lda LowerNibbleSample,x
vector2	ldx Sample2,y
	adc UpperNibbleSample,x
	sta VIA_PORTA
	iny
	sty Sample8BitIndex
	bne skip1
	inc vector1+2
	inc vector2+2
skip1	lda VIA_T1CL
	lda
	ldx
	ldy
	cli	
	
Play 2 channel Chip + 2 Channel Sample
or 1chip + 1cheg + 2samp
or 3chip + 2samp(overlaid)

Anyway rather than design a new music editor use Sonix and at event level define dual sample layer
using spare repeat bits 3+3 in event bytes
Dual sample always played on C.
B0-B2 (0-7) defines sample track

Samples always purcussion and played at 8Khz(125 Cycles) on T1. Use counter to capture 100hz event.
Use 100Hz event to process Sonix

 .byt SETSPEED,Speed
 .byt MOVE,Distance or EOR
 .byt SPARK	;Shoot
 .byt TURN	;Turn in opposite direction
 .byt JUMP,Offset
 .byt ONENDOFRAIL,Offset

 .byt SETSPEED+Speed(0-5)
 .byt MOVE+Distance
 .byt MOVE_EOR
 .byt SPARK	;Shoot
 .byt TURN	;Turn in opposite direction
 .byt JUMP+StepsBack
 .byt ONENDOFRAIL+StepsBack

Ahh another visitor, stay a while, stay forever..
Kill him my robots
No.. no.. no..
Congratulations
ahhhhhhhhhhh

B0-3 Allophone(16)
B4-6 Repeats(0-3)
B7   0(Allophone)

B0-3 Noise PW
B4-6 Repeats(0-3)
B7   1(Noise)

Credits to..
Groepaz
Dbug
Symoon
Chema

Inspiration..
Slay Radio
Cheveron

2:30 to pick up all furniture (with many deaths)
Credit Symoon for providing puzzle piece designs

012345678901234
     ROOMS  10%
 FURNITURE   5%
   PUZZLES   1%
PUNCHCARDS   0%
TOTAL GAME  11%

Disc menu
012345678901234
SAVE GAME
LOAD GAME 
SCREEN - COLOUR

Simon Steps

For Intro utility on im.dsk for transferring Tape image files to disk is called T2DMITS.COM
