; Simple graphics/sound/keyboard functions

_hires	equ $ec33
_text	equ $ec21
_ping	equ $fa9f
_shoot	equ $fab5
_zap	equ $fae1
_explode equ $facb
_kbdclick1	equ $fb14
_kbdclick2	equ $fb2a

        
_key
        jsr $023B       ; get key without waiting. If not available
        bpl key001      ; return 0
        jmp grexit2
key001          
	lda #0
        jmp grexit2
        
_cls    equ $ccce
_lores0 equ $d9ed
_lores1 equ $d9ea


_get
        jsr $023B       ; blatantly ripped off Fabrice's getchar
        bpl _get        ; loop until char available
        jmp grexit2     ; rip off Vaggelis' code as well, and exit. :-)

