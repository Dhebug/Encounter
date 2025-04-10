

; Example program for reading the Oric's     
; keyboard. All keys are scanned and a       
; virtual matrix of 8 bytes is updated at    
; each IRQ.                                  
;                                            
; Idea: Dbug                                 
; Main code: Twiligthe                       
; Adaptation & final implementation: Chema   
;                                            
; 2010                                        

#include "params.h"

#define KEYBOARD_BUFFER_SIZE 5

	.zero

zpTemp01			.byt 0
zpTemp02			.byt 0
tmprow				.byt 0
_gInputKey          .dsb 1

	.text 

oldKey 			.byt 0
_KeyBank 		.dsb 8   ; The virtual Key Matrix

; Usually it is a good idea to keep 0 all the unused
; entries, as it speeds up things. Z=1 means no key
; pressed and there is no need to look in tables later on.
_KeyboardASCIIMapping 
tab_ascii
    .asc "7","N","5","V",KET_RCTRL,"1","X","3"
    .asc "J","T","R","F",0,KEY_ESC,"Q","D"
    .asc "M","6","B","4",KEY_LCTRL,"Z","2","C"
    .asc "K","9",38,"-",0,0,42,39
    .asc " ",",",".",KEY_UP,KEY_LSHIFT,KEY_LEFT,KEY_DOWN,KEY_RIGHT
    .asc "U","I","O","P",KEY_FUNCT,KEY_DEL,")","("
    .asc "Y","H","G","E",0,"A","S","W"
    .asc "8","L","0","/",KEY_RSHIFT,KEY_RETURN,0,"+"




