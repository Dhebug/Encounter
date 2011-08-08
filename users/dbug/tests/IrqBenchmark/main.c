
#include "lib.h"


//
// From 'digiplayer.s'
//
void DigiPlayer_InstallIrq();

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
	unsigned int offset;
		
	cls();
    PrintString(0,"\4IRQ Benchmark 1.3");
		
	DetectOverlay();
    if (OverlayAvailable)
    {
	    PrintString(40-4,"\4OVR");
    }
    else
    {
	    PrintString(40-4,"\1ROM");
    }

    offset=80;
        
    // Compute the timer minimum delay
    Sei();
	ProfilerReset();
	ProfilerRead();
	ProfilerTimerOffset=65535-ProfilerTimer;
	
    PrintChar(offset,5);
    PrintString(-1,"TIMER2 OFFSET:");
    PrintHex(-1,ProfilerTimerOffset);
    PrintChar(-1,0);
    offset+=40*2;
    Cli();
    


    // Benchmark 1: Normal Oric interruptions 
    PrintChar(offset,17);
    PrintString(-1,"Normal ORIC boot with IRQ");
    PrintChar(-1,0);
    offset+=40;
    
    Cli();
    
    BenchmarkLoop(offset);
    offset+=40*4;

	
    // Benchmark 2: All interruptions disabled
    PrintChar(offset,17);
    PrintString(-1,"SEI");
    PrintChar(-1,0);
    offset+=40;
    
    Sei();
    
    BenchmarkLoop(offset);
    offset+=40*4;

    
    // Benchmark 3: All interruptions disabled + sample player enabled
    PrintChar(offset,17);
    PrintString(-1,"SEI+Initialised IRQ");
    PrintChar(-1,0);
    offset+=40;
    
	OverlayUsesROM();
    DigiPlayer_InstallIrq();		// Install the irq handler
    Sei();
    
    BenchmarkLoop(offset);
    offset+=40*4;

    	    	
    // Benchmark 4: All interruptions authorised + sample player enabled
    PrintChar(offset,17);
    PrintString(-1,"CLI+Initialised IRQ (from ROM)");
    PrintChar(-1,0);
    offset+=40;
    
    Sei();
	OverlayUsesROM();
    DigiPlayer_InstallIrq();		// Install the irq handler
    Cli();
    
    BenchmarkLoop(offset);
    offset+=40*4;

    // Benchmark 5: All interruptions authorised + sample player enabled
    if (OverlayAvailable)
    {
	    PrintChar(offset,17);
	    PrintString(-1,"CLI+Initialised IRQ (from RAM)");
	    PrintChar(-1,0);
	    offset+=40;
	    
	    Sei();
		OverlayUsesRAM();
	    DigiPlayer_InstallIrq();		// Install the irq handler
	    Cli();
	    
	    BenchmarkLoop(offset);
	    offset+=40*4;
	}
    
	// Done	
	while (1)
	{
	}
	  
}




