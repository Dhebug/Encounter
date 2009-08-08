;8 Channel

Patterns are composed in a fixed file format then when required
the pattern is compiled back into the compact format.


0123456789012345678901234567890123456789
N00-A 01-A 02-E 01-N 03-B 10-C 09-C 08-T
MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX



NM - Index (0-63)

C0 - Note & Octave
V  - Volume(0-63)
X  - Effect(0-63)
m  - Command Flag to indicate this entry is affected by the command on channel H only)


4 Bytes per channel ~ 3x64 == 192 per pattern ~ 192x8 = 1536

MPPSC PPAS PPAS PPAS PPAS PPAS PPAS PPAS

PP Pattern(00-7F)
S  Sound Source & Channel Link (00-63)
C  Command(0-63)


Physical Channel Link
0 A
1 B
2 C
3 AB
4 AC
5 BC
6 ABC
7

Sound Source
0 A
1 B
2 C
3 E
4 N
5 S(Sample)
6 I(SID)
7 V(Variable Pulsewidth)


Event Memory
000-127 Pattern
128-191 Command
192-199 Physical Channel Link(ABCENX)
200-207 Virtual Channel(A-H)
208-215 Sound Source(Tone,Noise,EG,Tone Bit,Volume, None)

Physical Channel
ABC	Chip
E	EG
N	Noise
X	Command Channel(H only)

Event Commands
192-192 Allocate Physical Channel A to current channel
193-193 Allocate Physical Channel B to current channel
194-194 Allocate Physical Channel C to current channel
195-195 Allocate Noise Register on A to Current Channel
196-196 Allocate Noise Register on B to current channel
197-197 Allocate Noise Register on C to current channel
198-198 Allocate Noise Register to current channel
199-199 Allocate EG on A to current channel
200-200 Allocate EG on B to current channel
201-201 Allocate EG on C to current channel
202-202 Allocate EG to current channel
203-203 Allocate Tone Bit on A to current channel
204-204 Allocate Tone Bit on B to current channel
205-205 Allocate Tone Bit on C to current channel
206-206 Allocate Volume on A to current Channel
207-207 Allocate 


Pattern Memory	ABC	N	E	T	Display
000-000 Bar	Bar	Bar	Bar	Bar	BAxx
001-001 Rest	Rest	Rest	Rest	Rest	RSxx
002-095 Note(94)	Note(94)	Pitch(94)	Period(94)-	C0xx
096-159 Volume(64)	Volume(64)Toggle(2)	Toggle(16)Toggle(2)	xxVx
160-223 Effect(64)	Effect(64)Effect(64)Wave(64)	Effect(64)xxxX
224-255 Period	Rows(32)	Rows(32)	Rows(32)	Rows(32)

Note: Whilst patterns do not contain commands, a channel can be set up
      as a command channel which will the act upon all channels.

Effects Memory
000-063 Volume
064-127 Note(-32 to +31)
128-191 Pitch
192-255 Command



Note 			95
Note with Effect 		223,95
Note with volume 		159,95
Note with volume and effect	159,223,95
Rest 			1
Rest with Volume 		159,1
Bar			0
Bar with Volume		159,0
Command			255

Std Charset for Editor Data
32-95	0-63 Numerics
96-107	0-11 Notes
108-117	0-9  Single Digits
118-127	10 Special Characters (Bar, Rest, |)


;32-95

000-093 Note(94)	Note(94)	Pitch(94)	Period(94)-	C0xx
094-094 Bar	Bar	Bar	Bar	Bar	BAxx
095-095 Rest	Rest	Rest	Rest	Rest	RSxx
096-159 Volume(64)	Volume(64)Toggle(2)	Toggle(16)Toggle(2)	xxVx
160-223 Effect(64)	Effect(64)Effect(64)Wave(64)	Effect(64)xxxX
224-255 Command(32)	Com(32)	Com(32)	Com(32)	Com(32)	CMMD


A fixed file format is a hell of alot easier to work with than a sequential(compiled) format.



DisplayPatternEntry
	lda (source),y
	ldx #5
.(
loop1	cmp PatternByteThreshhold,x
	bcs skip1
	dex
	bpl loop1
	ldx #1
	sec
skip1	ldy PatternEntryScreenOffset,x
	sbc PatternByteThreshhold,x
	clc
	adc PatternEntryASCIIOffset,x
	sta (screen),y
	tax
	bne skip2
	iny
	lda PatternEntryOctave-96,x
	sta (screen),y
skip2	rts
.)
	
PatternByteThreshhold
 .byt 0,94,95,96,160,224
PatternEntryScreenOffset
 .byt 0,0,0,2,3,0
PatternEntryASCIIOffset
 .byt 96,118,120,32,32,?
PatternEntryOctave
 .byt 
	
32-95	0-63 Numerics
96-107	0-11 Notes
108-117	0-9  Single Digits
118-127	10 Special Characters (Bar, Rest, |)

****************** Screen Layout *************************

Pattern Editor

 0123456789012345678901234567890123456789
19
29              Menu Area
39
49
59----------- PATTERN EDITOR -----------  Alt
6900-A 01-A 02-E 01-N 03-B 10-C 09-C 08-T Alt
7MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
8MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
9MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
0MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
1MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
2MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
3MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
4MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
5MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
6MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
7MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
8MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std<
9MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
0MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
1MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
2MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
3MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
4MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
5MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
6MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
7MC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VXmC0VX Std
89----------- Editor Statii ------------  Alt

Event Editor
 0123456789012345678901234567890123456789
19
29              Menu Area
39
49
59------------- EVENT EDITOR ------------ Alt
69
7MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
8MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
9MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
0MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
1MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
2MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
3MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
4MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
5MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
6MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
7MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
8MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std<
9MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
0MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
1MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
2MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
3MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
4MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
5MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
6MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
7MPPSO PPSO PPSO PPSO PPSO PPSO PPSO PPSO Std
89----------- Editor Statii ------------  Alt

Editor Music is arranged into Events, Patterns and Effects
Events are a list of up to 128 Rows. Each row may contain up to 8 Tracks. Each Track Entry is 2 Bytes
long. This consumes 2048 Bytes.


Patterns are a single sequence of up to 64 Notes and rests. Each entry is 2 bytes long and up to 127
Patterns may be defined. This consumes 16384 Bytes.

Effects are a single list of up to 128 entries, each entry defining Note, Pitch, Timbre and Volume.
Up to 64 Effects may be defined. This consumes 8192 Bytes.

