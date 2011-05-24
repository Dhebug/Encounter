;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Auxiliary functions
;; --------------------

#include "params.h"
#include "text.h"

; Ticks to change the lesson (originally $1500=5376)
#define LESCLK_VAL		5376 

;; Resets the game flags
reset_flags
.(
	; Reset all the game flags
	ldy #3
	lda #0
loopf
	sta lesson_status,y
	dey
	bpl loopf
	rts
.)

_init
.(
	; Reset game flags
	jsr reset_flags


	ldx #20
loop
	; Set flags for each character

	cpx #19
	bcc nopellet
	lda #IS_FAST_WALK
	bne doit
nopellet
	cpx #15
	bcc boy
	lda #(IS_TEACHER|IS_SLOW_WALK)
	bne doit
boy
	lda #0	
doit
	sta flags,x

	; Now the commands
	lda #0
	sta uni_subcom_high,x
	sta cont_subcom_high,x
	sta i_subcom_high,x
	sta command_list_high,x

	dex
	bpl loop

	; Initialize game variables
	lda #0
	sta last_char_moved

	; Reset Eric's main action timer
	lda #INITIAL_ERIC_TIMER
	sta Eric_timer
	lda #0
	sta Eric_mid_timer

	; First screen render
	jsr render_screen

	; Initialize the lesson
	lda #$ff
	sta current_lesson_index

	lda #<(LESCLK_VAL)
	sta lesson_clock
	lda #>(LESCLK_VAL)
	sta lesson_clock+1

	jsr change_lesson

	rts
 .)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Test for the main loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


_test_loop
.(
	; Time the frame...
	lda #0
	sta counter


	; Scroll if necessary...
	lda pos_col
	sec
	sbc first_col
	cmp #10-4
	bne noscrollr
	jsr _scroll_right
	jmp noscroll
noscrollr
	cmp #28+4
	bne noscroll
	jsr _scroll_left
noscroll

	; Deal with the lesson timer
	; Decrement it by one
	lda lesson_clock
	sec
	sbc #1
	sta lesson_clock
	bcs nocarry
	dec lesson_clock+1
nocarry
	; Is it time to change the lesson?
	ora lesson_clock+1
	bne notzero
	; It is, doit
	jsr change_lesson	
notzero

	; Now move the characters
	jsr move_chars

	; Now move Eric, if it needs be
	jsr deal_with_Eric

	; See if it is time to move Eric
	dec Eric_timer
	bne avoidEric

	; Reload Eric's main action timer
	lda #NORMAL_ERIC_TIMER
	sta Eric_timer

	; Do we have to move Eric to the midstride position?
	; Is Eric not midstride?
	lda anim_state
	cmp #4
	bcs nomidstride
	lsr
	bcc nomidstride
	ldx #0
	jsr step_character
	
	; Here the original version does something strange..
	lda Eric_mid_timer
	sta Eric_timer
	lda #0
	sta Eric_mid_timer

	; Don't check the keyboard this time
	jmp avoidEric	
nomidstride

	; Time to check the keyboard input
	jsr process_user_input

avoidEric

	; Protect the speech bubble, if any
	lda bubble_on
	beq nobubble

	ldy srb_offset
	lda SRB,y
	and srb_bitmask
	sta SRB,y

	lda SRB+5,y
	and srb_bitmask2
	sta SRB+5,y

	lda SRB+1,y
	and srb_bitmask2
	sta SRB+1,y

	lda SRB+6,y
	and srb_bitmask2
	sta SRB+6,y

	ldy srb_offset_lip
	ora srb_bitmask_lip
	lda SRB,y
	and srb_bitmask_lip
	sta SRB,y

nobubble
	; Render the screen
	jsr render_screen

	; Time before next move...
loop
	lda counter
	beq loop
	jmp _test_loop
.)

#define NUM_KEYS 5
; Keymap table
user_keys 
	.byt	 1, 2, 3, 4
	.byt	"S"				;, "J", "F", "W", "H"	
key_routh
    .byt >(up_Eric), >(left_Eric), >(down_Eric), >(right_Eric)
	.byt >(sit_Eric)
key_routl
	.byt <(up_Eric), <(left_Eric), <(down_Eric), <(right_Eric)
    .byt <(sit_Eric)

process_user_input
.(
	jsr ReadKeyNoBounce
	beq end       	
		
	; Ok a key was pressed, let's check
    ldx #NUM_KEYS-1
loop    
    cmp user_keys,x
    beq found
    dex
    bpl loop
end
	rts

found

    lda key_routl,x
    sta _smc_routine+1
    lda key_routh,x
    sta _smc_routine+2   

	; Some keys shall be read with repetitions
	cpx #4
	bcs call
	ldx #0
	sta oldKey

call
	ldx #0
_smc_routine
	; Call the routine
    jmp $1234   ; SMC     

.)




