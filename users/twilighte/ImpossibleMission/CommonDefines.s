;CommonDefines

#define	VIA_PORTB		$0300
#define	VIA_PORTAH	$0301
#define	VIA_DDRB		$0302
#define	VIA_DDRA		$0303
#define	VIA_T1CL		$0304
#define	VIA_T1CH		$0305
#define	VIA_T1LL		$0306
#define	VIA_T1LH		$0307
#define	VIA_T2LL		$0308
#define	VIA_T2CH		$0309
#define	VIA_SR		$030A
#define	VIA_ACR		$030B
#define	VIA_PCR		$030C
#define	VIA_IFR		$030D
#define	VIA_IER		$030E
#define	VIA_PORTA		$030F
#define	VIA2_PORTB	$0320

;Page 2 map
;0200-0209 Game Display digits
;020A-021E -
;021F	 Tape HIRES flag(1)
;0220-0243 -
;0244-0246 Oric IRQ Vector
;0247-0249 Oric NMI Vector
;024A-024C -
;024D	 Tape Speed(0)
;024E-0259 -
;025A-025F Tape work bytes (0)
;0260-027E -
;027F-028F Tape Filename to be loaded
;0290-0292 -
;0293-02A3 Tape Filename just loaded
;02A4-02A7 -
;02A8      Tape -
;02A9      Tape Start Address Lo
;02AA      Tape Start Address Hi
;02AB      Tape End Address Lo
;02AC      Tape End Address Hi
;02AD      Tape Program Type (0)
;02AE      Tape Auto Indicator (0 for off)
;02AF      Tape Array Type
;02B0      Tape
;02B1      Tape Format Error
;02B2      -

#define	SYS_IRQVECTORLO	$0245
#define	SYS_IRQVECTORHI	$0246

;Controller Codes --FUD-RL
#define	CONTROLLER_LEFT	1
#define	CONTROLLER_RIGHT	2
#define	CONTROLLER_FIRE1	32
#define	CONTROLLER_UP	16
#define	CONTROLLER_DOWN	8

#define	CONTROLLER_FLEFT	32+1
#define	CONTROLLER_FRIGHT	32+2

;Ethan Graphic Codes
#define	ETHAN_STANDING	0
#define	ETHAN_RUN		1
#define	ETHAN_RUN_END	15	;One after
#define	ETHAN_JUMP	16
#define	ETHAN_JUMP_END	27	;Last one
#define	ETHAN_SEARCHING	15

;Ethan Actions
#define	ACTION_STANDING	0
#define	ACTION_RUNNING	1
#define	ACTION_JUMPING	2
#define	ACTION_SEARCHING	3
#define	ACTION_FALLING	4
#define	ACTION_DIEING	5

;Ethans location
#define	IN_ROOM		0
#define	IN_CORRIDOR         1
#define	IN_SIMONCOMPUTER    2
#define	IN_TERMINAL         3
#define	IN_POCKETCOMPUTER   4
#define	IN_PHONEMENU        5

;Ethan Facing Codes
#define	FACING_LEFT	0
#define	FACING_RIGHT	1

;Droid Actions
#define	ACTION_MOVING		0
#define	ACTION_LOOKBACK               1
#define	ACTION_RETURNTOCOURSE         2
#define	ACTION_TURN                   3
#define	ACTION_SPARK                  4
#define	ACTION_WAIT                   5

;Droid Codes
#define	DROIDLEFT          	0
#define	DROIDLEFTTURNRIGHT1 1
#define	DROIDLEFTTURNRIGHT2 2
#define	DROIDLEFTTURNRIGHT3 3
#define	DROIDRIGHT          4


#define	END		0	;-
#define	PLATFORM		1	;x,y,l
#define	LIFTSHAFT           2	;g,x,y,l
#define	LIFTPLATFORMS	3	;g,dl,cl
#define	FURNITURE_          4	;x,y,f
#define	DROID               5	;x,y,l,t
#define	ENTRANCE     	6	;x,y
#define	OBJECT		7	;x,y,o
#define	REPEATOBJECT	8	;x,y,o,d,r
#define	DS_OBJECT		9	;x,y,o But to Screen
#define	DS_REPEATOBJECT	10	;x,y,o,d,r But to Screen

;Room Lift Groups
#define	GROUP0		0
#define	GROUP1		1
#define	GROUP2		2
#define	GROUP3		3
#define	GROUP4		4
#define	GROUP5		5
#define	GROUP6		6
#define	GROUP7		7

