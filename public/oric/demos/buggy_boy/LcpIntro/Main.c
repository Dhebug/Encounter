

#include	<lib.h>

// --------------------------------------
// LcpIntro
// --------------------------------------
// (c) 2004 Mickael Pointier.
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


#define ENABLE_VSYNC	


// ============================================================================
//
//									Externals
//
// ============================================================================


// ===== Vbl.s =====
void System_Initialize();

void System_InstallIRQ_SimpleVbl();
void System_InstallDoNothing_CallBack();


void VSync();

extern unsigned int VSyncCounter1;
extern unsigned int VSyncCounter2;

void VSyncGetCounter();

void IrqOff();

void Temporize();


extern unsigned char SystemEffectTrigger;

extern void InterruptCode();
extern void DigiPlayer_InstallIrq();

extern void VSync();


// ===== Tables.s =====
void TablesInit();


// ===== Lines.s =====
extern unsigned char CurrentPixelX;		// Coordinate X of edited pixel/byte
extern unsigned char CurrentPixelY;		// Coordinate Y of edited pixel/byte
extern unsigned char OtherPixelX;		// Coordinate X of other edited pixel/byte
extern unsigned char OtherPixelY;		// Coordinate Y of other edited pixel/byte

void DrawLine();





// === Resol.s ===
void ResolSwitchToHires();
void ClearHiresScreen();

void ResolSwitchToText();
void ResolClearText();


// === Text.s ===
void TextFadeIn();
void TextFadeOut();

void SwitchToHires();
void SwitchToText();
void ClearTextScreen();


// === Tables.s ===

extern unsigned char CosTable[256];

void Tables_InitialiseCostable();


// === Mandel.s ===

void Mandel_InitDisplay();
void Mandel_DrawFractal();


// ==== Fr08.s ====
void Sequence_Fr08();

// ==== Scroller.s ====
void Scroller_InitHires();
void Scroller_InitDycp();
void Scroller_DisplayDycp();

// ==== ChessBoard.s ====
void DrawHorizontalChecker();
void DrawVerticalChecker();

extern unsigned int xpos;
extern unsigned int curx;

extern unsigned int ypos;
extern unsigned int cury;

extern unsigned char zoom;
extern unsigned char zoomstart;


//
// RANDOM.S
//
extern	unsigned char	RandomValue;
extern	void		GetRand();


extern	void	Filler_ClearMinMaxTable();


extern	unsigned char	X0;
extern	unsigned char	Y0;
extern	unsigned char	X1;
extern	unsigned char	Y1;

extern	void AddLineASM();
extern	void FillTablesASM();





void RadarEffect()
{
    unsigned char   angle=0;
	int i;
	int x0,y0;
	int x1,y1;

	Filler_ClearMinMaxTable();

	//
	// Move the triangles around the screen
	//
	x0=120+(((int)CosTable[(angle+64)&255])-128)*99/128;
	y0=100+(((int)CosTable[(angle+128)&255])-128)*99/128;
	//for (i=0;i<2;i++)
	{
		do
		{
			angle+=4;
			x1=120+(((int)CosTable[(angle+64)&255])-128)*99/128;
			y1=100+(((int)CosTable[(angle+128)&255])-128)*99/128;

			X0=120;
			Y0=100;
			X1=x0;
			Y1=y0;
			AddLineASM();
			X0=120;
			Y0=100;
			X1=x1;
			Y1=y1;
			AddLineASM();
			X0=x0;
			Y0=y0;
			X1=x1;
			Y1=y1;
			AddLineASM();

			FillTablesASM();

			x0=x1;
			y0=y1;
		}
		while (angle);
	}
}





// ===========================================


void TextFadeFlash();

/*
void FadeFlash()
{
	TextFadeIn();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	TextFadeOut();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
	VSync();
}
*/

// ===============================================





void ChessBoard_MainLoop()
{
	unsigned char angle;
	unsigned char angle0;
	unsigned char angle1;
	unsigned char x,y;
	unsigned char ink,paper;
	unsigned char counter;
	unsigned char pixel;
	unsigned char *ptr_scren;

	angle1=0;
	angle0=0;
	angle=0;

	counter=255;	// 2 seconds
	while (counter--)
	{
		VSync();

		zoom=60+(CosTable[angle]>>1);
		zoomstart=1+(((int)zoom)*((int)CosTable[angle0]))/255;
		DrawHorizontalChecker();

		zoomstart=1+(((int)zoom)*((int)CosTable[angle1]))/255;
		DrawVerticalChecker();

		angle++;
		angle0+=2;
		angle1+=3;
	}
}


