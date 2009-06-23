;;; Code for printing texts in hires screen

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
    jsr decomp
    ;jsr put_char
    inx
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
    
    lda tmp1
    cmp #<($bf40)
    bne next
    lda tmp1+1
    cmp #>($bf40)
    bne next
    jmp end

next
    jmp looprows
end
    ;jsr _init_print

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
+gotoXY
  jsr relocate_cursor
  rts  

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
 .byt 64,64,64,65,64,62,73,66,67,75,64,69,74,68,64,61 
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
relocate_cursor 
        pha 
        ;Calculate screen loc 
        stx Cursor_origin_x 
        sty Cursor_origin_y 
        
        ;stx op1
        ;sty op2
            
        jsr pixel_address
        lda tmp0
        sta screen
        lda tmp0+1
        sta screen+1

       
        pla
        rts

put_colcombo 
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

;Print character, colour or Carriage return at next cursor position 
;A Character Code 
put_code 
        cmp #128 
        bcs put_colcombo 
        cmp #13 
        beq perform_CRLF 
        bcc put_colour 


;Print character at next cursor position 
;A Character Code 
put_char 
        stx res_x 
        sty res_y
        cmp #32 
        beq put_space 
        ldx capson
        beq nocaps
        and #$df    ; Uppercase it 

nocaps
        jsr ascii2code 
        jsr put_char_direct 
increment_cursor 
.(
        lda Cursor_origin_x
        clc
        adc #6
        sta Cursor_origin_x
        cmp #FINALX_TEXT
        bne cont
        jsr perform_CRLF
        jmp skip1
cont
        inc screen 
        bne skip1 
        inc screen+1 
skip1   
        ldx res_x 
        ldy res_y
     
        rts 
.)


put_space 
        lda #64 
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

