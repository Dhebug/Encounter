; Ok guys, I finally tested the routine I did up there. 
; Like said before, it only allows 14 bit input ($0000 to $41FF to be more accurate). 
; The reason for this is that M needs one more bit. 
; Ok, some people might want full 16 bit so here is a fixed routine which only has 3 opcodes more:
; This routine works perfectly for all values from $0000 to $FFFF. 
; It even works better than BASIC V2 math which for example fails at INT(SQR(X)) sometimes :)
; In fact, my small BASIC program which was supposed to test the assembler sqrt routine failed at value 26569. 
; It returned 162 there although 163*163 = 26569, so it said that my asm routine had failed although it was the BASIC V2 math routines which had failed :D

; unsigned 16bit SQRT(op1) -> x/A (uses tmp)

; Input is MLO/MHI for N and output is Y-register for int(sqrt(N)).
_sqrt16
.(
    ldx #$00    ; r = 0
    ldy #$07
    clc         ; clear bit 16 of m
loop
    txa
    ora stab-1,y
    sta tmp+1     ; (r asl 8) | (d asl 7)
    lda op1+1
    bcs skip0  ; m >= 65536? then t <= m is always true
    cmp tmp+1
    bcc skip1  ; t <= m
skip0
    sbc tmp+1
    sta op1+1     ; m = m - t
    txa
    ora stab,y
    tax         ; r = r or d
skip1
    asl op1+0
    rol op1+1     ; m = m asl 1
    dey
    bne loop

    ; last iteration

    bcs skip2
    stx tmp+1
    lda op1+0
    cmp #$80
    lda op1+1
    sbc tmp+1
    bcc skip3
skip2
    inx         ; r = r or d (d is 1 here)
skip3
	lda #0
    rts
.)		

stab:   .byt $01,$02,$04,$08,$10,$20,$40,$80

