; char *strtok(char *s, char *delim)

strtokp
        brk
        brk

_strtok
        ldy #0          ; check if s==NULL
        lda (sp),y
        bne strtok1
        iny
        lda (sp),y
        bne strtok1

strtok0
        lda strtokp     ; recalling previous pointer
        ldy #0
        sta (sp),y
        sta tmp
        iny
        lda strtokp+1
        sta (sp),y
        ora tmp
        beq strtok4

strtok1
        ldy #0          ; retval=cp
        lda (sp),y
        sta strtok2+1
        iny
        lda (sp),y
        sta strtok2+3

        jsr _strpbrk
        stx strtokp     ; store result of strpbrk to previous pointer
        sta strtokp+1

        ora strtokp
        beq strtok5     ; result NULL?

        lda strtokp     ; no -- then place a \0.
        sta tmp
        lda strtokp+1
        sta tmp+1
        ldy #0
        lda #0
        sta (tmp),y

strtok2
        ldx #1
        lda #3
        inc strtokp     ; increase previous pointer by one
        bne strtok3
        inc strtokp+1

strtok3
        rts

strtok4
        jmp retzero

strtok5
        ldx strtok2+1
        lda strtok2+3
        rts

