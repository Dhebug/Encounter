/* -*- c-basic-offset: 8 -*-
 * modified from _Dbug_ code
 */
//
// AlchimieGarden
//
// An Oric intro for Alchimie-X coded at the Kindergarden 2013 demo party.
//
//
#include <lib.h>

#include "script.h"

#include "AmigaTopazUnicodeRus_8.h"

extern unsigned char VIPSplash[];
extern unsigned char Gadgets[];
extern unsigned char LogoA0XB[];
//extern unsigned char logovip3[];
//extern unsigned char logoua3[];

unsigned char logobuf[40*/*200*/142];

//extern unsigned char	Texture[256*64];
extern char				TabCos[256];

#include "angle.c"
#include "prof.c"

unsigned char  IncX;
unsigned char  IncY;

#define	SCROLLER_START_ADDR 0xa000+SCROLLER_OFFSET


extern unsigned char ScrollerCommand;
extern unsigned char ScrollerCommandParam1;
extern unsigned char ScrollerCommandParam2;
extern unsigned char ScrollerCommandParam3;
extern unsigned char ScrollerCommandParam4;

extern unsigned char ScrollerScreenDir;


void System_InstallIRQ_SimpleVbl();
void ScrollerInit();


void (*BottomEffectCallBack)(void);
void (*TopEffectCallBack)(void);


unsigned char		value_1 = 0;
unsigned char		value_2 = 0;
void JSun_MainLoop()
{
	
	//while (1)
	//{
	DisplayJSun();
	
	IncX+=2+TabCos[value_1]>>4;
	IncY+=2+TabCos[value_2]>>4;
	
	value_1+=1;
	value_2+=2;
	//}
}

void JSun_Init()
{
	unsigned int    y;
    
	for (y=0;y<40*100;y++)
		{
			angle[y]&=31;
		}

	//hires();
}



void ClearTextWindow()
{
	char i, j;
	memset((char*)0xbb80+40*TWIN_LINE,A_BGGREEN/*BLUE*/,(TWIN_HEIGHT)*40);	
	for (i = TWIN_LINE; i < TWIN_LINE+TWIN_HEIGHT; i++) {
		poke(0xbb80+40*i+39, 30);    // HIRES
		for (j = 0; j < 8; j++)
			poke(0xa000+40*(8*i+j)+TWIN_COL, 26);    // TEXT
	}
	/*
	poke(0xa000+40*84,16+1);
	poke(0xa000+40*85,16+3);
	poke(0xa000+40*86,16+1);
	poke(0xa000+40*87,16+0);
	*/
}




void EffectDoNothing()
{

}



void main()
{
	char i;
	char done = 0;
		
	//
	// Pseudo hires switch
	//
	hires();
	//
	// Clear the screen
	//
	memset((char*)0xa000,0,8000);
	memset((char*)(0xa000+(40*19*8)),A_BGBLUE,40*(200-19*8+4));
	ScrollerInit();
	// screen gadgets
	for (i = 0; i < 8; i++) {
		*(char*)(SCROLLER_START_ADDR+40*i+40-7) = A_FWCYAN | 0x80;
		memcpy((char*)(SCROLLER_START_ADDR+40*i+40-6), &Gadgets[i*6], 6);
		*(char*)(SCROLLER_START_ADDR+40*i+40-6) |= 0x80;
		*(char*)(SCROLLER_START_ADDR+40*i+40-5) = A_FWWHITE | 0x80;
	}


	BottomEffectCallBack=EffectDoNothing;
	TopEffectCallBack=EffectDoNothing;

	System_InstallIRQ_SimpleVbl();
		

	//GameOfLife_Init();	
	//ClearTextWindow();

	while (1)
		{
			//if (key() == 27)
			//	break;
			if (!done && ScrollerCommand!=SCROLLER_NOTHING)
				{
					unsigned char command=ScrollerCommand;
					ScrollerCommand=SCROLLER_NOTHING;		
					switch (command)
						{
						case SCROLLER_SHOW_LOGOVIP:
							{
								/*memset(logobuf, 0x40, 40*150);*/
								//file_unpack((char *)0xa000, VIPSplash);
								file_unpack((char*)logobuf,VIPSplash);
								memcpy((void *)(0xa000), logobuf, 40*141);
								//file_unpack((char*)logobuf+40*40,logoua3);
							}
							break;

						case SCROLLER_SCREEN_UP:
							{
								if (!done)
									ScrollerScreenDir = -20;
							}
							break;

						case SCROLLER_SHOW_LOGOA0XB:
							{
								file_unpack((char*)logobuf,LogoA0XB);
								//memcpy(logobuf, LogoA0XB, LOGOA0XB_W*LOGOA0XB_H);
								for (i = 0; i < LOGOA0XB_H; i++) {
									memcpy((void *)(0xa000+(LOGOA0XB_Y+i)*40+LOGOA0XB_X), logobuf+i*LOGOA0XB_W, LOGOA0XB_W);
								}
								//ClearTextWindow();
								//memset(logobuf, 0x40, 40*150);
								//file_unpack((char*)logobuf+40*40,logoua3);
							}
							break;

						case SCROLLER_START_BOING:
							{
								//ClearTextWindow();
								JSun_Init();
								BottomEffectCallBack=JSun_MainLoop;
							}
							break;

						case SCROLLER_BOTTOM_TEXT:
							{
								char *t = *(void **)&ScrollerCommandParam1;
								char *dst = (char *)0xbf90+2;
								*(dst+40) = 0x0a;
								*dst++ = 0x0a;
								//memcpy((void *)(0x9800+32*8), &AmigaTopazUnicodeRus_8_bits, sizeof(AmigaTopazUnicodeRus_8_bits));
								//*(char *)(0xbf70-40) = 30;
								//*(char *)0xbf70 = 30;
								//*(char *)(0xbf70+40) = 30;
								memcpy(dst, t, strlen(t));
								memcpy(dst+40, t, strlen(t));
								//ClearTextWindow();

							}
							break;

						case SCROLLER_END:
						case SCROLLER_DONE:
							done = 1;
							return;
							break;
						}
				}

			// Stuff
			BottomEffectCallBack();
			TopEffectCallBack();
		}

	// doesn't work
	/* *(unsigned char *)0x26a = (*(unsigned char *)0x26a) & 0xf7; */
	/* *(unsigned char *)0x26a = (*(unsigned char *)0x26a) | 0x3; */
	/* memset((char*)0xa000,0x88,8000); */
	/* memset((char*)0xbb80,0x88,40*26);	 */
	/* hires(); */
	/* text(); */
	/* cls(); */
	/* printf("plop\n"); */
	/* paper(A_FWWHITE); */
	/* ink(A_FWBLACK); */
	/* printf("plop\n"); */
}