void ChessBoard_MakeVideoMode()
{
	unsigned char *ptr_screen;
	unsigned int y,x;
	unsigned char c,cc;

	ptr_screen=(unsigned char*)0xa000;
	for (y=0;y<200;y++)
	{
		ptr_screen[1]=1;		// INK
		ptr_screen[2]=16+0;		// PAPER
		ptr_screen[3]=26;		// ->TEXT

		ptr_screen+=40;
	}


	ptr_screen=(unsigned char*)0xbb80;
	for (y=0;y<25;y++)
	{
		ptr_screen[0]=30;		// ->HIRES
		c=32;
		cc=3;
		for (x=4;x<40;x++)
		{
			ptr_screen[x]=c;
			c++;
			cc--;
			if (!cc)
			{
				c++;
				cc=4;
			}
		}

		ptr_screen+=40;
	}

	// Put in BLACK INK the 3 last lines of text
	for (c=0;c<40*3;c++)
	{
		*((unsigned char*)0xbb80+40*25+c)=0;
	}

	*(unsigned char*)0xbfdf=26;	// TEXT
}

// =========================================

void Fx_DrawDigit_0();
void Fx_DrawDigit_1();
void Fx_DrawDigit_2();
void Fx_DrawDigit_3();
void Fx_DrawDigit_4();
void Fx_DrawDigit_5();
void Fx_DrawDigit_6();
void Fx_DrawDigit_7();
void Fx_DrawDigit_8();
void Fx_DrawDigit_9();

extern unsigned char Fx_DigitMask;





void RastersClearBuffer();
void RastersDisplayBuffer();



void Rasters_Demo()
{
	while (!SystemEffectTrigger)
	{
		//VSync();
		RastersDisplayBuffer();

		Scroller_DisplayDycp();
	}
}


// --------------------


extern void	DisplayRotoZoomAsm();
extern void DisplayRotoZoomAsm_WithTexture();


unsigned char Angle;
unsigned char ZoomX;
unsigned char ZoomY;

int	MoveX;
int	MoveY;
int	MoveDX;
int	MoveDY;

extern int				U,V,IU,IV,MU,MV;

extern unsigned char Buffer_RotoZoom[];

void RotoZoom_Initialise();
void RotoZoom_MoveCharacters();

void InitZoomBuffer()
{
	int x,y;

	int i;


	/*
	for (i=0;i<40*28;i++)
	{
		*(unsigned char*)(0xbb80+i)='*';
	}
	*/

	RotoZoom_Initialise();


	/*
	for (i=0;i<4095;i++)
	{
		GetRand();
		Buffer_RotoZoom[i]=17;	//6+(RandomValue&7);
	}

	for (i=0;i<63;i++)
	{
		Buffer_RotoZoom[i]=16;
		Buffer_RotoZoom[i*64]=16;
	}
	*/

	/*
	for (y=0;y<32;y++)
	{
		for (x=0;x<32;x++)
		{
			Buffer_RotoZoom[ x    +y*64]=16;
			Buffer_RotoZoom[(x+32)+y*64]=17;
			Buffer_RotoZoom[ x    +(y+32)*64]=18;
			Buffer_RotoZoom[(x+32)+(y+32)*64]=19;
		}
	}
	*/
}

void DoRotozoom()
{
	int x,y,z;
	int div_factor;
	int	offset;
	int	max_x;
	int max_y;
	int	i;
	int	delay;
	unsigned char red,green,blue;
	unsigned char aa;

	InitZoomBuffer();

	ZoomX+=4*20;
	ZoomY+=3*20;

	aa=0;

	x=0;
	y=0;
	delay=100*4;
	while (delay--)
	{
		
		//div_factor=16+16;	//(16+((CosTable[ZoomX]+128)>>3));
		div_factor=16;	//(16+((CosTable[ZoomX]+128)>>5));
		//div_factor=(16+((CosTable[ZoomX]+128)>>3));
		//div_factor=(16+((CosTable[ZoomX]+128)>>2));
		//div_factor=(16+((CosTable[ZoomX]+128)>>1));
		
		/*
		IU=(CosTable[Angle]<<7) 		/ div_factor;
		IV=(CosTable[(Angle+64)&255]<<7)/ div_factor;
		*/
		/*
		IU=((int)(CosTable[Angle]))<<4;
		IV=((int)(CosTable[aa]))<<4;
		*/
		IU=((int)(CosTable[Angle])-127)*16;
		IV=((int)(CosTable[aa])-127)*16;


		/*
		//div_factor=(16+((CosTable[ZoomX]+128)>>5));
		
		IU=(CosTable[Angle]>>4);
		IV=(CosTable[(Angle+64)&255]>>4);
		*/

		MU=x;
		MV=y;
		
		Angle+=1;
		aa+=2;
		//ZoomX+=4;
		//ZoomY+=3;
		
		DisplayRotoZoomAsm();

		RotoZoom_MoveCharacters();
		
		
		x+=233;
		y+=122;
		
	}
}


