

	.zero
	
;	*= tmp1
	
;e				.dsb 2	; Error decision factor (slope) 2 bytes in zero page
;i				.dsb 1	; Number of pixels to draw (iteration counter) 1 byte in zp
;dx				.dsb 1	; Width
;dy				.dsb 1	; Height
;_CurrentPixelX	.dsb 1
;_CurrentPixelY	.dsb 1
;_OtherPixelX	.dsb 1
;_OtherPixelY	.dsb 1
	
save_a			.dsb 1
save_x			.dsb 1
save_y			.dsb 1

	.text
	
	.dsb 256-(*&255)


	



 ;Drawin' a line
 ;v1.3 SLJ 7/2/94
_DrawLine8
 ; Compute DX
 sec
 lda _OtherPixelX
 sta __auto_cpx+1
 sbc _CurrentPixelX
 sta __auto_dx+1
    
 ; Compute DY
 sec
 lda _OtherPixelY 
 sbc _CurrentPixelY
 sta __auto_sdy+1
 sta __auto_ady+1
    
 ldx _CurrentPixelX   	;Plotting coordinates
 ldy _CurrentPixelY   	;in X and Y

 ; Set the start screen adress
 lda _HiresAddrLow,y
 sta tmp0+0
 lda _HiresAddrHigh,y
 sta tmp0+1
     
 lda #00     			;Saves us a CMP
 sec
__auto_sdy
 sbc #00				; -DY
 
 ; Draw the first pixel
 sta save_a
 sty save_y
 ldy _TableDiv6,x
 lda _TableBit6Reverse,x
 eor (tmp0),y
 sta (tmp0),y
 lda save_a
 ldy save_y

 clc
LOOP 
 inx             		; Step in x
__auto_ady
 adc #00				; +DY
 bcc NOPE    			; Time to step in y?
 iny            		; Step in y
 
 ; Set the new screen adress
 sta save_a
 lda _HiresAddrLow,y
 sta tmp0+0
 lda _HiresAddrHigh,y
 sta tmp0+1
 lda save_a

__auto_dx   
 sbc #00     			; -DX
 
NOPE 
 ; Draw the pixel
 sta save_a
 sty save_y
 ldy _TableDiv6,x
 lda _TableBit6Reverse,x
 eor (tmp0),y
 sta (tmp0),y
 lda save_a
 ldy save_y
  
__auto_cpx
 cpx #00				; At the endpoint yet?
 bne LOOP
 rts

 
/* 
Therefore, if we could keep track of the bit position of x, we could tell when x crossed a column, 
and just add 128 to the base address. Not only that, but we also know to increase the high byte of 
the pointer by one when we have crossed two columns. 

The logic is as follows: 

Find the bit pattern for a given x (for speed, use a table) 
If it is 10000000 then we have jumped a column 
If the column we are in doesn't have the high bit set in the low byte of the pointer to the base of 
the column, then set the high bit (add 128) 
Otherwise, set the high bit to zero (add 128), and increase the high byte of the column pointer 
(step into the next page). 
Here is (more or less) the code: 
In BASIC: 

	2000 rem bp(x) contains bit position for x
	2010 if int(x/8) = x/8 then base=base+128
	2020 poke base+y, (peek(base+y) or bp(x))

In assembly: 
        LDA     BITP,X  4       ;Load the bit pattern from a table
        BPL     CONT    3  2    ;Still in the same column?
        EOR     $LO        3    ;If not, add 128 to the low byte
        STA     $LO        3
        BMI     CONT       3  2 ;If the high bit is set, stay in the same page
        INC     $HI           5 ;Otherwise point to the next page
        LDA     #$128         2 ;We still need the bit pattern for x!
   CONT ORA     ($LO),Y 5
        STA     ($LO),Y 6       ;Plot the point
                        --------
           Cycle count: 18 26 32

*/ 