;Furniture
#define	BASEOFFURNITURE	122
#define	TERMINAL_		0
#define	SOFA		1
#define	FIREPLACE           2
#define	TOILET              3
#define	DRAWERS             4
#define	ARMCHAIR            5
#define	DESK                6
#define	BED             	7
#define	SINK            	8
#define	BATH            	9
#define	BOOKCASE        	10
#define	CANDY           	11
#define	SPEAKER         	12
#define	HIFI            	13
#define	LAMP            	14
#define	COMPUTER        	15
#define	TAPESTREAMER    	16
#define	HARDDISK        	17
#define	HARDDISK2    	18
#define   BASKET   		19
#define   FAGDISPENSER    	20
#define   TELEX           	21
#define   FRIDGE	   	22
#define   DOORWAY         	23
#define   SIMONCONSOLE    	24
#define	PICTURE		25
#define	WORKTOP		26

;Objects
;000-012 Simon Computer parts
;013-016 Droid Spark Frames
;017-026 Room Parts
;027-054 Puzzle Pieces
;055-066 Shaft Parts(shm_)
;067-068 Shaft Parts
;069-087 Security Terminal Parts
;088-111 Pocket Computer Buttons
;112-120 Puzzle Cursor Parts
;121     Work Puzzle Piece
;122-148 Furniture Graphics
;149-153 Spare
;154     Searching Bar Graphic
;155-167 Map of Rooms Parts
;168-169 Simon Cursors
;170     Work Puzzle Piece!
;171     Aargh Bubble
;172-174 Doorway opening frames
;175     Simon room graphic

#define	OBJ_TLSIMONBORDER		0
#define	OBJ_TSIMONBORDER              1
#define	OBJ_TRSIMONBORDER             2
#define	OBJ_LSIMONBORDER              3
#define	OBJ_RSIMONBORDER              4
#define	OBJ_BLSIMONBORDER             5
#define	OBJ_BSIMONBORDER              6
#define	OBJ_BRSIMONBORDER             7
#define	OBJ_SIMONBLACKCELL            8
#define	OBJ_SIMONWHITECELL            9
#define	OBJ_SIMONBLACKCROSS      	10
#define	OBJ_SIMONWHITECROSS           11	;?
#define	OBJ_SIMONBOTTOMPIPE		12
;13-16 Droid Sparks
#define	OBJ_SIMONBLACKCURSOR	168
#define	OBJ_SIMONWHITECURSOR	169
#define	OBJ_WORKPUZZLEAREA		170

;Lift GFX(Rooms)
#define	SHAFTGFX			17
#define	PLATFORMGFX		18
#define	LIFTGFX			19
#define	WALLGFX			20
#define	MAINSHAFTLIFTGFX 	  	21
#define	MAINSHAFTCORRIDORGFX          22	;?
#define	ENTRANCEGFX		23
#define	SEARCHFOUNDRESETLIFTGFX  	24
#define	SEARCHFOUNDSNOOZEDROIDGFX     25
#define	SEARCHWINDOWGFX		26
#define	PUZZLEPIECE00		27
#define	PUZZLEPIECE01		28
#define	PUZZLEPIECE02		29
#define	PUZZLEPIECE03		30
#define	PUZZLEPIECE04		31
#define	PUZZLEPIECE05		32
#define	PUZZLEPIECE06		33
#define	PUZZLEPIECE07		34
#define	PUZZLEPIECE08		35
#define	PUZZLEPIECE09		36
#define	PUZZLEPIECE10		37
#define	PUZZLEPIECE11		38
#define	PUZZLEPIECE12		39
#define	PUZZLEPIECE13		40
#define	PUZZLEPIECE14		41
#define	PUZZLEPIECE15		42
#define	PUZZLEPIECE16		43
#define	PUZZLEPIECE17		44
#define	PUZZLEPIECE18		45
#define	PUZZLEPIECE19		46
#define	PUZZLEPIECE20		47
#define	PUZZLEPIECE21		48
#define	PUZZLEPIECE22		49
#define	PUZZLEPIECE23		50
#define	PUZZLEPIECE24		51
#define	PUZZLEPIECE25		52
#define	PUZZLEPIECE26		53
#define	PUZZLEPIECE27		54
#define	SHM_NONEXISTANT		55
#define	SHM_ROOM     		56	;???
#define	SHM_SHAFT                     57
#define	SHM_SHAFTTL                   58
#define	SHM_SHAFTTR                   59
#define	SHM_SHAFTBL                   60
#define	SHM_SHAFTBR                   61
#define	SHM_SHAFTTLTR                 62
#define	SHM_SHAFTTLBR                 63
#define	SHM_SHAFTBLTR                 64
#define	SHM_SHAFTBLBR                 65
#define	SHM_TEMPLATE		66
#define	MAINSHAFTLIFTCABLES		67
#define	COLOURATTRIBUTEYELLOWCYAN	68