extern unsigned char BigBuffer[];

#define P(r,g,b)	(36+  ((r))  +  (((g))*5) +  (((b))*5*4))


unsigned char RasterLine[]=
{
	P(0,0,0),
	P(1,0,0),
	P(2,0,0),
	P(3,0,0),
	P(3,0,1),
	P(3,0,2),
	P(3,0,3),
	P(3,1,3),
	P(3,2,3),
	P(3,3,3),
	P(3,3,2),
	P(3,3,1),
	P(3,3,0),
	P(2,3,0),
	P(1,3,0),
	P(0,3,0),
	P(0,3,1),
	P(0,3,2),
	P(0,3,3),

	P(0,0,0)|128,

		P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	// -------- 0
	
	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),

	P(3,3,0),P(3,3,1),P(3,3,2),P(3,3,3),P(3,3,3),P(3,3,2),P(3,3,1),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),

	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),

	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	// -------- 256

	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	P(3,3,0),P(3,3,1),P(3,3,2),P(3,3,3),P(3,3,3),P(3,3,2),P(3,3,1),P(3,2,0),
	P(3,2,0),P(3,2,0),P(3,0,0),P(2,0,0),P(0,0,0),P(0,0,0),P(1,1,1),P(1,1,1),
	P(2,2,2),P(2,2,2),P(3,3,3),P(3,3,3),P(2,3,3),P(1,2,3),P(0,1,3),P(0,0,2),
	P(0,1,2),P(0,1,1),P(0,1,0),P(0,2,0),P(0,3,1),P(0,3,2),P(1,3,0),P(2,3,0),
	
	P(1,2,0),P(0,1,0),P(1,1,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	// -------- 384
	
	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	P(3,3,0),P(3,3,1),P(3,3,2),P(3,3,3),P(3,3,3),P(3,3,2),P(3,3,1),P(3,3,0),
	P(3,3,1),P(3,3,2),P(3,3,3),P(3,3,2),P(2,3,1),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
};


/*
void InitZoomBufferMandel()
{
	int x,y;

	int i;

	for (x=0;x<128*64;x++)
	{
		BigBuffer[x]=RasterLine[BigBuffer[x]];
	}
	
}
*/

void Mandle_ColorizeBigBuffer();

void DoRotozoomMandel()
{
	int x,y,z;
	int div_factor;
	int	offset;
	int	max_x;
	int max_y;
	int	i;
	int	delay;
	unsigned char red,green,blue;
	unsigned char aa;

	Mandle_ColorizeBigBuffer();
	//InitZoomBufferMandel();

	ZoomX+=4*20;
	ZoomY+=3*20;

	aa=0;

	x=0;
	y=0;
	delay=100*2;
	while (delay--)
	{
		div_factor=(16+((CosTable[ZoomX])>>1));
		
		
		IU=(((int)(CosTable[Angle])-127<<7)) 		/ div_factor;
		IV=(((int)(CosTable[(Angle+64)&255])-127)<<7)/ div_factor;
		

		MU=x;
		MV=y;
		
		Angle+=1;
		aa+=2;
		ZoomX+=4;
		
		DisplayRotoZoomAsm_WithTexture();

		
		x+=233;
		y+=122;
		
	}
}


// --------------------
void Rasters_Initialise();
void Fx_TvMire();
void Fx_Snow();
void Fx_BearWarning();


extern unsigned char Picture_Karhu[];

//void PlayerTest();


// ---------------------

void VScroll_Initialize();
void VScroll_DisplayScroller();
void VScroll_MainLoop();

void Mym_PlayFrame();
void Mym_Initialize();


void Fx_DrawTitle();

void InitColorText();

void Fx_CutSound();

#define PIXEL_4(r,g,b)	(36+  ((r))  +  (((g))*5) +  (((b))*5*4))

/*
void ColorTextTest()
{
	int r,g,b;

	for (r=0;r<4;r++)
	{
		for (g=0;g<4;g++)
		{
			for (b=0;b<4;b++)
			{
				*(unsigned char*)(0xbb80+3+r+g*40+b*40*4)=PIXEL_4(r,g,b);
			}
		}
	}
	while (1);
}
*/

