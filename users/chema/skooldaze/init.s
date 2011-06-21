

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Init code
;; ---------------------


#include "params.h"
#include "text.h"

; Ticks to change the lesson (originally $1500=5376)
; Why is this particular define not included from params.h?
#define LESCLK_VAL		5376 



#define _hires		$ec33
#define _text		$ec21
#define _ping		$fa9f

.zero

tmp0	.dsb 2
tmp1	.dsb 2
tmp2	.dsb 2
tmp3	.dsb 2
tmp4	.dsb 2
tmp5	.dsb 2
tmp6	.dsb 2
tmp7	.dsb 2
op1		.dsb 2
op2		.dsb 2
tmp		.dsb 2
;reg0	.dsb 2
;reg1	.dsb 2
;reg2	.dsb 2
;reg3	.dsb 2
;reg4	.dsb 2
;reg5	.dsb 2
;reg6	.dsb 2
;reg7	.dsb 2

#define        via_t1cl                $0304 


.text

; Main procedure.

_main
.(
	jsr _GenerateTables 

	jsr _hires
	//paper(6);ink(0);

	lda #6
	ldy #0        
    sty $2e0
	sta $2e1
	sty $2e2
	jsr $f204      ;paper
	
	ldy #0 
	sty $2e0
	sty $2e1
	sty $2e2
	jsr $f210      ;ink

	jsr _init_irq_routine 

	; Set demo mode
	jsr set_demo_mode

	jsr _init
	jmp _test_loop
.)


;; Resets the game flags
reset_flags
.(
	; Reset all the game flags
	; after lesson change
	ldy #4
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
	;jsr reset_flags

	; Initialize other game flags
	lda #0
	sta vis_col
	sta vis_row 
	sta tile_col
	sta first_col
	sta current_lesson_index


	ldx #20
loop
	; Set initial positions
	lda ini_pos_col,x
	sta pos_col,x
	lda #17
	sta pos_row,x

	; And animatory state, direction and flags

	lda #0
	jsr update_animstate

	lda ini_flags,x
	eor flags,x
	and #IS_FACING_RIGHT
	beq noright
	jsr change_direction
noright

	lda ini_flags,x
	sta flags,x

	; Now the commands
	lda #0
	sta uni_subcom_high,x
	sta cont_subcom_high,x
	sta i_subcom_high,x
	sta command_list_high,x
	sta cur_command_high,x

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

	lda #0
	sta pos_test
loopkk
	jsr write_char_board
	bne loopkk

	; Initialize SRB

	ldx #(21*5-1)
loopsrb
	lda #$fc
	sta SRB,x
	dex
	lda #$ff
	ldy #2
loopsrb2
	sta SRB,x
	dex
	dey
	bpl loopsrb2
	lda #$3f
	sta SRB,x
	dex
	bpl loopsrb


	; First screen render
	jsr render_screen

	; Scroll the screen
	lda #5
	sta tmp4
loops
	jsr _scroll_left
	dec tmp4
	bne loops

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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set and unset demo mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

set_demo_mode
.(
	lda #0
	sta game_mode

	lda #$ff
	sta demo_ff_00+1
	sta demo_ff_002+1

	lda #$10	; $d0 for normal mode
	sta demo_bpl_bne

	rts
.)


unset_demo_mode
.(
	lda #1
	sta game_mode

	lda #$00
	sta demo_ff_00+1
	sta demo_ff_002+1

	lda #$d0	; $10 for demo mode
	sta demo_bpl_bne

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

	; If in demo mode we are finished
	lda game_mode
	bne play_mode

	jsr ReadKey
	beq avoidEric
	
	; A key was pressed, exit demo mode.
	jsr unset_demo_mode
	jsr _init
	jmp _test_loop

play_mode

	; Now move Eric, if it needs be
	jsr deal_with_Eric
	bcs avoidEric

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
	and srb_bitmask
	sta SRB+5,y

	lda SRB+1,y
	and srb_bitmask2
	sta SRB+1,y

	lda SRB+6,y
	and srb_bitmask2
	sta SRB+6,y

	ldy srb_offset_lip
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

#define NUM_KEYS 7
; Keymap table
user_keys 
	.byt	 1, 2, 3, 4
	.byt	"S", "H", "F"				;, "J", "W"
key_routh
    .byt >(up_Eric), >(left_Eric), >(down_Eric), >(right_Eric)
	.byt >(sit_Eric), >(hit_Eric), >(fire_Eric)
key_routl
	.byt <(up_Eric), <(left_Eric), <(down_Eric), <(right_Eric)
    .byt <(sit_Eric), <(hit_Eric), <(fire_Eric)

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
+demo_bpl_bne
	bne loop	; Avoid dealing with Eric
	

	; Print the teacher's name and the room

	jsr uncolor_box

	lda game_mode
	bne notdemo

	; We are in demo mode... print that.
	lda #<demo_msg2
	sta tmp0
	lda #>demo_msg2
	sta tmp0+1

	lda #<buffer_text+BUFFER_TEXT_WIDTH*12
	sta tmp1
	lda #>buffer_text+BUFFER_TEXT_WIDTH*12
	sta tmp1+1

	jsr write_text

	lda #<demo_msg
	sta tmp0
	lda #>demo_msg
	sta tmp0+1

	jmp printit2 

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


