

;; Plots debris (a point) at given X1,Y1 position (signed 16-bit)
;; after clipping

draw_debris
.(

    lda X1
    sta op1
    lda X1+1
    sta op1+1

    lda #(CLIP_RIGHT)
    sta op2
    lda #0
    sta op2+1
    jsr cmp16
    bpl end
    lda #(CLIP_LEFT)
    sta op2
    jsr cmp16
    bmi end

    jsr draw_dot
    inc Y1
    bcc plot
    inc Y1+1
plot
    jmp draw_dot
end
    rts

.)

draw_dot
.(
    lda Y1
    sta op1
    lda Y1+1
    sta op1+1

    lda #(CLIP_BOTTOM)
    sta op2
    lda #0
    sta op2+1
    jsr cmp16
    bpl end
    lda #(CLIP_TOP)
    sta op2
    jsr cmp16
    bmi end
  
    ldx X1
    ldy Y1

    jsr pixel_address
    eor (tmp0),y
    sta (tmp0),y
end
    rts    
.)



