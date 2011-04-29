#include	"lib.h"

// --------------------------------------
// Assembly 2002 Intro Invit - Oric Port
// (c) 2002 Mickael Pointier.
// This code is provided as-is.
// I do not assume any responsability
// concerning the fact this is a bug-free
// software !!!
// Except that, you can use this example
// without any limitation !
// If you manage to do something with that
// please, contact me :)
// --------------------------------------
// --------------------------------------
// For more information, please contact me
// on internet:
// e-mail: mike@defence-force.org
// URL: http://www.defence-force.org
// --------------------------------------
// Note: This text was typed with an Win32
// editor. So perhaps the text will not be
// displayed correctly with other OS.


#define FINAL_VERSION



extern unsigned char picture_font_1[];
extern unsigned char picture_font_2[];

extern unsigned char *UnpackSrc;
extern unsigned char *UnpackDst;

extern void Unpack();


extern void TeletypeUpdate();

extern void InterruptCode();
extern void InterruptInstall();


extern void ScrollerInit();

extern unsigned char VblCounter;


extern void DisplayClearScreen();
extern void DisplayFighter();
extern void DisplayEmptyScreen();


extern void VSync();


extern unsigned char MessageAssemblyIntro[];
extern unsigned char MessageFightersIntro[];
extern unsigned char MessageFighterEetu[];
extern unsigned char MessageFighterSivu[];
extern unsigned char MessageFighterVirne[];
extern unsigned char MessageFighterPehu[];
extern unsigned char MessageFighterAbyss[];

/*
The frames used in the c64 version are 40x25 with 4 colors (256 bytes per
frame), and I can provide the datafiles if necessary. :)

the karate-animation is 48 frames which is played back and forth. so the
file is 12k's in size. there's 4 pixels per byte (in reverse order though,
bits 0&1 is the first pixel, 2&3 the second and so on). The frames is 250
bytes (1000 pixels) and there's 6 bytes "empty space" between frames.
*/



extern unsigned char picture_frames[];
extern unsigned char TabColors[];
extern unsigned char TabColors1[];

extern unsigned char DisplayColumn;


extern unsigned char MovieFrame;

void FrameUnpack();



/*
extern unsigned char BottomMessage[];

void DisplayBanner()
{
	unsigned char *ptr_scroller;
	unsigned char *ptr_screen;
	unsigned char c;

	ptr_screen=(unsigned char*)0xbf68;
	ptr_scroller=BottomMessage;
	*ptr_screen++=17;	// RED
	while (c=*ptr_scroller++)
	{
		*ptr_screen++=c;
	}

	ptr_screen=(unsigned char*)0xbf68+40;
	*ptr_screen++=17;	// RED
	while (c=*ptr_scroller++)
	{
		*ptr_screen++=c;
	}

	ptr_screen=(unsigned char*)0xbf68+80;
	*ptr_screen++=17;	// RED
	while (c=*ptr_scroller++)
	{
		*ptr_screen++=c;
	}
}
*/



void ScrollerDisplay();


void LZ77_UnCompress(unsigned char *buf_src,unsigned char *buf_dest)
{
	UnpackSrc=buf_src;
	UnpackDst=buf_dest;
	Unpack();
}


extern unsigned char picture_fight_1[];
extern unsigned char picture_fight_2[];
extern unsigned char picture_fight_3[];
extern unsigned char picture_fight_4[];
extern unsigned char picture_fight_5[];



void UpdateDemo()
{
	static int frame=0;
	static char direction=0;

	MovieFrame=frame;
	FrameUnpack();
	FrameDisplay();
#ifndef FINAL_VERSION
	ScrollerDisplay();
	TeletypeUpdate();
#endif

	//display(frame);

	if (!direction)
	{
		if (frame<47)	frame++;
		else			direction=1;
	}
	else
	{
		if (frame>0)	frame--;
		else			direction=0;
	}
}


void Animate()
{
	unsigned char	reg;
	unsigned char	count;
	unsigned char	decount;

	DisplayColumn=1;
	while (DisplayColumn<39)
	{
		UpdateDemo();
		DisplayColumn++;
	}

	DisplayColumn=39;
	count=48;
	while (count--)
	{
		UpdateDemo();
	}

	while (DisplayColumn>1)
	{
		UpdateDemo();
		DisplayColumn--;
	}
}

/*
void Temporise()
{
	unsigned char	count;

	count=48;
	while (count--)
	{
		FrameUnpack();
#ifndef FINAL_VERSION
		ScrollerDisplay();
		TeletypeUpdate();
#endif
	}
}
*/


