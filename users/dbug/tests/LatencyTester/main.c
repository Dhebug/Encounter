
#include "lib.h"


//
// From 'test.s'
//
extern void UpdatePSG();
extern void PsgStopSound();

extern void PsgExplode();

extern void CommonTest();
extern void AudioTest();
extern void VisualTest();

extern void KeyboardFlush();
extern void KeyboardWait();


extern unsigned char gKey;
extern unsigned char gDelay;
extern unsigned int  gRandomValue;
extern unsigned int  gReaction;

extern unsigned int  PsgfreqA;          //  0 1
extern unsigned int  PsgfreqB;          //  2 3
extern unsigned int  PsgfreqC;          //  4 5
extern unsigned char PsgfreqNoise;     //  6
extern unsigned char Psgmixer;         //  7
extern unsigned char PsgvolumeA;       //  8
extern unsigned char PsgvolumeB;       //  9
extern unsigned char PsgvolumeC;       // 10
extern unsigned int  PsgfreqShape;      // 11 12 
extern unsigned char PsgenvShape;      // 13


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


#define MAX_TEST_COUNT 10


unsigned int gGlobalMinDelay;
unsigned int gGlobalMaxDelay;

unsigned int gMinDelay;
unsigned int gMaxDelay;


void main()
{		
	// Debounce keyboard
	while (key())
	{
		get();
	};

	gGlobalMinDelay=65535;
	gGlobalMaxDelay=0;

	// Main testing loop
	while (1)
	{
		int testCount;

		setflags(SCREEN|NOKEYCLICK);
		paper(0);
		ink(3);
		cls();
	    PrintString(40*0,"\4Latency Tester 1.0");
		PrintString(40*0+35,"\1Dbug");

		PrintString(40*2,"\3This program will measure the latency");
		PrintString(40*3,"\3of your Oric system between the moment");
		PrintString(40*4,"\3you see or hear a signal, and how long");
		PrintString(40*5,"\3it takes to receive a keyboard input.");

		PrintString(40*7,"\5The theoretical faster loop is with a");
		PrintString(40*8,"\5real Oric connected to a CRT TV.");
		PrintString(40*9,"\5Emulators will be slower due to many");
		PrintString(40*10,"\5factors, including audio buffers, usb");
		PrintString(40*11,"\5delays, screen data generation, ... ");
		PrintString(40*12,"\5Scan doublers also often add latency");
		PrintString(40*13,"\5depending of the size of the internal");
		PrintString(40*14,"\5buffering required to build the image.");

		PrintString(40*16,"\6The test is simple: After some delays");
		PrintString(40*17,"\6of varying length, you will either see");
		PrintString(40*18,"\6or hear a signal.");

		PrintString(40*20,"\2As soon as you see or hear the signal");
		PrintString(40*21,"\2you need to press the space bar.");

		if (gGlobalMaxDelay)
		{
			sprintf(0xBB80+40*24,"\5Latest Fastest: %d Slowest: %d      ",gMinDelay,gMaxDelay);
			sprintf(0xBB80+40*25,"\5Today's Fastest: %d Slowest: %d      ",gGlobalMinDelay,gGlobalMaxDelay);		
		}

		PrintString(40*27+8,"\14PRESS ANY KEY TO START");

		get();


		//
		// Start the test
		//
		cls();
	    PrintString(40*0,"\4Latency Tester 1.0");
		PrintString(40*0+35,"\1Dbug");
		KeyboardFlush();

		gMinDelay=65535;
		gMaxDelay=0;

		for (testCount=0;testCount<MAX_TEST_COUNT;testCount++)
		{
			gReaction=-1;

			while (gReaction==-1)
			{	
				PrintString(40*27+8,"\3TEST STARTED - STAY FROSTY");

				gRandomValue=2000+(rand()&8191);

				//gRandomValue=1281;

				sprintf(0xBB80+40*2,"\3Test %d/%d (rand:%d)",testCount,MAX_TEST_COUNT,gRandomValue);

				poke(0xBB80+40*12+1,0);
				poke(0xBB80+40*13+1,0);
				PrintString(40*12+12,"\12 PRESS A KEY NOW!");
				PrintString(40*13+12,"\12 PRESS A KEY NOW!");

				CommonTest();

				poke(0xBB80+40*12+1,0);
				poke(0xBB80+40*13+1,0);

				if (gReaction==-1)
				{
					PrintString(40*27+8,"\14\1TOO EARLY! TRY AGAIN!        ");
					KeyboardWait();
				}
			}

			if (gReaction<gMinDelay)
			{
				gMinDelay=gReaction;
			}
			if (gReaction>gMaxDelay)
			{
				gMaxDelay=gReaction;
			}

			sprintf(0xBB80+40*25,"\5Fastest: %d Slowest: %d      ",gMinDelay,gMaxDelay);

			get();
		}

		// Record the scores
		if (gMinDelay<gGlobalMinDelay)
		{
			gGlobalMinDelay=gMinDelay;
		}
		if (gMaxDelay>gGlobalMaxDelay)
		{
			gGlobalMaxDelay=gMaxDelay;
		}

	};

}




