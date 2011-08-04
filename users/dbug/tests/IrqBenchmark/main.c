
#include "lib.h"


//
// From 'digiplayer.s'
//
void DigiPlayer_InstallIrq();

extern unsigned int ProfilerTimer;
extern unsigned char OverlayAvailable;



unsigned int ProfilerTimerMin=0xFFFF;
unsigned int ProfilerTimerMax=0;

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
			
    PrintString(offset+0,"\7CUR:");
    PrintHex(-1,ProfilerTimer);
    PrintChar(-1,0);
    
    PrintString(offset+40,"\2MIN:");
    PrintHex(-1,ProfilerTimerMin);
    PrintChar(-1,0);
    
    PrintString(offset+80,"\1MAX:");
    PrintHex(-1,ProfilerTimerMax);
    PrintChar(-1,0);
}


void main()
{
	unsigned int counter;
	unsigned int offset;
		
	cls();
    PrintString(0,"\4IRQ Benchmark 1.0");
		
	DetectOverlay();
    if (OverlayAvailable)
    {
	    PrintString(40-4,"\4OVR");
    }
    else
    {
	    PrintString(40-4,"\1ROM");
    }

        
    // Benchmark 1: All interruptions disabled
    offset=80;
    PrintChar(offset,17);
    PrintString(-1,"SEI");
    PrintChar(-1,0);
    offset+=40;
    
    Sei();
    
    counter=50;
	while (counter--)
	{
      Benchmark(offset);
	}

    // Benchmark 2: All interruptions disabled + sample player enabled
    offset+=40*4;
    PrintChar(offset,17);
    PrintString(-1,"SEI+Initialised IRQ");
    PrintChar(-1,0);
    offset+=40;
    
    DigiPlayer_InstallIrq();		// Install the irq handler
    Sei();
    
    counter=50;
	while (counter--)
	{
      Benchmark(offset);
	}
	    	
    // Benchmark 3: All interruptions authorised + sample player enabled
    offset+=40*4;
    PrintChar(offset,17);
    PrintString(-1,"CLI+Initialised IRQ");
    PrintChar(-1,0);
    offset+=40;
    
    Cli();
    
    counter=50;
	while (counter--)
	{
      Benchmark(offset);
	}  

	// Done	
    offset+=40*4;
    PrintString(offset,"\2Done");
	while (1)
	{
	}
	  
}




