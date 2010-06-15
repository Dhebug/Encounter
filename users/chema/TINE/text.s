;;; Code for printing texts in hires screen

#define Grammar $200

; in pixels
#define INITIALX_TEXT   6 
#define INITIALY_TEXT   6

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


print2buffer	.byt 00	; Prints in str buffer, for formatting text
buffercounter	.byt 00
print2dbuffer	.byt 00	; Prints to the double-buffer area

; Put this as a value different from 0
; and text will be printed on caps.

capson .byt 00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; printnl
; prints a string in text area ADDING a newline
; String pointer passed in (sp)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printnl
.(
    jsr print
    jmp perform_CRLF ; This is jsr/rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print2
; Same as print (below), but pointer passed in tmp0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print2
    lda tmp0
    ldx tmp0+1
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
loop
text
    lda 1234,x		; Get Next letter
    beq end         ; if 0, we are finished

	; If it is a newpage, do as if 0
	cmp #11
	beq end

    stx savx+1
    jsr decomp
savx
    ldx #0  ;SMC
    inx
	bne cont
	inc text+2
cont
    jmp loop

end
    rts
.)

#define COMPTEXT
#ifdef COMPTEXT
#ifdef GRAMMAR2PAGE4
.bss
*=$400

Grammar .dsb 256

.text

#endif

;;;;;;;;;; Decompression routine ;;;;;;;;;;;;;;;;;;
;__comp_start


decomp
.(
    tay
    ; Prepare the stack for the decompression routine
    lda #0
    pha
    tya
    pha

loop
    pla
    ; If it is 0, we are done
    beq end

    ; If it is a token, expand it, else print and continue
    bpl printit

    and #%01111111 ; Get table entry
    asl
    tay
    lda Grammar+1,y
    pha
    lda Grammar,y
    pha
    jmp loop
printit
    jsr put_code
    jmp loop
end
    ldy print2buffer
    beq nomore
    ldy buffercounter
    lda #0
    sta str_buffer,y
nomore
    rts


.)

;__comp_end

;#echo Size of decomp routine in bytes:
;#print (__comp_end - __comp_start)
;#echo

#endif



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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; clr_hires
; Clears text area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clr_hires
.(

    lda #<($a000)
    sta tmp1
    lda #>($a000)
    sta tmp1+1

looprows
    ldy #39
    lda #$40
loopcols
    sta (tmp1),y
    dey
    bpl loopcols

    lda tmp1
    clc
    adc #40
    sta tmp1
    bcc nocarry
    inc tmp1+1
nocarry
    
    lda tmp1+1
    cmp #>($bf40)
    bne next
    lda tmp1
    cmp #<($bf40)
    bne next
    jmp end

next
    jmp looprows
end
    ;jmp _init_print
    ;rts
.)


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
  ldx #INITIALX_TEXT
  ldy #INITIALY_TEXT
  jmp relocate_cursor
  ;rts  

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
    jmp gotoXY    
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Twilighte's code for printing texts...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.zero
screen  .word 00

.text
Cursor_origin_x .dsb 1 
Cursor_origin_y .dsb 1 

#define res_x tmp4
#define res_y tmp4+1

//res_x .dsb 1
//res_y .dsb 1


ascii2code 
        cmp #97 
.( 
        bcs skip1 
        cmp #65 
        bcs skip2 
        sbc #32 
        stx tmp 
        tax 
        lda punctuation_ascii,x ;31 Bytes 
        ldx tmp 
        rts 
skip1   sbc #97 
        rts 
skip2   sbc #39 
.) 
        rts 
punctuation_ascii 
 .byt 64,64,64,65,64,62,73,66,67,75,64,69,74,68,79,61 
 ;    !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0 
 .byt 52,53,54,55,56,57,58,59,60,71,70,77,76,78,63 
 ;    1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ? 


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
        
		lda print2dbuffer
		beq normal
		jsr pixel_address
		jmp cont
normal
		jsr pixel_address_real
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

       
        pla
        rts
.)

put_colcombo 
.(
        pha 
        and #7 
        sta colour_0 
        pla 
        lsr 
        lsr 
        lsr 
        lsr 
        and #7 
        sta colour_1 
        jmp put_colour_combo 
.)
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
        stx res_x 
        sty res_y
        cmp #32 
        beq put_space
        cmp #97
        bcc nocaps  ; It is not a letter 
        ldx capson
        beq nocaps
        and #$df    ; Uppercase it 

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
/*        cmp #FINALX_TEXT
        bne cont
        jsr perform_CRLF
        jmp skipme
cont*/
        inc screen 
        bne skipme 
        inc screen+1 
+skipme   
        ldx res_x 
        ldy res_y
     
        rts 
.)