void main()
{
	//
	// Make sure we are working on a machine where the 
	// overlay memory can be disabled, and then disable
	// it.
	// Also install a minimal IRQ handler that makes it
	// possible to use the VSync instruction
	//
	System_Initialize();

	//
	// Generate all the data we need for various demo parts
	//
	TablesInit();


	//Fx_PcWarning();	
	//while (1);

		
	/*
		SwitchToText();
		ClearTextScreen();

			Rasters_Initialise();
			Scroller_InitDycp();
			Rasters_Demo();
			ScrollerTerminate();
			Tables_InitialiseCostable();
		*/



	/*
		SwitchToHires();
		ClearHiresScreen();
		Fx_DrawTitle();
	*/

	// Test of optimization for fractalus
		
//		SwitchToHires();
//		ClearHiresScreen();
//	Mandel_InitDisplay();
//	Mandel_DrawFractal();
//
//	while (1);
	

	//
	// Vertical distorter scroller
	//
	/*
		SwitchToText();
		ClearTextScreen();
	
			VScroll_Initialize();
			VScroll_MainLoop();
			TablesInit();
	*/
	//PlayerTest();


	//-----------

	
	/*
		SwitchToHires();
		ClearHiresScreen();
	Mandel_InitDisplay();
	Mandel_DrawFractal();

	InitColorText();
	DoRotozoomMandel();
	*/


	//	DigiPlayer_InstallIrq();
	//	while(1);
	//-----------

	
		//
		// Tv Snow effect
		//		
		Fx_Snow();

		//
		// Color mire effect
		//
		Fx_TvMire();

		//
		// Count down
		//
		System_InstallIRQ_SimpleVbl();
		SwitchToHires();
		ClearHiresScreen();

			Fx_DigitMask=0;
			/*
			Fx_DrawDigit_9();
			RadarEffect();
			Fx_DrawDigit_8();
			RadarEffect();
			Fx_DrawDigit_7();
			RadarEffect();
			Fx_DrawDigit_6();
			RadarEffect();
			Fx_DrawDigit_5();
			RadarEffect();
			Fx_DrawDigit_4();
			RadarEffect();
			*/
			Fx_DrawDigit_3();
			RadarEffect();
			Fx_DrawDigit_2();
			RadarEffect();
			Fx_DrawDigit_1();
			RadarEffect();
			Fx_DrawDigit_0();
			RadarEffect();


		//
		// Farbraush intro tune
		//
		Sequence_Fr08();

		//
		// Display a warning sign
		//
		Fx_CutSound();
		Fx_PcWarning();

		//
		// The real demo stars here
		//
		SwitchToText();
		ClearTextScreen();

		Mym_Initialize();

			TextFadeFlash();


		//
		// Start digiplayer
		//
		//PlayerTest();
		//DigiPlayer_InstallIrq();
	
		//
		// Rotozoom
		//
		SwitchToText();
		ClearTextScreen();
		DoRotozoom();


		SwitchToText();
		ClearTextScreen();

			TextFadeFlash();

		//
		// Chessboard
		//
		SwitchToText();
		ClearTextScreen();

			ChessBoard_MakeVideoMode();
			ChessBoard_MainLoop();


		//
		// Bear advertisement
		//
		Fx_BearWarning();



		SwitchToText();
		ClearTextScreen();

			TextFadeFlash();


		//
		// Vertical distorter scroller
		//
		SwitchToText();
		ClearTextScreen();
	
			VScroll_Initialize();
			VScroll_MainLoop();
			TablesInit();


		//
		// Mandelbrot
		//
		SwitchToHires();
		ClearHiresScreen();

			//Scroller_InitHires();
			//System_InstallIRQ_SimpleVbl();
			Mandel_InitDisplay();
			Mandel_DrawFractal();
			//PlayerTest();
			//DigiPlayer_InstallIrq();

			//ScrollerTerminate();

		InitColorText();
		DoRotozoomMandel();


		//
		// DYCP
		//
		SwitchToText();
		ClearTextScreen();

			Rasters_Initialise();
			Scroller_InitDycp();
			Rasters_Demo();
			ScrollerTerminate();
			Tables_InitialiseCostable();


		//
		// End scroller with thanks
		//
		SwitchToHires();
		ClearHiresScreen();
		Fx_DrawTitle();

		// Cut the music		
		System_InstallDoNothing_CallBack();

		//
		// Color mire effect
		//
		Fx_TvMire();

		//
		// Tv Snow effect
		//		
		Fx_Snow();

		//
		// Black screen
		//
		SwitchToText();
		ClearTextScreen();

	//
	// And stay there forever
	//
	while (1);
}







