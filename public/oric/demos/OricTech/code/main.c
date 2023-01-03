//
// VIP 2015
// (c) 2015 Dbug / Defence Force
//
// v1.0: Original release at the VIP party
// v1.1: Fixed a typo in the scroller (2005 instead of 2015) and centered the text properly
//

#include <lib.h>

#include "defines.h"
#include "floppy_description.h"
#include "loader_api.h"
#include "script.h"

#ifdef OSDKNAME_intro
//#error "FUCK"
#endif


// irq.s
extern void System_InstallIRQ_SimpleVbl();
extern void VSync();
extern void Stop();
extern unsigned char KeyboardState;
extern unsigned char KeyboardStateMemorized;

// scroller.s
extern void BigScrollerInit();
extern void BigScrollerUpdate();

extern char* BackgroundPosition;
extern unsigned char BackgroundMapX;
extern unsigned char BackgroundMapActive;

extern unsigned char ScrollerCommand;
extern unsigned char ScrollerCommandParam1;
extern unsigned char ScrollerCommandParam2;
extern unsigned char ScrollerCommandParam3;
extern unsigned char ScrollerCommandParam4;



// buffer.s
extern unsigned char RastersPaper[];
extern unsigned char RastersInk[];
extern unsigned char GradientRainbow[];
extern unsigned char GradientVip[];

extern char BufferCharset[];
extern char BufferCharset30x40[];
extern char BufferInverseVideo[];

extern char MusicData[];
extern char CloudPicture[];
extern char RainDropPicture[];
extern char VipLogoPicture[];
extern char LongScrollerPicture[];
extern char SoundWarningPicture[];
extern char SampleSound[];
extern char SampleSoundDefence[];
extern char SampleSoundForce[];
extern char SampleSoundMusicNonStop[];
extern char SampleSoundTechnoPop[];
extern char SampleSoundChimeStart[];
extern char SampleSoundChimeEnd[];


#ifdef OSDKNAME_intro

void Pause(int delay)
{
	int i;

	for (i=0;i<delay;i++)
	{
		VSync();
	}
}



	char* screen;
	char* picture;
	int x,y,xx,yy;



//int mapDx=1;
//int mapDy=1;

int i,ii,x,y,yy;
int maxdrop;

char* buffer;
char* buffer2;
char* screen;
char* screen2;




int vipCounter;


void ShowVipLogo()
{
	vipCounter=-30;

	buffer=LongScrollerPicture+vipCounter*37;
	yy=0;
	while (vipCounter<350)
	{
		screen=(char*)0xa000;
		xx=x;
		yy=x;
		for (y=0;y<170;y++)
		{
			if (y<130)
			{	
				if (y&1)
				{
					// VIP logo
					//screen[1]=6;
					screen[0]=16+7;
					screen[1]=GradientVip[xx&31];
					xx++;
				}
				else				
				{
					// Rainbow
					//screen[1]=1;
					screen[0]=16+6;
					screen[1]=GradientRainbow[yy&31];
					yy--;
				}
			}
			else
			{
				if (y&1)
				{
					screen[0]=16+7;
					screen[1]=1;
				}
				else
				{
					screen[0]=16+6;					
					if ((y<138) || (y>165))
					{
						screen[1]=1;					
					}
					else
					{
						screen[1]=3;						
					}
				}
			}
			screen+=40;
		}

		screen=(char*)0xa000+40*170;
		buffer2=buffer;
		buffer+=37;
		for (y=0;y<30;y++)
		{
			screen[1]=0;
			if ( ((vipCounter+y)<0) || ((vipCounter+y)>=329) )
			{
				memset(screen+2,64,37);
			}
			else
			{
				memcpy(screen+2,buffer2,37);			
			}
			buffer2+=37;
			screen+=40;
		}

		VSync();
		x++;
		vipCounter++;
	}
}


unsigned int DropStartOffset[]=
{
	40*102+8,
	40*97 +13,
	40*104+18,
	40*101+26,
	40*98 +30
};