The total Memory a music composition may consume is 26624(#6800) Bytes.

Pattern 2 Byte format
0-63 6 Note
	00-60 Notes C-1 To C-5
	   61 Rest
	   63 Volume Rest
	   63 Bar
0-15 4 Volume
0-63 6 SFX

A0-1 Volume(B0-1)
A2-7 Note(B0-5)
B0-1 Volume(B2-3)
B2-7 Effect(B0-5)


Command Track H
A0-3 Command B0-3(16)
A4-7 Parameter1 B0-3(0-15)
B0-7 Parameter2 B0-7(May be Track Spread)

TMXX

Event 2 Byte format
A0-7 Pattern
	0-126 Pattern
	127   Rest
A7   -
B0-5 Channel Combination (0-31) or 63 for Pattern Command(Channel H only)
B6-7 Command
	0 No Command
	1 Mimic Track Left (Shown on Screen as <xtS) S remains as Sound Source
	  A0-2 Volume Offset(0 To - 7 of mimicked Track) (Shown in x as compounded 64)
	  A3-5 Pitch Offset(0 to -15 of mimicked Track)  (Shown in x as compounded 64)
	  A6-7 Time offset(0 to -3 behind mimicked Track)(Shown in t as single digit)
	2 Mimic Track Right (Shown on screen as >xts)
	3 Extended Command (For Channel A)
	  A0-2 Command
	  	0 New Music (Always set on Track A)
	  	   "New Music 03 '14 Character Name held in remaining Row bytes'"
	  	1 End of Music (Always Set on Track A)
	  	   A3-6 Final Volume
	  	2 Fade Music (Always set on Track A)
	  	   "Fade In Music at rate of 7"
	  	   A3   In(0) or Out(1)
	  	   A4-7 Rate over one pattern
	  	3 Loop Music
	  	   ?
	  	4 Set Music Behaviour
		   "TS0 VB4 NB7 IRQ- TSD00"
	  	   A3    Time Slot Behaviour(Share Timeslot(0) or Not(1))
	  	   A4    Use 4 Bit Volume Resolution(0) or 6 Bit(1)
	  	   A5    Use 5 Bit Noise Resolution(0) or 7 Bit(1)
	  	   A6-7  IRQ Music Speed (50Hz(0) 100Hz(1) 200Hz(2) 400Hz(3))
	  	   B0    -
	  	   B1-5  -
	  	   C0-7  Time Slot Delay Frac (255 for maximum speed)
	  	5 Set Note Behaviour
	  	   Range of Octaves 0-4 1-5 2-6 3-7 4-8 5-9
	  	   Channel Spread
	  	6
	  	7



0500 Music Memory(26624)
	0500 Event Memory
	0D00 Pattern Memory
	4D00 Effect Memory
6D00 Editor Memory(18432)
B500 Std Charset
B800 Preferences
B900 Alt Charset
BB80 Screen
BFE0 -
C000 ROM and Sedoric



Whilst the Notes volume can only be set between 0 and 15 it may be changed in smaller steps in the background.


VVVVVVVV 
VVVVVVVV 
PPPPPPPPPPPPPPPP
PPPPPPPPPPPPPPPP

SS PC	Description		Pitch/Note	Volume
A  A	Chip A with Channel A Volume	Chip A		Volume 4Bit
B  B	Chip B with channel B Volume	Chip B		Volume 4Bit
C  C	Chip C with channel C Volume	Chip C		Volume 4Bit
A  TA	Chip A with Channel A Status	Chip A		Tone Flag
B  TB	Chip B with channel B Status  Chip B		Tone Flag
C  TC	Chip C with channel C Status  Chip C		Tone Flag
E  A	EG on A			Period		EG Flag
E  B	EG on B			Period		EG Flag
E  C	EG on C			Period		EG Flag
E  AB	EG on A and B		Period		EG Flag
E  BC	EG on B and C		Period		EG Flag
E  AC	EG on A and C		Period		EG Flag
E  ABC	EG on A, B and C		Period		EG Flag
N  A	Noise on A		Noise		Noise Flag
N  B	Noise on B		Noise		Noise Flag
N  C	Noise on C		Noise		Noise Flag
N  AB	Noise on A and B		Noise		Noise Flag
N  BC	Noise on B and C		Noise		Noise Flag
N  AC	Noise on A and C		Noise		Noise Flag
N  ABC	Noise on A, B and C		Noise		Noise Flag
S  A	Sample on Volume A		Software		Volume 4Bit
S  B	Sample on Volume B		Software		Volume 4Bit
S  C	Sample on Volume C		Software		Volume 4Bit
I  A	SID on A			Software		Volume 4Bit
I  B	SID on B			Software		Volume 4Bit
I  C	SID on C			Software		Volume 4Bit
I  E	SID on EG			Software		Cycle
V  A	VPW on A			Software		Volume 4Bit
V  B	VPW on B			Software		Volume 4Bit
V  C	VPW on C			Software		Volume 4Bit
V  E	VPW on EG			Software		Cycle
31 Possible Configurations


8 Track is based around allocating a Track a tempered timeslot on the sound resource.
For example if Track A,B and C is given ChipA Volume A then each Track gets one go


The feature that permits Two Tracks to share the same channel resource needs to follow rules
when one track is not being used.
Timeslot Behaviour(TSB)
1)When a Track is inactive, it will permit the other track to occupy its timeslot(TSB0)
2)When a Track is inactive, it will silence the timeslot and not permit the other track to use it(TSB1)
TimeKeeping Behaviour
1)Each Track plays the Effect at the speed and ignores the timeslot given it(TMK0)
2)Each Track only increments the Effect pointer for each timeslot it is given(TMK1)
Both behaviours are set in the music Event Command 4




Effects need to modify Volume,Pitch,Timbre and Note with flow changes(loop,end)
					ABCEN
