;;;;; Some C wrappers

;; Calculates the dot product between
;; <VX,VY,VZ> and <VectX,VectY,VectZ>
;; see tinefuncs.s

;; int dot_product()
_dot_product
.(
    jsr dot_product
    ldx op1
    lda op1+1
    rts

.)



;; Wrappers for pixel_address (returns
;; address of scan and pixel code in 
;; addr and scan
;; and for put_pixel(char X, char Y). 
 
_addr .word 00
_scan .byt 0
_pixel_address
.(
    ldy #0
    lda (sp),y
    tax

    ldy #2
    lda (sp),y
    tay 

    jsr pixel_address
    sta _scan
    tya
    clc
    adc tmp0
    sta _addr
    bcc end
    inc tmp0+1
end
    lda tmp0+1
    sta _addr+1

    rts

.)


_put_pixel
.(

    ldy #0
    lda (sp),y
    tax
 
    ldy #2
    lda (sp),y
    tay 

    jsr pixel_address
	;eor (tmp0),y				; 5
    ora (tmp0),y				; 5
	sta (tmp0),y   
    rts
.)



