; The rest of the hires and sound routines. Use Params.
        
_curset
		;jmp _curset
        ldx #3         ;Get three parms
        jsr getXparm
        jsr $f0c8      ;curset
        jmp grexit     ;common exit point

_curmov        
        ldx #3         ;Get three parms
        jsr getXparm
        jsr $f0fd      ;curmov
        jmp grexit     ;common exit point
                 
_draw       
        ldx #3         ;Get three parms
        jsr getXparm
        jsr $f110      ;draw
        jmp grexit     ;common exit point
                 
_hchar 
        ldx #3         ;Get three parms
        jsr getXparm
        jsr $f12d      ;char
        jmp grexit     ;common exit point

_fill                
        ldx #3         ;Get three parms
        jsr getXparm
        jsr $f268      ;fill
        jmp grexit     ;common exit point

_paper
        ldx #1         ;Get one parm
        jsr getXparm
        jsr $f204      ;paper
        jmp grexit     ;common exit point

_ink
        ldx #1         ;Get one parm
        jsr getXparm
        jsr $f210      ;ink
        jmp grexit     ;common exit point
        
_circle        
        ldx #2         ;Get two parms
        jsr getXparm
        jsr $f37f      ;circle
        jmp grexit     ;common exit point

_point        
        ldx #2          ;Get two parms
        jsr getXparm
        jsr $f1c8       ;point
        lda $2e1
        jmp grexit2     ;common exit point No2, store just A
        
_pattern
        ldy #0
        lda (sp),y
        sta $213
        tya
        jmp grexit2
