; Memory allocation

_stacksize
        .word $0200      ; Bytes to allow for the C stack

_heapovh
        .byt $04        ; Length of memory block descriptor (minimum 4)

_heapstart
        .word $0000      ; Start of heap memory

_heapend
        .word $b400      ; End of heap memory (should be $9800 for HIRES)

_heapdesc
        .word $0000      ; Pointer to the first block descriptor

_nheapdesc
        .word $0000      ; Total number of descriptors

_nheapbytes
        .word $0000      ; Total bytes of heap memory allocated

_heapsize
        .word $0000      ; Total bytes in the heap


_heapinit               ; initialise the _heapstart pointer.
        clc
        lda _stacksize  ; _heapstart=osdk_stack+_stacksize
        adc osdk_stack
        sta _heapstart
        lda _stacksize+1
        adc osdk_stack+1
        sta _heapstart+1

        lda #0          ; nheapdesc=nheapbytes=heapdesc=0
        sta _nheapdesc
        sta _nheapdesc+1
        sta _nheapbytes
        sta _nheapbytes+1
        sta _heapdesc
        sta _heapdesc+1

_heapupdate
        sec             ; _heapsize=_heapend-_heapstart
        lda _heapend
        sbc _heapstart
        sta _heapsize
        lda _heapend+1
        sbc _heapstart+1
        sta _heapsize+1

        rts


; void *malloc (unsigned int n)

_malloc
        ldy #1                  ; (tmp0) wanted = n + heapovh
        lda (sp),y
        tax
        dey
        lda (sp),y

_mallocmc                       ; machine code entry pt... A=low(n), X=high(n)
        pha
        lda _heapstart          ; if(!heapstart)heapinit
        ora _heapstart+1
        bne mallocproper
        jsr _heapinit

mallocproper
        pla
        clc
        adc _heapovh
        sta tmp0
        txa
        adc #0
        sta tmp0+1

        lda #<_heapdesc     ; (tmp2) desc = &heapdesc
        sta tmp2
        lda #>_heapdesc
        sta tmp2+1

        lda _heapstart          ; (tmp3) start = heapstart
        sta tmp3
        lda _heapstart+1
        sta tmp3+1

mallocloop
        lda tmp2                ; if(!desc)return NULL
        ora tmp2+1
        bne malloc1
        jmp retzero

malloc1
        ldy #0                  ; (tmp4)next=desc->next
        lda (tmp2),y
        sta tmp4
        iny
        lda (tmp2),y
        sta tmp4+1

        ora tmp4                ; if(!next)
        bne malloc2

        ldx _heapend+1          ; temp=heapend
        lda _heapend

malloc2
        ldx tmp4+1              ; temp=next
        lda tmp4

        sec                     ; (temp)len=temp-start
        sbc tmp3
        tay                     ; y=low byte
        txa
        sbc tmp3+1              ; a=high byte

        cmp tmp0+1              ; if(len>=wanted) {compare high bytes}
        bcc mallocelse          ; false, go to else part
        bne mallocthen          ; true, go to then part
        cpy tmp0                ; we have to compare the low bytes, too
        bcc mallocelse          ; false, go to else part

mallocthen
        ldy #0                  ; desc->next=start
        lda tmp3
        sta (tmp2),y
        lda tmp3+1
        iny
        sta (tmp2),y

        dey                     ; (tmp3)start->next=(tmp4)next
        lda tmp4
        sta (tmp3),y
        iny
        lda tmp4+1
        sta (tmp3),y

        iny                     ; (tmpe)start->len=(tmp0)wanted
        lda tmp0
        sta (tmp3),y
        iny
        lda tmp0+1
        sta (tmp3),y

        inc _nheapdesc          ; nheapdesc++
        bne malloc3
        inc _nheapdesc+1

malloc3
        clc                     ; nheapbytes+=wanted
        lda tmp0
        adc _nheapbytes
        sta _nheapbytes
        lda tmp0+1
        adc _nheapbytes+1
        sta _nheapbytes+1

        clc                     ; return start+heapovh
        lda tmp3
        adc _heapovh
        tax
        lda tmp3+1
        adc #0
        rts

mallocelse
        lda tmp4                ; desc=next
        sta tmp2
        lda tmp4+1
        sta tmp2+1

        ldy #2                  ; start=desc+desc->len
        clc
        lda tmp2
        adc (tmp2),y
        sta tmp3
        iny
        lda tmp2+1
        adc (tmp2),y
        sta tmp3+1

        jmp mallocloop          ; continue with loop


;Implementation in C:
;
;void *malloc (unsigned int n)
;{
;     register unsigned int wanted=n+heapovh;       /* tmp0 */
;     register unsigned int len;                    /* tmp1 */
;     register memdesc *desc=(memdesc *)&heapdesc;  /* tmp2 */
;     register memdesc *start=(memdesc *)heapstart; /* tmp3 */
;     register memdesc *next;                       /* tmp4 */
;
;     while(desc){
;          next=desc->next;
;
;          if(!next)len=heapend-(int)start;
;          else len=next-start;
;
;          if(len>=wanted){
;               desc->next=start;
;               start->next=next;
;               start->len=wanted;
;
;               nheapdesc++;
;               nheapbytes+=wanted;
;
;               return (void *)((char *)start+heapovh);
;          } else {
;               desc=next;
;               start=(memdesc *)((char *)desc+desc->len);
;          }
;     }
;     return NULL;
;}