;73 Characters + 7 for special chars (Not defined yet) [CHEMA: 73=', 74=-, 75=ç (put *), 76==, 77=<-, 78=->]
;80 Characters == 400($190) Bytes 

character_bitmap_row0   ;80 Bytes 
    .byt $40,$70,$40,$46,$40,$5c,$7e,$70,$58,$4c,$58,$58,$40,$40,$40,$40 
    .byt $40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$7e,$7e,$7e,$7e,$7e,$7e 
    .byt $7e,$72,$5c,$5c,$72,$5c,$7e,$7e,$7e,$7e,$7e,$7e,$7e,$7e,$72,$72 
    .byt $6a,$72,$72,$7e,$7c,$7e,$7e,$7c,$7e,$7e,$7e,$7e,$7e,$7e,$58,$7e 
    .byt $5c,$7e,$5c,$5c,$40,$40,$40,$40,$5f,$4c,$40,$5e,$40,%01001000,%01000100,$40 
character_bitmap_row1   ;80 Bytes 
    .byt $5e,$7e,$5e,$7e,$5e,$50,$72,$7e,$40,$40,$5a,$58,$76,$7e,$5e,$7e 
    .byt $7e,$7e,$5e,$7e,$72,$72,$6a,$72,$72,$7e,$66,$72,$66,$66,$70,$70 
    .byt $60,$72,$5c,$5c,$72,$5c,$7e,$66,$72,$72,$72,$72,$70,$5c,$72,$72 
    .byt $6a,$72,$72,$74,$5c,$42,$66,$6c,$60,$60,$66,$72,$72,$72,$72,$72 
    .byt $5c,$68,$58,$4c,$40,$40,$4c,$4c,$53,$46,$40,$66,$7e,%01011111,%01111110,$40 
character_bitmap_row2   ;80 Bytes 
    .byt $66,$66,$66,$66,$66,$7e,$7e,$66,$58,$4c,$5c,$58,$7e,$66,$72,$72 
    .byt $72,$70,$78,$5c,$72,$72,$6a,$5e,$72,$6c,$7e,$7e,$60,$66,$7e,$7e 
    .byt $6e,$7e,$5c,$5c,$7c,$5c,$6a,$66,$72,$72,$72,$7c,$7e,$5c,$72,$72 
    .byt $6a,$5c,$7e,$48,$5c,$7e,$5e,$6c,$7e,$7e,$4c,$7e,$7e,$72,$5e,$4e 
    .byt $48,$7e,$58,$4c,$40,$40,$40,$40,$7c,$40,$7e,$60,$40,%01111111,%01111111,$40 
character_bitmap_row3   ;80 Bytes 
    .byt $66,$66,$60,$66,$78,$5c,$46,$66,$58,$4c,$56,$58,$6a,$66,$72,$7e 
    .byt $7e,$70,$4e,$5c,$72,$5c,$7e,$7c,$7e,$5a,$66,$72,$66,$66,$70,$70 
    .byt $66,$72,$5c,$5c,$66,$5c,$6a,$66,$72,$7e,$72,$66,$46,$5c,$72,$5c 
    .byt $7e,$66,$5c,$56,$5c,$70,$66,$7e,$46,$66,$4c,$66,$46,$72,$72,$40 
    .byt $40,$4a,$58,$4c,$4c,$4c,$4c,$4c,$53,$40,$40,$7e,$7e,%01011111,%01111110,$40 
character_bitmap_row4   ;80 Bytes 
    .byt $7f,$7e,$7e,$7e,$7e,$5c,$7e,$66,$58,$5c,$56,$58,$6a,$66,$7e,$70 
    .byt $46,$70,$7c,$5c,$7e,$48,$5c,$66,$46,$7e,$66,$7e,$7e,$7e,$7e,$70 
    .byt $7e,$72,$5c,$7c,$66,$5e,$6a,$66,$7e,$70,$7f,$66,$7e,$5c,$7e,$48 
    .byt $5c,$66,$5c,$7e,$5c,$7e,$7e,$4c,$7e,$7e,$58,$7e,$7e,$7e,$7e,$4c 
    .byt $48,$7e,$5c,$5c,$4c,$46,$46,$40,$5f,$40,$40,$44,$40,%01001000,%01000100,$40


colour_0 
 .byt 0 
colour_1 
 .byt 0 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  pixel_address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MC routine that calculates the address pointer for a given pixel (x,y) and
; the pixel in scan.
; Needs:
; RegX x coordinate
; RegY y coordinate
;
; Returns:
; The address of the scan in tmp0 which includes
; the selected pixel is calculated as:
;
;  y*40+x/6+$a000
;
; and the pixel in scan as a bit in tmp1
;
;  x mod 6

; 1st: how to find y * 40 and to enjoy it.

pixel_address
.(
    tya             ;; the tab_scan contains only the addresses for even rows, so
    lsr             ;; we 1st check if row if even or odd: IF CARRY IS 1 AFTER
    bcs pp_oddrow   ;; A RIGHT LOGICAL SHIFT THEN IT'S ODD, else it's even.
    rol             ;; we restore the original value...
    tay             ;; ...use it as index...
    lda tab_scan,y  ;; ...look up LSB of offset then...
    sta tmp0        ;; ...store it...
    iny         
    lda tab_scan,y  ;; same for MSB...
    sta tmp0+1
    jmp pp_done1    ;; ...and done for now.
pp_oddrow          
    rol             ;; here: if the row is ODD, we fetch the offset of the FORMER
    tay             ;; one, and add 40 to it... eeeasy as pie... albeit a tad
    lda tab_scan,y  ;; confusing here, since we are at an odd offset within the
    sta tmp0+1      ;; table and that means we must swap MSB & LSB for the
    dey             ;; current entry... ie, let this be the scan offset table:
    lda tab_scan,y  
    adc #40         ;;
    sta tmp0        ;;  LSB1    MSB1    LSB2    MSB2    LSB3   ...
    bcc pp_done1   ;;                              ^ Y points here so...
    inc tmp0+1      ;;          ^ we store, decrement, then add 40.
pp_done1


; 2nd: we must now find (x div 6) and (x mod 6).

;; The idea here is a bit the same that before, BEING THE KEY that:
;;  * EVEN numbers are 0, 2 or 4 (mod 6), while
;;  * ODD numbers are 1, 3 or 5 (mod 6).
;; It follows that there are two cases:
;;  * case 1:  x = 2 * k  (k whole):
;;      x div 6 = k div 3
;;      x mod 6 = 2 * (k mod 3)
;;  * case 2:  x = 2 * k + 1 (k whole):
;;      x div 6 = k div 3 = (2 * k) div 6 = (x - 1) div 6
;;      x mod 6 = ((x - 1) mod 6) + 1
;; Confused?  You are not a Jedi yet. :)
;; Besides, in tab_mod06 are not the remainders, but the pixel masks
;; (of even cols), going as:
;;  remainder 0 ->  mask 32
;;  remainder 2 ->  mask 8
;;  remainder 4 ->  mask 2
;; The masks for odd cols are resp. 16, 4 and 1, which are halves of the
;; even ones, so we must lsr them after fetching.

pp_positive2
    ;lda op1         ;; we 1st load coord x.
    ;tax             ;; use it as index.
    txa
    lsr             ;; is it odd?
    bcs pp_oddcol  ;; then skip till next label, else...
    lda tab_mod06,x ;; load quotient & store it
    sta tmp       
    inx             ;; next offset in table is mask.
    lda tab_mod06,x
    sta tmp1       
    jmp pp_done2   ;; done!
pp_oddcol          ;; what if x is odd? Note the sequence
    asl             ;; "lsr a / asl a" means A := (A/2)-1 if
    tax             ;; A is odd (this case), so now a is even.
    lda tab_mod06,x ;; we fetch divisor then
    sta tmp         ;; store it...
    inx
    lda tab_mod06,x ;; now the pixel mask (doubled)...
    lsr             ;; all that's left is adjusting the mask.
    sta tmp1
pp_done2
    
       
pp_positive3   
; All together now!
    lda tmp0
    adc tmp
    sta tmp0
    lda tmp0+1
    adc #$a0
    sta tmp0+1
pp_end 
    rts ; We're done!
.)


