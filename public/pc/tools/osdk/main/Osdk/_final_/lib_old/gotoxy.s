; Do not print on the first screen columns. Screen attributes will be destroyed

_gotoxy
        ldy #$0         ; Grab first 8-bit parameter
        lda (sp),y
        sta tmp         ; Store column number (0-based)
        iny
        iny
        lda (sp),y      ; Grab second 8-bit parameter
        sta tmp+1       ; Move it to the X register
        lda $026a       ; Disable the cursor
        pha
        and #$fe        
        sta $026a       
        lda #$00
        jsr $f801
        lda tmp         ; Reload column number
        sta $0269       ; Store it where the OS can find it
        lda tmp+1       ; Now play with the row number
        sta $0268       ; Store it for the OS's sake
        jsr $da0c       ; Calculate screen row address
        lda $1f         ; Update pointers
        ldy $20
        sta $12
        sty $13
        pla             ; Restore state of cursor
        sta $026a
        lda #$01
        jmp $f801

