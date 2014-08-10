; Sound routines
_play        
        ldx #4          ;Get four parms
        jsr getXparm
        jsr $fbd0       ;play
        jmp grexit      ;common exit point
        
_music
        ldx #4          ;Get four parms
        jsr getXparm
        jsr $fc18       ;music
        jmp grexit      ;common exit point

_sound        
        ldx #3          ;Get three parms
        jsr getXparm
        jsr $fb40       ;sound
        jmp grexit      ;common exit point
