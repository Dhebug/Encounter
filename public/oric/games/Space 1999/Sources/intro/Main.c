
#include	<lib.h>

// --------------------------------------
//              Space: 1999
//          The Intro Sequence
// --------------------------------------
// (c) 2007 Mickael Pointier.
// This code is provided as-is.
// I do not assume any responsability
// concerning the fact this is a bug-free
// software !!!
// Except that, you can use this example
// without any limitation !
// If you manage to do something with that
// please, contact me :)
// --------------------------------------
// For more information, please contact me
// on internet:
// e-mail: mike@defence-force.org
// URL: http://www.defence-force.org
// --------------------------------------
// Note: This text was typed with a Win32
// editor. So perhaps the text will not be
// displayed correctly with other OS.

// http://www.space1999.net/catacombs/main/pguide/up10.html  <- Good pictures !


// Tables.s
extern char ShadingTable[8];
extern char LabelBumpReconf[16*8];

extern char LeftPattern[6];
extern char RightPattern[6];

extern char TableMul6[256];
extern char TableDiv6[256];
extern char TableMod6[256];
						
extern char Mod6Left[256];
extern char Mod6Right[256];
extern char MinX[256];
extern char MaxX[256];

extern unsigned char BufferUnpack[8000];

extern unsigned char BufferAddrLow[256];
extern unsigned char HiresAddrLow[176];
extern unsigned char TextAddrLow[80];
extern unsigned char BufferAddrHigh[256];
extern unsigned char HiresAddrHigh[176];
extern unsigned char TextAddrHigh[80];

extern unsigned char CosTableDither[256];
extern unsigned int SteppingTableDitherWord[256];

extern unsigned char 	SquareRootTable[6680];
extern unsigned char 	SquareTableLow[60];
extern unsigned char 	SquareTableHigh[60];
extern unsigned char	DiscPartTable[1200];
extern unsigned char 	DiscFullTable[4000];

void TablesInit();
void CreateHalfDisc();
void GenerateSquareTables();
void MirrorTheDisc();


// Draw.s

extern unsigned char X0,X1,Y;
extern unsigned char CX,CY,RAY;

extern unsigned char TimerCounter;
extern unsigned char KeyCode;

void DrawSegment();
void DrawDisc();
void FlipToScreen();


// Auxiliar
extern void switch_ovl(void);
extern void switch_eprom(void);

unsigned char gShadingAngle=0;



extern unsigned char LabelPictureLogo[];
extern unsigned char LabelPictureMartinLandau[];
extern unsigned char LabelPictureBarbaraBain[];
extern unsigned char LabelPictureProducer[];
extern unsigned char LabelPictureItcLogo[];
extern unsigned char LabelPictureEpisode[];
extern unsigned char LabelPictureBarryMorse[];
extern unsigned char LabelPictureSylviaAnderson[];
extern unsigned char Labelscene1[];
extern unsigned char Labelscene2[];


unsigned char LogoColor[]={ 7,7,7,3,7,3,3,1,3,1,1,3,1,3,3,3};
unsigned char EarthColor[]={ 4,4,4,6,4,6,6,2,6,2,2,6,2,6,6,6 };


void color_cycle(unsigned char counter)
{
	unsigned char* pLine;
	unsigned char ii0;
	unsigned char ii1;
	unsigned char y;
	unsigned char i0=0;
	unsigned char i1=0;
	
	while (counter--)
	{
		ii0=i0;
		ii1=i1;
		pLine=(unsigned char*)0xa000+2;
		for (y=0;y<90;y++)
		{
			if (y&1)
			{
				// Earth
				*pLine=EarthColor[ii1&15];
				ii1++;
			}	
			else
			{
				// Logo
				*pLine=LogoColor[ii0&15];
				ii0++;
			}
			pLine+=40;
		}
		i0++;
		i1--;
	}
}

void wait(int counter)
{

    for(;counter;counter--)
    {
        TimerCounter=100;
        while(TimerCounter);
    }

}



void UnpackToBuffer(void *pPackedData)
{
	file_unpack(BufferUnpack,pPackedData);
}

void ClearBuffer()
{
	memset(BufferUnpack,64,8000);
}

void BlitRectangle(
	unsigned char* pdst,
	unsigned char* psrc,
	unsigned char width,
	unsigned char height
	)
{
	while (height--)
	{
		memcpy(pdst,psrc,width);
		pdst+=40;
		psrc+=40;
	}
}


