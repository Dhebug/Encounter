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

	ShowStory();
	Wait(20);
	BurnText();

	/*
	ShowStory2();
	Wait(20);
	BurnText();
	*/

	clr_all();
	p=(char *)(0xa000+40*49);
	*p=A_BGBLUE;
	p=(char *)(0xa000+40*151);
	*p=A_BGBLUE;

 	FirstText();
	Wait(8);
	
	DoubleBuffOn();
    InitTestCode();
	clr_toparea();
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
	////RotateThargoid();

	DoubleBuffOff();
	ShowThargoid();
	////RotateThargoid();
	Dialogue3();
	Wait(15);
	////RotateThargoid();
	Dialogue3b();
	Wait(15);


	ShowBadguy();
	DoubleBuffOff();
	Dialogue4();
	Wait(25);
	//Dialogue5();

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

	FontUnpack();
	DoubleBuffOff();

	ShowStory2();
	Wait(20);
	BurnText();

	Credits1();
	Wait(6-2);
	BurnText();

	Credits2();
	Wait(2);
	BurnText();
	Wait(3-1);

	Credits3();
	Wait(5-1);
	BurnText();

	Credits4();
	Wait(5-1);
	BurnText();

	Credits5();
	Wait(5-1);
	BurnText();

	CreditsEnd();
	Wait(7);
	BurnText();
	clr_all();


	ShowLogo();
	Wait(10+3);//20);
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


