
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
_ProfilerRoutineCount		.dsb PROFILER_ROUTINE_COUNT		; How many times a routine has been called in a frame

_ProfilerRoutineTimeLow		.dsb PROFILER_ROUTINE_COUNT		; 16 bits duration for each routine (low byte)
_ProfilerRoutineTimeMid		.dsb PROFILER_ROUTINE_COUNT		; 16 bits duration for each routine (mid byte)
_ProfilerRoutineTimeHigh	.dsb PROFILER_ROUTINE_COUNT		; 16 bits duration for each routine (high byte)

_ProfilerFrameCount			.dsb 2							; 16 bits frame counter
_ProfilerCycleCount			.dsb 4							; 32 bits cycle counter (should be in Zero Page, really)

_ProfilerFunctionId			.dsb 1							; 1 byte function counter
_ProfilerStackIndex			.dsb 1							; 1 byte stack pointer

_ProfilerStackTimeLow		.dsb PROFILER_MAX_CALLDEPTH		; 24 bits duration for each routine (low byte)
_ProfilerStackTimeMid		.dsb PROFILER_MAX_CALLDEPTH		; 24 bits duration for each routine (mid byte)
_ProfilerStackTimeHigh		.dsb PROFILER_MAX_CALLDEPTH		; 24 bits duration for each routine (high byte)



_ProfilerInitialize
.(
 ; Initialize the various profiler parameters
 ; to use sane values.
 lda #0
 sta _ProfilerFrameCount+0
 sta _ProfilerFrameCount+1 
 
 sta _ProfilerCycleCount+0
 sta _ProfilerCycleCount+1
 sta _ProfilerCycleCount+2
 sta _ProfilerCycleCount+3

 ;
 ; Install the IRQ vector
 ;
 sei
 lda #<_ProfilerIrqRoutine
 sta PROFILER_IRQVECTOR+0
 lda #>_ProfilerIrqRoutine
 sta PROFILER_IRQVECTOR+1

 ; Set t1 latch to FFFF
 ; We don't need to mess around with setting any special T1 mode, Oric boot
 ; will have already done this.
 lda #$FF
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
 ;jmp _ProfilerIrqRoutine
 ;Reset IRQ
 cmp VIA_T1CL

 inc _ProfilerCycleCount+2
 bne end
 inc _ProfilerCycleCount+3
end	
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
 
 ; Reset the stack
 sta _ProfilerStackIndex

 ; Reset the global cycle counter 
 sei
 sta _ProfilerCycleCount+0
 sta _ProfilerCycleCount+1
 sta _ProfilerCycleCount+2
 sta _ProfilerCycleCount+3
 
 ; Set t1 counter to FFFF so that we can be sure the first count is correct
 ; As a bonus this will also reset any Interrupt flag the routine up till now may have triggered.
 lda #$FF
 sta VIA_T1CL
 sta VIA_T1CH
 cli
 
 rts
 .)
 

_ProfilerEnterFunction
.(
 ;jmp _ProfilerEnterFunction
 
 ; One more entry for this function
 ldx _ProfilerFunctionId
 inc _ProfilerRoutineCount,x
 
 ; Store the current profile value in the stack
 sei
 
 ;Immediately after capture current T1 (Last count)
 lda VIA_T1CL
 ldy VIA_T1CH
 
 ldx _ProfilerStackIndex
 
 ;Now because T1 is counting 65535 down we'll need to invert the value we've sampled
 sta _ProfilerStackTimeLow,x
 tya
 sta _ProfilerStackTimeMid,x
 
 sec
 lda #$FF
 sbc _ProfilerStackTimeLow,x
 sta _ProfilerStackTimeLow,x
 lda #$FF
 sbc _ProfilerStackTimeMid,x
 sta _ProfilerStackTimeMid,x
 
 lda _ProfilerCycleCount+2
 sta _ProfilerStackTimeHigh,x
 cli
  
 inc _ProfilerStackIndex
 rts 
 .)
 
