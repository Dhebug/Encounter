
;CPU USAGE FRAMEWORK


#define PROFILER_ASM
#define PROFILER_MAIN

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



_ProfilerNames
#include "profile.h"

#ifdef PROFILER_ENABLE

	.zero

_profiler_temp_0			.dsb 1
_profiler_temp_1			.dsb 1
_profiler_save_x			.dsb 1
_profiler_save_y			.dsb 1
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

#ifdef PROFILER_USE_NAMES
_ProfilerRoutineNameLow		.dsb PROFILER_ROUTINE_COUNT		; adress of the name for each routine (low byte)
_ProfilerRoutineNameHigh	.dsb PROFILER_ROUTINE_COUNT		; adress of the name for each routine (high byte)
#endif



_ProfilerInitialize
.(
#ifdef PROFILER_USE_PRINTER
 lda #<ProfilerMessagePrinterStart
 ldx #>ProfilerMessagePrinterStart 
 jsr _PrinterSendString
 jsr _PrinterSendCrlf
#endif // PROFILER_USE_PRINTER

;bla
; jmp bla

#ifdef PROFILER_USE_NAMES
 .(
 lda #<_ProfilerNames
 sta tmp0+0
 lda #>_ProfilerNames
 sta tmp0+1
 ldx #0
 ldy #0
loop
 ; Get the function id
 lda (tmp0),y
 
 ; Last one ?
 cmp #PROFILER_ROUTINE_COUNT
 beq end
 
 ; Set the current pointer in the pointer table
 .(
 tax
 inc tmp0+0
 bne skip
 inc tmp0+1
skip 
 lda tmp0+0
 sta _ProfilerRoutineNameLow,x
 lda tmp0+1
 sta _ProfilerRoutineNameHigh,x 
 .)
 
 ; Search the null terminator
 .(
search 
 lda (tmp0),y
 inc tmp0+0
 bne skip
 inc tmp0+1
skip 
 cmp #0
 bne search
 .)
 
 jmp loop 
end 
 .)
#endif

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
 
 
/*
; That one is a mad function
; Takes as as the function ID,
; Do the normal profile,
; But then it patches the stack frame to call the release function automatically
At this point the stack contains:

*/
_ProfilerEnterFunctionStack
.(
 rts
.)  

_ProfilerLeaveFunctionStack
.(
 rts
.)  


 
; A=id of the function to profile
_ProfilerEnterFunctionAsm
 .(
 stx _profiler_save_x
 sty _profiler_save_y
  
 ; One more entry for this function
 tax
 inc _ProfilerRoutineCount,x
 
 ; Store the current profile value in the stack
 sei
 
 ;Immediately after capture current T1 (Last count)
 lda VIA_T1CL
 ldy VIA_T1CH
 sty _profiler_temp_0

 ; Add the start value
 clc
 adc _ProfilerRoutineTimeLow,x
 sta _ProfilerRoutineTimeLow,x
 
 lda _ProfilerRoutineTimeMid,x
 adc _profiler_temp_0
 sta _ProfilerRoutineTimeMid,x
 
 lda _ProfilerRoutineTimeHigh,x
 adc _ProfilerCycleCountHigh
 sta _ProfilerRoutineTimeHigh,x
 
 cli
 
 ldx _profiler_save_x
 ldy _profiler_save_y
 
 rts
 .)
  
_ProfilerEnterFunctionC
 .(
 ; One more entry for this function
 ldx _profiler_function_id
 inc _ProfilerRoutineCount,x
 
 ; Store the current profile value in the stack
 sei
 
 ;Immediately after capture current T1 (Last count)
 lda VIA_T1CL
 ldy VIA_T1CH
 sty _profiler_temp_0

 ; Add the start value
 clc
 adc _ProfilerRoutineTimeLow,x
 sta _ProfilerRoutineTimeLow,x
 
 lda _ProfilerRoutineTimeMid,x
 adc _profiler_temp_0
 sta _ProfilerRoutineTimeMid,x
 
 lda _ProfilerRoutineTimeHigh,x
 adc _ProfilerCycleCountHigh
 sta _ProfilerRoutineTimeHigh,x
 
 cli
  
 rts 
 .)
 
 
_ProfilerLeaveFunctionAsm
.(
 stx _profiler_save_x
 sty _profiler_save_y

 tax
 
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
 
 ldx _profiler_save_x
 ldy _profiler_save_y

 rts 
 .)
 
_ProfilerLeaveFunctionC
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
 ; Write the frame number in the string
 ;
 .(
 lda _ProfilerFrameCount+1
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta ProfilerMessageFrameCount+0

 lda _ProfilerFrameCount+1
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta ProfilerMessageFrameCount+1
  
 lda _ProfilerFrameCount+0
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta ProfilerMessageFrameCount+2
 
 lda _ProfilerFrameCount+0
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta ProfilerMessageFrameCount+3
 .)
 
 ;
 ; Write the global profiler IRQ counter in the string
 ;
 .(
 lda _ProfilerCycleCountHigh
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta ProfilerMessageFrameTime+0

 lda _ProfilerCycleCountHigh
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta ProfilerMessageFrameTime+1
 	

 lda _ProfilerCycleCountMid
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta ProfilerMessageFrameTime+2

 lda _ProfilerCycleCountMid
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta ProfilerMessageFrameTime+3

 
 lda _ProfilerCycleCountLow
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 sta ProfilerMessageFrameTime+4

 lda _ProfilerCycleCountLow
 and #$0F
 tax
 lda ProfilerMessageHexDigit,x
 sta ProfilerMessageFrameTime+5
 .)
 cli
 
#ifdef PROFILER_USE_PRINTER
 lda #<ProfilerMessageFrame
 ldx #>ProfilerMessageFrame 
 jsr _PrinterSendString
 jsr _PrinterSendCrlf
#endif // PROFILER_USE_PRINTER
 
 ;
 ; Show the count/time for each routine
 ;
 .( 
 ldy #0
loop_show_functions 
 jsr ProfilerDisplayFuncCountTime
 iny
 cpy #PROFILER_ROUTINE_COUNT
 bne loop_show_functions
 .)
    
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

#ifdef PROFILER_USE_PRINTER
 jsr _PrinterSendCrlf
#endif // PROFILER_USE_PRINTER
   
 rts
.)