void DisplayMessage(unsigned char *ptr_texte)
{
	unsigned char	*ptr_screen;
	unsigned char	*ptr_font;
	unsigned char	cx;
	unsigned char	y;
	unsigned char	car;

	ptr_screen=(unsigned char*)0xa000+40*16+2;

	cx=0;

	while (1)
	{
		car=*ptr_texte++;
		if (car==1)
		{
			break;
		}
		else
		if (car==0)
		{
			cx=0;
			ptr_screen+=40*8;
		}
		else
		{
			ptr_font=(unsigned char*)0x9800+((int)car)*8;
			for (y=0;y<8;y++)
			{
				ptr_screen[cx+40*y]|=ptr_font[y];
			}
			cx++;
			VSync();
		}
	}
	
}


void Temporise(unsigned char *ptr_texte)
{
	unsigned char	*ptr_screen;
	unsigned char	y,counter;

	ptr_screen=(unsigned char*)0xa000+40*8;

	//while (1)
	{
		//
		// Fade IN
		//
		y=0;
		while (y<188)
		{
			VSync();
			ptr_screen[  0]=16+7;	// Blanc
			ptr_screen[ 40]=16+6;	// Cyan
			ptr_screen[ 80]=16+4;	// Bleu
			ptr_screen[120]=16+0;	// Noir

			ptr_screen[  0+1]=0;	// Noir
			ptr_screen[ 40+1]=1;	// Rouge
			ptr_screen[ 80+1]=3;	// Jaune
			ptr_screen[120+1]=7;	// Blanc

			y++;
			ptr_screen+=40;
		}

		//
		// Display the text
		//
		DisplayMessage(ptr_texte);


		//
		// Temporisation
		//
		counter=50*3;
		while (counter--)
		{
			VSync();
		}


		//
		// Fade OUT
		//
		while (y>0)
		{
			VSync();
			y--;
			ptr_screen-=40;
			ptr_screen[  0]=16+7;	// Blanc
			ptr_screen[ 40]=16+3;	// Jaune
			ptr_screen[ 80]=16+1;	// Rouge
			ptr_screen[120]=16+0;	// Noir

			ptr_screen[  0+1]=7;	// Noir
			ptr_screen[ 40+1]=6;	// Cyan
			ptr_screen[ 80+1]=4;	// Blue
			ptr_screen[120+1]=0;	// Blanc
		}
		/*
		counter=50*3;
		while (counter--)
		{
			VSync();
		}
		*/

	}
}



void DisplayFighterFrame(unsigned char *ptr_picture,unsigned char *ptr_texte)
{
	DisplayClearScreen();
	LZ77_UnCompress(ptr_picture,(unsigned char*)0xdc00);
	DisplayFighter();
	Temporise(ptr_texte);
	DisplayClearScreen();
}



void DisplaySimpleMessage(unsigned char *ptr_texte)
{
	DisplayClearScreen();
	DisplayEmptyScreen();
	Temporise(ptr_texte);
	DisplayClearScreen();
}

/*
extern unsigned char MessageAssemblyIntro[];
extern unsigned char MessageFightersIntro[];
extern unsigned char MessageFighterEetu[];
extern unsigned char MessageFighterSivu[];
extern unsigned char MessageFighterVirne[];
extern unsigned char MessageFighterPehu[];
extern unsigned char MessageFighterAbyss[];
*/

void demo()
{
#ifndef FINAL_VERSION
	hires();
#endif

	ScrollerInit();

#ifdef FINAL_VERSION
	InterruptInstall();
#endif


	memcpy((unsigned char*)0x9800,picture_font_1,1024);
//extern unsigned char picture_font_2[];

	//paper(0);

	//DisplayBanner();
	DisplayClearScreen();

	while (1)
	{
		DisplaySimpleMessage(MessageAssemblyIntro);
		Animate();	
		DisplaySimpleMessage(MessageFightersIntro);
		Animate();	
		DisplayFighterFrame(picture_fight_1,MessageFighterPehu);
		Animate();	
		DisplayFighterFrame(picture_fight_2,MessageFighterAbyss);
		Animate();	
		DisplayFighterFrame(picture_fight_3,MessageFighterEetu);
		Animate();	
		DisplayFighterFrame(picture_fight_4,MessageFighterSivu);
		Animate();	
		DisplayFighterFrame(picture_fight_5,MessageFighterVirne);
	}
}



void main()
{
//	HiresTest();
	demo();
}


