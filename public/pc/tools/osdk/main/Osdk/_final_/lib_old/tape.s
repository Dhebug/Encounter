;	Tape I/O.

_cwrite			; this writes a byte to tape
        ldy #$0
        lda (sp),y
        jmp $e65e

_cread			; reads a byte from tape
        jsr $e6c9
        jmp grexit2

_cwritehdr equ $e607	; writes a file header to tape
_creadsync equ $e735	; read synchro bytes (all 0x16 bytes)
	
