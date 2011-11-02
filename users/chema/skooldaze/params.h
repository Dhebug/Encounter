;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;Main definitions
;;----------------

; Rom addresses 
#define _hires		$ec33
#define _text		$ec21
#define _ping		$fa9f
#define _shoot		$fab5
#define _zap		$fae1
#define _explode	$facb
#define _kbdclick1	$fb14
#define _kbdclick2	$fb2a
#define _cls		$ccce
#define _lores0		$d9ed
#define _lores1		$d9ea

; Attributes 
#define A_FWBLACK        0
#define A_FWRED          1
#define A_FWGREEN        2
#define A_FWYELLOW       3
#define A_FWBLUE         4
#define A_FWMAGENTA      5
#define A_FWCYAN         6
#define A_FWWHITE        7
#define A_BGBLACK       16
#define A_BGRED         17
#define A_BGGREEN       18
#define A_BGYELLOW      19
#define A_BGBLUE        20
#define A_BGMAGENTA     21
#define A_BGCYAN        22
#define A_BGWHITE       23

; Game constants 

#define MAX_CHARACTERS	21
#define SKOOL_ROWS		21
#define SKOOL_COLS		128
#define FIRST_VIS_COL	2
#define LAST_VIS_COL	37
#define VISIBLE_COLS	(LAST_VIS_COL-FIRST_VIS_COL+1)	
#define SRB_SIZE		105

; Offscreen position (for pellets). Keep it >128 and <255-3
#define OFFSCREEN_POS	200

; Buffer width for lesson/lines box.
#define BUFFER_TEXT_WIDTH 11	

; Ticks to change the lesson (originally $1500=5376)
#define LESCLK_VAL		($d00)

; Value of the high byte that marks when the teacher tells the kids to sit down (originally 15)
#define CLASS_START		(9)	  		

; Visibility ranges for characters
#define VIS_RANGE_X		14+1
; This is not used
#define VIS_RANGE_Y		14


; Eric's main timer constants
#define INITIAL_ERIC_TIMER	17-4
#define NORMAL_ERIC_TIMER	9-4-2
#define FAST_ERIC_TIMER		4-2
#define MIDS_ERIC_TIMER		5-2

;;;; Conditional compiling and optimizations

;; Partial support for AIC mode... necessary if we want colors
#define AIC_SUPPORT

;; Tries to get rid of unnecessary jsr instructions
#define AVOID_JSRS

;; Substitutes the multiplying with a big (512) table, not much optimization though.
//#define FULLTABLEMUL8

;; Avoid Oricutron's bug with ror addr,x (version 0.7)
//#define AVOID_ORICUTRON_BUG

;; Inverse things to get white bubbles
#define WHITE_BUBBLES

;; Center play area
#define CENTER_PLAY_AREA

;; Use the brk trick to set tmp0 and save some memory
#define BRK2SETTMP0

;; Use a long version of Au Claire...
#define USE_THREE_TUNES

;; Other characters may produce sfx when hitting
#define OTHERS_DOSND

;; Einstein may lie sometimes about blackboard defacement and being hit
//#define EINSTEIN_LIES

;; Ticks before a teacher may give lines to Eric after another teacher did so.
;; Originally this was 150 and half of this value (75) was used if a different teacher was to give lines
;; This has been simplified, but remember ticks here are quicker.

#define LINES_DELAY_VAL 100

;; Definitions for characters

#define CHAR_ERIC		 0
#define CHAR_EINSTEIN	 1
#define CHAR_ANGELFACE	 2
#define CHAR_BOYWANDER	 3
#define CHAR_BOY1		 4
#define CHAR_BOY2		 5
#define CHAR_BOY3		 6
#define CHAR_BOY4		 7
#define CHAR_BOY5		 8
#define CHAR_BOY6		 9
#define CHAR_BOY7		10
#define CHAR_BOY8		11
#define CHAR_BOY9		12
#define CHAR_BOY10		13
#define CHAR_BOY11		14
#define CHAR_CREAK		15
#define CHAR_ROCKITT	16
#define CHAR_WACKER		17
#define CHAR_WITHIT		18
#define CHAR_EPELLET	19
#define CHAR_BPELLET	20

#define CHAR_FIRST_TEACHER CHAR_CREAK

;;; Character flags field

; Original Spectrum flags field is
;0 Restart the command list at the next opportunity if bit 1 is reset (see 25126) 
;1 Always reset 
;2-3 Unused 
;4 Character is a teacher (checked by 25367) 
;5 Character is walking fast continuously (set for pellets and stampeding boys; see 27246) 
;6 Character is walking slowly continuously (always reset, but checked by 25367) 
;7 Character is walking slowly (see 25266) 


#define RESET_COMMAND_LIST	 1
#define UNKNOWN				 2
#define IS_FACING_RIGHT		 4
#define FREE				 8
#define IS_TEACHER			 16
#define IS_FAST_WALK		 32
#define IS_SLOW_CONTINUOUS	 64
#define IS_SLOW_WALK		128



; Eric's status flags
; 0 ERIC is firing the catapult
; 1 ERIC is hitting 
; 2 ERIC is jumping
; 3 ERIC is being spoken to by little boy no. 10
; 4 ERIC has just been knocked down or unseated
; 5 ERIC is writing on a blackboard 
; 6 Unused (always reset)
; 7 ERIC is sitting or lying down

#define ERIC_FIRING			1
#define ERIC_HITTING		2
#define ERIC_JUMPING		4
#define ERIC_SPOKEN			8
#define ERIC_DOWN			16
#define ERIC_WRITTING		32

#define ERIC_SITTINGLYING	128


;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Lesson descriptors
;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Each entry in this table defines the teacher for the period 
; (if any), and the room. The teacher is identified by bits 4-6
;
; Bits Teacher 
#define DES_ROCKITT	%0000
#define DES_WACKER	%0001
#define DES_WITHIT	%0010
#define DES_CREAK	%0011
#define DES_NONE	%0100

; The room is identified by bits 0-3
; Bits Room 
#define DES_READING	%0001
#define DES_MAP		%0010
#define DES_WHITE	%0011
#define DES_EXAM	%0100
#define DES_LIBRARY	%0101
#define DES_DINNER	%0110
#define DES_PLAY	%0111



;;; Collision map
#define WALLTOPFLOOR		77
#define WALLMIDDLEFLOOR		53
#define WALLMIDDLEFLOOR2	107

;; Stairs

; The bottom and top cols are all equal
#define STAIRLBOTTOM		24+1
#define STAIRLTOP			STAIRLBOTTOM-7
#define STAIRRBOTTOM		96-1
#define STAIRRTOP			STAIRRBOTTOM+7


; Position of chairs
; Reading room

#define CH_READR			74	
#define CH_READL			62	

; Map room
#define CH_MAPR				96	
#define CH_MAPL				84	

; White room
#define CH_WHITER			50	
#define CH_WHITEL			38	

; Exam room
#define CH_EXAMAR			87	
#define CH_EXAMAL			75	
#define CH_EXAMBR			70	
#define CH_EXAMBL			58	

; Position of blackboards
#define COL_EXAM_BOARD		55
#define COL_WHITE_BOARD		34
#define COL_READING_BOARD	56