void BlackScreen()
{
	switch_ovl();
	paper(0);
	ink(0);
	switch_ovl();
	ClearBuffer();
	BlitRectangle((unsigned char*)0xa000+2,BufferUnpack+2,38,200);	// To avoid erasing the ink and paper attributes
	//FlipToScreen();
	switch_ovl();
	ink(0);
	switch_ovl();
}

void ThisEpisode()
{
	BlackScreen();

	UnpackToBuffer(LabelPictureEpisode);
	BlitRectangle((unsigned char*)0xa000+(40*81)+3,BufferUnpack,33,37);
	switch_ovl();
	ink(3);
	switch_ovl();
}


void TextSeptember()
{
	BlackScreen();
	
	UnpackToBuffer(LabelPictureEpisode);
	BlitRectangle((unsigned char*)0xa000+(40*81)+3,BufferUnpack+(40*37),33,44);
	switch_ovl();
	ink(3);
	switch_ovl();
}

void Text13th()
{
	BlackScreen();
	
	UnpackToBuffer(LabelPictureEpisode);
	BlitRectangle((unsigned char*)0xa000+(40*65)+6,BufferUnpack+(40*81),28,70);
	switch_ovl();
	ink(3);
	switch_ovl();
}

void Text1999()
{
	BlackScreen();
	
	UnpackToBuffer(LabelPictureEpisode);
	BlitRectangle((unsigned char*)0xa000+(40*65)+3      ,BufferUnpack+(40*81)   ,6,70);	// 1
	BlitRectangle((unsigned char*)0xa000+(40*65)+3+6    ,BufferUnpack+(40*81)+29,9,70);	// 9
	BlitRectangle((unsigned char*)0xa000+(40*65)+3+6+9  ,BufferUnpack+(40*81)+29,9,70);	// 9
	BlitRectangle((unsigned char*)0xa000+(40*65)+3+6+9+9,BufferUnpack+(40*81)+29,9,70);	// 9
	switch_ovl();
	ink(3);
	switch_ovl();
}



// part three, filter out the part of the cycling which are hidden by graphics
void FilterTheDisc1();
void FilterTheDisc2();



extern unsigned char BoomColorBase;
extern unsigned char GlowColor[6];
extern unsigned char BoomColorMinus16[37+16];
extern unsigned char BoomColor[37];

void DrawNuclearBoom();

unsigned char BaseBlinkColor[]={ 5,4,5,1,3,7,3,1,3,1,3,7,7,6,4,1 };


void BlinkInkBase(unsigned char base)
{
	switch_ovl();	
	curset(0,80,3);
	//fill(100,1,BaseBlinkColor[base&3]);
	fill(120,1,BaseBlinkColor[base&15]);
	switch_ovl();
}

void MoonExplodes()
{
	BlackScreen();
	BlitRectangle((unsigned char*)0xa000,BufferUnpack,40,89);
	
	UnpackToBuffer(LabelPictureLogo);
	BlitRectangle((unsigned char*)0xa000+(40*89)+1,BufferUnpack+(40*89)+1,39,111);
	
	GenerateSquareTables();

	CreateHalfDisc();
	MirrorTheDisc();
	FilterTheDisc1();
	FilterTheDisc2();
	
	BoomColorBase=0;

	// Glow	
	while (BoomColorBase<40)
	{
		memcpy(BoomColorMinus16+10+BoomColorBase,GlowColor,6);
		DrawNuclearBoom();
		BoomColorBase++;
	}

	// Deglow
	while (BoomColorBase>0)
	{
		BoomColorBase--;
		memcpy(BoomColorMinus16+10+BoomColorBase,GlowColor,6);
		DrawNuclearBoom();
	}
}

	
void MoonScrollsDown()
{
	unsigned char counter;
	
	gShadingAngle=64;
	
	//BlackScreen();
	
	UnpackToBuffer(LabelPictureLogo);
	BlitRectangle((unsigned char*)0xa000+(40*89),BufferUnpack+(40*89),40,111);
	
	counter=64;
	while (counter--)
	{
		unsigned char y=112;
		unsigned char* ptr=(unsigned char*)0xa000+(40*197);
		
		
	RAY=20;
	CX=120;
	CY=50;
		
	DrawDisc();
	
	gShadingAngle+=3;
		
		while (y)
		{
			memcpy(ptr+80,ptr,80);
			ptr-=80;
			y-=2;
		}
	}
}

