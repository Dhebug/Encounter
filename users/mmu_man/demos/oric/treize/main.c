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

#include "data/pics.h"

//#include "AmigaTopazUnicodeRus_8.h"
//#include "Minecrafter_3_6_6.h"
//#include "revertro_10.h"
//#include "LiberationMono_Regular_10.h"
#include "Skia_Regular_8.h"

/*extern unsigned char Logo[];
extern unsigned char Hey[];
extern unsigned char Scroll[];
*/
extern unsigned char terrainmap[];
#define TERRAIN_NLINES 6
#define TERRAIN_NVLINES 8
#define TERRAIN_MAPLEN 52

unsigned char logobuf[40*200/*142*/];
// HEY, let's steal overlay RAM !!!
// music player doesn't like at all
//unsigned char *logobuf = (unsigned char *)0xc200;
//char *scrollerFont = Minecrafter_3_6_6_bits - 32*8;
//char *scrollerFont = revertro_10_bits - 32*8;
char *scrollerFont = Skia_Regular_8_bits - 32*8;
//char *scrollerFont = (char *)0x9C00;// - 32*8;

//extern unsigned char	Texture[256*64];
//extern char				TabCos[256];

char ScrollScrollerPage = 0;
char ScrollScrollerLine = 0;

//#include "angle.c"
//#include "prof.c"

#define	SCROLLER_START_ADDR 0xa000+SCROLLER_OFFSET

#define VIP_SCROLL_LINES 4

extern unsigned char ScrollerCommand;
extern unsigned char ScrollerCommandParam1;
extern unsigned char ScrollerCommandParam2;
extern unsigned char ScrollerCommandParam3;
extern unsigned char ScrollerCommandParam4;

extern unsigned char ScrollerScreenDir;

extern void A12_DoLeftScroll(unsigned char *);

void System_InstallIRQ_SimpleVbl();
void System_UninstallIRQ_SimpleVbl();
void ScrollerInit();


void ScrollHiresUp1();

void (*BottomEffectCallBack)(void);
void (*TopEffectCallBack)(void);

void VIP_FixupAttributes()
{
	// try to work around the mess left by pictconv
	// TODO: fix pictconv instead
	char x;
	unsigned char y;
	unsigned char *p = (unsigned char *)logobuf;
	for (y = 0; y < 138; y++, p += 40) {
		if (p[0] != 0x00)
			continue;
		for (x = 1; x < 40; x++)
			if (p[x] != 0x7f)
				break;
		if (x < 2)
			continue;
		while(x)
			p[--x] = 0x40;
	}
}


/*
// make sure we have paper in col 0, ink in col 1.
void A12_FixupAttributes()
{
	unsigned char x, y;
	// TODO: rewrite this part in asm
	unsigned char *p = (unsigned char *)0xa000;
	for (y = 0; y < 200; y++) {
		unsigned char a0 = p[0];
		unsigned char a1 = p[1];
		if ((a0 & 0x7f) < 8)
			p[1] = a0;
		if ((a1 & 0x7f) >= 16 && (a1 & 0x7f) < 26)
			p[0] = a1;
	}
}
*/

void A12_LeftScroll()
{
	static unsigned char col = 0;
	static unsigned char phase = 1;

	A12_DoLeftScroll(logobuf + col);

/*
	unsigned char y;
	// TODO: rewrite this part in asm
	unsigned char *p = (unsigned char *)0xa000;
	unsigned char *b = logobuf + col;
	for (y = 0; y < 200; y++) {
//		for (x = 1; x < 40 - 1; x++) {
		// x == 1
		unsigned char v = p[2];
		unsigned char a = v & 0x7f;
		if (a >= 24) {
			;
		}
		else if (a < 8) { // ink
			p[1] = v;
		}
		else if (a < 16)
			;
		else if (a < 24) {
			p[0] = v;
		}
		// rest of the line
		memcpy(p+2, p+3, 40 - 3);
		p[40 - 1] = *b;
		
		p += 40;
		b += 40;
	}
*/
	col++;
#if 0
	if (col == 40/* - 1*/) {
		phase++;
		A12_UnpackAndFixup(logos[phase%3]);
		col = 0;
	}
#endif
}