ProfilerDisplayFuncCountTime
.( 
 ;stx _profiler_temp_0
 sty _profiler_temp_1
 
 ; Compute the screen horizontal offset (y*8)
 tya
 asl 
 asl 
 asl 
 tax
 
 ; Display on the second line the number of time each routine is called
 lda _ProfilerRoutineCount,y
 pha
 pha
 
 lda #" "
 ;tya
 ;clc
 ;adc #16+1
 sta PROFILER_LINE1+0,x
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE1+1,x                ; Function ID
#ifdef PROFILER_USE_PRINTER
 jsr _PrinterSendChar
#endif // PROFILER_USE_PRINTER
 lda #"x"
 sta PROFILER_LINE1+2,x                
#ifdef PROFILER_USE_PRINTER
 jsr _PrinterSendChar
#endif // PROFILER_USE_PRINTER
 
 pla
 lsr
 lsr
 lsr
 lsr
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE1+3,x               ; Number of calls (high byte)
#ifdef PROFILER_USE_PRINTER
 jsr _PrinterSendChar
#endif // PROFILER_USE_PRINTER
 
 pla
 and #$0F
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE1+4,x               ; Number of calls (low byte)
#ifdef PROFILER_USE_PRINTER
 jsr _PrinterSendChar
#endif // PROFILER_USE_PRINTER

 ;ldx _profiler_temp_0
 ldy _profiler_temp_1
 
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
#ifdef PROFILER_USE_PRINTER
 jsr _PrinterSendChar
#endif // PROFILER_USE_PRINTER

 pla
 lsr
 lsr
 lsr
 lsr
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE2+1,x
#ifdef PROFILER_USE_PRINTER
 jsr _PrinterSendChar
#endif // PROFILER_USE_PRINTER
 
 pla
 and #$0F
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE2+2,x
#ifdef PROFILER_USE_PRINTER
 jsr _PrinterSendChar
#endif // PROFILER_USE_PRINTER
  
 pla
 lsr
 lsr
 lsr
 lsr
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE2+3,x
#ifdef PROFILER_USE_PRINTER
 jsr _PrinterSendChar
#endif // PROFILER_USE_PRINTER
 
 pla
 and #$0F
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE2+4,x
#ifdef PROFILER_USE_PRINTER
 jsr _PrinterSendChar
#endif // PROFILER_USE_PRINTER
   
 pla
 lsr
 lsr
 lsr
 lsr
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE2+5,x
#ifdef PROFILER_USE_PRINTER
 jsr _PrinterSendChar
#endif // PROFILER_USE_PRINTER
 
 pla
 and #$0F
 tay
 lda ProfilerMessageHexDigit,y
 sta PROFILER_LINE2+6,x
#ifdef PROFILER_USE_PRINTER
 jsr _PrinterSendChar
#endif // PROFILER_USE_PRINTER
 

#ifdef PROFILER_USE_PRINTER
#ifdef PROFILER_USE_NAMES
 lda #" "
 jsr _PrinterSendChar
 ldy _profiler_temp_1
 lda _ProfilerRoutineNameLow,y
 ldx _ProfilerRoutineNameHigh,y
 jsr _PrinterSendString
#endif // PROFILER_USE_NAMES
#endif // PROFILER_USE_PRINTER

#ifdef PROFILER_USE_PRINTER
 jsr _PrinterSendCrlf
#endif // PROFILER_USE_PRINTER

 ;ldx _profiler_temp_0
 ldy _profiler_temp_1

 rts
 .)
 

 