void ShowThalionSequence()
{
	// Move down
	screen=(char*)0xa000;
	for (y=0;y<200;y+=2)
	{
		screen[0]=16+4;
		screen[1]=7;
		memset(screen+2,64,38);
		screen+=80;	
#ifndef FAST_INTRO		
		VSync();
		VSync();
#endif		
	}	

	// Move up
	screen+=40;	
	for (y=0;y<200;y+=2)
	{
		screen-=80;	
		screen[0]=16+4;
		screen[1]=7;
		memset(screen+2,64,38);
#ifndef FAST_INTRO			
		VSync();
		VSync();
#endif		
	}

	// Scroll down the clouds -- 33 bytes large, 198x104 pixels in size
#ifdef FAST_INTRO		
	y=104;
#else		
	for (y=0;y<105;y++)
#endif		
	{
		screen=(char*)0xa000+y*40;
		buffer=CloudPicture+33*104;
		for (yy=0;yy<y;yy++)
		{
			buffer-=33;
			screen-=40;
			memcpy(screen+3,buffer,33);
		}
		VSync();
	}	

	// Wait a bit
	Pause(50*1);

	// Then the rain droplets 
	// RainDropPicture -- 2 bytes large 12x25 pixels
	screen2=(char*)0xa000;
	for (i=0;i<60;i++)
	{
		screen=screen2;
		buffer=RainDropPicture;
		for (y=0;y<25;y++)
		{
			for (x=0;x<5;x++)
			{
				*(screen+DropStartOffset[x]+0)=buffer[0];
				*(screen+DropStartOffset[x]+1)=buffer[1];
			}
			buffer+=2;
			screen+=40;
		}
		screen2+=40;
	}

	// Wait a bit
	//Pause(50*5);

	// Fade to light blue background
	screen=(char*)0xa000+40*200;
	buffer=VipLogoPicture+40*200;
	for (y=0;y<200;y+=2)
	{
		buffer-=40;
		screen-=40;	
		screen[0]=16+7;
		screen[1]=   7;
		memcpy(screen+2,buffer+2,38);

		buffer-=40;
		screen-=40;	
		screen[0]=16+6;
		screen[1]=   6;
		memcpy(screen+2,buffer+2,38);
		VSync();
	}	

	//while (1){}
	// Display the VIP logo
	ShowVipLogo();
}

#endif



#ifdef OSDKNAME_intro
//
// The VIP cloud intro
//
void main()
{
//#ifdef ENABLE_VIP_INTRO
	// Install the IRQ handler
	System_InstallIRQ_SimpleVbl();


	// Load the cloud picture
	LoadFileAt(LOADER_CLOUD,CloudPicture);

	// Load the rain drop picture
	LoadFileAt(LOADER_RAINDROP,RainDropPicture);

	// Load the VIP scroll stuff
	LoadFileAt(LOADER_VIP_LOGO,VipLogoPicture);

	// Load the Long Scroller
	LoadFileAt(LOADER_LONG_SCROLLER,LongScrollerPicture);

	// Load the sound warning picture
	LoadFileAt(LOADER_SOUND_WARNING,SoundWarningPicture);

#ifdef ENABLE_MUSIC	
	// Load and play the music
	LoadFileAt(LOADER_INTRO_MUSIC,MusicData);
	Mym_MusicStart();
#endif

	// Display the Thalion blue bubbles sequence
	ShowThalionSequence();

#ifdef ENABLE_MUSIC	
	// Stop the music
	Mym_MusicStop();
#endif

	// Clear the screen
	memset((char*)0xa000,64,8000);

	// Wait one second
	Pause(50*1);

	// Show the sound warning picture
	memcpy((char*)0xa000,SoundWarningPicture,8000);

	// Wait three seconds
	Pause(50*3);

	// Quit
	System_RestoreIRQ();

	// Quit and return to the loader to fetch the second part of the program
	InitializeFileAt(LOADER_TECHTECH_SECOND,0xc000);
//#endif
}
#endif



#ifdef OSDKNAME_techtech

//
// The Tech Tech intro
// _EndDemoData
// 3146 - 3402 - 4170 - 4426 - 4938 - 5194
//
// _InitColorText
// 922 - 0
//
// main
// 185 - 33
/*
void main()
{
	// Initialize stuff
	TechTechInit();
}
*/
#endif


/*

Some more design stuff:
- TEXT screen goes from $BB80 to $BFDF
- HIRES screen goes from $A000 to $BFDF
- The usable STD charset is from $b400+8*32 to $b400+8*(32+96)
                                 $B400+256 to $B400+1024
                                 $B500 to $B7FF

$B500-$A000=5376 / 40 = 134.4
$B800-$A000=6144 / 40 = 153.6

154-134=20 lines

134/8 -> 16.75

For each line:
HIRES ATTRIBUTE TEXT


TechTech history:
- 
- November 1987 - Amiga    - TechTech by Sodan & Magician42 -> http://www.pouet.net/prod.php?which=4445   (http://www.sodan.dk)
- December 1989 - Atari ST -  grodan and kvack kvack (Sowatt Demo) by The Carebears   -> http://www.pouet.net/prod.php?which=754
- March 2004    - Windows  - Ported to pc -> http://www.pouet.net/prod.php?which=11934



November 1987
Sodan & Magician 42
release
Tech Tech
on the Amiga
-
December 1989
The Carebears
convert it in
Grodan and Kvack Kvack
on the Atari ST

FontleroyBrown 20

--------------------
In November 1987
Sodan & Magician 42
released Tech Tech
on the Amiga.

In December 1989
The Carebears
converted it into
Grodan and Kvack Kvack
for the Atari ST.

In May 2005
Defence Force
realized it could not be done
on the Oric but tried anyway !!!
-----------------------


*/





