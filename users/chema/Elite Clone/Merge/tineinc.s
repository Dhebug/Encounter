
#define miitoa2

#ifdef miitoa2
bufconv
	.byt 0,0,0,0,0,0,0,0,0,0,0,0
itoa2
.(
    lda op2
    sta op1
    lda op2+1
    sta op1+1
    lda #0
    sta op2
    sta op2+1
    jmp ltoa
.)

#endif

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
; udiv10 op2= op2 / 10 and A= op2 % 10
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



;-------------------------------
;
; 32 bit -> ASCII conversion
;
; Take 2 -- Divide by 10 manually; remainder is coeff
; of successive powers of 10
;
; Number to convert -> op1, op1+1, op2, op2+1 (lo..hi)
;
; SLJ 8/28/96


#define FAQ2 op1
#define TEMP tmp+1

ltoa
.(
    LDA #10
    STA FAQ2+4

    ldx #0
loop
    JSR DIV32
    pha
    inx
	lda op2
	ora op2+1
    ora op1
    ora op1+1
    bne loop

    ldy #0
poploopl
    pla
	clc
	adc #$30
	sta bufconv,y
	iny
	dex
	bne poploopl
	lda #0
	sta bufconv,y
    ldx #<bufconv
  	lda #>bufconv
    RTS
.)


;
; Routine to divide a 32-bit number (in faq2..faq2+3) by
; the 8-bit number in faq2+4.  Result -> faq2..faq2+3, remainder
; in A.  Numbers all go lo..hi
;

DIV32     
.(  
          LDA #00
          LDY #$20
LOOP      ASL FAQ2
          ROL FAQ2+1
          ROL FAQ2+2
          ROL FAQ2+3
          ROL
          CMP FAQ2+4
          BCC DIV2
          SBC FAQ2+4
          INC FAQ2
DIV2      DEY
          BNE LOOP
          RTS
.)