#ifdef PROFILER_USE_PRINTER


; Call by doing:
; lda #<msg
; ldx #>msg
; jsr _PrinterSendString
;
_PrinterSendString
 .(
 sta __auto+1
 stx __auto+2
 
 ldx #0
next_char 
__auto
 lda $1234,x
 beq end_of_line
 jsr _PrinterSendChar
 inx
 jmp next_char
end_of_line
 
 rts
 .)
 
; A=character to send
_PrinterSendChar
 .(
 php
 sei
 sta $301		; Send A to port A of 6522
 lda $300
 and #$ef		; Set the strobe line low
 sta $300
 lda $300
 ora #$10		; Set the strobe line high
 sta $300
 plp
loop_wait 		; Wait in a loop until active transition of CA1
 lda $30d
 and #2
 beq loop_wait	; acknowledging the byte
 lda $30d
 rts
 .)

_PrinterSendCrlf
 .(
 lda #10
 jsr _PrinterSendChar
 lda #13
 jsr _PrinterSendChar 
 rts 
 .)

; A=value to send
_PrinterSendHexByte
 .(
 pha
 lsr
 lsr
 lsr
 lsr
 tax
 lda ProfilerMessageHexDigit,x
 jsr _PrinterSendChar

 pla
 jsr _PrinterSendChar 
 rts 
 .)
 
ProfilerMessagePrinterStart	.byte "Profiling started",10,13,0
  
#endif // PROFILER_USE_PRINTER 
 
ProfilerMessageHexDigit		.byte "0123456789ABCDEF",0
ProfilerMessageFrame 		.byte "Frame:"
ProfilerMessageFrameCount	.byte "0000 "
 		                    .byte "Time="
ProfilerMessageFrameTime	.byte "000000"
							.byte 0
ProfilerMessage
 
#endif // PROFILER_ENABLE

 
/*

Profile:
08       php ; place holder
08       php ; place holder
08       php
48       pha 
A9 xx    lda #ROUTINE_ASM
20 xx xx jsr _ProfilerEnterFunctionStack
68       pla
28       plp

Enter:
08       php
48       pha 
A9 xx    lda #ROUTINE_ASM
20 xx xx jsr _ProfilerEnterFunctionAsm
68       pla
28       plp

Leave:
08       php
48       pha 
A9 xx    lda #ROUTINE_ASM
20 xx xx jsr _ProfilerLeaveFunctionAsm
68       pla
28       plp

*/