_ProfilerLeaveFunction
.(
 ;jmp _ProfilerLeaveFunction
 
 ; Store the current profile value in the stack
 sei
 
 ;Immediately after capture current T1 (Last count)
 lda VIA_T1CL
 ldy VIA_T1CH
 
 ldx _ProfilerStackIndex
 
 ;Now because T1 is counting 65535 down we'll need to invert the value we've sampled
 sta _ProfilerStackTimeLow,x
 tya
 sta _ProfilerStackTimeMid,x
 
 sec
 lda #$FF
 sbc _ProfilerStackTimeLow,x
 sta _ProfilerStackTimeLow,x
 lda #$FF
 sbc _ProfilerStackTimeMid,x
 sta _ProfilerStackTimeMid,x
 
 lda _ProfilerCycleCount+2
 sta _ProfilerStackTimeHigh,x
 cli
  
 ; Compute the difference in cycles
 sec
 lda _ProfilerStackTimeLow,x
 sbc _ProfilerStackTimeLow-1,x
 sta _ProfilerStackTimeLow,x
 lda _ProfilerStackTimeMid,x
 sbc _ProfilerStackTimeMid-1,x
 sta _ProfilerStackTimeMid,x
 lda _ProfilerStackTimeHigh,x
 sbc _ProfilerStackTimeHigh-1,x
 sta _ProfilerStackTimeHigh,x
 
 ; Add that to the count for this particular routine
 ldy _ProfilerFunctionId
 clc
 lda _ProfilerStackTimeLow,x
 adc _ProfilerRoutineTimeLow,y
 sta _ProfilerRoutineTimeLow,y
 lda _ProfilerStackTimeMid,x
 adc _ProfilerRoutineTimeMid,y
 sta _ProfilerRoutineTimeMid,y
 lda _ProfilerStackTimeHigh,x
 adc _ProfilerRoutineTimeHigh,y
 sta _ProfilerRoutineTimeHigh,y
 
 
 ; Move down the stack
 dec _ProfilerStackIndex
  
 rts 
 .)
 
 
 
_ProfilerDisplay
.(
 sei
 
 ;Immediately after capture current T1 (Last count)
 lda VIA_T1CL
 ldy VIA_T1CH
 
 ;Now because T1 is counting 65535 down we'll need to invert the value we've sampled
 sta _ProfilerCycleCount+0
 sty _ProfilerCycleCount+1
 
 lda #$FF
 sec
 sbc _ProfilerCycleCount+0
 sta _ProfilerCycleCount+0
 lda #$FF
 sbc _ProfilerCycleCount+1
 sta _ProfilerCycleCount+1
 
 
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
 lda _ProfilerCycleCount+2
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+11

 lda _ProfilerCycleCount+2
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+12
 	

 lda _ProfilerCycleCount+1
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+13

 lda _ProfilerCycleCount+1
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+14

 
 lda _ProfilerCycleCount+0
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+15

 lda _ProfilerCycleCount+0
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE0+16
 .)
 
 
 ;
 ; Show the count for each routine
 ;
 ldy #0
 
 lda #" "
 sta PROFILER_LINE1+0
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE1+1
 lda #"x"
 sta PROFILER_LINE1+2 
 
 lda _ProfilerRoutineCount,y
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE1+3
 
 lda _ProfilerRoutineCount,y
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE1+4
 
 iny
 
 lda #" "
 sta PROFILER_LINE1+5
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE1+6
 lda #"x"
 sta PROFILER_LINE1+7 
 
 lda _ProfilerRoutineCount,y
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE1+8
 
 lda _ProfilerRoutineCount,y
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE1+9
 
 iny
 
 lda #" "
 sta PROFILER_LINE1+10
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE1+11
 lda #"x"
 sta PROFILER_LINE1+12
 
 lda _ProfilerRoutineCount,y
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE1+13
 
 lda _ProfilerRoutineCount,y
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE1+14
 
 
 ;
 ; Show the time for each routine
 ;
 ldy #0
 
 lda #" "
 sta PROFILER_LINE2+0

 lda _ProfilerRoutineTimeHigh,y
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+1
 
 lda _ProfilerRoutineTimeHigh,y
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+2
  
 lda _ProfilerRoutineTimeMid,y
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+3
 
 lda _ProfilerRoutineTimeMid,y
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+4
   
 lda _ProfilerRoutineTimeLow,y
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+5
 
 lda _ProfilerRoutineTimeLow,y
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+6
 
 /*
 iny
 
 lda #" "
 sta PROFILER_LINE2+5
 lda _ProfilerRoutineTimeMid,y
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+6
 
 lda _ProfilerRoutineTimeMid,y
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+7
 
 lda _ProfilerRoutineTimeLow,y
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+8
 
 lda _ProfilerRoutineTimeLow,y
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+9
 
 iny
 
 lda #" "
 sta PROFILER_LINE2+10
 lda _ProfilerRoutineTimeMid,y
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+11
 
 lda _ProfilerRoutineTimeMid,y
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+12
 
 lda _ProfilerRoutineTimeLow,y
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+13
 
 lda _ProfilerRoutineTimeLow,y
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta PROFILER_LINE2+14
 */ 
  
 cli
 rts
.)


ProfilerMessageHexDigit	.byte "0123456789ABCDEF",0
ProfilerMessageFrame 	.byte "Frame:",0
 
 
#endif

 
 