;; Change the current lesson
change_lesson
.(
	; Reset the lesson clock
	lda #>LESCLK_VAL
	sta lesson_clock+1
	lda #<LESCLK_VAL
	sta lesson_clock

	; Increment current lesson
	inc current_lesson_index

	; Get lesson code from table
	ldx current_lesson_index
	lda main_timetable,x

	; Is it playtime?
	cmp #243
	bcc cont
	; Are we in demo mode?
	ldx game_mode
	beq cont
	; Select a 'special' playtime occasionally
	tax
	jsr randgen
	and #7
	clc
	adc #238
	cmp #243
	bcs cont
	txa	; Get the old identifier
cont
	sta current_lesson

	; Get the lesson descriptor
	sec
	sbc #224
	tax
	lda lesson_descriptors,x
	sta lesson_descriptor

	cmp #254	; Second playtime in a row
	bcs nobell
	; Ring the bell
	jsr _ping
nobell

	; Put the name of teacher and place it in the lesson box

	; Clear all game flags & other matters
	jsr reset_flags

	; Now update all characters
	ldx #MAX_CHARACTERS-3
loop
	; Trigger the command list reset
	lda flags,x
	ora #RESET_COMMAND_LIST
	sta flags,x

	; Pick up the command list number for this lesson 
	; from the character's personal timetable. As they lie in the
	; Last 32 bytes of each page, starting in skool_r00 and the indexes
	; are 224-255, no need for more than the following:

	ldy current_lesson
	txa
	clc
	adc #>skool_r00
	sta smc_ptimetable+2
smc_ptimetable
	lda $1200,y	; Get the personal timetable code for this lesson

	; Now get the pointer to the command list
	tay
	lda command_list_table-128,y
	sta command_list_low,x
	lda command_list_table-127,y
	sta command_list_high,x

	dex
	;bpl loop	; We are dealing with Eric here, just for testing
	bne loop
	


	; Print the teacher's name and the room
	lda game_mode
	bne notdemo

notdemo
	; Get the room's name
	lda #<class_names
	sta tmp0
	lda #>class_names
	sta tmp0+1
	lda lesson_descriptor
	and #%1111
	sec
	sbc #1
	jsr search_string

	lda #<buffer_text+BUFFER_TEXT_WIDTH*12
	sta tmp1
	lda #>buffer_text+BUFFER_TEXT_WIDTH*12
	sta tmp1+1

	jsr write_text

	; Now the teacher's name
	lda lesson_descriptor
	lsr
	lsr
	lsr
	lsr
	cmp #%0100
	bne notnone
	; Is it the library?
	lda lesson_descriptor
	and #%1111
	cmp #DES_LIBRARY
	bne isplaytime
	; Point to REVISION
	lda #EN_REVISION
	bne printit	; This always jumps
	
isplaytime
	lda #<empty_st
	sta tmp0
	lda #>empty_st
	sta tmp0+1
	bne printit2	; This always jumps

notnone	
	and #%11
	clc
	adc #5
printit
	ldx #<names_extras
	stx tmp0
	ldx #>names_extras
	stx tmp0+1
	jsr search_string

printit2
	lda #<buffer_text+BUFFER_TEXT_WIDTH*4
	sta tmp1
	lda #>buffer_text+BUFFER_TEXT_WIDTH*4
	sta tmp1+1

	jsr write_text


	; Now dump the buffer into the screen

	lda #<22*8*40+15+$a000
	sta tmp1
	lda #>22*8*40+15+$a000
	sta tmp1+1

	lda #<buffer_text
	sta tmp0
	lda #>buffer_text
	sta tmp0+1

	jsr dump_text_buffer

	rts
.)



; A real random generator... trying to enhance this...
randgen 
.(
   ;php				; INTERRUPTS MUST BE ENABLED!  We store the state of flags. 
   ;cli 
   lda randseed     ; get old lsb of seed. 
   ora $308			; lsb of VIA T2L-L/T2C-L. 
   rol				; this is even, but the carry fixes this. 
   adc $304			; lsb of VIA TK-L/T1C-L.  This is taken mod 256. 
   sta randseed     ; random enough yet. 
   sbc randseed+1   ; minus the hsb of seed... 
   rol				; same comment than before.  Carry is fairly random. 
   sta randseed+1   ; we are set. 
   ;plp 
   rts				; see you later alligator. 
.)
randseed 
  .word $dead       ; will it be $dead again? 





