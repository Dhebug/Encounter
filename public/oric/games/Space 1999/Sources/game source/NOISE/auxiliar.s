
;; Auxiliar functions...

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;do_div6
; Helper function...
; Finds a div 6 and returns result in a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+do_div6
    tax             ;; use it as index.
    lsr             ;; is it odd?
    bcs d6_oddcol  ;; then skip till next label, else...
    lda tab_mod06,x ;; load quotient & store it
    ;sta tmp       
    jmp d6_done2   ;; done!
d6_oddcol          ;; what if x is odd? Note the sequence
    asl             ;; "lsr a / asl a" means A := (A/2)-1 if
    tax             ;; A is odd (this case), so now a is even.
    lda tab_mod06,x ;; we fetch divisor then
d6_done2
    rts
    

#ifndef FASTMULT

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;mul8
; op1*op2 (8-bit fast multiplication)
; This routine multiplies a * b (being a & b 8-bit numbers), based on the fact that
; a * b = (a^2 + b^2 - (a-b)^2) >> 1 , and using a table of squares.
; Numbers are up to 127
; Params in tmp0 and tmp0+1, result returned in tmp1 (2 bytes)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+mul8
    ;; calculate a^2 
    ldy tmp0 
    lda sq_tableLO,y
    sta tmp1
    lda sq_tableHI,y
    sta tmp1+1

    ;; calculate b^2 an add it to the
    ;; previous result
    ldy tmp0+1
    lda sq_tableLO,y
    clc
    adc tmp1
    sta tmp1
    lda sq_tableHI,y
    adc tmp1+1
    sta tmp1+1

    ;; calculate (a-b)^2 and substract
    ;; it from the previous result
    lda tmp0
    sec
    sbc tmp0+1
    bpl m8_notneg
    sta tmp
    lda #0
    sec
    sbc tmp
m8_notneg
    tay
    lda sq_tableLO,y
    sta tmp
    sec
    lda tmp1
    sbc tmp
    sta tmp1
    lda sq_tableHI,y
    sta tmp
    lda tmp1+1
    sbc tmp
    sta tmp1+1

    
    ;; divide result by 2
    lsr tmp1+1
    ror tmp1

    rts ; We're done!

#endif


;;;; C interfaces...


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; char dodiv6(char op)
; returns op div 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
+_dodiv6
    ldy #0
    lda (sp),y
    jsr do_div6
    tax
    lda #0
    rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; void ij2xy(unsigned char i, unsigned char j, unsigned char *x, unsigned char * y)
; Gets x,y screen position from tile i,j coordinates 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

+_ij2xy
  ; Fetch return pointers...
    ldy #4
    lda (sp),y
    sta tmp4
    iny
    lda (sp),y
    sta tmp4+1
    iny
    lda (sp),y
    sta tmp5
    iny
    lda (sp),y
    sta tmp5+1  

  ; Fetch i and j
    ldy #0
    lda(sp),y
    sta op1
    ldy #2
    lda(sp),y
    sta op2

#ifdef 0       
    ;calculate equivalent x and y 
    clc
    adc op1     ;i+j
    sta tmp0
    lda #alto_tile/2      
    sta tmp0+1
    jsr mul8
    lda tmp1   ;(alto_tile/2)*(i+j)
    clc 
    adc #32    ; +32 ; ANTES SUMABAMOS 12!

    ldy #0
    sta (tmp5),y  ; store y

    lda op1    
    sec
    sbc op2    ; i-j
    bpl p1t_unsigned
    sta tmp0
    sec
    lda #0
    sbc tmp0
    sta tmp0
    lda #ancho_tile/2
    sta tmp0+1
    jsr mul8
    sec
    lda #0
    sbc tmp1 ; (ancho_tile/2)*(i-j)
    jmp p1t_cont2
p1t_unsigned
    sta tmp0
    lda #ancho_tile/2
    sta tmp0+1
    jsr mul8
    lda tmp1   ; (ancho_tile/2)*(i-j)
p1t_cont2

    clc
    adc #108   ;+120-ancho_tile/2
    ldy #0
    sta (tmp4),y  ; store y
#endif
	jsr ij2xy
	
	tya
	ldy #0
	sta (tmp5),y
	txa
	sta (tmp4),y
	
    rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ij2xy
; Helper function. Calculates the
; equivalent x,y screen coords from
; a tile position i,j
;
; Params: op1: i, op2: j
; Returns x position in X and y position in Y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

+ij2xy
    ;calculate equivalent x and y 
	lda op2
    clc
    adc op1     ;i+j
#ifndef FASTMULT
    sta tmp0
    lda #alto_tile/2      
    sta tmp0+1
    jsr mul8
    lda tmp1   ;(alto_tile/2)*(i+j)
	clc 
#else
	asl
	sta tmp
	asl
	clc
	adc tmp
#endif    
    adc #32    ; +32 ; ANTES SUMABAMOS 12!
	
	pha	; Save result
	
    lda op1    
    sec
    sbc op2    ; i-j
    bpl ij2xy_unsigned
    sta tmp0
    sec
    lda #0
    sbc tmp0
#ifndef FASTMULT
    sta tmp0
    lda #ancho_tile/2
    sta tmp0+1
    jsr mul8
	lda tmp1
#else
	asl
	sta tmp
	asl
	clc
	adc tmp
	asl
	sta tmp1
#endif
    sec
    lda #0
    sbc tmp1 ; (ancho_tile/2)*(i-j)
    jmp ij2xy_cont2
ij2xy_unsigned
#ifndef FASTMULT
    sta tmp0
    lda #ancho_tile/2
    sta tmp0+1
    jsr mul8
    lda tmp1   ; (ancho_tile/2)*(i-j)
#else
	asl
	sta tmp
	asl
	clc
	adc tmp
	asl
#endif
ij2xy_cont2

    clc
    adc #108   ;+120-ancho_tile/2
	tax

	; Get y coord
	pla
	tay
	
end
    rts


