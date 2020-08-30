
#include "defines.h"

#define ROM

#ifdef ROM
#define IRQ_ADDRLO $0245
#define IRQ_ADDRHI $0246
#else
#define IRQ_ADDRLO $fffe
#define IRQ_ADDRHI $ffff
#endif

#define        via_portb               $0300 
#define		   via_ddrb				   $0302	
#define		   via_ddra				   $0303
#define        via_t1cl                $0304 
#define        via_t1ch                $0305 
#define        via_t1ll                $0306 
#define        via_t1lh                $0307 
#define        via_t2ll                $0308 
#define        via_t2ch                $0309 
#define        via_sr                  $030A 
#define        via_acr                 $030b 
#define        via_pcr                 $030c 
#define        via_ifr                 $030D 
#define        via_ier                 $030E 
#define        via_porta               $030f 

    .zero

_gKey               .dsb 1

irq_A               .dsb 1
irq_X               .dsb 1
irq_Y               .dsb 1

    .text 

_InitIRQ
.(
    ;Since we are starting from when the standard irq has already been 
    ;setup, we need not worry about ensuring one irq event and/or right 
    ;timer period, only redirecting irq vector to our own irq handler. 
    sei

    ; Setup DDRA, DDRB and ACR
    lda #%11111111
    sta via_ddra
    lda #%11110111 ; PB0-2 outputs, PB3 input.
    sta via_ddrb
    lda #%1000000
    sta via_acr

    ; Since we have only IRQ handler for everything, it is generally
    ; more useful to run at 50Hz, instead of 100 Hz.
    lda #<20000
    sta via_t1ll 
    lda #>20000
    sta via_t1lh

    ; Patch IRQ vector
    lda #<irq_routine 
    sta IRQ_ADDRLO
    lda #>irq_routine 
    sta IRQ_ADDRHI
    cli 
    rts 
.)


irq_routine 
.(
    ;Preserve registers 
    sta irq_A
    stx irq_X
    sty irq_Y

    ;Clear IRQ event 
    lda via_t1cl 

    ;Process keyboard 
    jsr ReadKeyboard 

    ;Restore Registers 
    lda irq_A
    ldx irq_X
    ldy irq_Y

    ;End of IRQ 
    rti 
.)


values_code .byt $df,$7f,$f7,$bf,$fe,$ef

ReadKeyboard
.(
    lda #00
    sta _gKey

    ; Select the bottom row of the keyboard
    ldy #04
    sty via_portb

    ldx #5
loop_read

    ; Write Column Register Number to PortA
    ldy #$0e
    sty via_porta

    ; Tell AY this is Register Number
    ldy #$ff
    sty via_pcr

    ; Clear CB2, as keeping it high hangs on some orics.
    ; Pitty, as all this code could be run only once, otherwise
    ldy #$dd
    sty via_pcr

    ; Write to Column Register 
    lda values_code,x
    sta via_porta
    lda #$fd
    sta via_pcr
    sty via_pcr

    lda via_portb
    and #08
    beq key_not_pressed

    lda values_code,x
    eor #$ff
    ora _gKey 
    sta _gKey

key_not_pressed    
    dex
    bpl loop_read
    rts
.)