put_space 
.(
        ; Check if we are printing to buffer
        lda print2buffer
        beq cont1
        ldy buffercounter
        lda #" "
        sta str_buffer,y
        inc buffercounter
        bne skipme
cont1
        lda #64 
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
;colour_0 The first colour (Repeated thrice) 
;colour_1 The second colour (Repeated twice) 
put_colour_combo 
        stx res_x 
        sty res_y 
        lda colour_0 
        ldx colour_1 
        ldy #00 
        sta (screen),y 
        txa 
        ldy #40 
        sta (screen),y 
        lda colour_0 
        ldy #80 
        sta (screen),y 
        txa 
        ldy #120 
        sta (screen),y 
        lda colour_0 
        ldy #160 
        sta (screen),y 
        jmp increment_cursor 


;Relocate cursor and Print character 
;Pass: 
;X X position on screen (Byte alligned 0 to 39) 
;Y Y position on screen (Row alligned 0 to 195) 
;A Character Code (ASCII) 
place_char 
        jsr relocate_cursor 
        jsr ascii2code 
put_char_direct 
        tax     ;char_number 
        lda character_bitmap_row0,x 
        ldy #00 
        sta (screen),y 
        lda character_bitmap_row1,x 
        ldy #40 
        sta (screen),y 
        lda character_bitmap_row2,x 
        ldy #80 
        sta (screen),y 
        lda character_bitmap_row3,x 
        ldy #120 
        sta (screen),y 
        lda character_bitmap_row4,x 
        ldy #160 
        sta (screen),y 
        rts 

/*
;73 Characters + 7 for special chars (Not defined yet) [CHEMA: 73=', 74=-, 
;75=space (for deleting), 76==, 77=<-, 78=->, 79=/]
;80 Characters == 400($190) Bytes 
*/

character_bitmap_row0   ;80 Bytes 
    .byt $40,$70,$40,$46,$40,$5c,$7e,$70,$58,$4c,$58,$58,$40,$40,$40,$40 
    .byt $40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$7e,$7e,$7e,($7e & %11111100),$7e,$7e 
    .byt $7e,$72,$5c,$5c,$72,$5c,$7e,$7e,($7e & %11011111),$7e,$7e,$7e,$7e,$7e,$72,$72 
    .byt $6a,$72,$72,$7e,$7c,$7e,$7e,$7c,$7e,$7e,$7e,$7e,$7e,$7e,$58,$7e 
    .byt $5c,$7e,$5c,$5c,$40,$40,$40,$40,$5f,$4c,$40,$40,$40,%01001000,%01000100,%01000010 
character_bitmap_row1   ;80 Bytes 
    .byt $5e,$7e,$5e,$7e,$5e,$50,$72,$7e,$40,$40,$5a,$58,$76,$7e,$5e,$7e 
    .byt $7e,$7e,$5e,$7e,$72,$72,$6a,$72,$72,$7e,$66,$72,$66,$66,$70,$70 
    .byt $60,$72,$5c,$5c,$72,$5c,$7e,$66,$72,$72,$72,$72,$70,$5c,$72,$72 
    .byt $6a,$72,$72,$74,$5c,$42,$66,$6c,$60,$60,$66,$72,$72,$72,$72,$72 
    .byt $5c,$68,$58,$4c,$40,$40,$4c,$4c,$53,$46,$40,$40,$7e,%01011111,%01111110,%01000110
character_bitmap_row2   ;80 Bytes 
    .byt $66,$66,$66,$66,$66,$7e,$7e,$66,$58,$4c,$5c,$58,$7e,$66,$72,$72 
    .byt $72,$70,$78,$5c,$72,$72,$6a,$5e,$72,$6c,$7e,$7e,$60,$66,$7e,$7e 
    .byt $6e,$7e,$5c,$5c,$7c,$5c,$6a,$66,$72,$72,$72,$7c,$7e,$5c,$72,$72 
    .byt $6a,$5c,$7e,$48,$5c,$7e,$5e,$6c,$7e,$7e,$4c,$7e,$7e,$72,$5e,$4e 
    .byt $48,$7e,$58,$4c,$40,$40,$40,$40,$7c,$40,$7e,$40,$40,%01111111,%01111111,%01001100 
character_bitmap_row3   ;80 Bytes 
    .byt $66,$66,$60,$66,$78,$5c,$46,$66,$58,$4c,$56,$58,$6a,$66,$72,$7e 
    .byt $7e,$70,$4e,$5c,$72,$5c,$7e,$7c,$7e,$5a,$66,$72,$66,$66,$70,$70 
    .byt $66,$72,$5c,$5c,$66,$5c,$6a,$66,$72,$7e,$72,$66,$46,$5c,$72,$5c 
    .byt $7e,$66,$5c,$56,$5c,$70,$66,$7e,$46,$66,$4c,$66,$46,$72,$72,$40 
    .byt $40,$4a,$58,$4c,$4c,$4c,$4c,$4c,$53,$40,$40,$40,$7e,%01011111,%01111110,%01011000
character_bitmap_row4   ;80 Bytes 
    .byt $7f,$7e,$7e,$7e,$7e,$5c,$7e,$66,$58,$5c,$56,$58,$6a,$66,$7e,$70 
    .byt $46,$70,$7c,$5c,$7e,$48,$5c,$66,$46,$7e,$66,$7e,$7e,$7e,$7e,$70 
    .byt $7e,$72,$5c,$7c,$66,$5e,$6a,$66,$7e,$70,$7f,$66,$7e,$5c,$7e,$48 
    .byt $5c,$66,$5c,$7e,$5c,$7e,$7e,$4c,$7e,$7e,$58,$7e,$7e,$7e,$7e,$4c 
    .byt $48,$7e,$5c,$5c,$4c,$46,$46,$40,$5f,$40,$40,$40,$40,%01001000,%01000100,%01010000


colour_0 
 .byt 0 
colour_1 
 .byt 0 


;;; SOME EXTRA FUNCTIONS.... These are kludges... BEWARE

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




