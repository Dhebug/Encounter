
#include "lib.h"


//
// From 'digiplayer.s'
//

extern unsigned int ProfilerTimer;
extern unsigned char OverlayAvailable;
extern unsigned int IrqCounter;


unsigned int ProfilerTimerMin=0xFFFF;
unsigned int ProfilerTimerMax=0;
unsigned int ProfilerTimerOffset=0;

unsigned int IrqCounterMin=0xFFFF;
unsigned int IrqCounterMax=0;

unsigned char Hexdigits[]="0123456789ABCDEF";

unsigned char* PrintStringScreen=(unsigned char*)0xbb80;


void PrintString(int offset,char* string)
{
	if (offset>=0)
	{
		PrintStringScreen=(unsigned char*)0xbb80+offset;
	}
	
	while (*string)
	{
		*PrintStringScreen++=*string++;
	}
}

void PrintChar(int offset,unsigned char car)
{
	if (offset>=0)
	{
		PrintStringScreen=(unsigned char*)0xbb80+offset;
	}
	*PrintStringScreen++=car;
}

void PrintHexByte(int offset,unsigned int value)
{
	char buffer[5];
	buffer[0]=Hexdigits[(value>>4)&15];
	buffer[1]=Hexdigits[(value)&15];
	buffer[2]=0;
	PrintString(offset,buffer);
}

void PrintHex(int offset,unsigned int value)
{
	char buffer[5];
	buffer[0]=Hexdigits[(value>>12)&15];
	buffer[1]=Hexdigits[(value>>8)&15];
	buffer[2]=Hexdigits[(value>>4)&15];
	buffer[3]=Hexdigits[(value)&15];
	buffer[4]=0;
	PrintString(offset,buffer);
}




void Benchmark(unsigned int offset)
{
	unsigned int i;
	unsigned char* screen;

	ProfilerReset();
	ProfilerTest_20000_cycles();
	/*
	for (i=0;i<4250;i++)
	{
	}
	*/
	ProfilerRead();

	ProfilerTimer=65535-ProfilerTimer;
	if (ProfilerTimer>ProfilerTimerMax)	ProfilerTimerMax=ProfilerTimer;
	if (ProfilerTimer<ProfilerTimerMin)	ProfilerTimerMin=ProfilerTimer;

	if (IrqCounter>IrqCounterMax)		IrqCounterMax=IrqCounter;
	if (IrqCounter<IrqCounterMin)		IrqCounterMin=IrqCounter;
				
    PrintString(offset+0,"\7CUR:");
    PrintHex(-1,ProfilerTimer);
    PrintChar(-1,0);

    PrintString(offset+40,"\2MIN:");
    PrintHex(-1,ProfilerTimerMin);
    PrintChar(-1,0);
    
    PrintString(offset+80,"\1MAX:");
    PrintHex(-1,ProfilerTimerMax);
    PrintChar(-1,0);
    
    PrintString(offset+80+10,"\3DIFF:");
    PrintHex(-1,ProfilerTimerMax-ProfilerTimerMin);
    PrintChar(-1,0);

    
    PrintString(offset+20,"\7IRQs:");
    PrintHex(-1,IrqCounter);
    PrintChar(-1,0);
        
    PrintString(offset+21+40,"\2MIN:");
    PrintHex(-1,IrqCounterMin);
    PrintChar(-1,0);
    
    PrintString(offset+21+80,"\1MAX:");
    PrintHex(-1,IrqCounterMax);
    PrintChar(-1,0);
}


void BenchmarkLoop(unsigned int offset)
{
	unsigned int counter;
	ProfilerTimerMin=0xFFFF;
	ProfilerTimerMax=0;
	
	IrqCounterMin=0xFFFF;
	IrqCounterMax=0;
	
    counter=50;
	while (counter--)
	{
      Benchmark(offset);
	}
}