#if 0
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
#endif


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

void EffectScrollUp()
{
	static unsigned char i = 0;
	static unsigned char *p = logobuf;
	static char pass = 0;
	unsigned char *s, *d;

	if (pass > 4)
		return;
	// scroll up
	memcpy((unsigned char *)0xa000, (unsigned char *)0xa000+40*VIP_SCROLL_LINES, 40*(200-VIP_SCROLL_LINES));
//ScrollHiresUp1();
	memcpy((unsigned char *)0xa000+40*(200-VIP_SCROLL_LINES), p, 40*VIP_SCROLL_LINES);
	p += 40*VIP_SCROLL_LINES;
	i += VIP_SCROLL_LINES;
	if (i < LogoVIP1_H)
		return;
	p = logobuf;
	i = 0;
	pass++;
	switch (pass) {
		case 1:
			file_unpack(logobuf, LogoVIP2);
			//memset(logobuf+LogoVIP2_H*40,A_BGWHITE,(sizeof(logobuf)-LogoVIP2_H*40));
			break;
		case 2:
			file_unpack(logobuf, LogoVIP3);
			//memset(logobuf+LogoVIP3_H*40,A_BGWHITE,(sizeof(logobuf)-LogoVIP3_H*40));
			break;
		case 3:
			file_unpack(logobuf, LogoVIP4);
			memset(logobuf+LogoVIP4_H*40,A_BGWHITE,((LogoVIP1_H-LogoVIP4_H)*40));
			break;
//		case 2:
		case 4:
			memset(logobuf,A_BGWHITE,sizeof(logobuf));
			break;
		default:
			break;
	}
		
	
#if 0
	if (ScrollScrollerLine >= ScrollM1_H)
		return;

	/* scroll up */
	s = (unsigned char *)0xa000 + (ScrollT_H + 1) * 40;
	d = s - 40;
	memcpy(d, s, (ScrollM1_H - 1) * 40);

	/* append 1 line */
	s = logobuf + (ScrollT_H + ScrollScrollerLine) * 40;
	d = (unsigned char *)0xa000 + (ScrollT_H + ScrollM1_H - 1) * 40;
	memcpy(d, s, 40);
#endif

	ScrollScrollerLine++;
}


//static unsigned char Ty = 20+88+3;
static unsigned char Tp = 0;
void ScrollTerrainBAD()
{
	unsigned char m = 64;
	unsigned char *p;
	char i, j;
	unsigned int v = 256 - 3*m + Tp;

	p = (unsigned char *)0xa000 + 40 * (20+88+3/*+2*/);
	for (i = 1, j = 0; i < 3; i++) {
		for (; j < 48 && terrainmap[j] > v; j++) {
#if 1
			if (terrainmap[j] > v)
				continue;
			if (terrainmap[j] <= v) {
				p[40 * j] = A_BGBLACK;
			}
			if (terrainmap[j] <= v-1/* && terrainmap[j+1] < v-1*/) {
				p[40 * j] = A_BGBLUE;
			}
			break;
#endif
		}
		p[40 * j] = A_BGBLACK;
		for (; j < 46 && terrainmap[j] > v-1; j++);
		if (j < 46)
			p[40 * j] = A_BGBLUE;
		v -= m;
	}
	Tp--;
	Tp = Tp % m;
}

