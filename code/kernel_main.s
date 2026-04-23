#include "params.h"
#include "../build/floppy_description.h"

; ============================================
; Kernel zero page layout (linear from $00)
; ============================================
    .zero
    *= OSDK_ZP_START
#include "zp_crt.inc"

_IrqCounter             .dsb 1
_VblCounter             .dsb 1

; Used by the kernel code (irq.s WaitFrames, audio, etc.) and by modules
_param0                 .dsb 2
_param1                 .dsb 2
_param2                 .dsb 2

    .text

; ============================================
; Shared library imports
; ============================================
// These are parts of the OSDK libraries used by all four modules of the game
// By importing them inside the kernel we avoid wasting room on disk
#pragma osdk import _memset _memcpy mul16i mul16u

; ============================================
; Kernel Entry Point
; ============================================
; Called once at boot by the loader.
; Installs the IRQ handler, then chains to the first game module.
;
_KernelEntry
    jsr _System_InstallIRQ_SimpleVbl

    ; Chain to the first enabled module
    ; Modules load right after the kernel (_KernelEndText)
#if defined(ENABLE_SPLASH)
    lda #LOADER_SPLASH_PROGRAM
#elif defined(ENABLE_INTRO)
    lda #LOADER_INTRO_PROGRAM
#else
    lda #LOADER_GAME_PROGRAM
#endif
    sta _LoaderApiEntryIndex
    lda #<_KernelEndText
    sta _LoaderApiAddressLow
    lda #>_KernelEndText
    sta _LoaderApiAddressHigh
    jmp _LoaderApiInitializeFileFromDirectory

; ============================================
; IRQ install / restore
; ============================================
_System_InstallIRQ_SimpleVbl
.(
    sei

    lda $306
    sta VIA_Restore_Low+1
    lda $307
    sta VIA_Restore_High+1

    lda $FFFE
    sta IRQ_Restore_Low+1
    lda $FFFF
    sta IRQ_Restore_High+1

    ;  Set the VIA parameters to get a 200hz IRQ
    lda #<19966/4
    sta $306
    lda #>19966/4
    sta $307

    ; Install interrupt (this works only if overlay ram is accessible)
    lda #<InterruptHandler
    sta $FFFE
    lda #>InterruptHandler
    sta $FFFF

    lda #4
    sta _IrqCounter

    lda #0
    sta _VblCounter

    ; Reset the patchable IRQ callback to default (no-op)
    lda #<_DoNothing
    sta _IrqCallback50hz+1
    lda #>_DoNothing
    sta _IrqCallback50hz+2

    cli
    rts
.)

_System_RestoreIRQ_SimpleVbl
.(
    sei

    ;  Restore the VIA
+VIA_Restore_Low
    lda #$12
    sta $306
+VIA_Restore_High
    lda #$12
    sta $307

    ; Restore the IRQ handler
+IRQ_Restore_Low
    lda #$12
    sta $FFFE
+IRQ_Restore_High
    lda #$23
    sta $FFFF

    cli
    rts
.)

; ============================================
; Interrupt Handler (200hz)
; ============================================
InterruptHandler
.(
    bit $304

    pha
    txa
    pha
    tya
    pha

    ; Call the Frequent IRQ handler
    jsr IrqTasksHighSpeed

    dec _IrqCounter
    bne skip_50hz_task

    lda #4
    sta _IrqCounter

    ; 50hz IRQ tasks: keyboard, music, sound, patchable callback
    inc _VblCounter
    jsr ReadKeyboard
    jsr _PlayMusicFrame
    jsr SoundUpdate50hz
+_IrqCallback50hz
    jsr _DoNothing

    ; Call the loader "RGB flash" disk access indicator
    jsr _LoaderApiLoadingAnimation

skip_50hz_task

    ; Restore regs and return
    pla
    tay
    pla
    tax
    pla
    rti
.)

; ============================================
; Wait / Sync utilities
; ============================================

; param0+0/param0+1=number of frames to wait
_WaitFramesAsm
.(
    ; Do we have a zero number of frames???
    lda _param0+0
    bne loop
    lda _param0+1
    bne loop
    rts

loop
    jsr _WaitIRQ    ; Uses A register
    dec _param0+0
    bne loop
    dec _param0+1
    bpl loop
    rts
.)

