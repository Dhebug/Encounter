;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Auxiliar routines

; Copy charset to alt hires charset for messages
charset_to_althires
.(
	; Swap numbers
	ldx #168
loopn
	lda cs_symbols-1,x
	sta _hires_altcharset+256+128-80-1,x
	dex
	bne loopn
	
	; Swap letters
	ldx #200+16
loopl
	lda cs_letters-1,x
	sta _hires_altcharset+256+256-1,x
	dex
	bne loopl
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Prints message in beginner's
; mode. The message id is
; passed in register A
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_beginner_msg
.(
	stx savx+1
	sty savy+1
	pha
	jsr StopSound
	jsr _clear_bottom_text_area
	jsr set_graphic_attributes	
	
	ldx #2
	ldy #25
	jsr gotoxy
	; Set tmp pointing to the string
	pla
	jsr search_string

loop1
	ldy #0
	lda (tmp),y
	beq end
	jsr putchar
	inc tmp
	bne nocarry
	inc tmp+1
nocarry
	jsr waitirq
	jmp loop1
end	
	jsr _StartPlayer
	;jsr InitSound
	lda #50
	jsr TimedWaitKey
	jsr _prepare_bottom_text_area
	jsr set_graphic_attributes
savx
	ldx #0
savy
	ldy #0
	rts
.)
; Swap letters and numbers with 
; tile graphics and back.
; Basically swap the necesary tiles from
; _std_charset and _oricium_character_set

charset_in .byt 0

swap_charsets
.(
	; Signal charset has been put in or out
	lda charset_in
	eor #$ff
	sta charset_in
	
	; Swap numbers
	ldx #168
loopn
	lda cs_symbols-1,x
	pha
	lda _std_charset+128-80-1,x
	sta cs_symbols-1,x
	pla
	sta _std_charset+128-80-1,x
	dex
	bne loopn
	
	; Swap letters
	ldx #200+16
loopl
	lda cs_letters-1,x
	pha
	lda _std_charset+256-1,x
	sta cs_letters-1,x
	pla
	sta _std_charset+256-1,x
	dex
	bne loopl

	rts
.)

swapflags .dsb 4


; Swap graphic for big chains
swap_bchain
.(
	inc swapflags
	
	ldx #3*8
loop
	lda extra_std_tiles-1,x
	pha
	lda _std_charset+20*8-1,x
	sta extra_std_tiles-1,x
	pla
	sta _std_charset+20*8-1,x

	lda extra_alt_tiles-1,x
	pha
	lda _alt_charset+20*8-1,x
	sta extra_alt_tiles-1,x
	pla
	sta _alt_charset+20*8-1,x
	
	dex
	bne loop
	rts
.)

; Swap graphic for small chains
swap_schain
.(
	inc swapflags+1

	ldx #2*8
loop
	lda extra_std_tiles+3*8-1,x
	pha
	lda _std_charset+23*8-1,x
	sta extra_std_tiles+3*8-1,x
	pla
	sta _std_charset+23*8-1,x

	lda extra_alt_tiles+3*8-1,x
	pha
	lda _alt_charset+23*8-1,x
	sta extra_alt_tiles+3*8-1,x
	pla
	sta _alt_charset+23*8-1,x	
	
	dex
	bne loop
	rts
.)

; Swap graphic for medium chains
swap_mchain
.(
	inc swapflags+2

	ldx #3*8
loop
	lda extra_std_tiles+5*8-1,x
	pha
	lda _std_charset+25*8-1,x
	sta extra_std_tiles+5*8-1,x
	pla
	sta _std_charset+25*8-1,x

	lda extra_alt_tiles+5*8-1,x
	pha
	lda _alt_charset+25*8-1,x
	sta extra_alt_tiles+5*8-1,x
	pla
	sta _alt_charset+25*8-1,x

	dex
	bne loop
	rts
.)

; Swap graphic for windows
swap_windows
.(
	inc swapflags+3

	ldx #2*8
loop
	lda extra_std_tiles+8*8-1,x
	pha
	lda _std_charset+28*8-1,x
	sta extra_std_tiles+8*8-1,x
	pla
	sta _std_charset+28*8-1,x

	lda extra_alt_tiles+8*8-1,x
	pha
	lda _alt_charset+28*8-1,x
	sta extra_alt_tiles+8*8-1,x
	pla
	sta _alt_charset+28*8-1,x

	dex
	bne loop
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Some routines to
; print text
;;;;;;;;;;;;;;;;;;;;;;;;;;;

.zero
CursorX .byt 00
CursorY .byt 00
.text

; Put a character at screen position
; and advance screen pointer
; The ascii code of the character
; to be printed is passed in reg A
; It also handles \n commands
putchar
.(
	cmp #$7f
	bne checkret
	lda screen
	bne isok
	dec screen+1
isok
	dec screen
	ldy #0
	lda #DELETE_CHAR
	sta (screen),y
	rts
checkret	
    cmp #NEWLINE
    bne putchar2
	; Advance one line
	ldy CursorY
	iny
	ldx #2
	jmp gotoxy
putchar2
	ldy #0
	sta (screen),y
	inc screen
	bne endpc
	inc screen+1
endpc
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets the pointer
; to the specified string
; passed in A
; and stores it in tmp
; Does not check for existance!
;;;;;;;;;;;;;;;;;;;;;;;;;
search_string
.(
	tax
	lda #<_strings
	sta tmp
	lda #>_strings
	sta tmp+1
	cpx #0
	beq found
	
cont	
    ldy #0
loop
    lda (tmp),y
    beq out    ; Search for zero
    iny
    bne loop

out
    ; Found the end. 
	; Skip consecutive zeros
loop2
	iny
	lda (tmp),y
	beq loop2
	
	;Add length to pointer    
    tya
    clc
    adc tmp
    bcc nocarry
    inc tmp+1
nocarry
    sta tmp    

    dex
    bne cont

found
	rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; prints a string passed as
; an offset in strings passed
; in register A at row Y
; centered in the screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_string_centered
.(
	sty savY+1
	jsr search_string
	; Get the string length
	ldy #0
loop	
	lda (tmp),y
	beq done
	iny
	bne loop
done
	; Now Y contains the length of the string (without the ending 0)
	; divide it by 2
	tya
	lsr
	sta tmp1
	; Calculate the column where to start
	lda #19
	sec
	sbc tmp1
	tax
	; Prepare everything and print
savY
	ldy #0
	jsr gotoxy
	jmp puts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; prints a string passed as
; an offset in strings passed
; in register A at screen
; location X (col),Y(row)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_string
.(
	pha
	jsr gotoxy
	pla
+print_string_ex	
	jsr search_string	
	; Print the string
	; Do not issue an RTS here
.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Print a string passed
; in tmp
puts
.(
	ldy #0
putsloop
	lda (tmp),y
	beq endputs
	sty savy+1
	jsr putchar
savy
	ldy #0
	iny
	bne putsloop
	inc tmp+1
	jmp putsloop
endputs
	lda #NEWLINE
	jmp putchar
.)

;;;;;;;;;;;;;;;;;;;;;
; print a BCD number
; passed in A
;;;;;;;;;;;;;;;;;;;;;

print_digit
.(
	; Two digits in a BCD 8-bit number
	; Save A for later
	; and get the highest digit
	pha
	lsr
	lsr
	lsr
	lsr
	clc
	adc #48 ; ascii code for 0
	jsr putchar
	; Now the lowest digit
	pla
	and #%1111
	clc
	adc #48
	jmp putchar
.)	
	
	
clrscr
.(
	lda #<$bfe0
	sta tmp
	lda #>$bfe0
	sta tmp+1
	ldx #26+2
looprows
	lda #$20
	ldy #39
loopcols
	sta (tmp),y
	dey 
	bpl loopcols
	
	lda tmp
	sec
	sbc #40
	sta tmp
	bcs skip
	dec tmp+1
skip
	dex
	bpl looprows
	
	rts
.)	

gotoxy
.(
	stx CursorX
	sty CursorY

	lda #<$bb80
	sta screen
	lda #>$bb80
	sta screen+1
	
	lda #0
	sta tmp0+1
	sty tmp0
	tya
	asl
	asl
	clc
	adc tmp0
	asl
	rol tmp0+1
	asl
	rol tmp0+1
	asl	
	rol tmp0+1
	
	clc
	adc screen
	sta screen
	lda tmp0+1
	adc screen+1
	sta screen+1

	clc
	txa
	adc screen
	sta screen
	bcc skip
	inc screen+1
skip	
	rts
.)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code for redefining keys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
KeyBankUsed .byt 00
KeyBitflag  .byt 00

#define BASE_STR_KEYRED		28

row_temp .byt 00
i_temp	 .byt 00

redefine_keys
.(
	; Hack because some routine before is clearing this
	; variable, producing key bounces.
	lda #"R"
	sta oldKey
	
	ldy #7
	sty row_temp

	lda #BASE_STR_KEYRED-1
	sta i_temp

	ldy #NUM_KEYS-1
loop
	sty savy+1
	inc row_temp
	inc row_temp
	inc i_temp
	
	ldy row_temp
	lda i_temp
	ldx #12
	jsr print_string

loopr
	jsr waitirq
	jsr ReadKeyboard
	jsr _ReadKeyNoBounce
	beq loopr
	
	; TODO: Check if key is already in use
	
	pha
	ldy row_temp
	ldx #22
	jsr display_user_key
	;ldy #10
	;jsr pause
savy
	ldy #0
	pla 
	sta user_keys,y
	lda KeyBankUsed
	sta tab_banks,y
	lda KeyBitflag
	sta tab_bits,y
	
	dey
	bpl loop
	
	rts
.)

	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Displays the user key, handling special
; keys such as UP, or LSHIFT
; Inputs: Reg A=ASCII code
; 		  Reg X,Y =position in screen
;				   to display the message
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
display_user_key
.(
	cmp #32
	bne skip
	lda #13
skip	
	cmp #33 
	bcs normal
	clc
	adc #34
	jmp print_string
normal	
	pha	
	jsr gotoxy
	pla
	jmp putchar
.)


#define _VSyncCounter1 tmp

detect_vsync_hack
.(
	lda #0
	sta _VSyncCounter1
	sta _VSyncCounter1+1

	lda $300
vsynccounter_wait1
	lda $30D
	and #%00010000 ;test du bit cb1 du registre d'indicateur d'IRQ
	bne vsynccounter_wait1_end

	inc _VSyncCounter1
	bne vsynccounter_wait1
	inc _VSyncCounter1+1
	beq vsynccounter_end
	jmp vsynccounter_wait1

vsynccounter_wait1_end
	sec
	rts
vsynccounter_end
	clc
	rts
 .)  

perform_vsync
.(
	; We want to have an IRQ in sync with the screen
	; refresh.
	; Set a first tentative value for the T1 latch.
	lda #<19966
	sta $306
	lda #>19966
	sta $307

	; Remove cursor and other things...
	lda #0
	sta $26a

	
	;lda #A_TEXT50
	;sta $bfdf
	
	; Detect if vsync hack is present
	jsr clrscr
	ldy #20
	lda #72
	jsr print_string_centered
	
	lda #0
	sta $2df
	sta using_vsync_hack
loop	
	jsr detect_vsync_hack
	bcc vsync_hack_absent
	; vsync hack detected!
	inc using_vsync_hack
	jmp end
vsync_hack_absent	
	lda $2df
	beq loop	
	
	; Set up instructions
	jsr clrscr
	ldx #2
	ldy #10-4
	lda #0
	jsr print_string
	ldx #2
	ldy #24
	lda #1
	jsr print_string
	

	; Call the calibration routine
	jsr _DoSync
	
	; Clear the screen
end	
	jmp clrscr
.)


_Syncrho
.(
	sta $04     
	stx $03     
	lda #$80    
	sta $00     
	lda #$bb    
	sta $01     
	ldy #$00    
	clc         
l1
	lda $04     
	sta ($00),y 
	ldx $03      
loop1
	dex         
	bne loop1   
	tya        
	adc #$28    
	tay         
	bcc l1   
	lda #$00    
	adc $01     
	sta $01     
	cmp #$c0    
	bcc l1  
	rts        
.)

tmpval .byt 00

_DoSync
.(
	sei    
	lda #0
	sta tmpval
l6
	lsr $02df   
	lda #$40    
l2
	bit $030d   
	beq l2   
	lda #A_BGCYAN ;$11    
	ldx #$01    
	jsr _Syncrho   
	lda #A_BGBLUE  ;$12    
	ldx #$12    
	jsr _Syncrho   
	brk         
	brk         
	lda $02df   
	cmp #$8a ;d3    
	bne l3 
	; If we did not press this the last time, stop the bar
	cmp tmpval
	bne stop
	
	; Increment counter
	inc $0306   
	bne l3   
	inc $0307   
l3
	cmp #$8b ;c6    
	bne l4   
	; If we did not press this the last time, stop the bar
	cmp tmpval
	bne stop
	
	; Decrement counter
	ldx $0306   
	bne l5   
	dec $0307   
l5
	dec $0306   
l4
	cmp #$d1    
	bne l6   
	lda #<19966
	sta $306
	lda #>19966
	sta $307	
	cli         
	rts         
stop
	sta tmpval ; Save this for later
	lda #<19966
	sta $306
	lda #>19966
	sta $307
	bne l6	; Always jumps
.)



_oricium_character_set
cs_symbols
; ;,',],[,\,=,,,-,.,/
; 0,1,2,..., 9, :  (21 characters, 168 bytes)

.byt $4c, $4c, $40, $4c, $4c, $48, $50, $40
.byt $4c, $4c, $4c, $40, $40, $40, $40, $40
.byt $5e, $46, $46, $46, $46, $5e, $40, $40
.byt $7c, $70, $70, $70, $70, $7c, $40, $40
.byt $60, $50, $48, $44, $42, $40, $40, $40
.byt $40, $40, $5e, $40, $5e, $40, $40, $40
.byt $40, $40, $40, $4c, $4c, $48, $50, $40
.byt $40, $40, $5e, $40, $40, $40, $40, $40
.byt $40, $40, $40, $40, $4c, $4c, $40, $40
.byt $42, $44, $48, $50, $60, $40, $40, $40

cs_numbers
.byt $7e, $72, $72, $7a, $7a, $7e, $40, $40
.byt $4c, $5c, $6c, $4c, $4c, $4c, $40, $40
.byt $7e, $46, $46, $7e, $70, $7e, $40, $40
.byt $7e, $46, $5e, $46, $46, $7e, $40, $40
.byt $70, $72, $72, $7e, $46, $46, $40, $40
.byt $7e, $70, $7e, $46, $46, $7c, $40, $40
.byt $5e, $70, $70, $7e, $72, $7e, $40, $40
.byt $7e, $46, $4c, $4c, $58, $58, $40, $40
.byt $7e, $72, $7e, $72, $72, $7e, $40, $40
.byt $7e, $72, $72, $7e, $46, $7e, $40, $40
.byt $40, $40, $4c, $40, $4c, $40, $40, $40

cs_letters
;  A, B ,C,...Z (26 characters 208 bytes)
.byt $40, $40, $40, $40, $40, $40, $40, $40
.byt $7c, $72, $72, $7e, $72, $72, $40, $40
.byt $7c, $72, $7c, $72, $72, $7c, $40, $40
.byt $7e, $70, $70, $70, $70, $7e, $40, $40
.byt $7c, $72, $72, $72, $72, $7c, $40, $40
.byt $7e, $70, $78, $70, $70, $7e, $40, $40
.byt $7e, $70, $7c, $70, $70, $70, $40, $40
.byt $7e, $70, $70, $76, $72, $7e, $40, $40
.byt $72, $72, $7e, $72, $72, $72, $40, $40
.byt $7c, $58, $58, $58, $58, $7c, $40, $40
.byt $5e, $46, $46, $46, $66, $5c, $40, $40
.byt $72, $74, $78, $74, $72, $72, $40, $40
.byt $70, $70, $70, $70, $70, $7e, $40, $40
.byt $7c, $6a, $6a, $62, $72, $72, $40, $40
.byt $72, $7a, $76, $72, $72, $72, $40, $40
.byt $5e, $72, $72, $72, $72, $7e, $40, $40
.byt $7c, $72, $72, $7c, $70, $70, $40, $40
.byt $5e, $72, $72, $72, $74, $7a, $40, $40
.byt $7c, $72, $72, $7c, $72, $72, $40, $40
.byt $7e, $70, $7e, $46, $46, $7e, $40, $40
.byt $7c, $58, $58, $58, $58, $58, $40, $40
.byt $72, $72, $72, $72, $72, $7c, $40, $40
.byt $72, $72, $72, $72, $74, $78, $40, $40
.byt $72, $72, $62, $6a, $6a, $7c, $40, $40
.byt $62, $54, $48, $48, $54, $62, $40, $40
.byt $64, $64, $64, $58, $58, $58, $40, $40
.byt $7e, $46, $4c, $58, $70, $7e, $40, $40