these are not the most uptodate formats, no random, etc.
00 000-031 Positive Pitch Step (1-32)		XXXXX
01 032-063 Negative Pitch Step (1-32)		XXXXX
02 064-095 Positive Note Offset (1-32)		XXX
03 096-127 Negative Note Offset (1-32)		XXX
04 128-143 Volume				XXXbb
05 144-144 Envelope Off			XXXXX
06 145-145 Envelope On			XXXXX
07 146-146 Tone On				XXXXX
08 147-147 Tone Off				XXXXX
09 148-148 Noise On				XXXXX
10 149-149 Noise Off			XXXXX
11 150-150 Conditional (If Volume = 0)
12 151-151 End of Effect
13 152-182 Loop Back (0-30)
14 183-190 Filter Octave (2-9)
15 191-191 Filter Off
16 192-200 Delay (1-9 Ticks)
17 201-201 Conditional Stop (If Pitch = 0)
18 202-202 Conditional Stop (If Noise = 0)
19 203-203 Conditional Stop (If Pitch > Note)
20 204-204 Conditional Stop (If Pitch < Note)
21 205-213 Set Counter Value(1-9)
22 214-245 Noise (0-31)
23 246-246 Increment Volume
24 247-247 Decrement Volume
25 248-248 Increment Noise
26 249-249 Decrement Noise
27 250-250 Relative Mode
28 251-251 Absolute Mode
29 252-252 Decrement Envelope Period
30 253-253 Increment Envelope Period
31 254-254 Set Envelope Sawtooth Waveform
32 255-255 Set Envelope Triangle Waveform


************************* Menu ***********************
Could still use a drop down menu i guess. Memory seems to suggest ok atm.
We have 40x5 to play with.
This top area still needs to contain..

*Look up table for Event SoundSource and others
*Play Monitor (Although could go base of screen)
*Menu for main nav
*Disk load/save and Print Options
0123456789012345678901234567890123456789
 FILE EVENT PATTERN EFFECT >O  -------- Row 0
x
x
x
x

FILE (Always disk or printer)
0123456789012345678901234567890123456789
 MUSICXXXX I  MUSICXXXX I  MUSICXXXX I
 MUSICXXXX I  MUSICXXXX I  MUSICXXXX I
 MUSICXXXX I  MUSICXXXX I  MUSICXXXX I
 MUSICXXXX I  MUSICXXXX I  MUSICXXXX I
 MUSICXXXX I  MUSICXXXX I  MUSICXXXX I
 MUSICXXXX I  MUSICXXXX I  MUSICXXXX I
 MUSICXXXX I  MUSICXXXX I  MUSICXXXX I
 MUSICXXXX I  MUSICXXXX I  MUSICXXXX I
 MUSICXXXX I  MUSICXXXX I  MUSICXXXX I
 MUSICXXXX I  MUSICXXXX I  MUSICXXXX I
 MUSICXXXX I  MUSICXXXX I  ????????? I
Status Row(Drive,Free)

When on any filename, the user can press L(Load), S(Save), P(Print), C(Compile)?
Also
CTRL D to select Drive
CTRL F to Set Filter of files shown

EVENT

PATTERN

EFFECT


Event	5 Rows
Pattern	9 Rows
Effect	5 Rows

0 Top Menu
1 EVENT
2 LEGEND
3 Data
4 Data
5>Data
6 Data
7 Data
8 PATTERN 
9 LEGEND
0 Data   
1 Data   
2 Data   
3 Data   
4>Data   
5 Data       
6 Data       
7 Data   
8 Data   
9 EFFECT
0 Data   
1 Data  
2 Data  
3>Data  
4 Data  
5 Data  
6 Data  
7 STATUS




Tracks could be processed as if destined for chip and then interpreted after depending on SS
So each track would generate its own Note, Pitch, Volume and then..
ABC on Vol would direct as normal
ABC on Stat would direct pitch and note as normal but if vol==0 then stat off else stat on
etc.


However that technique is inefficient. Sure it would work but just not neat enough.
We have 5 Sound resources
A
B
C
E
N
And each needs to hold one or more Track references
	ldx #4
	lda ChannelBankLo,x
	sta source
	lda ChannelBankHi,x
	sta source+1

Or we have a block of memory 5x8 long.
	ldx #4
	txa
	asl
	asl
	asl
	sta temp01
	
	lda CurrentTrackPointer,x
	adc #1
	cmp UltimateTrack,x
	bcc skip1
	lda #00
skip1	ora temp01
	tay
	lda ChannelBlock,y
	
	
	

	
	
  HGFEDCBA
A 00000000
B 00000000
C 00000000
E 00000000
N 00000000

Each bit corresponds to Track

	ldx #4
	lda ChannelBlock,x
	;Fetch current Index(0-7)
	ldy CurrentTrackIndex,x
	and Bitpos,y
	bne 
	
	
WHICH IS FASTEST/LEAST MEMORY TO -- Translate 1,2,4,8,16,32,64,128 to 0-7 in Y
*Looping
	ldy #8
loop5	dey
	cmp Bitpos,y
	bcc loop5
Cycles == 82 or less
Memory == 16 Bytes

*Compare
	ldy #7
	cmp #64
	beq skip6
	bcs skip7
	cmp #16
	beq skip4
	bcs skip5
	cmp #4
	beq skip2
	bcs skip3
	cmp #1
	beq skip0
	jmp skip1
	
skip0	dey
skip1	dey
skip2	dey
skip3	dey
skip4	dey
skip5	dey
skip6	dey
skip7

Cycles == 38 Cycles or Less
Memory == 34 Bytes	
	
*Compare2
	ldy #6
	cmp #64
	beq skip1
	iny
	bcs skip1
	ldy #4
	cmp #16
	beq skip1
	iny
	bcs skip1
	ldy #2
	cmp #4
	beq skip1
	iny
	bcs skip1
	ldy #00
	cmp #1
	beq skip1
	iny
skip1

Cycles == 38 Cycles or Less
Memory == 34 Bytes	



ScanKeyboard is currently very inefficient.
We should separately scan Soft keys since they reside on the same column

11110111

Optimising extraction of Music Data from Pattern Entry
B0-1 Volume
B2-7 Note
B0-1 Volume
B2-7 Effect

Rotate method
	lda #00
	sta prTrackVolume,x
	iny		;2
	lda (source),y      ;5
	lsr                 ;2
	rol prTrackVolume,x ;7
	lsr                 ;2
	rol prTrackVolume,x ;7
	sta prTrackEffect,x ;4
	dey                 ;2
	lda (source),y      ;5
	lsr                 ;2
	rol prTrackVolume,x ;7
	lsr                 ;2
	rol prTrackVolume,x ;7
	sta prTrackLnNote,x ;4
Cycles==64 Cycles
Bytes==32 Bytes

Mask Extraction
	iny		;2
	lda (source),y      ;5
	and #3              ;2
	asl                 ;2
	asl                 ;2
	sta prTrackVolume,x ;4
	lda (source),y      ;5
	lsr                 ;2
	lsr                 ;2
	sta prTrackEffect,x ;4
	dey                 ;2
	lda (source),y      ;5
	and #3              ;2
	ora prTrackVolume,x ;4
	sta prTrackVolume,x ;4
	lda (source),y      ;5
	lsr                 ;2
	lsr                 ;2
	sta prTrackLnNote,x ;4