; This two are por pixel_addresss
; table of row scan offsets relative to base_hires_address.

tab_scan
    .word    0,  80, 160, 240, 320, 400, 480, 560, 640, 720, 800, 880, 960,1040,1120,1200,1280,1360,1440,1520
    .word 1600,1680,1760,1840,1920,2000,2080,2160,2240,2320,2400,2480,2560,2640,2720,2800,2880,2960,3040,3120
    .word 3200,3280,3360,3440,3520,3600,3680,3760,3840,3920,4000,4080,4160,4240,4320,4400,4480,4560,4640,4720
    .word 4800,4880,4960,5040,5120,5200,5280,5360,5440,5520,5600,5680,5760,5840,5920,6000,6080,6160,6240,6320
    .word 6400,6480,6560,6640,6720,6800,6880,6960,7040,7120,7200,7280,7360,7440,7520,7600,7680,7760,7840,7920


; table of quotients & masks mod 6.  Format is a pair (a,b), where a = (2x) div 6, b = pixel mask.

tab_mod06
    .byt  0,32, 0,8, 0,2, 1,32, 1,8, 1,2, 2,32, 2,8, 2,2
    .byt  3,32, 3,8, 3,2, 4,32, 4,8, 4,2, 5,32, 5,8, 5,2
    .byt  6,32, 6,8, 6,2, 7,32, 7,8, 7,2, 8,32, 8,8, 8,2
    .byt  9,32, 9,8, 9,2,10,32,10,8,10,2,11,32,11,8,11,2
    .byt 12,32,12,8,12,2,13,32,13,8,13,2,14,32,14,8,14,2
    .byt 15,32,15,8,15,2,16,32,16,8,16,2,17,32,17,8,17,2
    .byt 18,32,18,8,18,2,19,32,19,8,19,2,20,32,20,8,20,2
    .byt 21,32,21,8,21,2,22,32,22,8,22,2,23,32,23,8,23,2
    .byt 24,32,24,8,24,2,25,32,25,8,25,2,26,32,26,8,26,2
    .byt 27,32,27,8,27,2,28,32,28,8,28,2,29,32,29,8,29,2
    .byt 30,32,30,8,30,2,31,32,31,8,31,2,32,32,32,8,32,2
    .byt 33,32,33,8,33,2,34,32,34,8,34,2,35,32,35,8,35,2
    .byt 36,32,36,8,36,2,37,32,37,8,37,2,38,32,38,8,38,2
    .byt 39,32,39,8,39,2


#ifdef miitoa
bufconv
	.byt 0,0,0,0,0,0,0,0,0,0,0,0
utoa
.( 
    ldy#0
    sty bufconv
    jmp itoaloop   
+itoa
	ldy #0
	sty bufconv
	lda op2+1
	bpl itoaloop
	lda #$2D	; minus sign
	sta bufconv
	sec
	lda #0
	sbc op2
	sta op2
	lda #0
	sbc op2+1
	sta op2+1
	
itoaloop
	jsr udiv10
	pha
	iny
	lda op2
	ora op2+1
	bne itoaloop
	
	ldx #0
	lda bufconv
	beq poploop
	inx
poploop
	pla
	clc
	adc #$30
	sta bufconv,x
	inx
	dey
	bne poploop
	lda #0
	sta bufconv,x
	ldx #<bufconv
	lda #>bufconv
	rts
			
;
; udiv10 op2= op2 / 10 and A= tmp2 % 10
;
udiv10
	lda #0
	ldx #16
	clc
udiv10lp
	rol op2
	rol op2+1
	rol 
	cmp #10
	bcc contdiv
	sbc #10
contdiv
	dex
	bne udiv10lp
	rol op2
	rol op2+1
    rts
.)

#endif


