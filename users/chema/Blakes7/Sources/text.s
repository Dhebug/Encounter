;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Code for printing texts

; in pixels
#define INITIALX_TEXT   6 
#define INITIALY_TEXT   8

; in pixels
#define FINALX_TEXT     (240-6)

; Attributes 
#define A_FWBLACK        0
#define A_FWRED          1
#define A_FWGREEN        2
#define A_FWYELLOW       3
#define A_FWBLUE         4
#define A_FWMAGENTA      5
#define A_FWCYAN         6
#define A_FWWHITE        7


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print2
; Same as print (below), but pointer passed in tmp0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print2
    lda tmp0
    ldx tmp0+1
#ifdef SPEECHSOUND   
    stx pointer2string+1
    sta pointer2string
#endif
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print
; prints a string in text area
; String pointer passed in a (low) and x (high)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print
.(
	; Get pointer to text string
	sta text+1
	stx text+2

	; Start printing char by char
	ldx #0
#ifndef SPEECHSOUND	
	stx last_nchars_printed
#endif
loop
text
	lda 1234,x		; Get Next letter
	beq end         ; if 0, we are finished

	; If it is a newline, do as if 0
	cmp #11
	beq end

	stx savx+1
	jsr put_code
savx
	ldx #0  ;SMC
	inx
	bne cont
	inc text+2
cont
	jmp loop
	
	ldy print2buffer
	beq end
	ldy buffercounter
	lda #0
	sta str_buffer,y
end
	rts
.)

