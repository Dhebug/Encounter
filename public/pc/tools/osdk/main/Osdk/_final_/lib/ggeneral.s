; Help routines for more complicated functions


getXparm               ; Get X params (16bit) from stack
        ldy #0         ; X is the number of params
        sty $2e0       ; Zero error indicator.
        stx tmp        ; store X in storage byte
        ldx #0
getXloop
        lda (sp),y
        sta $2e1,x
        inx    
        iny    
        lda (sp),y
        sta $2e1,x
        inx 
        iny            ; 
        dec tmp        ; decrement pointer
        bne getXloop
        rts

        
grexit        
        lda $2e0       ;Return error from Graphics or sound routines
grexit2        
	tax
	lda #0
        rts 
