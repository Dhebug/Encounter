
    .zero

_angle          .dsb 1
_angle2         .dsb 1
_angle3         .dsb 1
_angle4         .dsb 1
_y              .dsb 1
_position       .dsb 1
_stopMoving     .dsb 1

_height         .dsb 1
_startPosition  .dsb 1
_frameCount     .dsb 2

_ptrSrc          .dsb 2
_ptrDst          .dsb 2
_ptrDstBottom    .dsb 2

_offset                  .dsb 2
_sourceOffset            .dsb 2
_verticalSourceOffset    .dsb 2
_maxVerticalSourceOffset .dsb 2

    .text


IrqTasksHighSpeed
.(
    rts
.)

IrqTasks50hz
.(
    ; Process keyboard
    jsr ReadKeyboard
    jsr _PlayMusicFrame
    jsr SoundUpdate50hz
    rts    
.)


; No-op to avoid a linker bug
_PrinterSendStringAsm
    rts


_Copy38Bytes
.(
    ldx #38-1
loop
+_Copy38Source = *+1
	lda $2211,x
+_Copy38Target = *+1
	sta $5544,x
	dex
	bpl loop
	rts
.)



_Erase38Bytes
.(
    lda #64
    ldx #38-1
loop
+_Erase38Target = *+1
	sta $5544,x
	dex
	bpl loop
	rts
.)


#ifdef ENABLE_MUSIC
_JingleMusic
.(
    .dw events
    .byt 1+2+4+8+16+32        ; All the three channels are used
#include "splash_music.s"
events
#include "splash_music_events.s"
.)
#endif
