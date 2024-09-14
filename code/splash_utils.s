#include "params.h"

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
    jmp SoundUpdateHighSpeed
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




#ifdef PRODUCT_TYPE_TEST_MODE    
//
// These bits are copy-pasted from the rest of the code and are only active when building the "Test" configuration
//
#include "crc32.s"
#include "profiler.s"
#include "score.s"

_InitializeGraphicMode
.(
    jsr _ClearTextWindow

    lda #31|128
    sta $bb80+40*0  	   ; Switch to HIRES, using video inverse to keep the 6 pixels white

    lda #26
	sta $a000+40*128       ; Switch to TEXT
    rts
.)


; Full Oric display is 240x224
; The top graphic window is 240x128
; Which leaves us with a 240x96 text area at the bottom (12 lines )
; 40*12 = 480
_ClearTextWindow  
.(
  lda #" "   ;lda #"x" ;+1+4
  ldx #0
loop
  sta $bb80+40*16+256*0,x
  sta $bfdf-255,x
  dex
  bne loop
  rts
.)


; _param0=paper color
_ClearMessageWindowAsm
.(
    ; Pointer to first line of the "window"
    lda #<$bb80+40*18
    sta tmp0+0
    lda #>$bb80+40*18
    sta tmp0+1

    ldx #1+23-18
loop_line
    ; Erase the 39 last characters of that line
    ldy #39
    lda #32
loop_column
    sta (tmp0),y
    dey
    bne loop_column

    ; Paper color at the start of the line
    lda _param0
    sta (tmp0),y

    ; Next line
    clc
    lda tmp0+0
    adc #40
    sta tmp0+0
    lda tmp0+1
    adc #0
    sta tmp0+1

    dex
    bne loop_line

    rts
.)

#endif