void ScrollTerrain()
{
	//unsigned char m = 64;
	unsigned char *p;
	char i, j;
//	unsigned int v = 256 - 3*m + Tp;

	static char hlines[TERRAIN_NLINES] = {
		0 * (TERRAIN_MAPLEN/TERRAIN_NLINES),
		1 * (TERRAIN_MAPLEN/TERRAIN_NLINES),
		2 * (TERRAIN_MAPLEN/TERRAIN_NLINES),
		3 * (TERRAIN_MAPLEN/TERRAIN_NLINES),
		4 * (TERRAIN_MAPLEN/TERRAIN_NLINES),
		5 * (TERRAIN_MAPLEN/TERRAIN_NLINES),
	};

	p = (unsigned char *)0xa000;// + 40 * (20+88+3/*+2*/);
	for (i = 0; i < TERRAIN_NLINES; i++) {
		unsigned char m = hlines[i];
		unsigned char l = terrainmap[m];
		l = l - 13;
		if (l < (100-LogoA13_H/2-3)) {
			l = 100-LogoA13_H/2 - l;
			p[40 * l] = A_BGBLACK;
			l = 200 - l;
			p[40 * l] = A_BGBLACK;
		}
		m = (m - 1) % TERRAIN_MAPLEN;
		hlines[i] = m;
		l = terrainmap[m];
		l = l - 13;
		if (l < (100-LogoA13_H/2-2)) {
			l = 100-LogoA13_H/2 - l;
			p[40 * l] = A_BGMAGENTA;
			l = 200 - l;
			p[40 * l] = A_BGMAGENTA;
		}
	}
}

static char TerrainHSpeed = 0;
void ScrollTerrainH()
{

	unsigned char *p;
	unsigned char *q;
	char i, j;

	static unsigned char vlines[TERRAIN_NVLINES] = {
		0 * (240/(TERRAIN_NVLINES-1)),
		1 * (240/(TERRAIN_NVLINES-1)),
		2 * (240/(TERRAIN_NVLINES-1)),
		3 * (240/(TERRAIN_NVLINES-1)),
		4 * (240/(TERRAIN_NVLINES-1)),
		5 * (240/(TERRAIN_NVLINES-1)),
		6 * (240/(TERRAIN_NVLINES-1)),
		7 * (240/(TERRAIN_NVLINES-1)),
	};
	unsigned char vlinesPosX[TERRAIN_NVLINES];
	unsigned char vlinesHSpeed[TERRAIN_NVLINES];
	unsigned char vlinesHDec[TERRAIN_NVLINES];
	unsigned char vlinesHOffset[TERRAIN_NVLINES];
	unsigned char vlinesHBits[TERRAIN_NVLINES];

	for (i = 0; i < TERRAIN_NVLINES; i++) {
		unsigned char v;
		vlines[i] = (vlines[i] + TerrainHSpeed) % 240;
		v = vlinesPosX[i] = vlines[i];
		vlinesHOffset[i] = v / 6;
		vlinesHBits[i] = 0x40 | (1 << (5 - (v % 6)));
/*
		if (v < 120)
			v = (120 - v) / 2;
		else
			v = (v - 120) / 2;
		if (v > 50)
			v = 50;
		else
			v = v;
*/
		if (v < 120)
			v = (120 - v) / 4;
		else
			v = (v - 120) / 4;
		vlinesHDec[i] = vlinesHSpeed[i] = terrainmap[v] / 10;
	}
	p = (unsigned char *)0xa000;
	q = (unsigned char *)0xa000+199*40;
	for (j = 100-LogoA13_H/2-1; j > 0; j--) {
		for (i = 0; i < TERRAIN_NVLINES; i++) {
			unsigned char v = vlinesPosX[i];
			if (v > 12 /* && v < 240 - 12*/) {
				p[vlinesHOffset[i]] = vlinesHBits[i];
				q[vlinesHOffset[i]] = vlinesHBits[i];
			}
			if (vlinesHDec[i]-- == 0) {
				vlinesHDec[i] = vlinesHSpeed[i];
				vlinesPosX[i] += (vlinesPosX[i] > 120) ? -1 : 1;
				v = vlinesPosX[i];
				vlinesHOffset[i] = v / 6;
				vlinesHBits[i] = 0x40 | (1 << (5 - (v % 6)));
			}
		}
		p += 40;
		q -= 40;
	}
}