Cycles==60 Cycles
Bytes==36 Bytes

Compiler
Composer
Genre
Group
Author
Songs
Date

;This routine is intended where a key routine is being used outside the IRQ
KeySensitiveAYRegisterDump
	;Backup current PCR state
	;Read Current Register (which you can't do?)
	inactive
	read value
	write value
	write register
	lda VIA_PCR
	sta 
	cmp #PCR_SETINACTIVE
	
**************** CPU LOAD MONITOR ******************
The IRQ routine Resets the irq to Latch values, processes music then captures t1 to irqCycles.
VIA_T1L - irqCycles == TotalCycles consumed by music

CPU load on screen is shown as an 8 character bar and can be based on 65536/8192 which
equates to TotalCycles/8192 or LSR 13 Times.
Alternatively we generate the bar on the fly and achieve 48 pixel which (through tables)
could give is 5 Bit or pseudo 6 Bit Res.
Ultimately we might provide a percentage figure but that requires reducing 65536 to 100 and using
same equation for TotalCycles.
So dividing Total cycles by 655.36 or 655
We could do this as a stepped process in the IRQ delivering the result repeatedly to a loc and
building an average TotalCycles for use in the division.

A0-1 Volume(B0-1)
A2-7 Note(B0-5)
B0-1 Volume(B2-3)
B2-7 Effect(B0-5)

Rather than have a dedicated track for commands, it would definately make the system more
flexible (and possibly less code) to have Command in place of Note entry..
A0-1 Command Number
A2-7 62(Command)
B0-1 Command Number
B2-7 Command Parameter(0-63)

Displayed as..
cF-N

Command must then include Volume Rest

However not sure. Channel spread actually might be useful sometimes.
Like you played one event row then advance to next wanting to observe same tempo changes
but different patterns. You can only do this with the current format, otherwise you would
have to put the same tempo changes in each new pattern.


MultiSpeed IRQ
Music may be played at 25Hz, 50Hz, 100Hz or 200Hz
Bigger Resolution volume or Noise always plays at 4 times the speed of MusicIRQ
Digidrum may be played at 1Khz,2Khz,3Khz or 4Khz
SID and VPW is variable between about 200Hz and 5Khz
Note: SID,VPW or Digidrum can be played though not in combination.

T1 processes Digidrum,SID and VPW and is variable
T2 processes Music IRQ and Bigger Resolution and is constant


So for MusicIRQ played at 200Hz, BR would play at 800Hz.

Pattern entry breakdown is done like this..
	lda (pattern),y
	lsr
	rol prTrackVolume,x
	lsr
	rol prTrackVolume,x
	sta prTrackEffect,x
	dey
	lda (pattern),y
	lsr
	rol prTrackVolume,x
	lsr
	rol prTrackVolume,x

	; Add Base Octave
	adc prBaseOctave,x
	sta prTrackNote,x

Which is taken from the format..
A0   Volume B3
A1   Volume B2
A2-7 Note/Rst/VRST/Bar
B0   Volume B1
B1   Volume B0
B2-7 Effect

PlotPattern works similarly..
	lda PatternEntryByte0
	lsr
	rol ppTempA
	lsr
	rol ppTempA
	A holds Note
	lda PatternEntryByte1
	lsr
	rol ppTempA
	lsr
	rol ppTempA
	A holds effect
	lda ppTempA
	and #15
	A holds volume
	
Pattern Command
A0-3 Command ID(0-11)
A4-7 Param1(0-15)
B0-7 Param2(0-255)

ID Description	Param1		Param2

0  Trigger Out	Value to Write	ZP Location
1  Trigger In	Value to detect	ZP Location
2  Song Tempo	-		Tempo Frac
3  Effect Tempo	-		Tempo Frac
4  Pitchbend Up	Rate		Channel/s
5  Pitchbend Down	Rate		Channel/s
6  Spare
7  Spare
8  Spare
9  Spare
10 Rest		-		-
11 Bar		-		-


The problem with this format is that it differs from Note Pattern which means Rest
(which every pattern is initialised with) is not the same code for Command H.
We can't just use the Note Pattern format because we need a 7 bit byte to specify
Tracks where needed.

The best resolve is to make Command 4 a Rest since in binary this will appear as rest..
The Rest code is 61 which in binary is..
111101XX==Note Rest
    0100==Command 4
111111XX==Note Bar
    1100==Command 12



So the reformatted Command list would be..
0000 00 Trigger Out
0001 01 Trigger In
0010 02 Song Tempo
0011 03 Pitch Bend(More intelligent)
0100 04 Rest
0101 05 Rest
0110 06 Rest
0111 07 Rest
1000 08 Spare
1001 09 Spare
1010 10 Not Used
1011 11 Not Used
1100 12 Bar
1101 13 Bar
1110 14 Bar
1111 15 Bar



 .byt "TR-OUT - VAL(",128,"),ZPLOC(",131,")",0
EmbeddedMessage1
 .byt "TR-IN - VAL(",128,"),ZPLOC(",131,")",0
EmbeddedMessage2
 .byt "SONG TEMPO - FRAC TEMPO(",129,")",0
EmbeddedMessage3
 .byt "EFFECT TEMPO - FRAC TEMPO(",129,")",0
EmbeddedMessage4
 .byt "PITCHBEND ^ - RATE(",128,",CHANNELS(",130,")",0
EmbeddedMessage5
 .byt "PITCHBEND V - RATE(",128,",CHANNELS(",130,")",0

20081201 Jump over inactive tracks in pattern editor			DISMISSED(See Notes)
If we do this highlighting across inactive tracks could be achieved which would complicate the
copy/paste process.


To optimise, replace HelpPlotYLOC table with calculated loc

;Parsed
;Y Index(0-51) - 0-25/26-51
;Return
;screen location
;Corruption
;A&Y
CalcHelpPlotScreenLoc
	tya
	ldy #0
	sty source+1
	cmp #26
.(
	bcc skip1
	sbc #26
	ldy #1
skip1	;Ax40 == (Ax32)+(A*8)
.)
	asl
	asl
	asl
	sta source
	asl
	rol source+1
	asl
	rol source+1
	adc source
	sta source
.(
	bcc skip1
	inc source+1
skip1
.)
	cpy #1
	beq	
	
IRQ Speed
There are a number of factors that determine the IRQ speed

Primarily Timer1 is used for Digidrum, VPW and SID
Whilst Timer2 is used for Resolution processing, Effect and Note Processing, Keyboard and counters.


IRQHandler
	bit via_ifr
	bvs ProcessTimer1
	sta ?
	
	; Resetting IRQ can be achieved by writing T2 High which also reloads 200Hz
	lda #>5000
	sta via_t2ch

	;Backup X/Y
	stx ?
	sty ?
	
	
	; Process Effects at 200hz?
	lda prIRQEffectSpeed
	cmp #3
	bcc skip2
	ldx #7
loop1	lda prTrackProperty,x
	and #TRACKPROPERTY_ACTIVEEFFECT
	beq skip1
	jsr prProcEffect
skip1	dex
	bpl loop1
	;Cannot process Resolution when effects are played at 200hz
	jmp skip3

skip2	; Process 200Hz Resolution?
	lda prGlobalProperty
	and #BIT3+BIT4
	beq skip3
	
	?
	
skip3	; Process Timeslot
	jsr TimeSlotManagement
	
	; Count down to 100(2) or 50(1) for Effect?
	lda prIRQEffectSpeed
	beq skip4
	cmp #2
	
	
	
	
TIMESLOT MANAGEMENT
Is performed as part of transferring tracks pitch&Volume to resources but is always equal or slower than
transfer.
Sharing is split into groups, so when a number of tracks share the same resource they are allocated a new
group which contains its own unique count and index.
Each Track sharing within the same group is also given a unique Entry which marks the Tracks ID within the
group.

So when Tracks A,D and E share the same resource, Group 0 is assigned, Track A's Entry is 0, D is 1 and E
is 2. The Count is set to 2 and index set to Count.
Each time the routine is called, Index cycles between 0 and Count and is compared against Entry of Track
for whether the track has the timeslot or not.



*Run Playroutine
*Transfer Track-Pitch & Track-Volume to Track-resource based on SS & timeslot
*Send AY

*Process Res

Handle noise&volume Dither here before we begin
TransferTrack2Resource
	;Process Timeslot delay
	lda TimeslotDelay
	sec
	adc TimeslotDelayFrac
	sta TimeslotDelay
.(
	bcc skip1
	ldy #7
loop1	lda Bitpos,y
	and prActiveTracks_Pattern
	beq skip2	;Track not active - skip to next
	and prActiveTracks_Sharing
	beq skip2	;Not sharing
	ldx SharingGroup,y
	dec SharingIndex,x
	bpl skip2
	lda SharingCount,x
	sta SharingIndex,x
skip2	dey
	bpl loop1
skip1	;Process Track Transfer in Timeslot
	ldy #7
.)
.(
loop1	lda Bitpos,y
	and prActiveTracks_Pattern
	beq skip1	;Track not active - skip to next
	and prActiveTracks_Sharing
	beq skip2	;Not sharing - so send direct to AY
	ldx SharingGroup,y
skip1	lda SharingEntry,y
	cmp SharingIndex,x
	beq skip2	;Track active for Timeslot
	;Observe TSB rule for inactive track(B5 Do not share Timeslot)
	lda prGlobalProperty
	and #BIT5
	beq skip1
	;Zero Volume resource
	lda #00
	jsr TrackVolume2ResourceSetVol
	jmp skip1
skip2	;Transfer Track Pitch to Resource
	jsr TrackPitch2Resource
	;Process Track Volume Resolution
	jsr TrackVolume2Resource
skip1	dey
	bpl loop1
.)
	rts

For example A+B,C+D,E+F,G+H
prActiveTracks_Sharing is 11111111
SharingGroup is 0,0,1,1,2,2,3,3
SharingIndex is 0-1,0-1,0-1,0-1
SharingCount is 1,1,1,1
SharingEntry is 0,1,0,1,0,1,0,1

For example A+B,C+D+E,F,G,H
prActiveTracks_Sharing is 11111000
SharingGroup is 0,0,1,1,1
SharingIndex is 0-1,0-2
SharingCount is 1,2
SharingEntry is 0,1,0,1,2

For example A,B,C,D
prActiveTracks_Sharing is 00000000


SharingGroup
 .dsb 8,0
SharingIndex
 .dsb 4,0
SharingCount
 .dsb 4,0
SharingEntry
 .dsb 8,0	
	
Trouble is with timeslots is the system technically allows up to 4 timeslots on different resources to
concurrently exist.
ie. A+B,C+D,E+F,G+H
Or the other extreme is that all 8 channels share the same resource like A+B+C+D+E+F+G+H

u have a byte(A) that flags that sharing exists for track
u have 5 more bytes(B-F) for each resource
then u have another byte(G) that flags that a track is currently active on a resource

so when G reset in G and inactive track
when no G and sharing set in G
	
	
	
;Process Higher Volumes and Noise Resolutions from AbsoluteVolume/AbsoluteNoise
	

AYRegisterBase
00 AY_PitchALo	.byt 0
01 AY_PitchBLo	.byt 0
02 AY_PitchCLo	.byt 0
03 AY_PitchAHi	.byt 0
04 AY_PitchBHi	.byt 0
05 AY_PitchCHi	.byt 0
06 AY_Noise 	.byt 0
07 AY_Status 	.byt %01111000
08 AY_VolumeA	.byt 0
09 AY_VolumeB	.byt 0
10 AY_VolumeC	.byt 0
11 AY_PeriodLo	.byt 0
12 AY_PeriodHi	.byt 0
13 AY_Cycle 	.byt 0
14 AY_Dummy	.byt 0

Having effects process tracks outside of timeslot would allow a transition from dedicated resource
to shared resource without incurring a slowdown penalty as the effect is processed only when the timeslot
is given.
The flip of coin is that the effect would be synchronised to the timeslot.
EFFECT IS independant OF TIMESLOT

11111111 200Hz
10101010 100Hz
10001000 50Hz
10000000 25Hz

In file editor
Press RETURN over existing filename to LOAD EXISTING
Press RETURN over ???? filename to SAVE NEW
Press FUNC+S over existing filename to SAVE EXISTING
Press FUNC+S over ???? filename to SAVE NEW

Problem
It was decided that Effects completely control sound..

0 dec vol by 1
1 skip on volume over
2 delay 1
3 loop 0

Pattern set vol to 15
Effect immediately decs volume by 1 on first hit

Remedy..
0 skip on volume over
1 delay 1
2 dec vol by 1
3 loop 0

Problem: Note Frac causes inconsistent distance between notes(Irregular tempo).
 Reason: Fractional Stepping will approximate the tempo across many intervals but individual
         intervals will vary in size(Dithered tempo)
Resolve: Use Fractional stepping only where the overall tempo is required otherwise use decs

Digidrum	I-BH - I is the Digidrum icon, B is the Bank and H is the Number(High Offset).
	       Digidrums are 4 bit samples and are either extracted from the top 4
	       bits(Bank1) or the lower 4 bits(Bank0)
	       Format in memory is..
	       Note   - -
	       Volume - Bank(0 or 1)
	       Effect - High Offset (+$3E)
SID	PP12 - PP is the pitch offset, 1 is the first value, 2 is the second value and S is
	       the Pitch offset(down from Channel Pitch).
	       Format in memory is..
	       Note   - Pitch Offset
	       Volume - Value1
	       Effect - Value2
Buzzer	NN12 - NN is the Note, 1 is the first Cycle Code, 2 is the second Cycle Code
	       Format in memory is..
	       Note   - Note
	       Volume - Value1
	       Effect - Value2
	       
SFX x 64
00111111
00000000 11111100
+0 0/64/128/192
	
	
	lda 
	lsr
	pha
	lda #00
	ror
	sta SFX
	pla
	adc #>SFXMemory
	sta SFX+1

Utilities..
Import Mused File
Import Sonix File
Import MOD File
Import MIDI File
Compile
Compile & Print

To speed up player use 512 table for quick reference to range vector for SFX
In compiled player this might be optionally to handle Pattern and List as well.

Use 2's compliment to reduce number of subroutines

	lda (SFX),y
	tax
	lda SFXValueIndex,x
	pha
	lda SFXCodeIndex,x
	tax
	lda SFXCodeVectorLo,x
	sta vector1+1
	lda SFXCodeVectorHi,x
	sta vector1+2
	pla
vector1	jsr $dead
	

SFXCodeIndex
 .dsb 50,0	;00 00 Positive Pitch Offset 1-25
 .dsb 50,1	;02 02 Positive Note Offset 1-25
 .dsb 50,2	;04 04 Positive Volume Offset 1 to 15
 .dsb 32,3 	;06 06 Positive Noise Offset 1 to 16
 .dsb 16,4 	;08 08 Positive EG Offset 1 to 8
 .dsb 2,5 	;10 0A Envelope Off(0) or On(1)
 .dsb 2,6 	;11 0B Tone On(0) or Off(1)
 .dsb 2,7 	;12 0C Noise On(0) or Off(1)
 .dsb 2,8 	;13 0D Skip Loop when Volume Over
 .byt 9 		;14 0E End SFX
 .dsb 4,10 	;15 0F Filter 1 to 4
 .dsb 10,11 	;16 10 Delay 1 to 10
 .dsb 20,12	;17 11 Set Counter 1 to 20
 .dsb 25,13 	;18 12 Loop 0 to 24
 .byt 14 		;19 13 Random Delay
 .byt 15 		;20 14 Random Noise
 .byt 16 		;21 15 Random Volume
 .byt 17		;22 16 Random Note
 .byt 18 		;23 17 Random Pitch
 .dsb 4,19 	;24 18 EG Wave 1 to 4

One 256 Byte table referencing SFX Code index and another 256 Byte table referencing
range value.
SFXValueIndex
 .byt 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
 .byt 256-1,256-2,256-3,256-4,256-5,256-6,256-7,256-8,256-9,256-10,256-11,256-12
 .byt 256-13,256-14,256-15,256-16,256-17,256-18,256-19,256-20,256-21,256-22,256-23,256-24,256-25
 .byt 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
 .byt 256-1,256-2,256-3,256-4,256-5,256-6,256-7,256-8,256-9,256-10,256-11,256-12
 .byt 256-13,256-14,256-15,256-16,256-17,256-18,256-19,256-20,256-21,256-22,256-23,256-24,256-25
 .byt 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
 .byt 256-1,256-2,256-3,256-4,256-5,256-6,256-7,256-8,256-9,256-10,256-11,256-12
 .byt 256-13,256-14,256-15
 .byt 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
 .byt 256-1,256-2,256-3,256-4,256-5,256-6,256-7,256-8,256-9,256-10,256-11,256-12
 .byt 256-13,256-14,256-15,256-16
 .byt 1,2,3,4,5,6,7,8
 .byt 256-1,256-2,256-3,256-4,256-5,256-6,256-7,256-8
 .byt 0,1
 .byt 0,1
 .byt 0,1
 .byt 0,1
 .byt 0
 .byt 0,1,2,3
 .byt 1,2,3,4,5,6,7,8,9,10
 .byt 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
 .byt 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0
 .byt 0,1,2,3
 


 
 -NAVIGATE--
 V XXXXXXXXX
 


 .byt 0	;Navigation
 .byt <eeNavTrackLeft
 .byt <eeNavTrackRight
 .byt <eeNavLeft
 .byt <eeNavRight
 .byt <eeNavUp
 .byt <eeNavDown
 .byt <eeHome
 .byt <eeEnd
 .byt <leSongPrevious
 .byt <leSongNext
 .byt <JumpPattern
 .byt <JumpMenu
 .byt <JumpSFX
 .byt <JumpFile
 .byt <JumpHelp
 .byt 0	;Modify
 .byt <eeIncrement
 .byt <eeDecrement
 .byt <eeReset
 .byt <eeToggle
 .byt 0	;Commands
 .byt <eeRest
 .byt <eePattern
 .byt <eeComMimicLeft
 .byt <eeComMimicRight
 .byt <eeComNewSong
 .byt <eeComEndSong
 .byt <eeComFadeMusic
 .byt <eeComLoopMusic
 .byt <eeComSongBehaviour
 .byt <eeComNoteSettings
 .byt <eeComNoteBehaviour
 .byt <eeCommandH
 .byt 0	;Copying
 .byt <eeHilightDown
 .byt <eeHilightUp
 .byt <eeCopy
 .byt <eeCut
 .byt <eePaste
 .byt <eeGrab
 .byt <eeDrop
 .byt <eeCopyLast
 .byt <eeCopyNext
 .byt 0	;Playing
 .byt <PlayPattern
 .byt <JumpPlay
 .byt 0	;Manipulation
 .byt <eeInsertGap
 .byt <eeDeleteGap

 
Add extra stuff to effect commands and see what ranges we can have


We need to add
Specific Wave code(14)
Restore Original Note(1)

Now the offsets could be inefficient because they are seperated to positive
and negative. using 2's compliment we can use just one range reducing the
wastage by 1 value in each range.


prProc_SFXPositivePitch
prProc_SFXNegativePitch
prProc_SFXPositiveNote
prProc_SFXNegativeNote
prProc_SFXPositiveVolume
prProc_SFXNegativeVolume
prProc_SFXPositiveNoise
prProc_SFXNegativeNoise
prProc_SFXPositiveEGPeriod
prProc_SFXNegativeEGPeriod
prProc_SFXSwitchEG
prProc_SFXSwitchTone
prProc_SFXSwitchNoise
prProc_SFXSetSkipCondition
prProc_SFXFilter
prProc_SFXDelay
prProc_SFXSetCounter
prProc_SFXEndSFX
prProc_SFXLoop
prProc_SFXRandomDelay	1
prProc_SFXRandomNoise	1
prProc_SFXRandomVolume	1
prProc_SFXRandomNote	1
prProc_SFXRandomPitch	1
prProc_SFXWave		16
prProc_SFXRestoreNote	1



The problem is we type F and must write F Note to Pattern observing List Note Offset
            A-1  
<LIST OFFSET>|
CDEFGAB CDEFGAB CDEFGAB
 OCTV0   OCTV1   OCTV2

Type C -|               C-1 Fails!
Type G -----|           G-1 Fails!
Type B -------|         B-1 Ok!

Permit change only if the Selected note is available in the current octave.

	
	;Convert Typed 0-6 to Note 0-11(Ignore current Sharp)
	
	;Take the Pattern entry up to B-X(or 60) by observing
	;calculated ShortNote
	lda PatternNote
	clc
	adc ListNoteOffset
	jsr CalcNote	(Y 0-11)
	ldx PatternNote
	cpy TypedNote
	beq NoChange
loop1	cpy #11
	bcs B-Xreached
	iny
	inx
	cpx #61
	bcc loop1
B-Xreached
	;Then bring Pattern entry down to Typed Note. If Pattern
	;Entry <0 then Fail
loop2	cpy TypedNote
	beq Success
	dey
	dex
	bpl loop2
	jmp Failed
success	Store PatternNote(x)
NoChange	rts
	
	
ok, above routine works!!
	
	
For octave..
Permit change only if the current note is attainable in the selected octave
otherwise abort.

fetch listoffset
calc octave and store as lo
add 60 to listoffset
calc octave and store as hi
if octave selected >=lo and <=hi
  increment lo whilst adding 12 to listoffset until lo==selected octave
end if


or..

fetch current patternentry (which includes list offset)
convert to note&Octave
if SelectedOctave=Octave
  Success
if SelectedOctave<Octave
  add 12 to patternentry whilst inc octave until either patternentry>60(fail) or octave ==selected
elseif SelectedOctave>Octave
  sub 12 from patternentry whilst dec octave until either patternentry<0(fail) or octave ==selected
end if

	sbc #48
	tay
	lda PatternEntryLongNote	;This is independant of list offset
	
loop1	cpy PatternEntryOctave	;This includes list offset
	beq Success
	bcc sub
	iny
	clc
	adc #12
	cmp #61
	bcc loop1
	rts	;Failed
sub	dey
	sec
	sbc #12
	bpl loop1
	rts	;Failed
Default
Success	sta PatternEntryLongNote
	jmp peStorePatternLongNote

	
Works!

Why do we have top menu?
We already have keyboard shortcuts to all editors

0123456789012345678901234567890123456789
 FILE LIST PATTERN SFX >HO S01 ABCDEFGH

 OCTAYE 1.00 TWILIGHTE >HO S01 ABCDEFGH

Mimic History of 4 captures only permits 4 ticks back which is not sufficient even over 7
Tracks. How much extra memory would 16 or 32 history captures consume?
96 Byte table
4 Records for Pitch Lo
4 Records for Pitch Hi
4 Records for Volume
thats 12 across potentially 8 tracks so 96 Bytes

16 Records for 3 is 48 Bytes x 8 is 384

Could do history of 10..
10 Records for Pitch Lo
10 Records for Pitch Hi
10 Records for Volume

Could also crunch data..
16 Records for Pitch Lo
16 Records for Pitch Hi & Volume
thats 32 across potentially 8 tracks so 256 Bytes
But this would limit volume resolution to 4 bit

Changing the time delay setting (0-3) from the number of ticks behind to the Number of ticks between samples
whilst keeping the number of ticks behind to 4. This would permit a greater delay but 



0-2 0-7(0,2,4,6,8,10,12,14) Time Offset
3-5 0-7(0,4,8,12,16,20,24,28) Pitch Offset
6-7 0-3(0,4,8,12) Volume Offset
0-5 SS
6-7 Mimic Control

Perhaps a Pattern Command to Set Waveform would be good

0-3 Command EG Waveform
4-7 Waveform
0-7 Spare


The file filter is a bit corrupt, ie changing the filter shows one thing in the status and quite
another in the dir. Their is also some question over the loading areas, like utility should never
be loaded since it would upset play. Digidrum is not valid for first version, etc.

Currently the filter is..
;Filter can be..
;0 No Filter(*)ANY TYPE Show all types
;1 Show Type 0 MODULE   (Music)
;2 Show Type 1 PATTERNS (PATTERNS)
;3 Show Type 2 SFXS     (SFX)
;4 Show Type 3 UTILITY  (UTILITY)
;5 Show Type 4 DIGIDRUM (DIGIDRUM)
;6 Show Type 5 KEYS     (OTHER)

Now we have AYT, the file extensions should be AY? and may be as follows
Type	Name		Area					Sectors
AY0	"MODULE  "	List,Patterns,SFX,SFX Names,Key Preferences	93
AY1	"MUSIC   "	List,Patterns,SFX,SFX Names
AY2	"LIST    "	List
AY3	"PATTERNS"	Patterns
AY4	"SFX     "	SFX,SFX Names
AY5	"KEYS    "	Key Preferences
AY6	"SPARE1  "	Not Used (Eventually Digidrum)
AY7	"SPARE2  "	Not Used

Great Scott
Lawks
Core Blimey
Bloomin Heck

Mad Bowman


Sonix Import(No Size penalty)
Events   		  >> List
Patterns 		  >> Patterns
Ornaments and Samples >> SFX

MOD Import(Based on 2 Channel Sharing)
List		  >> List
Patterns		  >> Patterns
Commands		  >> SFX (With raised Volume Res)

MUSED Import
Sequence		  >> List & Patterns

AYT
Music Editor
Import
Export

Frere Jacques

============ Compiler ================


0123456789012345678901234567890123456789

 1 - Load AYT music
 2 - Compile
 3 - Options
 4 - save module
 5 - Exit

 
Options
 Accelerate SFX?
 Accelerate 

 
 .byt 0	;00 00 Positive Pitch Offset 1-16
 .byt 16	;01 01 Negative Pitch Offset 1-16
 .byt 32	;02 02 Positive Note Offset 1-16
 .byt 48	;03 03 Negative Note Offset 1-16
 .byt 64	;04 04 Positive Volume Offset 1 to 16
 .byt 80	;05 05 Negative Volume Offset 1 to 16
 .byt 96  ;06 06 Positive Noise Offset 1 to 16
 .byt 112 ;07 07 Negative Noise Offset 1 to 16
 .byt 128 ;08 08 Positive EG Offset 1 to 8
 .byt 136 ;09 09 Negative EG Offset 1 to 8
 .byt 144 ;10 0A Envelope Off(0) or On(1)
 .byt 146 ;11 0B Tone On(0) or Off(1)
 .byt 148 ;12 0C Noise On(0) or Off(1)
 .byt 150 ;13 0D Set Skip Loop Condition(1-3)
 .byt 153 ;14 0F Filter 1 to 4
 .byt 157 ;15 10 Delay 1 to 15
 .byt 172	;16 11 Set Counter 1 to 31
 .byt 203 ;17 11 End SFX
 .byt 204 ;18 12 Loop Row 0 to 31
 .byt 235 ;19 13 Random Delay
 .byt 236 ;20 14 Random Noise
 .byt 237 ;21 15 Random Volume
 .byt 238	;22 16 Random Note
 .byt 239 ;23 17 Random Pitch
 .byt 240 ;24 18 EG Wave 0-15

 .byt 0   ;00 11 End SFX
 .byt 1   ;01 13 Random Element 0-4
 .byt 6   ;02 08 Positive EG Offset 1 to 8
 .byt 14  ;03 09 Negative EG Offset 1 to 8
 .byt 22  ;04 06 Positive Noise Offset 1 to 16
 .byt 38  ;05 07 Negative Noise Offset 1 to 16
 .byt 54  ;06 0A Envelope Off(0) or On(1)
 .byt 56  ;07 0B Tone On(0) or Off(1)
 .byt 58  ;08 0C Noise On(0) or Off(1)
 .byt 60  ;09 0D Set Skip Loop Condition(1-3)
 .byt 63  ;10 0F Filter 1 to 4
 .byt 67	;11 11 Set Counter 1 to 31
 .byt 98  ;12 18 EG Wave 0-15
 .byt 114 ;13 12 Loop Row 0 to 31
 .byt 146	;14 00 Positive Pitch Offset 1-16
 .byt 162	;15 01 Negative Pitch Offset 1-16
 .byt 178	;16 02 Positive Note Offset 1-16
 .byt 194	;17 03 Negative Note Offset 1-16
 .byt 210 ;18 10 Delay 1 to 14
 .byt 224	;19 04 Positive Volume Offset 1 to 16
 .byt 240	;20 05 Negative Volume Offset 1 to 16

Extend Pattern Grab/Drop as follows..
J will grab entry
K will drop entry

L will drop Contextually the Field the cursor is over
If over Rest,Vrest or Bar then entry will be dropped


The problem with Pattern command Track and range limit of 4 is that for generic clearing of entry
it is better to have common code for Rest.
This is done in CTRL X, CTRL D, CTRL I, DEL, etc.
The other problem is that when one boots ayt all patterns are set to note type rest
so entering patterns always shows 61 in command h, now we could add some code to curtail
this but perhaps it might be better conforming to this format..
				Range	Parameter		Graphic
0-1 -
2-7 Command ID
	00-15 Pitchbend		Rate	Track		3
	06    Trigger Out		-	Value(0-63)	0
	17    Trigger In		-	Value(0-63)	1
	18    Note Tempo		-	Tempo(0-63)	2
	19-34 EG Cycle		Cycle	Track(EG Flag)	4
	35-50 EG Period		Hi	Lo		5
	51-60 -
	61    Rest					----
	62    Rest					----
	63    Bar						----
0-7 Parameter

DEL
CTRL I
CTRL D
CTRL X

Also displaying of Grabbed entry
pattern plot
proc pattern command




However bypass this and can then open up commands from 4 to full 16..


		Param1(4)	Param2(8)	Show
00 Trigger In	Value	Loc	c0XX
01 Trigger Out	Value	Loc	c1XX
02 Note Tempo	-	Tempo	c2-X
03 EG Period Long	Period Hi	Period Lo	c3XX
04 EG Cycle	Cycle	Period Lo	c4XX
05 Pitchbend	Rate	Tracks	c5X-
06 Note Range	Track?	Range	c6X-
07 Vibrato	Rate	Tracks	c799
08 Arpeggio	Track	O1/O2	c8FF
09 -
10 Rest		-	-	RST-
11 Bar		-	-	====
12-15


To pitchbend without having to search ahead for note, one could backup the current pitch in pbend before
storing the new note. then run from backup to current note at rate.

C-3
---
---
C-4<	c599

Since proc pattern works left>>right, we'll know both pitches before we reach PBend Command.


The trouble is that when a track row ends, if it was noise it won't neccesarily disable
noise on a channel. Automatically disabling noise may well produce undesirable results.

One could use a new RWC for this..
DISABLE TNE ON CHANNELS ABC

Alternatively one could place the emphasis on the SFX to make sure the start sets
the Tone, EG and Noise Flags.

For contextual info for Patterns..

"A-RESTED TRACK  "
"A-NOTE          "
"A-OCTAVE        "
"A-VOLUME        "
"A-SFX "12345678""
"A-REST          "
"A-VRST          "
"A-BAR           "

TRACK A  NOTE         
         OCTAVE
         VOLUME
         SFX(........)
         REST
         BAR
         VRST
         
Problem with highlighting accross inactive patterns
The problem is this scenario where A is active Track and - is inactive track..

ABCDEFGH
AAAA-AAA

If we wanted to copy Tracks D,F,G to Tracks A onwards, would it be expected to paste
to ABC or ACD?

Perhaps ABC would be more logical.