/*
; Prints num in reg A (00-99)
printnum
.(
    ldx #0
    sec
loop
    inx
    sbc #10
    bcs loop
    dex

    adc #(10+48)
    pha
    txa
    clc
    adc #48   
    jsr put_char
    pla
    jsr put_char
    rts
    
.)
*/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Text functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialize X,Y
; to initial positions
; or set X, Y or both to a given
; position passed in regs X and Y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_init_print
.(
	ldx #0
	stx print2buffer
	stx buffercounter
	stx double_height
	stx capson
	ldx #INITIALX_TEXT
	ldy #INITIALY_TEXT
	jmp relocate_cursor
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Twilighte's code for printing texts...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.zero
screen  .word 00
res_x 	.dsb 1
res_y 	.dsb 1

.text

ascii2code 
	sec
	sbc #32
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; printnl
; prints a string in text area ADDING a newline
; String pointer passed in a (low) and x (high)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printnl
.(
    jsr print
; jmp perform_CRLF ; This is jsr/rts
.)
	
;Perform $CRLF 
perform_CRLF 
        stx res_x 
        sty res_y
        lda Cursor_origin_y 
        clc 
        adc #06 ;Vertical character spacing 
        tay 
        ldx #INITIALX_TEXT  ;Cursor_origin_x 
        jsr relocate_cursor 
        ldx res_x 
        ldy res_y
        rts 

/*
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set X to a given value
; passed in reg X
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+gotoX
    ldy Cursor_origin_y
    jmp gotoXY    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set Y to a given value
; passed in reg Y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+gotoY
    ldx Cursor_origin_x
   ; jmp gotoXY    
*/	
;Relocate Cursor 
;Pass: 
;X X position on screen (Byte alligned 0 to 39) 
;Y Y position on screen (Row alligned 0 to 195) 
gotoXY
relocate_cursor
.( 
        pha 
        ;Calculate screen loc 
        stx Cursor_origin_x 
        sty Cursor_origin_y 
normal
	jsr PixelAddress
cont
        tya
        clc	
        adc tmp0
        bcc noinctmp0
        inc tmp0+1
noinctmp0    
        sta screen
        lda tmp0+1
        sta screen+1

	ldx Cursor_origin_x 
	ldy Cursor_origin_y
        pla
        rts
.)

put_colcombo 
.(	
	cmp #$c0
	php
        pha 
        and #7 
        sta colour_0 
        pla 
        lsr 
        lsr 
        lsr 
        ;lsr 
        and #7 
        sta colour_1
	plp
	bcc put_colour_combo2
        jmp put_colour_combo 
.)

; Puts a space character
put_space
	lda #32
	jsr put_char
	jmp increment_cursor 


;Print character, colour or Carriage return at next cursor position 
;A Character Code 
put_code 
        cmp #128 
        bcs put_colcombo 
        cmp #13 
        beq perform_CRLF
        cmp #32 
        bcc put_colour 
;Print character at next cursor position 
;A Character Code 
put_char 
.(
#ifndef SPEECHSOUND
	inc last_nchars_printed
#endif	
        stx res_x 
        sty res_y

        cmp #97
        bcc nocaps  ; It is not a letter 
        ldx capson
        beq nocaps
        and #$df    ; Uppercase it 
.)
nocaps
.(
        ; Check if we are printing to buffer
        ldy print2buffer
        beq cont

        ldy buffercounter
        sta str_buffer,y
        inc buffercounter
        bne skipme   ; This is allways true
cont    
        jsr ascii2code 
        jsr put_char_direct 
.)
increment_cursor 
.(
        lda Cursor_origin_x
        clc
        adc #6
        sta Cursor_origin_x
        inc screen 
        bne skipme 
        inc screen+1 
+skipme   
        ldx res_x 
        ldy res_y
     
        rts 
.)


;Places the colour combination of colour_0 and colour_1 at the current cursor 
;position and increments the cursor. 
;Pass: 
;colour_0 The first colour 
;colour_1 The second colour  
put_colour_combo2
.(
        stx res_x 
        sty res_y 
	
	lda screen
	sta tmp
	lda screen+1
	sta tmp+1
	
	ldx #4
loop
	ldy #0
	lda colour_0
	sta (tmp),y
	jsr add40tmp
	
	dex
	bpl loop

	ldx #2
loop2
	ldy #0
	lda colour_1
	sta (tmp),y
	jsr add40tmp
	dex	
	bpl loop2
	
        jmp increment_cursor 
.)

;Places the colour in A at the current cursor position and increments the 
;cursor. 
;Pass: 
;A Colour(0-7) 
put_colour 
        sta colour_0 
        sta colour_1 

;Places the colour combination of colour_0 and colour_1 at the current cursor 
;position and increments the cursor. 
;Pass: 
;colour_0 The first colour 
;colour_1 The second colour  
put_colour_combo 
.(
        stx res_x 
        sty res_y 
	
	lda screen
	sta tmp
	lda screen+1
	sta tmp+1
	
	ldx #3
loop
	ldy #0
	lda colour_0
	sta (tmp),y
	lda colour_1
	ldy #40
	sta (tmp),y
	lda #80
	jsr addAtmp
	dex
	bpl loop
        jmp increment_cursor 
.)

;Relocate cursor and Print character 
;Pass: 
;X X position on screen (Byte alligned 0 to 39) 
;Y Y position on screen (Row alligned 0 to 195) 
;A Character Code (ASCII) 
place_char 
        jsr relocate_cursor 
        jsr ascii2code 
put_char_direct
.( 
	sta tmp1+0
	lda #0
	sta tmp1+1

	asl tmp1+0 	; x2
	rol tmp1+1 

	asl tmp1+0 	; x4
	rol tmp1+1 

	asl tmp1+0 	; x8
	rol tmp1+1 

	clc
	lda tmp1+0
	adc #<__charfont
	sta tmp1+0

	lda tmp1+1
	adc #>__charfont
	sta tmp1+1

	lda screen
	sta tmp2
	lda screen+1
	sta tmp2+1

	lda double_height
	bne put_double_heigth
	
	ldx #8
	ldy #0
loop	
	lda (tmp1),y
	sta (tmp2),y

	.(
	inc tmp1+0
	bne skip
	inc tmp1+1
skip	
	.)

	.(
	clc
	lda tmp2+0
	adc #40
	sta tmp2+0
	bcc skip
	inc tmp2+1
skip	
	.)

	dex
	bne loop
	rts
.)

put_double_heigth
.(
	ldx #8
loop	
	ldy #0
	lda (tmp1),y
	sta (tmp2),y
	ldy #40
	sta (tmp2),y
	
	.(
	inc tmp1+0
	bne skip
	inc tmp1+1
skip	
	.)

	.(
	clc
	lda tmp2+0
	adc #80
	sta tmp2+0
	bcc skip
	inc tmp2+1
skip	
	.)

	dex
	bne loop
	rts
.)

colour_0 
 .byt 0 
colour_1 
 .byt 0 

;;; SOME EXTRA FUNCTIONS.... These are kludges... BEWARE
/*
del_char
.(
    sty savy+1
    ldy Cursor_origin_y
    lda Cursor_origin_x
    sec
    sbc #6    
    tax
    jsr relocate_cursor
    lda #75
    jsr put_char_direct
savy
    ldy #0  ;SMC
    rts
.)
*/
; Searches for a string. tmp0 holds pointer to base and x holds offset (in strings).
SearchString
.(
    txa
    bne cont
    rts
cont
    ldy #0
loop
    lda (tmp0),y
    beq out    ; Search for zero
    iny
    bne loop

out
    ; skip consecutive zeros
loopz
    iny
    lda (tmp0),y
    beq loopz
    ; Found the end. Add length to pointer    
    tya
    clc
    adc tmp0
    bcc nocarry
    inc tmp0+1
nocarry
    sta tmp0    

    dex
    bne cont
    
    rts

.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets in reg Y the length
; of the string pointed to
; by tmp0
;;;;;;;;;;;;;;;;;;;;;;;;;;;
StringLength
.(
	ldy #0
loop	
	lda (tmp0),y
	beq done
	iny
	bne loop
done
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; prints a string passed as
; pointer in tmp0 at position
; passed in reg Y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PrintCentered
.(
	lda #<str_buffer
	sta tmp0
	lda #>str_buffer
	sta tmp0+1	

	sty savY+1
	; Get the string length
	jsr StringLength
	; Now Y contains the length of the string (without the ending 0)
	; divide it by 2
	tya
	lsr
	sta tmp1
	; Calculate the column where to start
	lda #19
	sec
	sbc tmp1
	; x6
	asl
	sta tmp1
	asl
	adc tmp1
	
	tax
	; Prepare everything and print
savY
	ldy #0
	jsr gotoXY
	lda #<str_buffer
	sta tmp0
	lda #>str_buffer
	sta tmp0+1	
	jmp print2
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Searches for a string
; and prints it.
; First entry point for passing
; the base pointer in regs X,Y
; (Low, high)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PrintStringWithXY
.(
	stx tmp0
	sty tmp0+1
	tax
.)
SearchStringAndPrint
.(
    jsr SearchString
    jmp print2
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Load a text resource and prints
; a string inside it
; Params: screen pointer must be
; setup to where we are printing
; reg X is the text resource
; and reg A is the string number
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LoadAndPrintString
.(
	pha
	stx resx+1
	jsr LoadString
	tax
	pla
	jsr PrintStringWithXY	
	; Mark the resource as discardable
resx	
	ldx #0
	jmp NukeString
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clears certain areas in the screen. Two entry points
; ClearCommandArea for clearing the area with the command
; sentence and Clear Speech Area for the speech sentence
; at the top of the screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ClearCommandArea
.(
	stx savx+1
	sty savy+1
	pha
	jsr HideMouse
	ldx #<$a000+((ROOM_ROWS+1)*8)*40+1+40
	ldy #>$a000+((ROOM_ROWS+1)*8)*40+1+40
	jmp ClearArea
+ClearSpeechArea
	stx savx+1
	sty savy+1
	pha
	ldx #<$a000+1
	ldy #>$a000+1
ClearArea	
	stx tmp
	sty tmp+1
	
	ldx #8
loop2	
	lda #$40
	ldy #39-1
loop
	sta (tmp),y
	dey
	bpl loop
	
	jsr add40tmp
	dex
	bne loop2
	
	jsr ShowMouse
	; Get registers back
savx
	ldx #0
savy
	ldy #0
	pla
	rts
.)

/*
gets
.(
    lda #<str_buffer
	sta tmp2
    lda #>str_buffer
	sta tmp2+1
	ldy #0
getsloop
	sty savy+1
readloop
	jsr ReadKeyNoBounce
	beq readloop

savy
	ldy #0 ;SMC
	cmp #$0D
	beq endgets
	cmp #$20
	bcc getsloop
	cmp #$7f
	beq backspace
	cpy #$a
	beq getsloop
	sta (tmp2),y
	iny
echochar
    jsr put_char
	jmp getsloop
backspace
	cpy #0
	beq getsloop
	dey
    jsr del_char
	jmp getsloop
endgets
	lda #0
	sta (tmp2),y
	
	rts

.)
*/



/* Prints and deals with game menu */

; Menu strings and so in tables.s
#define NMENUITEMS 7-2

DoMenu
.(
	inc InPause

	; META: Stop AY
	lda ayw_Status
	pha
	lda #%01111111
	ldx #7
	jsr SendAYReg
		
	; Set BW Palette
	jsr SetBWPalette
	
	; Draw menu frame, logo and title
	jsr DrawMenuFrame
	
	; Check if this was the first menu
	; to see if we have to launch the
	; new game/continue menu
	lda MenuShown
	bne menuwasshown
	; Mark menu as shown and proceed
	inc MenuShown
	; Check for a saved game
	jsr CheckForSavedGame
	bne menuwasshown
	; Draw save/load menu
	jsr SaveOptions
	bcs end
	bcc skipm
menuwasshown	
	; Draw menu & handle it	
	jsr MainOptions	
skipm	
	; Remove menu
	jsr RedrawAllScreen
	; Put color back
	jsr SetRoomPalette

end	
	dec InPause	
	; Clear frame time 
	lda #0
	sta LastFrameTime
		
	; Put AY back
	pla
	ldx #7
	jmp SendAYReg ; jsr/rts
.)

DrawMenuFrame
.(
	; Clear menu area
	ldx #((NMENUITEMS+3)*8+3) ; 20 only the logo
	lda #<($a000+8*3*40)
	sta tmp
	lda #>($a000+8*3*40)
	sta tmp+1
.(	
loopl	
	lda #$40
	ldy #38
loopc
	sta (tmp),y
	dey
	bpl loopc
	
	jsr add40tmp
	dex
	bne loopl
.)
	; Draw frame
.(
	lda #<($a000+(8*3+1+7)*40)
	sta tmp
	lda #>($a000+(8*3+1+7)*40)
	sta tmp+1

	lda #<($a000+(8*3+(NMENUITEMS+3)*8-2)*40)
	sta tmp0
	lda #>($a000+(8*3+(NMENUITEMS+3)*8-2)*40)
	sta tmp0+1
	
	ldy #38
	lda #%01111111
loop	
	sta (tmp),y
	sta (tmp0),y
	dey
	bne loop

	jsr add40tmp
	ldx #((NMENUITEMS+3)*8-8-4) ; 20 only the logo
loopv
	lda #%01100000
	ldy #1
	sta (tmp),y
	lda #%01000001
	ldy #38
	sta (tmp),y
	jsr add40tmp
	dex
	bpl loopv
.)

	; Dump logo
	lda #<($a000+(8*3+1)*40+2)
	sta tmp
	lda #>($a000+(8*3+1)*40+2)
	sta tmp+1

	ldx #0
	ldy #0
looplo
	lda logo,x
	sta (tmp),y 
	iny
	cpy #5
	bcc skip
	jsr add40tmp
	ldy #0
skip
	inx
	cpx #100
	bne looplo

	; Draw the title
	ldy #3*8-4
	ldx #(40-21)/2*6-12
	jsr gotoXY
	lda #<menu_title
	ldx #>menu_title
	jmp print	; jsr/rts
.)
		
;vol_table 	.byt 0,3,5,15
/* Moved to player's space vol_sel   	.byt 0
ttalk_sel 	.byt 1
*/

#ifndef SPEECHSOUND
saytimen 	.byt 14,20-4,30-4,35-4,40-4	; This is fast talking
#endif

MainOptions
.(
	lda #0
	sta i_count
	lda #3*8-4+16
	sta row
	;inc double_height	
loop
	ldy row
	ldx #(40-21)/2*6-12
	jsr gotoXY
	ldx #<menu_str
	ldy #>menu_str
	lda i_count	
	jsr PrintStringWithXY
	jsr increment_vars
	lda i_count
+smc_nitems	
	cmp #NMENUITEMS
	bne loop	
loopkey	
	; Handle menu
	jsr WaitKey
	
	cpx #"R"
	bne check2
	jsr RedefineKeys
	jmp MainOptions
check2	
	cpx #"T"
	bne check3
	; Adjust talk speed
	inc ttalk_sel
	lda ttalk_sel
	and #%1
	sta ttalk_sel
#ifdef SPEECHSOUND
	jsr UpdateTalkSound
#else	
	jsr UpdateTalkTime
#endif	
	jmp MainOptions
check3
	cpx #"V"
	bne check4
	; Adjust volume
	inc vol_sel
	lda vol_sel
	and #%11
	sta vol_sel
	tax
	jsr UpdateVolumeSetting
	jmp MainOptions
check4
	cpx #KEY_ESC
	bne loopkey

cont2
cont	
	; Return
	rts	
.)

;i_count 	.byt 0	
;row	.byt 0

i_count = op1
row =	op2

add7timex7
.(
loop
	clc
	adc #7
	bcc next
	inc tmp+1
next	
	dex
	bpl loop	
	sta tmp
	rts
.)



UpdateVolumeSetting
.(
	ldx vol_sel
	lda vol_table,x
	sta GlobalVolume
	;jsr UpdateVolString	
.)
UpdateVolString
	ldx vol_sel
	lda #>stv-7
	sta tmp+1
	lda #<stv-7
	jsr add7timex7
	lda #<vlevel
	ldx #>vlevel
copystr
.(	
	sta tmp0
	stx tmp0+1
	ldy #6
lcopy
	lda (tmp),y
	sta (tmp0),y
	dey
	bpl lcopy
	rts
.)

#ifdef SPEECHSOUND
UpdateTalkSound
.(
	;lda List_speech+1
	;cmp #SPEECHVOL
	;beq setoff
	lda ttalk_sel
	beq setoff
	lda #SPEECHVOL
	.byt $2c
setoff
	lda #15
	sta List_speech+1
.)
#else
UpdateTalkTime
.(
	lda ttalk_sel
	asl
	asl
	asl
	tay
	;clc
	ldx #4
loopsayt
	tya
	adc saytimen,x
	sta saytime,x
	dex
	bpl loopsayt
	
	;jsr UpdateTalkTimeString	
.)
#endif	
UpdateTalkTimeString
	ldx ttalk_sel
	lda #>stt-7
	sta tmp+1
	lda #<stt-7
	jsr add7timex7
	lda #<tspeed
	ldx #>tspeed
	jmp copystr
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;
; Save/continue menu
; returns with C=1 if
; savepoint loaded, else
; C=0;
;;;;;;;;;;;;;;;;;;;;;;;;;
SaveOptions
.(
	ldy #3*8-4+16
	ldx #(40-21)/2*6-18
	jsr gotoXY
	lda #<menusave_str
	ldx #>menusave_str
	jsr print	
	ldy #3*8-4+16+8
	ldx #(40-21)/2*6-18
	jsr gotoXY
	lda #<menusave_str2
	ldx #>menusave_str2
	jsr print
	
loopkey	
	; Handle menu
	jsr WaitKey
	
	cpx #"C"
	bne check3
	jsr LoadGame
	sec
	rts
check3	
	cpx #"N"
	bne loopkey
	clc
	rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Checks for a saved slot, by
; reading one sector and checking
; for the first byte to be %00111100
; Returns Z=1 (result of the cmp)
; if there is a saved game, Z=0 if
; not.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CheckForSavedGame
.(
	; Get the sector/track of the savepoint
	ldx #LOADER_SAVESPACE
	lda FileStartSector,x
	sta _LoaderApiFileStartSector
	lda FileStartTrack,x
	sta _LoaderApiFileStartTrack
	; Now prepare to load just one sector
	; into $200
	lda #$ff
	sta _LoaderApiFileSizeLow
	lda #0
	sta _LoaderApiFileSizeHigh
	sta _LoaderApiAddressLow	
	lda #<$02
	sta _LoaderApiAddressHigh
	jsr _LoaderApiLoadFile
	ldx #0
	lda $200
	cmp #%00111100
	rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code for redefining keys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


RedefineKeys
.(
	jsr DrawMenuFrame
	ldy #(40-21)/2*6-18-3
	sty row
	lda #0
	sta i_count

	ldy #NUM_KEYS-1
loop
	sty savy+1
	
	ldy row
	ldx #6*8
	jsr gotoXY
	ldx #<redefine_strings
	ldy #>redefine_strings
	lda i_count
	jsr PrintStringWithXY
loopr
	jsr ReadKeyNoBounce
	beq loopr
	
	; Check not ESC
	cpx #10	; ESC
	beq loopr
	; Check not a number
	jsr isnum
	bne loopr
valid	
	txa
	ldy row
	ldx #6*22
	jsr DisplayKey
savy
	ldy #0
	jsr increment_vars

	lda KeyBankUsed
	sta tab_banks,y
	lda KeyBitflag
	sta tab_bits,y
	
	dey
	bpl loop

	jsr WaitIRQ
	;jsr WaitIRQ
#ifdef IJK_SUPPORT	
	lda #0
	sta $100
#endif
	jmp DrawMenuFrame
.)

isnum
.(
	cpx #"1"
	bcc nan
	cpx #"9"+1
	bcc num
nan
	lda #0
	rts
num
	lda #1
	rts
.)

increment_vars
.(
	clc
	lda row
	adc #8
	sta row
	inc i_count
	rts
.)	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Displays the user key, handling special
; keys such as UP, or LSHIFT
; Inputs: Reg A=ASCII code
; 	   Reg X,Y =position in screen
;	   to display the message
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DisplayKey
.(
	cmp #32
	bne notspace
	lda #13
notspace	
	cmp #33 
	bcs letter	
	sec
	sbc #1
	pha
	jsr gotoXY
	ldx #<tab_knames
	ldy #>tab_knames
	pla
	jmp PrintStringWithXY
letter	
	jmp place_char
.)