;#define	MAINSHAFTLIFTWALL		69
;#define	EARTHBLOCK0		70
;#define	EARTHBLOCK1		71
;#define	EARTHBLOCK2		72
;#define	EARTHBLOCK3		73
;#define	CORRIDORCOLUMN       	74
;#define	CORRIDORLITCORRIDOR           75
;#define	CORRIDORUNLITCORRIDOR         76
;#define	CORRIDORLIFTGATE              77

#define	OBJ_UPPOWER	 	88
#define	OBJ_UPFLIP	          89
#define	OBJ_UPMIRROR	          90
#define	OBJ_UPUNDO	          91
#define	OBJ_UPDISK	          92
#define	OBJ_UPAMBER	          93
#define	OBJ_UPGREEN	          94
#define	OBJ_UPWHITE	          95
#define	OBJ_UPMODEM	          96
#define	OBJ_UPSOUND	          97
#define	OBJ_UPSTATS	          98
#define	OBJ_UPPAUSE	          99
#define	OBJ_DOWNPOWER	          100
#define	OBJ_DOWNFLIP	          101
#define	OBJ_DOWNMIRROR	          102
#define	OBJ_DOWNUNDO	          103
#define	OBJ_DOWNDISK	          104
#define	OBJ_DOWNAMBER	          105
#define	OBJ_DOWNGREEN	          106
#define	OBJ_DOWNWHITE	          107
#define	OBJ_DOWNMODEM	          108
#define	OBJ_DOWNSOUND	          109
#define	OBJ_DOWNSTATS	          110
#define	OBJ_DOWNPAUSE	          111

#define	VOIDPUZZLEPIECE		121
#define	SPEECHAARGH		171

;For RepeatDisplayGraphicObject routine
#define	REPEATOBJECTDOWN		0
#define	REPEATOBJECTRIGHT		1

;Droid Script Commands
#define	SETSPEED			0
#define	MOVE                          1
#define	LOOKBACK                      2
#define	ONSENSE                       3
#define	RETURNTOCOURSE                4
#define	ONENDOFRAIL                   5
#define	TURN                          6
#define	SPARK                         7
#define	JUMP                          8
#define	WAIT                          9
#define	FACE                          10

#define	TOENDOFRAIL		128

#define	SPARKSTART		0
#define	SPARKEND 			4

;Room Lift Statii
#define	LIFT_STATIC		0
#define	LIFT_GOINGDOWN		1
#define	LIFT_GOINGUP		2

#define	SEARCH_OFF		0
#define	SEARCH_ON			1

;SFX Command Codes
#define	SETCHANNEL_A		0
#define	SETCHANNEL_B       		1
#define	SETCHANNEL_C       		2
#define	SETCHANNEL_A_   		3
#define	SETCHANNEL_A_E   		4
#define	SETCHANNEL_A_N   		5
#define	SETCHANNEL_A_NE   		6
#define	SETCHANNEL_A_T   		7
#define	SETCHANNEL_A_TE   		8
#define	SETCHANNEL_A_TN   		9
#define	SETCHANNEL_A_TNE   		10
#define	SETCHANNEL_B_   		11
#define	SETCHANNEL_B_E   		12
#define	SETCHANNEL_B_N   		13
#define	SETCHANNEL_B_NE   		14
#define	SETCHANNEL_B_T   		15
#define	SETCHANNEL_B_TE   		16
#define	SETCHANNEL_B_TN   		17
#define	SETCHANNEL_B_TNE   		18
#define	SETCHANNEL_C_   		19
#define	SETCHANNEL_C_E   		20
#define	SETCHANNEL_C_N   		21
#define	SETCHANNEL_C_NE   		22
#define	SETCHANNEL_C_T   		23
#define	SETCHANNEL_C_TE   		24
#define	SETCHANNEL_C_TN   		25
#define	SETCHANNEL_C_TNE   		26
#define	SETPITCH   		27
#define	SETVOLUME       		28
#define	PLAY            		44
#define	END_A_OFF          		94
#define	END_B_OFF          		95
#define	END_AB_OFF         		96
#define	END_C_OFF          		97
#define	END_AC_OFF         		98
#define	END_BC_OFF         		99
#define	END_ABC_OFF        		100
#define	SFXJUMP         		101
#define	ADJUSTVOLUME		102+15
#define	LOOPONVOLUMERANGE		133
#define	LOOPONCOUNTERRANGE		134
#define	SETNOISE			135
#define	SETENV			167
#define	TRIGGER_SAWTOOTH   		168
#define	TRIGGER_TRIANGLE   		169
#define	TRIGGER_DESCEND    		170
#define	TRIGGER_ASCEND     		171
#define	ADJUSTPITCH     		172+15
#define	END_NORMAL         		203
#define	SETCOUNTER      		204
#define	RANDOM_HIGH		0

