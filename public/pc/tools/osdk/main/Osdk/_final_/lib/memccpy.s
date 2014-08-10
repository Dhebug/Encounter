; void *memccpy(void *dest, void *source, int c, unsigned int count)

_memccpy
        ldy #4
        lda (sp),y
        sta strncpy1+6

        ldy #7
        jmp cpycommon   ; we modify and use strncpy

