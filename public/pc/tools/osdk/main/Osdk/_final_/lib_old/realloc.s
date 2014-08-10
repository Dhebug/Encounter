; void *realloc(void *mem_address, unsigned int newsize)

_realloc
        jsr get_2ptr

        lda op1         ; if(!mem_address)
        ora op1+1
        bne realloc0

        lda op2         ; ...then just return malloc(newsize)
        ldx op2+1
        jmp _mallocmc

realloc0
        lda op2         ; if(!newsize)
        ora op2+1
        bne realloc1

        lda op1         ; ...then just free(mem_address)
        ldx op1+1
        jmp _freemc

realloc1                ; uh-oh, here comes the tough part
        lda op1         ; tmp0=mem_address-_heapovh, to get the memdesc
        sec             
        sbc _heapovh
        sta tmp0
        lda op1+1
        sbc #0
        sta tmp0+1

        ldy #2          ; is the length of the block == newsize?
        lda (tmp0),y
        cmp op2
        bne realloc2    ; no, the low bytes are different
        iny
        lda (tmp0),y
        cmp op2+1
        bne realloc2    ; no, the high bytes are different

reallocret
        lda op1+1       ; YES! No work to be done, just return the buffer
        ldx op1
        rts

realloc2                ; argh, we REALLY have to resize the block!
        lda op2+1       
        cmp (tmp0),y    ; ok, last chance... is newsize<currentsize?
        bmi realloc4    ; no, it's not, (HIGH newsize)>=(HIGH currentsize)
        bcc realloc3    ; YES! Little work to be done!
        lda op2
        dey
        cmp (tmp0),y    ; how about the low bytes?
        bne realloc4    ; bummer, (LOW newsize)>(LOW currentsize)

realloc3                ; Simple work to be done here.
        ldy #0          ; Calculate currentsize-newsize, store in tmp1
        sec
        lda (tmp0),y
        sbc op2
        sta tmp1
        iny
        lda (tmp0),y
        sbc op2+1
        sta tmp1

        sec             ; _nheapbytes-=tmp1
        lda _nheapbytes
        sbc tmp1
        sta _nheapbytes
        lda _nheapbytes+1
        sbc tmp1+1
        sta _nheapbytes+1

        dey             ; And adjust memdesc->len (current size)
        lda op2         ; This will, of course, fragment the memory.
        sta (tmp0),y    ; Oh well... 
        iny
        lda op2+1
        sta (tmp0),y

        jmp reallocret  ; return the same buffer pointer

realloc4                ; Reallocating a larger buffer. Hmm...
        lda op2
        ldx op2+1
        jsr _mallocmc   ; call malloc for a new buffer

        stx tmp         ; did it return NULL?
        pha
        ora tmp
        bne realloc5

        jmp retzero     ; Oops... yes, it did. Return NULL.

realloc5                ; Good, malloc din't return NULL.
        pla             ; we'll be returning its return value, then.
        sta reallocret2+1
        stx reallocret2+3

        ldy #1          ; this is a quick and dirty hack (AND ugly)
        sta (sp),y      ; (AND maybe horribly buggy) :-(
        dey
        txa
        sta (sp),y      ; first store the target block

        ldy #2          ; then store the source block (mem_address)
        lda op1
        sta (sp),y
        iny
        lda op1+1
        sta (sp),y

        iny             ; also store the number of bytes to copy
        lda op2
        sta (sp),y
        iny
        lda op2+1
        sta (sp),y

        jsr _memcpy     ; call memcpy()

        lda op1         ; free(mem_address)
        ldx op1+1
        jsr _freemc

reallocret2             ; ...and return the new buffer
        lda #1
        ldx #3
        rts