;SFX's
#define	SFX_HIGHBEEP     		0
#define	SFX_LOWBEEP                   1
#define	SFX_MIDBEEP                   2
#define	SFX_FOUNDLETTER               3
#define	SFX_DIALTONE                  4
#define	SFX_DIALDIGIT                 5
#define	SFX_MODEMTALK                 6
#define	SFX_SCSCALE                   7
#define	SFX_FOOTSTEPLEFT              8
#define	SFX_FOOTSTEPRIGHT             9
#define	SFX_ROBOTPLASMA               10
#define	SFX_LIFTSTART                 11
#define	SFX_LIFTEND                   12
#define	SFX_ROBOTTURN                 13
#define	SFX_ROBOTMOTORS               14
#define	SFX_PLASMAKILL                15
#define	SFX_ROOMFOOTSTEP		16
#define	SFX_ROOMLIFTSTART		17
#define	SFX_ROOMLIFTEND		18
#define	SFX_CORRIDORFOOTSTEPS	19
#define	SFX_ELECTRICUTION		20
#define	SFX_DEATHBYHEIGHT		21


;Collision Values(B0-4)
#define	COL_BACKGROUND		$00 
#define	COL_WALL                      $01 	;W
#define	COL_ENTRANCE                  $02 	;E
#define	COL_PLATFORM                  $03	;P
#define	COL_CHASM			$04	;C Gap in floor at base of screen (also shaft at base)
#define	COL_MAINFOYERLIFT             $05 
#define	COL_FURNITUREITEM00           $08	;F 
#define	COL_FURNITUREITEM01           $09 
#define	COL_FURNITUREITEM02           $0A 
#define	COL_FURNITUREITEM03           $0B 
#define	COL_FURNITUREITEM04           $0C 
#define	COL_FURNITUREITEM05           $0D 
#define	COL_FURNITUREITEM06           $0E 
#define	COL_FURNITUREITEM07           $0F 
#define	COL_FURNITUREITEM08           $10 
#define	COL_FURNITUREITEM09           $11 
#define	COL_FURNITUREITEM10           $12 
#define	COL_FURNITUREITEM11           $13 
#define	COL_LIFTPLATFORM0		$14	;L
#define	COL_LIFTPLATFORM1             $15 
#define	COL_LIFTPLATFORM2             $16 
#define	COL_LIFTPLATFORM3             $17 
#define	COL_LIFTPLATFORM4             $18 
#define	COL_LIFTPLATFORM5             $19
#define	COL_LIFTPLATFORM6             $1A
#define	COL_LIFTPLATFORM7             $1B
;B5-7	Enemies
;	1      Spark
;	2      Orb
;	3-7(6) Robots
#define	COL_SPARK			32
#define	COL_ORB			32*2
#define	COL_DROID0		32*3
#define	COL_DROID1		32*4
#define	COL_DROID2		32*5
#define	COL_DROID3		32*6
#define	COL_DROID4		32*7


;Collision Values(B5-7)
#define	COL_SPARK			32*1
#define	COL_ORB			32*2
#define	COL_ROBOT0		32*3
#define	COL_ROBOT1		32*4
#define	COL_ROBOT2		32*5
#define	COL_ROBOT3		32*6
#define	COL_ROBOT4		32*7


;Command Constant Parameters
#define	scOFF			0
#define	scON			1
#define	scSAWTOOTH		12
#define	scTRIANGLE		14
#define	scCHANNEL_A		0
#define	scCHANNEL_B		1
#define	scCHANNEL_C		2
#define	ONCOUNTERNOTZERO		0

;Monitor Part Objects
#define	MON_PART0                     69
#define	MON_PART1                     70
#define	MON_PART2                     71
#define	MON_PART3                     72
#define	MON_PART4                     73
#define	MON_PART5                     74
#define	MON_PART6                     75
#define	MON_PART7                     76
#define	MON_PART8                     77
#define	MON_PART9                     78
#define	MON_PART10                    79
#define	MON_PART11                    80
#define	MON_PART12                    81
#define	MON_PART13                    82
#define	MON_PART14                    83
#define	MON_PART15		84
#define	MON_PART16		85
#define	MON_PART17		86
#define	MON_PART18		87

