; Simple graphics/sound/keyboard functions


;
; The idea is that at some point we will implement the correct address on Oric 1
; and add some machine detection that will use the jump location.
;
_hires		jmp $ec33	
_text		jmp $ec21
_ping		jmp $fa9f
_shoot		jmp $fab5
_zap		jmp $fae1
_explode	jmp $facb
_kbdclick1	jmp $fb14
_kbdclick2	jmp $fb2a
_cls		jmp $ccce
_lores0		jmp $d9ed
_lores1		jmp $d9ea

        
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

