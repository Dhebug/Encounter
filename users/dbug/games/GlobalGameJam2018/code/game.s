
;#include "loader_api.h"


	.zero

selected_option		.dsb 1
selected_offset     .dsb 1   ; 0, 40 or 80

day_of_the_week     .dsb 2
	
	.text

#define SET_DAY(message)			lda #<message:sta day_of_the_week+0:lda #>message:sta day_of_the_week+1

#define PRINT_HIRES(message)		lda #0:sta _PrintHiresX:lda #<message:sta _PrintMessagePtr+0:lda #>message:sta _PrintMessagePtr+1:jsr _PrintTextHires
#define PRINT_TEXT(message)			lda #0:sta _PrintScreenX:lda #<message:sta _PrintMessagePtr+0:lda #>message:sta _PrintMessagePtr+1:jsr _PrintSelectedText



_WaitOneSecond
.(
	pha
	txa 
	pha
	ldx #50
loop
	jsr _VSync
	dex
	bne loop

	pla
	tax
	pla
	rts
.)

_WaitThreeSeconds
	rts  ; ----------- comment out in final version
	jsr _WaitOneSecond
	jsr _WaitOneSecond
	jsr _WaitOneSecond
	rts


_GameStart
.(
	;jmp sunday
	jsr _WaitThreeSeconds
	jsr _LoadTitleScreen
	jsr _WaitThreeSeconds

	PRINT_HIRES(_MessageWelcomeToTelegraphHero)

	jsr _WaitThreeSeconds
	jsr _WaitThreeSeconds
	jsr _WaitThreeSeconds


    ; 
    ; _MorseTableCount
    ; _MorseTableBitmask
    ;
    .(
    lda #"A"
    jsr _DisplayMorseString
    /*
    sta _MessageMorse_PATCH_character
    sec
    sbc #"0" //65   ; Now we have 0
    tax 
    lda _MorseTableCount,x            // A=count
    tay                               // Y=count
    lda _MorseTableBitmask,x          // A = bitmask
    sta tmp0
    ldx #0    
loop_morse
    rol tmp0      // Get the dot/dash
    bcc dot          // Is it a dot
dash
    lda #"-"
	jmp end_dot
dot
    lda #"."
end_dot
    sta _MessageMorse_PATCH_code,x
    inx
    dey 
	bne loop_morse    
	lda #" "
    sta _MessageMorse_PATCH_code,x
	PRINT_HIRES(_MessageMorseCodeLetter)
	*/
	.)


    lda #"Z"
    jsr _DisplayMorseString
    //sta _MessageMorse_PATCH_character
	//PRINT_HIRES(_MessageMorseCodeLetter)

    lda #"9"
    jsr _DisplayMorseString
    //sta _MessageMorse_PATCH_character
	//PRINT_HIRES(_MessageMorseCodeLetter)

    ; So things don't wrap forever...
	jsr _LoopForever


	jmp _GameStart
.)


_DisplayMorseString
    //jmp _DisplayMorseString
.(
    sta _MessageMorse_PATCH_character
    sec
    sbc #"0" //65   ; Now we have 0
    //sbc #65   ; Now we have 0
    tax 
    lda _MorseTableCount,x            // A=count
    tay                               // Y=count
    lda _MorseTableBitmask,x          // A = bitmask
    sta tmp0
    ldx #0    
loop_morse
    rol tmp0      // Get the dot/dash
    bcc dot          // Is it a dot
dash
    lda #"-"
	jmp end_dot
dot
    lda #"."
end_dot
    sta _MessageMorse_PATCH_code,x
    inx
    dey 
	bne loop_morse    
	lda #5
    sta _MessageMorse_PATCH_code,x

	PRINT_HIRES(_MessageMorseCodeLetter)

	rts
.)

 
_SelectOption
.(
	lda #0
	sta selected_option
loop	
	; Select based on choice
	ldx selected_option
	beq selectFirst
	dex
	beq selectSecond
	bne selectThird

display
	sta $bb80+40*25
	stx $bb80+40*26
	sty $bb80+40*27

	; Hack to get a null terminator...
	lda #0
	sta $bb80+40*25+39
	sta $bb80+40*26+39
	sta $bb80+40*27+39

_ReadKeyboard
	jsr _WaitNoKeyPressed
waitKey	
	lda _KeyboardStateMemorized
	beq waitKey
	lsr
	lsr
	lsr
	bcs up
	lsr
	bcs down
	lsr
	bcs select
	jmp loop

selectFirst
    lda #0
    sta selected_offset
	lda #16+1
	ldx #16+0
	ldy #16+0
	jmp display

selectSecond
    lda #40
    sta selected_offset
	lda #16+0
	ldx #16+1
	ldy #16+0
	jmp display

selectThird
    lda #80
    sta selected_offset
	lda #16+0
	ldx #16+0
	ldy #16+1
	jmp display

up
	dec selected_option
	bpl done_up
	ldx #2
	stx selected_option
done_up
	jmp loop

down
	ldx selected_option
	inx
	cpx #3
	bne done_down
	ldx #0
done_down
	stx selected_option
	jmp loop

select	
    ; Copy the selected message to the history log
    clc
    lda #<$bb80+40*25+1
    adc selected_offset
    sta _PrintMessagePtr+0
    lda #>$bb80+40*25+1
    adc #0
    sta _PrintMessagePtr+1:

    ldx #0
    stx _PrintHiresX
    jsr _PrintTextHiresNoScroll

    jsr _EraseTextArea
    rts

.)





_LoopForever
	jmp _LoopForever