;Puzzle cursor parts
#define	PUZZLECURSORHORIZONTAL	112
#define	PUZZLECURSORVERTICAL          113
#define	PUZZLECURSORDELETEDHORIZTOP   116
#define	PUZZLECURSORDELETEDVERTICAL   117
#define	PUZZLECURSORDELETEDHORIZBOT	120

;Puzzle Memory Arrows
#define	PUZZLEMEMORYARROWUP		114
#define	PUZZLEMEMORYARROWDOWN   	115
#define	PUZZLEMEMORYDELETEDARROWUP	118
#define	PUZZLEMEMORYDELETEDARROWDOWN  119

;Screen Codes (Main Shaft and Corridors)
#define	LSM_EARTHMIX0                 0
#define	LSM_EARTHMIX1                 1
#define	LSM_EARTHMIX2                 2
#define	LSM_EARTHMIX3                 3
#define	LSM_LEFTCORRIDORSTRIP         4
#define	LSM_LEFTCORRIDORSHADOW        5
#define	LSM_LEFTCORRIDORCOLUMNS       6
#define	LSM_LEFTCORRIDORFLOOR         7
#define	LSM_RIGHTCORRIDORSTRIP        8
#define	LSM_RIGHTCORRIDORSHADOW       9
#define	LSM_RIGHTCORRIDORCOLUMNS      10
#define	LSM_RIGHTCORRIDORFLOOR        11
#define	LSM_LEFTRIGHTCORRIDORSTRIP    12
#define	LSM_LEFTRIGHTCORRIDORSHADOW   13
#define	LSM_LEFTRIGHTCORRIDORCOLUMNS  14
#define	LSM_LEFTRIGHTCORRIDORFLOOR    15

;Bits
#define	BIT0			1
#define	BIT1                          2
#define	BIT2                          4
#define	BIT3                          8
#define	BIT4                          16
#define	BIT5                          32
#define	BIT6                          64
#define	BIT7                          128

;Map of Rooms Objects
#define	MOR_ROOM       		155
#define	MOR_CONTROLROOM               156
#define	MOR_SIMONROOM		175
#define	MOR_BLANK                     157
#define	MOR_SHAFT                     158
#define	MOR_SH_TR                     159
#define	MOR_SH_TL                     160
#define	MOR_SH_TLTR                   161
#define	MOR_SH_BR                     162
#define	MOR_SH_BRTL                   163
#define	MOR_SH_BL                     164
#define	MOR_SH_BLTR                   165
#define	MOR_SH_BLBR                   166
#define	MOR_TEMPLATE		167

;Special Rooms
#define	ROOM_SIMON		8
#define	ROOM_CONTROL		29
#define	ROOM_SECURITYTERMINAL	32

;Colours
#define	INK_BLACK			0
#define	INK_RED                       1
#define	INK_GREEN                     2
#define	INK_YELLOW                    3
#define	INK_BLUE                      4
#define	INK_MAGENTA                   5
#define	INK_CYAN                      6
#define	INK_WHITE                     7
#define	PAPER_BLACK		16
#define	PAPER_RED                     17
#define	PAPER_GREEN                   18
#define	PAPER_YELLOW                  19
#define	PAPER_BLUE                    20
#define	PAPER_MAGENTA                 21
#define	PAPER_CYAN                    22
#define	PAPER_WHITE                   23

;Lift shaft collision codes
#define	LSM_BACKGROUND		0
#define	LSM_WALL                      1
#define	LSM_ENTRANCE                  2
#define	LSM_PLATFORM                  3
#define	LSM_FOYERLIFT                 5

;Time constants
#define	TIME_ONMODEM		2	;Minutes

#define	ROOMTEXT_DESTROYHIMMYROBOTS	20
#define	ROOMTEXT_BLANK                1
#define	ROOMTEXT_NO                   2
#define	ROOMTEXT_YOUDIED              3
#define	ROOMTEXT_CONGRATULATIONS      4
#define	ROOMTEXT_FOUNDNOTHING         5
#define	ROOMTEXT_FOUNDPUZZLEPIECE     6
#define	ROOMTEXT_FOUNDLIFTRESET       7
#define	ROOMTEXT_FOUNDSNOOZE          8
#define	ROOMTEXT_JUST30SECONDS        9
#define	ROOMTEXT_JUST30MINUTESLEFT    10
#define	ROOMTEXT_SIMONFAILED       	11
#define	ROOMTEXT_SIMONSUCCESS        	12
#define	ROOMTEXT_SIMONENTER		24