void InitScrollTerrainH()
{

	unsigned char *p = (unsigned char *)0xa000+1;
	unsigned char *q = (unsigned char *)0xa000+199*40+1;
	char j;
	// clean up the screen first... something filled hires with attributes?
	for (j = 0; j < 100-LogoA13_H/2; j++) {
		memset(p, 0x40, 40-1);
		p += 40;
		memset(q, 0x40, 40-1);
		q -= 40;
	}
	// do it once (it's sloooow)
	ScrollTerrainH();
	// now put the paper attributes
	p = (unsigned char *)0xa000+1;
	q = (unsigned char *)0xa000+199*40+1;
	for (j = 0; j < 100-LogoA13_H/2; j++) {
		*p = A_FWMAGENTA;
		p += 40;
		*q = A_FWMAGENTA;
		q -= 40;
	}
}

void EffectUnscroll()
{
	static i = 0;
	unsigned char *s, *d;

#if 0
	if (i > ScrollM1_H / 2)
		return;

	/* top */
	s = logobuf;
	d = (unsigned char *)0xa000 + (100 - ScrollT_H - i) * 40;
	memcpy(d, s, ScrollT_H * 40);

	/* bottom */
	s = logobuf + (200 - ScrollB_H) * 40;
	d = (unsigned char *)0xa000 + (100 + i) * 40;
	memcpy(d, s, ScrollB_H * 40);

	/* middle */
	s = logobuf + (ScrollT_H) * 40;
	d = (unsigned char *)0xa000 + (100 - i) * 40;
	memcpy(d, s, 2 * i * 40);

#endif
	i++;
}



void EffectScrollScroll()
{
	unsigned char *s, *d;

#if 0
	if (ScrollScrollerLine >= ScrollM1_H)
		return;

	/* scroll up */
	s = (unsigned char *)0xa000 + (ScrollT_H + 1) * 40;
	d = s - 40;
	memcpy(d, s, (ScrollM1_H - 1) * 40);

	/* append 1 line */
	s = logobuf + (ScrollT_H + ScrollScrollerLine) * 40;
	d = (unsigned char *)0xa000 + (ScrollT_H + ScrollM1_H - 1) * 40;
	memcpy(d, s, 40);
#endif

	ScrollScrollerLine++;
}



void UnpackToBufAndFadeIn(unsigned char *src, unsigned char height)
{
	char y, *d1, *d2, *s1, *s2;

	BottomEffectCallBack=EffectDoNothing;

	memset(logobuf, 0, 200*40);

	d1 = (char *)0xa000;
	d2 = d1 + 40*199;

	for (y = 0; y < 100; y++, d1+=40, s1+=40, d2-=40, s2-=40) {
		memset(d1, 0, 40);
		memset(d2, 0, 40);
	}

	file_unpack(logobuf + (200 - height) / 2 * 40, src);

	d1 = (char *)0xa000;
	d2 = d1 + 40*199;
	s1 = (char *)logobuf;
	s2 = s1 + 40*199;
	for (y = 0; y < 100; y++, d1+=40, s1+=40, d2-=40, s2-=40) {
		memcpy(d1, s1, 40);
		memcpy(d2, s2, 40);
	}

}


char foofoo = 0;
	char done = 0;