/*
void MoonZoomer()
{
	RAY=1;
	CX=120;
	CY=100;
	
	gShadingAngle=64;
	
	while (1)
	{
		//RAY=1;
		DrawDisc();
		//draw_disc();
				
		//printf("%d\n",gShadingAngle);
		if (RAY<64)
		{
			RAY++;
		}
		if (RAY>30)
		{
			gShadingAngle+=3;
		}
		if (RAY==64)
		{
			break;
		}
	}
}
*/

extern void reboot_oric();
void launch_game();

void main()
{
	
	//paper(0);
	hires();

	//printf("    Press ESC to skip intro");
	
    switch_ovl();

	init_irq_routine();

	TablesInit();

    PlayMainTune();

//	wait(1);

	//goto shortcut;
 	//
	// ITC entertainment logo
	//
	UnpackToBuffer(LabelPictureItcLogo);
	FlipToScreen();
	wait(4);
	
	
	//
	// Starring Martin Landau
	//
	UnpackToBuffer(LabelPictureMartinLandau);
	FlipToScreen();
	wait(3);
	
	//
	// Starring Barbara Bain
	//
	UnpackToBuffer(LabelPictureBarbaraBain);
	FlipToScreen();
	wait(4);


	//
	// Space:1999 title picture
	//
	UnpackToBuffer(LabelPictureLogo);
	FlipToScreen();
	color_cycle(255);//64);
	
	// Then various pictures
	// - Animation of an eagle following down - close up
	// - Eagle rotates and near moon surface then explode
	// - Eagle with purple electric sparks reaching it
	// - People in moon base alpha getting shocked and shaked 
	// - Explosion
	
	// ---- This Episode yellow message
	//
	// This episode
	//
	ThisEpisode();
	wait(1);

	// - Scene1
	UnpackToBuffer(Labelscene1);
	FlipToScreen();
	wait(9);
	
	// - Guy in shuttle with big yellow helmet
	// - Captain Koening looking scared
	// - Barbara on the ground looking helpless
	// - Lot's of other pictures in fast succession
	// - Lot's of other pictures in fast succession
	// - Lot's of other pictures in fast succession
	
	// ---- This Episode yellow message
	//
	// This episode
	//
	ThisEpisode();
	wait(1);


	// - Scene2
	UnpackToBuffer(Labelscene2);
	FlipToScreen();
	wait(9);
	
	
	// - Lot's of other pictures in fast succession
	// - Lot's of other pictures in fast succession
	
	// ---- Animation of the three planets scrolling slowly (00:38) -> also starring Barry Morse
	UnpackToBuffer(LabelPictureBarryMorse);
	FlipToScreen();
	wait(5);
	
	// ---- View of the blue plannet -> producer Sylvia Anderson
	UnpackToBuffer(LabelPictureSylviaAnderson);
	FlipToScreen();
	wait(5);
	
	// - Blue and red planet -> executive producer Gerry Anderson
	UnpackToBuffer(LabelPictureProducer);
	FlipToScreen();
	wait(5);

	// in fast succession:
	// - September
	// - 13th
	// - 1999
	TextSeptember();
	wait(1);
	Text13th();
	wait(1);	
	Text1999();
	wait(1);	

	// 00:53 - Explosions on the moon surface 
	// 00:56 - huge explosion on the back of moon base alpha (can reuse the title picture bottom part, then draw a growing disc)
	MoonExplodes();
	//wait(150);


	// 00:57 - people in moon base alpha being shacked
	// - the moon base alpha scroll downs with the earth standing still
	MoonScrollsDown();
	//wait(150);
	
	// - Some more explosions in the base
	// - Planet animation of the moon going away (01:02)
	
	//hires();
	//MoonZoomer();
			
	
	//UnpackToBuffer(LabelPictureEpisode);
	//FlipToScreen();


	launch_game();

}


void launch_game()
{
   
	BlackScreen();
	//wait(2);
	StopMusic();
	wait(2);	

	//draw_circle(120,100,99);
	//draw_circle_mike(120,100,99);
	//printf("done");

	reboot_oric();
	

}