ReadKeyboard
.(
    php
	sei
	;Write Column Register Number to PortA 
	lda #$0E 
	sta via_porta 
	;Tell AY this is Register Number 
	lda #$FF 
	sta via_pcr 
	; Clear CB2, as keeping it high hangs on some orics.
	; Pity, as all this code could be run only once, otherwise
	ldy #$dd 
	sty via_pcr 

	ldx #7 
loop2   ;Clear relevant bank 
	lda #00 
	sta _KeyBank,x 
	;Write 0 to Column Register 
	sta via_porta 
	lda #$fd 
	sta via_pcr 
	lda #$dd
	sta via_pcr
	lda via_portb 
	and #%11111000
	stx zpTemp02
	ora zpTemp02 
	sta via_portb 
	;Wait 10 cycles for circuit to settle on new row 
	;Use time to load inner loop counter and load Bit 
	; CHEMA: Fabrice Broche uses 4 cycles (lda #8:inx) plus
	; the four cycles of the and absolute. That is 8 cycles.
	; So I guess that I could do the same here (ldy,lda)
	ldy #$80
	lda #8 
	;Sense Row activity 
	and via_portb 
	beq skip2 
	;Store Column 
	tya
loop1   
	eor #$FF 
	sta via_porta 
	lda #$fd 
	sta via_pcr 
	lda #$dd
	sta via_pcr
	lda via_portb 
	and #%11111000
	stx zpTemp02
	ora zpTemp02 
	sta via_portb 
	;Use delay(10 cycles) for setting up bit in _KeyBank and loading Bit 
	tya
	ora _KeyBank,x 
	sta zpTemp01 
	lda #8 
	;Sense key activity 
	and via_portb 
	beq skip1 
	;Store key 
	lda zpTemp01 
	sta _KeyBank,x 
skip1   ;Proceed to next column 
	tya 
	lsr 
	tay 
	bcc loop1 
skip2   ;Proceed to next row 
	dex 
	bpl loop2 
	plp            ; Used to be cli, but technically we want to restore the existing interupt mask

    ; We insert joystick information in the keyboard matrix
    jsr _InsertJoystickEvents

    jsr _ReadKeyInternal
    beq no_key_pressed
    cpx gInternalLastKeyPressed
    beq still_pressed
    ldy gInternalKeyPressedCount
    cpy #KEYBOARD_BUFFER_SIZE
    bcs keyboard_buffer_full
    txa
    sta gInternalKeyPressedBuffer,y
    inc gInternalKeyPressedCount
still_pressed    
keyboard_buffer_full    
no_key_pressed
    stx gInternalLastKeyPressed
	rts 
.)  


_InsertJoystickEvents
.(
    ; Read the status of the joystick: This is an OSDK API that handle 
    ; most of the known joystick interfaces such a IJK, PASE, Dk'tronic, ...
    jsr _joystick_read

    ; To make the code easier, we simulate key presses in the keyboard matrix
    ; for each of the direction: JOYSTICK UP translates to the UP arrow key, FIRE to SPACE, etc...
    lda _KeyBank+4          ; We preload the entire row from the keyboard matrix

    lsr _OsdkJoystick_0     ; Shift the joystick status
    bcc no_right            ; Check if RIGHT is pressed
    ora #%10000000          ; RIGHT ARROW key
no_right

    lsr _OsdkJoystick_0     ; Shift the joystick status
    bcc no_left             ; Check if LEFT is pressed
    ora #%00100000          ; LEFT ARROW key
no_left

    lsr _OsdkJoystick_0     ; Shift the joystick status
    bcc no_fire             ; Check if FIRE is pressed
    ora #%00000001          ; SPACE key
no_fire

    lsr _OsdkJoystick_0     ; Shift the joystick status
    bcc no_down             ; Check if DOWN is pressed
    ora #%01000000          ; DOWN ARROW key
no_down

    lsr _OsdkJoystick_0     ; Shift the joystick status
    bcc no_up               ; Check if UP is pressed
    ora #%00001000          ; UP ARROW key
no_up

    sta _KeyBank+4          ; And we save back the row with the eventual modifications
    rts
.)


; Some more routines, not actualy needed, but quite useful
; for reading a single key (get the first active bit in 
; the virtual matrix) and returning his ASCII value.
; Should serve as an example about how to handle the keymap.

; Reads a key (single press, but repeating) and returns his ASCII value in reg X. 
; Z=1 if no keypress detected.

_ReadKeyInternal
.(
	ldx #7
loop
	lda _KeyBank,x
	and #%11101111    ; The column 4 of the matrix contains all the CTRL, SHIFT and FUNC keys
	beq skip
	
	ldy #$ff
loop2
	iny
	lsr
	bcc loop2

	txa
	asl
	asl
	asl
	sty tmprow
	clc
	adc tmprow
	tax
	lda tab_ascii,x  ; Get the code associated to the key

	tax
	rts

skip
	dex
	bpl loop

	ldx #0
	rts
.)

zx
gInternalLastKeyPressed   .byt 0
gInternalKeyPressedCount  .byt 0
gInternalKeyPressedBuffer .dsb KEYBOARD_BUFFER_SIZE


_ReadKey
.(
    php
	sei

    ; Are there any keys in the buffer?
    ldx gInternalKeyPressedCount
    beq no_key

    lda gInternalKeyPressedBuffer-1,x
    dec gInternalKeyPressedCount
    tax
    lda #0
    plp
    rts

no_key
    lda #0
    tax
    plp
    rts
.)

_WaitReleasedKey
    jsr _WaitIRQ
    jsr _ReadKey
    cpx #0
    bne _WaitReleasedKey
    rts


; Read a single key, same as before but no repeating.

_ReadKeyNoBounce
.(
	jsr _ReadKey
	cpx oldKey
	beq retz
	stx oldKey
	cpx #0
	beq retz
	rts
retz
	ldx #0
	rts
.)


; Wait for a keypress
_ByteStreamCommand_WAIT_KEYPRESS    ; .byt COMMAND_WAIT_KEYPRESS
    lda $bb80+40*22+38     ; Save the character
    pha
    lda #95                ; Sterling Pound symbol redefined to be an enter key symbol
    sta $bb80+40*22+38
    jsr _WaitKey
    stx _gInputKey         ; Store the result so it can be used later
    pla
    sta $bb80+40*22+38     ; Restore the original character
    rts
    
_WaitKey
.(
loop
	jsr _WaitIRQ
	jsr _ReadKeyNoBounce
	beq loop
	rts	
.)