void main()
{
	unsigned char i;
//	char done = 0;
	char *p;
	char *q;

	cls();
	printf("<?php echo FarbrauschLikeProgressBar(); ?>");
	// don't we have a sleep() somewhere?
//	for (i = 0; i < 4; i++);
	file_unpack(logobuf, LogoVIP1);

/*
	p = (char*)logobuf + 1;
	for (i = 0; i < 200; i++, p += 40)
		*p = (i % 2) ? A_FWYELLOW : A_FWWHITE;
*/
	//
	// hires switch
	//
	hires();

	//file_unpack((char*)0xa000, Scroll);//, _Logo_H*_Logo_W/6);
	//memcpy((char*)0xa000, logobuf, 40*200);

#if 0

	file_unpack((char*)0xa000, Logo);//, _Logo_H*_Logo_W/6);
	hires();
	file_unpack((char*)0xa000+(224-_Hey_H)/2*40, Hey);//, _Logo_H*_Logo_W/6);
	while(1);
#endif

	//
	// Clear the screen
	//
	memset((char*)0xa000,A_BGWHITE,8000);
	// clear text lines
	memset((char*)0xbf68,' ',40*3);
	*(char *)(0xbf68) = A_BGBLACK;
	*(char *)(0xbf68+40) = A_BGBLACK;
	*(char *)(0xbf68+80) = A_BGBLACK;
	*(char *)(0xbf68+1) = A_FWWHITE;
	*(char *)(0xbf68+1+40) = A_FWCYAN;
	*(char *)(0xbf68+1+80) = A_FWWHITE;
	//memset((char*)(0xa000+(40*19*8)),A_BGBLUE,40*(200-19*8+4));
//XXX
//memcpy((void *)(0x9800+32*8), &AmigaTopazUnicodeRus_8_bits, sizeof(AmigaTopazUnicodeRus_8_bits));
//memcpy((void *)(0x9C00/*+32*8*/), &AmigaTopazUnicodeRus_8_bits, /*(127-32)*8*/sizeof(AmigaTopazUnicodeRus_8_bits));
// fixup system font
memset((void *)(0x9800+'_'*8), 0, 8-2);
// DEBUG: copy std charset over alt one
//memcpy((void *)(0x9C00/*+32*8*/), (void *)(0x9800+32*8), (127-32)*8);
//XXX: memset(, 0!!!);

	ScrollerInit();
	// screen gadgets
/*	for (i = 0; i < 8; i++) {
		*(char*)(SCROLLER_START_ADDR+40*i+40-7) = A_FWCYAN | 0x80;
		memcpy((char*)(SCROLLER_START_ADDR+40*i+40-6), &Gadgets[i*6], 6);
		*(char*)(SCROLLER_START_ADDR+40*i+40-6) |= 0x80;
		*(char*)(SCROLLER_START_ADDR+40*i+40-5) = A_FWWHITE | 0x80;
	}
*/

	BottomEffectCallBack=EffectDoNothing;
	TopEffectCallBack=EffectDoNothing;

	System_InstallIRQ_SimpleVbl();


	//GameOfLife_Init();	
	//ClearTextWindow();

	while (1)
		{
			//if (key() == 27)
			//	break;
//foofoo++;
			if (!done && ScrollerCommand!=SCROLLER_NOTHING)
				{
					unsigned char command=ScrollerCommand;
					ScrollerCommand=SCROLLER_NOTHING;		
					switch (command)
						{
						case SCROLLER_SHOW_SCROLL:
							{
								/*memset(logobuf, 0x40, 40*150);*/
								//file_unpack((char *)0xa000, VIPSplash);
								//file_unpack((char*)logobuf,LogoVIP1);
								//VIP_FixupAttributes();
								//memcpy((void *)(0xa000+40*20), logobuf, 40*138);
								//file_unpack((char*)logobuf+40*40,logoua3);
								//file_unpack((char *)0xa000, LogoVIP1);
								BottomEffectCallBack=EffectScrollUp;
							}
							break;

						case SCROLLER_SCROLL_SCROLL:
							{
								//file_unpack((char*)logobuf+40*40,logoua3);
								/*if (ScrollScrollerPage++ == 0)
									file_unpack(logobuf + ScrollT_H * 40, ScrollM2);
								else
									file_unpack(logobuf + ScrollT_H * 40, ScrollM3);
								p = (char*)logobuf + 1;
								for (i = 0; i < 200; i++, p += 40)
									*p = (i % 2) ? A_FWYELLOW : A_FWWHITE;
								ScrollScrollerLine = 0;
								BottomEffectCallBack=EffectScrollScroll;*/
							}
							break;


						case SCROLLER_SHOW_LOGOA13:
							{
								UnpackToBufAndFadeIn(LogoA13, LogoA13_H);
								BottomEffectCallBack=ScrollTerrain;//EffectDoNothing;
								InitScrollTerrainH();
								*(char *)(0xa000+(100-LogoA13_H/2-1)*40) = A_BGMAGENTA;
								*(char *)(0xa000+(100+LogoA13_H/2+1)*40) = A_BGMAGENTA;
								*(char *)(0xbf68+80) = A_BGBLACK;
								*(char *)(0xbf68+1+80) = A_FWMAGENTA;
								*(char *)(0xbf68+40) = A_BGBLACK;
								*(char *)(0xbf68+1+40) = A_FWRED;
								*(char *)(0xbf68) = A_BGBLACK;
								*(char *)(0xbf68+1) = A_FWCYAN;
								//scrollerFont = revertro_10_bits - 32*8;
/*
								file_unpack((char*)logobuf,LogoA0XB);
								//memcpy(logobuf, LogoA0XB, LOGOA0XB_W*LOGOA0XB_H);
								for (i = 0; i < LOGOA0XB_H; i++) {
									memcpy((void *)(0xa000+(LOGOA0XB_Y+i)*40+LOGOA0XB_X), logobuf+i*LOGOA0XB_W, LOGOA0XB_W);
								}
								//ClearTextWindow();
								//memset(logobuf, 0x40, 40*150);
								//file_unpack((char*)logobuf+40*40,logoua3);
*/
							}
							break;

						case SCROLLER_SHOW_BELETT:
							{
								BottomEffectCallBack=EffectDoNothing;
								UnpackToBufAndFadeIn(Hey, Hey_H);
/*
								*(char *)(0xbf68+80) = A_BGBLACK;
								*(char *)(0xbf68+1+80) = A_FWYELLOW;
								*(char *)(0xbf68+40) = A_BGBLACK;
								*(char *)(0xbf68+1+40) = A_FWGREEN;
								*(char *)(0xbf68) = A_BGBLACK;
								*(char *)(0xbf68+1) = A_FWYELLOW;
*/
							}

							break;

#if 0
						case SCROLLER_SCREEN_LEFT:
							{
								if (!done)
									ScrollerScreenDir = -20;
							}
							break;

						case SCROLLER_START_BOING:
							{
								//ClearTextWindow();
								JSun_Init();
								BottomEffectCallBack=JSun_MainLoop;
							}
							break;

#endif
						case SCROLLER_BOTTOM_TEXT:
							{
//	memset((char*)0xa000,0,8000);

								char *t = *(void **)&ScrollerCommandParam1;
								char *dst = (char *)0xbf90-40+2;
								//*(dst+40) = 0x0a;
								//*dst++ = 0x0a;
								//memcpy((void *)(0x9800+32*8), &AmigaTopazUnicodeRus_8_bits, sizeof(AmigaTopazUnicodeRus_8_bits));
								//*(char *)(0xbf70-40) = 30;
								//*(char *)0xbf70 = 30;
								//*(char *)(0xbf70+40) = 30;
								memcpy(dst, t, strlen(t));
								//memcpy(dst+40, t, strlen(t));
								//ClearTextWindow();
/*
*(char *)0xbf90 = 17;
done = 1;
return;
//exit(1);
*/
							}
							break;

/*						case SCROLLER_RESET_BOTTOM_CB:
							{
								BottomEffectCallBack = EffectDoNothing;
							}
							break;
*/
						case SCROLLER_SET_BOTTOM_CB:
							{
								BottomEffectCallBack = *(void (**)(void))&ScrollerCommandParam1;
							}
							break;

						case SCROLLER_END:
						case SCROLLER_DONE:
							memset((char*)0xa000,A_BGBLACK,8000);
							BottomEffectCallBack = EffectDoNothing;
							done = 1;
							//System_UninstallIRQ_SimpleVbl();
							//return;
							//while(1);
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

