
;CPU USAGE FRAMEWORK


#define PROFILER_ASM

#define PROFILER_IRQVECTOR	$245
;#define PROFILER_IRQVECTOR	$FFFC


; Where the profiler is display on screen.
#define PROFILER_SCREEN_BASE $bb80+40*25		
#define PROFILER_LINE0		PROFILER_SCREEN_BASE+0
#define PROFILER_LINE1		PROFILER_SCREEN_BASE+40
#define PROFILER_LINE2		PROFILER_SCREEN_BASE+80


;Based on setting T1 to FFFF and adding to global counter in IRQ for up to 16.5
;Million Clock Cycles.


#define VIA_T1CL 			$0304
#define VIA_T1CH 			$0305

#define VIA_T1LL 			$0306
#define VIA_T1LH 			$0307




#include "profile.h"

#ifdef PROFILER_ENABLE

	.zero

_profiler_temp_0			.dsb 1
_profiler_temp_1			.dsb 1
_profiler_function_id		.dsb 1							; 1 byte function counter
	
	.text
	
_ProfilerRoutineCount		.dsb PROFILER_ROUTINE_COUNT		; How many times a routine has been called in a frame

_ProfilerRoutineTimeLow		.dsb PROFILER_ROUTINE_COUNT		; 16 bits duration for each routine (low byte)
_ProfilerRoutineTimeMid		.dsb PROFILER_ROUTINE_COUNT		; 16 bits duration for each routine (mid byte)
_ProfilerRoutineTimeHigh	.dsb PROFILER_ROUTINE_COUNT		; 16 bits duration for each routine (high byte)

_ProfilerFrameCount			.dsb 2							; 16 bits frame counter
_ProfilerCycleCountLow		.dsb 1							; 24 bits cycle counter (should be in Zero Page, really)
_ProfilerCycleCountMid		.dsb 1							; 24 bits cycle counter (should be in Zero Page, really)
_ProfilerCycleCountHigh		.dsb 1							; 24 bits cycle counter (should be in Zero Page, really)




_ProfilerInitialize
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
 lda #<_ProfilerIrqRoutine
 sta PROFILER_IRQVECTOR+0
 lda #>_ProfilerIrqRoutine
 sta PROFILER_IRQVECTOR+1

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
 ; Should probably restore the original IRQ handler
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
 


  
_ProfilerNextFrame
.(
 ; Increment the totaly number of frames
 inc _ProfilerFrameCount+0
 bne end
 inc _ProfilerFrameCount+1
end   

 ; Reset the individual routine counters
 lda #0
 ldx #PROFILER_ROUTINE_COUNT
loop
 sta _ProfilerRoutineCount-1,x
 sta _ProfilerRoutineTimeLow-1,x
 sta _ProfilerRoutineTimeMid-1,x
 sta _ProfilerRoutineTimeHigh-1,x
 dex
 bne loop 
 
 ; Reset the global cycle counter 
 sei
 lda #$FF
 
 ; Our main timer starts at $FFFFFF
 sta _ProfilerCycleCountLow
 sta _ProfilerCycleCountMid
 sta _ProfilerCycleCountHigh
 
 ; Set t1 counter to FFFF so that we can be sure the first count is correct
 ; As a bonus this will also reset any Interrupt flag the routine up till now may have triggered.
 sta VIA_T1CL
 sta VIA_T1CH
 cli
 
 rts
 .)
 

_ProfilerEnterFunction
.(
 ; One more entry for this function
 ldx _profiler_function_id
 inc _ProfilerRoutineCount,x
 
 ; Store the current profile value in the stack
 sei
 
 ;Immediately after capture current T1 (Last count)
 lda VIA_T1CL
 ldy VIA_T1CH
 sty _profiler_temp_1

 ; Add the start value
 clc
 adc _ProfilerRoutineTimeLow,x
 sta _ProfilerRoutineTimeLow,x
 
 lda _ProfilerRoutineTimeMid,x
 adc _profiler_temp_1
 sta _ProfilerRoutineTimeMid,x
 
 lda _ProfilerRoutineTimeHigh,x
 adc _ProfilerCycleCountHigh
 sta _ProfilerRoutineTimeHigh,x
 
 cli
  
 rts 
 .)
 