void main()
{
	unsigned char car;
	unsigned int offset;
		
	cls();
    PrintString(0,"\4IRQ Benchmark 1.6");

    //
    // Some basic setup and hardware detection
    //
	DetectOverlay();
            
    // Compute the timer minimum delay
    Sei();
	ProfilerReset();
	ProfilerRead();
	ProfilerTimerOffset=65535-ProfilerTimer;
	
    PrintChar(20,5);
    PrintString(-1,"TIMER2 OFFSET:");
    PrintHex(-1,ProfilerTimerOffset);
    PrintChar(-1,0);
    Cli();
    
    //
    // Ask which test we want to perform
    //    
    PrintString(40,"PRESS (B) FOR BRK TEST");
    PrintString(80,"PRESS (I) FOR IRQ TEST");
    
    do
    {
	    car=toupper(get());
    }
    while ((car!='B') && (car!='I'));
    
       
    
    if (car=='B')
    {
	    //
	    // BRK Test
	    //
	    int flag=0;
		int counter=20*27;
		
		PrintStringScreen=(unsigned char*)0xbb80+40;
		    
	    // Compute the LOW and HIGH irq timings
	    Sei();
		OverlayUsesROM();
	    InstallSamplePlayerIrq();		// Install the irq handler
	    Sei();
	    
	    while (counter--)
	    {
			ProfilerReset();
			TestLowIrq();
			ProfilerRead();
			ProfilerTimer=65535-ProfilerTimer;
				    
			*PrintStringScreen++=(Hexdigits[(ProfilerTimer>>4)&15] | (flag?128:0));
			*PrintStringScreen++=(Hexdigits[(ProfilerTimer)&15] | (flag?128:0));
		    
		    flag=1-flag;
	    }    
	}
	else
	{
		//
		// IRQ Test
		//    
	    offset=40;
	
	    // Benchmark 1: Normal Oric interruptions 
	    PrintChar(offset,17);
	    PrintString(-1,"Normal ORIC boot with IRQ");
	    PrintChar(-1,0);
	    offset+=40;
	    
	    Cli();
	    
	    BenchmarkLoop(offset);
	    offset+=40*3;
	
		
	    // Benchmark 2: All interruptions disabled
	    PrintChar(offset,17);
	    PrintString(-1,"SEI");
	    PrintChar(-1,0);
	    offset+=40;
	    
	    Sei();
	    
	    BenchmarkLoop(offset);
	    offset+=40*3;
	
	    
	    // Benchmark 3: All interruptions disabled + irq counter enabled
	    PrintChar(offset,17);
	    PrintString(-1,"SEI+16khz IRQ");
	    PrintChar(-1,0);
	    offset+=40;
	    
		OverlayUsesROM();
	    InstallCountingIrq();		// Install the irq handler
	    Sei();
	    
	    BenchmarkLoop(offset);
	    offset+=40*3;
	
	    	    	
	    // Benchmark 4: All interruptions authorised + irq counter enabled
	    PrintChar(offset,17);
	    PrintString(-1,"CLI+16khz IRQ (from ROM)");
	    PrintChar(-1,0);
	    offset+=40;
	    
	    Sei();
		OverlayUsesROM();
	    InstallCountingIrq();		// Install the irq handler
	    Cli();
	    
	    BenchmarkLoop(offset);
	    offset+=40*3;
	
	    // Benchmark 5: All interruptions authorised + sample player enabled
	    PrintChar(offset,17);
	    PrintString(-1,"CLI+4khz Sample IRQ (from ROM)");
	    PrintChar(-1,0);
	    offset+=40;
	    
	    Sei();
		OverlayUsesROM();
	    InstallSamplePlayerIrq();		// Install the irq handler
	    Cli();
	    
	    BenchmarkLoop(offset);
	    offset+=40*3;
	
	    
	    // Benchmark 6: All interruptions authorised + irq counter enabled
	    if (OverlayAvailable)
	    {
		    offset+=40;
		    PrintChar(offset,21);
		    PrintString(-1,"BONUS: CLI+16khz IRQ (from RAM)");
		    PrintChar(-1,0);
		    offset+=40;
		    
		    Sei();
			OverlayUsesRAM();
		    InstallCountingIrq();		// Install the irq handler
		    Cli();
		    
		    BenchmarkLoop(offset);
		    offset+=40*3;
		}
	}
    	        
	// Done	
    Sei();
	while (1)
	{
	}	 
}