; Waits for the next IRQ
_VSync
_WaitIRQ
.(
    lda _VblCounter
loop
    cmp _VblCounter
    beq loop
+_DoNothing
    rts
.)

; ============================================
; Inline Parameter Utilities
; ============================================
; Generic helper: copies N inline bytes following a JSR to (sp),
; and adjusts the caller's return address to skip past them.
; Input:  A = number of inline parameter bytes
; Output: (sp)+0..(sp)+(N-1) populated, return address adjusted
; Clobbers: A, X, Y, tmp0, tmp1
_InlineParamsToStack
.(
    sta tmp0                ; save byte count
    tsx

    ; Read caller's return address from hardware stack
    ldy $0103,x
    sty tmp1
    ldy $0104,x
    sty tmp1+1

    ; Adjust return address on stack to skip N param bytes
    clc
    lda tmp0
    adc $0103,x
    sta $0103,x
    bcc no_carry
    inc $0104,x
no_carry

    ; Point tmp1 at first inline param byte (original return + 1)
    inc tmp1
    bne no_inc
    inc tmp1+1
no_inc

    ; Copy N bytes: (tmp1)+Y -> (sp)+Y
    ldy tmp0
    dey
copy
    lda (tmp1),y
    sta (sp),y
    dey
    bpl copy

    rts
.)

; jsr _InlineMemset / .word dest / .byt value,0 / .word size
_InlineMemset
.(
    lda #6
    jsr _InlineParamsToStack
    jmp _memset
.)

; lda fill_value / jsr _InlineMemsetA / .word dest / .word 0 / .word size
_InlineMemsetA
.(
    sta tmp2
    lda #6
    jsr _InlineParamsToStack
    ldy #2
    lda tmp2
    sta (sp),y
    jmp _memset
.)

; jsr _InlineMemcpy / .word dest / .word src / .word size
_InlineMemcpy
.(
    lda #6
    jsr _InlineParamsToStack
    jmp _memcpy
.)

; ============================================
; Panic handler
; ============================================
; Stop the program while blinking the bottom right corner with psychedelic colors
_Panic
#ifdef ENABLE_STACK_DUMP
    ; Display the last return addresses from the stack on screen.
    ; IMPORTANT: No jsr/rts — we must not modify the stack while reading it.
    tsx                         ; X = current stack pointer
    stx tmp3                    ; Save base stack index

    ; Screen pointer: text area line 17, column 0 (line after the clock)
    lda #<($BB80+17*40)
    sta tmp0+0
    lda #>($BB80+17*40)
    sta tmp0+1

    ; Compute number of valid return addresses on stack: min(($FF - SP) / 2, 10)
    lda #$FF
    sec
    sbc tmp3                    ; A = bytes on stack
    lsr                         ; A = number of return addresses
    cmp #10
    bcc use_count
    lda #10
use_count
    sta tmp1                    ; Loop counter
    beq panic_blink             ; Nothing to show

dump_loop
    ldx tmp3
    inx                         ; Point to high byte of return address
    inx
    stx tmp3                    ; Save for next iteration

    ; Print high byte: $0100+X
    lda $0100,x
    ldy #0
    pha
    lsr
    lsr
    lsr
    lsr
    tax
    lda hex_table,x
    sta (tmp0),y
    iny
    pla
    and #$0F
    tax
    lda hex_table,x
    sta (tmp0),y
    iny

    ; Print low byte: $0100+(saved X - 1)
    ldx tmp3
    dex
    lda $0100,x

    pha
    lsr
    lsr
    lsr
    lsr
    tax
    lda hex_table,x
    sta (tmp0),y
    iny
    pla
    and #$0F
    tax
    lda hex_table,x
    sta (tmp0),y

    ; Advance screen pointer to next line (+40 bytes)
    clc
    lda tmp0+0
    adc #40
    sta tmp0+0
    lda tmp0+1
    adc #0
    sta tmp0+1

    dec tmp1
    bne dump_loop
#endif

panic_blink
    lda #16+1
    sta $BFDF
    lda #16+2
    sta $BFDF
    jmp panic_blink

#ifdef ENABLE_STACK_DUMP
hex_table .byt "0123456789ABCDEF"
#endif


_PsgPlayLoopCount
    .dsb 10      ; 10 levels of loops
_PsgPlayLoopPosition
    .dsb 10      ; 10 levels of loops
