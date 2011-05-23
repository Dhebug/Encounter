#include <stdio.h>
#include "oobj3d/obj3d.h"

#define A_FWBLACK        0
#define A_FWRED          1
#define A_FWGREEN        2
#define A_FWYELLOW       3
#define A_FWBLUE         4
#define A_FWMAGENTA      5
#define A_FWCYAN         6
#define A_FWWHITE        7
#define A_BGBLACK       16
#define A_BGRED         17
#define A_BGGREEN       18
#define A_BGYELLOW      19
#define A_BGBLUE        20
#define A_BGMAGENTA     21
#define A_BGCYAN        22
#define A_BGWHITE       23



// tables.s
void TablesInit();

// -------------

// Starwars.s

extern unsigned int  position;

void RasterizeInitScanlineBuffer();
void RasterizeNextLineMapping();
void RasterizeScroller();

// -------------

extern unsigned char XIncTableLow[256];
extern unsigned char XIncTableHigh[256];

extern unsigned char EmptyTextureLine[16];



void ComputeDivTable()
{
	int	y;
	unsigned char dst_w;
	unsigned int x_inc;

	dst_w=2;
	for (y=1;y<128;y++)
	{
		x_inc=((((unsigned int)(128)<<8))/dst_w);
		
		XIncTableLow[y] =(x_inc&255);
		XIncTableHigh[y]=(x_inc>>8);
						
		dst_w+=2;
	}
}





/* Prototipes */

typedef struct t_obj
{
  int CenterX,CenterY,CenterZ;
  void * objp;
  char ID;
  char User;
  char XRem, YRem, ZRem;
  char orientation[18];
}t_obj;


extern t_obj * pointer;

extern void * LabelPictureFont;
extern void * BufferUnpack;
char X,Y,x,y;

char * p;


void launch_game();

main()
{
	switch_ovl();
	InitIRQ();

	DoubleBuffOff();
	GenerateExtraTables();
	SequenceDefenceForceLogo();
	//Wait(8);

	init_disk();
	load_overlay();

	InitIRQ();

	DoubleBuffOn();
	FontUnpack();
	DoubleBuffOff();
	FontInit();

	CreditsElite();
	Wait(15);

	InitMusic();

	clr_all();

	//goto kk;

	p=(char *)(0xa000+40*49);
	*p=A_BGBLUE;
	p=(char *)(0xa000+40*151);
	*p=A_BGBLUE;

    InitTestCode();

    Test1337();
	EmptyObj3D();
	DoubleBuffOff();

	SWTablesInit();
	ComputeDivTable();
	RasterizeInitScanlineBuffer();
	position=0;
	while (position<323)
	{
		RasterizeScroller();
		position+=2;
	}


	FontUnpack();
 	FirstText();
	Wait(8+3);
	
    //InitTestCode();
	ReInit3D();
	//clr_toparea();
    FirstScene();
	RotateThargoid();

	DoubleBuffOff();
	Dialogue1();
	DoubleBuffOn();
	RotateThargoid();
	DoubleBuffOff();
	Dialogue2();
	
	DoubleBuffOn();
	RotateThargoid();

	DoubleBuffOff();
	ShowThargoid();
	Dialogue3();
	Wait(15-1+5);
	//Dialogue3b();
	//Wait(15-1);


	ShowBadguy();
	DoubleBuffOff();
	Dialogue4();
	Wait(25-1);

	ClearWideBuff();
	Dialogue5();
	DoubleBuffOn();
	PutSun();
	RotateThargoid();

	DoubleBuffOff();
	Dialogue6();

	DoubleBuffOn();
	RotateThargoid();
	clr_bottomarea();
	clr_toparea();
	FinalScene();


kk:
	FontUnpack();
	DoubleBuffOff();

#ifdef OLDCREDITS

	Credits1();
	Wait(6-4);
	BurnText();

	Credits3();
	Wait(5-3);
	BurnText();

	Credits4();
	Wait(5-1);
	BurnText();

	Credits5();
	Wait(5-3);
	BurnText();

	CreditsEnd();
	Wait(5-3);
	BurnText();
	clr_all();

#else
	Credits1();
	Wait(20+3-3);
	BurnText();

	Credits2();
	Wait(20+3-3);
	BurnText();

	CreditsEnd();
	Wait(16-3);
	BurnText();
	clr_all();

#endif

	ShowLogo();
	Wait(10+10);//20);
	BurnText();
	clr_all();
	//Wait(5);

	launch_game();

}


void launch_game()
{
   
	clr_all();
	StopMusic();
	Wait(2);	

	reboot_oric();
}


