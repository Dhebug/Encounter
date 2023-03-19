//
// Stuff which is common to the intro and the game
// (c) 2023 Dbug / Defence Force
//

#include "common.h"


char gIsHires = 1;
char* gPrintAddress = (char*)0xbb80;

 score_entry gHighScores[SCORE_COUNT];


void PlaySound(const char* registerList)
{
	memcpy(PsgVirtualRegisters,registerList,14);
	PsgNeedUpdate = 2;
}

void SetLineAddress(char* address)
{
	gPrintAddress=address;
}

void PrintLine(const char* message)
{
	strcpy(gPrintAddress,message);	
	gPrintAddress+=40;
}

 void PrintWord(const char* message)
 {
	char car;
	while (car=*message++)
	{
		*gPrintAddress++=car;
	}
 }


void Text(char paperColor,char inkColor)
{
	int y;
	if (gIsHires)
	{
    	memset((char*)0xa000,paperColor,0xbfe0-0xa000);	
        poke(0xbfdf,26);
        WaitIRQ();
        WaitIRQ();
		memcpy((char*)0xb500,(char*)0x9900,8*96);
		gIsHires=0;	
    }
    else
    {
    	memset((char*)0xbb80,paperColor,0xbfe0-0xbb80);	
    }
	for (y=0;y<28;y++)
	{
		poke(0xbb80+y*40+1,inkColor);
		memset(0xbb80+y*40+2,32,38);
	}
}


void Hires(char paperColor,char inkColor)
{
	int y;
	if (!gIsHires)
	{
		memcpy((char*)0x9900,(char*)0xb500,8*96);
		gIsHires=1;
	}
	memset((char*)0xa000,paperColor,0xbfe0-0xa000);   // Blinks for some reason, bug in memset???
	poke(0xbfdf,31);
	WaitIRQ();
	WaitIRQ();
	for (y=0;y<200;y++) 
	{
		poke(0xa000+y*40+0,paperColor);
		poke(0xa000+y*40+1,inkColor);
	}
	for (y=0;y<3;y++)
	{
		poke(0xbb80+40*25+y*40+0,paperColor);
		poke(0xbb80+40*25+y*40+1,inkColor);
	}
}

void WaitFrames(int frames)
{
    while (frames--)
    {
        WaitIRQ();
    }
}
