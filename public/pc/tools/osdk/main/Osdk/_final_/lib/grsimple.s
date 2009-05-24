; Simple graphics/sound/keyboard functions


        
_key
	jsr $023B       ; get key without waiting. If not available
	bpl key001      ; return 0
	jmp grexit2
key001          
	lda #0
	jmp grexit2
        

_get
	jsr $023B       ; blatantly ripped off Fabrice's getchar
	bpl _get        ; loop until char available
	jmp grexit2     ; rip off Vaggelis' code as well, and exit. 

