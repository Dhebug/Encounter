



//
// Profiler
//


#define PROFILER_IRQVECTOR	$FFFE

_ProfilerFrameCount			.dsb 2							; 16 bits frame counter

_ProfilerCycleCountTimeStamp
_ProfilerCycleCountBottom   
_ProfilerCycleCountLow		.dsb 1							; 24 bits cycle counter (should be in Zero Page, really)
_ProfilerCycleCount
_ProfilerCycleCountMid		.dsb 1							; 24 bits cycle counter (should be in Zero Page, really)
_ProfilerCycleCountTop
_ProfilerCycleCountHigh		.dsb 1							; 24 bits cycle counter (should be in Zero Page, really)
_ProfilerCycleCountUnused   .dsb 1                          ; Should stay at zero

#define VIA_T1CL 			$0304
#define VIA_T1CH 			$0305

#define VIA_T1LL 			$0306
#define VIA_T1LH 			$0307

_ProfilerInitialize
    //jmp _ProfilerInitialize
.(
    ; Initialize the various profiler parameters
    ; to use sane values.
    lda #0
    sta _ProfilerFrameCount+0
    sta _ProfilerFrameCount+1 

    ;
    ; Install the IRQ vector
    ;
    sei
    ; Save the existing IRQ vector
    lda PROFILER_IRQVECTOR+0:sta restore_irq_low+1
    lda PROFILER_IRQVECTOR+1:sta restore_irq_high+1

    ; Put the new IRQ vector
    lda #<_ProfilerIrqRoutine:sta PROFILER_IRQVECTOR+0
    lda #>_ProfilerIrqRoutine:sta PROFILER_IRQVECTOR+1

    ; Save the timer values
    lda VIA_T1LL:sta restore_VIA_T1LL+1
    lda VIA_T1LH:sta restore_VIA_T1LH+1
    lda VIA_T1CL:sta restore_VIA_T1CL+1
    lda VIA_T1CH:sta restore_VIA_T1CH+1

    lda #$FF

    ; Our main timer starts at $FFFFFF
    sta _ProfilerCycleCountLow
    sta _ProfilerCycleCountMid
    sta _ProfilerCycleCountHigh


    ; Set t1 latch to FFFF
    ; We don't need to mess around with setting any special T1 mode, Oric boot
    ; will have already done this.
    sta VIA_T1LL
    sta VIA_T1LH

    ; Set t1 counter to FFFF so that we can be sure the first count is correct
    ; As a bonus this will also reset any Interrupt flag the routine up till now may have triggered.
    sta VIA_T1CL
    sta VIA_T1CH
    cli

    rts
.)


_ProfilerTerminate
.(
    ; Restore the original IRQ vector
    sei
+restore_irq_low    lda #00:sta PROFILER_IRQVECTOR+0
+restore_irq_high   lda #00:sta PROFILER_IRQVECTOR+1

+restore_VIA_T1CL   lda #00:sta VIA_T1CL
+restore_VIA_T1CH   lda #00:sta VIA_T1CH   
+restore_VIA_T1LL   lda #00:sta VIA_T1LL
+restore_VIA_T1LH   lda #00:sta VIA_T1LH
    cli
    rts
.)


_ProfilerIrqRoutine
.(
    ; Reset IRQ
    cmp VIA_T1CL

    ; Decrement the high byte
    dec _ProfilerCycleCountHigh
    rti
.)
 
_ProfileStartFunction
beg
.(
    php
    sei
    lda #$FF
    ; Our main timer starts at $FFFFFF
    sta _ProfilerCycleCountLow
    sta _ProfilerCycleCountMid
    sta _ProfilerCycleCountHigh

    sta VIA_T1CL
    sta VIA_T1CH
    plp
    rts
.)

_ProfileEndFunction
.(
    php
    sei
    lda VIA_T1CL
    ldy VIA_T1CH
    sta _ProfilerCycleCountLow
    sty _ProfilerCycleCountMid
     
    lda #$FF
    sec
    sbc _ProfilerCycleCountLow
    sta _ProfilerCycleCountLow
    lda #$FF
    sbc _ProfilerCycleCountMid
    sta _ProfilerCycleCountMid
    lda #$FF
    sbc _ProfilerCycleCountHigh
    sta _ProfilerCycleCountHigh
        
    plp
end    
    rts
.)

