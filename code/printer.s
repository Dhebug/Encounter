#include "params.h"


#ifdef ENABLE_PRINTER

; Call by doing:
; lda #<msg
; ldx #>msg
; jsr _PrinterSendString
;
_PrinterSendStringAsm
.(
    sta __auto+1
    stx __auto+2

    ldx #0
next_char 
__auto
    lda $1234,x
    beq end_of_line
    jsr _PrinterSendCharAsm
    inx
    jmp next_char
end_of_line

    rts
.)
 

 ; param0 = location to read data from
 ; param1 = number of characters to print
_PrinterSendMemoryAsm
.(
    ldx _param1
    ldy #0
next_char 
    lda (_param0),y
    iny
    cmp #32
    bcs valid
    lda #32
valid 
    jsr _PrinterSendCharAsm
    dex
    bne next_char
    
    rts
.)


; A character to send
_PrinterSendCharAsm
.(
    bit _gUsePrinter
    bvc end_send_char
    php
    sei
    sta $301		; Send A to port A of 6522
    lda $300
    and #$ef		; Set the strobe line low
    sta $300
    lda $300
    ora #$10		; Set the strobe line high
    sta $300
    plp
loop_wait 		; Wait in a loop until active transition of CA1
    lda $30d
    and #2
    beq loop_wait	; acknowledging the byte
    lda $30d
end_send_char    
    rts
.)

_PrinterSendCrlfAsm
.(
    lda #10
    jmp _PrinterSendCharAsm
    ;lda #13
    ;jsr _PrinterSendCharAsm 
    ;rts 
.)

#else
_PrinterSendString
    rts
  
#endif // ENABLE_PRINTER 
