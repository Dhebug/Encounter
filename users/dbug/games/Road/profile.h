//
// User settings
//
#define PROFILER_ENABLE			// Comment out to disable profiling
#define PROFILER_USE_PRINTER	// Comment out to disable the usage of printer
#define PROFILER_USE_NAMES		// Comment out to disable the usage of function names

#ifdef PROFILER_MAIN
#define FUNCTIONNAME(function_id,function_name)	.byte function_id,function_name,0
#else
#define FUNCTIONNAME(function_id,function_name)
#endif


//
// List of routines (need an enum !)
// Should have incrementing numbers, finishing by PROFILER_ROUTINE_COUNT as the number of routines to profile
//
#define ROUTINE_MAIN_LOOP			0
#define ROUTINE_DRAW_ROAD			1
#define ROUTINE_SCROLL_COLORS 		2
#define ROUTINE_TURN_LOOP			3
#define ROUTINE_DRAW_LOOP			4
//#define ROUTINE_UNUSED				5
#define PROFILER_ROUTINE_COUNT   	5	


FUNCTIONNAME(ROUTINE_MAIN_LOOP,"MainLoop")
FUNCTIONNAME(ROUTINE_DRAW_ROAD,"DrawRoad")
FUNCTIONNAME(ROUTINE_SCROLL_COLORS,"ScrollColors")
FUNCTIONNAME(ROUTINE_TURN_LOOP,"TurnLoop")
FUNCTIONNAME(ROUTINE_DRAW_LOOP,"DrawLoop")
//FUNCTIONNAME(ROUTINE_UNUSED,"---")
FUNCTIONNAME(PROFILER_ROUTINE_COUNT,0)	// End marker
	



//
// Profiler API
//
#ifdef PROFILER_ENABLE
// Profiler is enabled

#ifdef PROFILER_ASM
// Assembler API
#define PROFILE_ENTER(id)	.byte $08,$48,$a9,id,$20,<_ProfilerEnterFunctionAsm,>_ProfilerEnterFunctionAsm,$68,$28
#define PROFILE_LEAVE(id)	.byte $08,$48,$a9,id,$20,<_ProfilerLeaveFunctionAsm,>_ProfilerLeaveFunctionAsm,$68,$28
#define PROFILE(id)         .byte $08,$08,$08,$48,$a9,id,$20,<_ProfilerEnterFunctionStack,>_ProfilerEnterFunctionStack,$68,$28

#else
// C API
#define PROFILE_ENTER(id) {profiler_function_id=id;ProfilerEnterFunctionC();}
#define PROFILE_LEAVE(id) {profiler_function_id=id;ProfilerLeaveFunctionC();}

extern unsigned char ProfilerRoutineCount[PROFILER_ROUTINE_COUNT];
extern unsigned char ProfilerRoutineTimeLow[PROFILER_ROUTINE_COUNT];
extern unsigned char ProfilerRoutineTimeHigh[PROFILER_ROUTINE_COUNT];
extern unsigned int ProfilerFrameCount;
extern unsigned char profiler_function_id;

void ProfilerInitialize();
void ProfilerTerminate();
void ProfilerNextFrame();
void ProfilerDisplay();
void ProfilerEnterFunction();
void ProfilerLeaveFunction();
#endif


#else
// Profiler is disabled, "do nothing" macros

#define PROFILE_ENTER(id)
#define PROFILE_LEAVE(id)
#define PROFILE(id)

#ifdef PROFILER_ASM
// Assembler API
#else
// C API
#define ProfilerInitialize()
#define ProfilerTerminate()
#define ProfilerNextFrame()
#define ProfilerDisplay()
#endif

#endif

/*

I wonder if we could hack a profiler, which would compute the average 
time/count spent in some routines, perhaps with a "enter/leave" function 
that would take the value of the VIA timer, and increment a counter.

Let's imagine a PROFILE macro, and a set of defines:

#define PROFILER_ENABLE

#define ROUTINE_PROJECTION 0
#define ROUTINE_CLIPPING 1
#define ROUTINE_DRAWING 2
#define ROUTINE_AI 3
#define ROUTINE_STARFIELD 4
#define ROUTINE_COUNT 5

etc...

Then some tables to store the data:

#ifdef PROFILER_ENABLE
ProfilerRoutineCount      .dsb ROUTINE_COUNT
ProfilerRoutineTimeLow .dsb ROUTINE_COUNT
ProfilerRoutineTimeHigh .dsb ROUTINE_COUNT
#endif

Then the PROFILE macro itself, would be use that way:

ProjectionRoutine
    PROFILE_ENTER(ROUTINE_PROJECTION)
    bla
    bla
    bla
    jsr something
    bne loopsomewhere
    PROFILE_LEAVE(ROUTINE_PROJECTION)
    rts

This would increment the ProfilerRoutineCount entry for this routine, and 
add the VIA timer to the ProfilerRoutineTimeLow/High.
Obviously you have to put the LEAVE on every single exit point, which kind 
of suck, so a solution for that would be to also have an additional smart 
one that automaticaly does the LEAVE when exiting a routine.

Something like that:

ProjectionRoutine
    PROFILE(ROUTINE_PROJECTION) // Do the ENTER and push the LEAVE
    bla
    bla
    bla
    jsr something
    bne loopsomewhere
    rts  // Automaticall calls the LEAVE function

Of course all the macros should no nothing if the ENABLE_PROFILE is not 
enabled.

I guess the PROFILE routine could be doing something like that:

    lda #<ProfileEnd
    pha
    lda #>ProfileEnd
    pha

So it would call the ProfileEnd when performing a rts in the profiled 
function.
Just an idea, need to think about it :)

Perhaps something I could implement as displayed in the 3 last lines of the 
screen :)

Screen layout:

0123456789012345678901234567890123456789
Frame:0123
 1:0123/01 2:0123/01 3:0123/01 4:0123/01
 5:0123/01 6:0123/01 7:0123/01 8:0123/01

0123456789012345678901234567890123456789
Frame:0123
 1x01 2x01 3x01 4x01 5x01 6x01 7x01 8x01
 0123 0123 0123 0123 0123 0123 0123 0123
 

0123456789012345678901234567890123456789
Frame:0123
 0x01    1x01    2x01    3x01    4x01 
 012345  012345  012345  012345  012345 

0123456789012345678901234567890123456789
Frame:0123
 0x01    1x01    2x01    3x01    4x01 
 12345 12345 12345 12345 12345 12345 12345 



 
0123456789012345678901234567890123456789
Frame:0123 Cycles:012345 Fps:23
 0:012345 1:012345 2:012345 3:012345 
 4:012345 5:012345 6:012345 7:012345 

0123456789012345678901234567890123456789
Frame:0123 Cycles:012345 Fps:23
0:0123451:0123452:0123453:0123454:012345 
5:0123456:0123457:0123458:0123459:012345 

   
012345 012345 012345 012345 012345 

Infos for each profile group:
- Number of calls
- Total duration
- Average duration
- Percentage of frame



 

 
 +0 +10 +20...
*/