_ProfilerLeaveFunction
.(
 ldx _profiler_function_id
 
 ; Store the current profile value in the stack
 sei
 
 ;Immediately after capture current T1 (Last count)
 lda VIA_T1CL
 ldy VIA_T1CH
 sta _profiler_temp_0
 sty _profiler_temp_1
  
 ; Subtract the end value
 sec
 lda _ProfilerRoutineTimeLow,x
 sbc _profiler_temp_0
 sta _ProfilerRoutineTimeLow,x
 
 lda _ProfilerRoutineTimeMid,x
 sbc _profiler_temp_1
 sta _ProfilerRoutineTimeMid,x
 
 lda _ProfilerRoutineTimeHigh,x
 sbc _ProfilerCycleCountHigh
 sta _ProfilerRoutineTimeHigh,x
 
 cli
  
 rts 
 .)
 
 
 
_ProfilerDisplay
.(
 sei
 
 ;Immediately after capture current T1 (Last count)
 lda VIA_T1CL
 ldy VIA_T1CH
 
 ;Now because T1 is counting 65535 down we'll need to invert the value we've sampled
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
 
 
 ;
 ; Show the Frame message
 ;
 .(
 ldx #0
loop 
 lda ProfilerMessageFrame,x
 beq end
 sta PROFILER_LINE0,x
 inx
 bne loop
end 
 .)
 
 ;
 ; Show the frame number
 ;
 .(
 lda _ProfilerFrameCount+1
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+6

 lda _ProfilerFrameCount+1
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+7
  
 lda _ProfilerFrameCount+0
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+8
 
 lda _ProfilerFrameCount+0
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+9
 .)
 
 ;
 ; Show the global profiler IRQ counter
 ;
 .(
 lda _ProfilerCycleCountHigh
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+11

 lda _ProfilerCycleCountHigh
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+12
 	

 lda _ProfilerCycleCountMid
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+13

 lda _ProfilerCycleCountMid
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+14

 
 lda _ProfilerCycleCountLow
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+15

 lda _ProfilerCycleCountLow
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+16
 .)
 
 
 ;
 ; Show the count for each routine
 ;
 ldy #0
 ldx #8*0
 jsr ProfilerDisplayFuncCount
 ldy #1
 ldx #8*1
 jsr ProfilerDisplayFuncCount
 ldy #2
 ldx #8*2
 jsr ProfilerDisplayFuncCount
 ldy #3
 ldx #8*3
 jsr ProfilerDisplayFuncCount
 ldy #4
 ldx #8*4
 jsr ProfilerDisplayFuncCount
  
 ;
 ; Show the time for each routine
 ;
 ldy #0
 ldx #8*0
 jsr ProfilerDisplayFuncTime
 ldy #1
 ldx #8*1
 jsr ProfilerDisplayFuncTime
 ldy #2
 ldx #8*2
 jsr ProfilerDisplayFuncTime
 ldy #3
 ldx #8*3
 jsr ProfilerDisplayFuncTime
 ldy #4
 ldx #8*4
 jsr ProfilerDisplayFuncTime
   
 cli
 rts
.)


ProfilerDisplayFuncCount
.( 
 lda _ProfilerRoutineCount,y
 pha
 pha
 
 lda #" "
 sta PROFILER_LINE1+0,x
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE1+1,x
 lda #"x"
 sta PROFILER_LINE1+2,x
 
 pla
 lsr
 lsr
 lsr
 lsr
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE1+3,x
 
 pla
 and #$0F
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE1+4,x
 rts
 .)


ProfilerDisplayFuncTime
.(
 lda _ProfilerRoutineTimeLow,y
 pha
 pha
 lda _ProfilerRoutineTimeMid,y
 pha
 pha
 lda _ProfilerRoutineTimeHigh,y
 pha
 pha
 
 lda #" "
 sta PROFILER_LINE2+0,x

 pla
 lsr
 lsr
 lsr
 lsr
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE2+1,x
 
 pla
 and #$0F
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE2+2,x
  
 pla
 lsr
 lsr
 lsr
 lsr
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE2+3,x
 
 pla
 and #$0F
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE2+4,x
   
 pla
 lsr
 lsr
 lsr
 lsr
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE2+5,x
 
 pla
 and #$0F
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE2+6,x
 rts
 .)
 
 
ProfilerMessageHexDigit	.byte "0123456789ABCDEF",0
ProfilerMessageFrame 	.byte "Frame:",0
 
 
#endif

 
 