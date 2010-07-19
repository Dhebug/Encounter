
#include	<lib.h>

// --------------------------------------
//              Space: 1999
//           The Game Trailer
// --------------------------------------
// (c) 2010 Mickael Pointier.
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

//#define ENABLE_TESTS

#define ENABLE_MUSIC
#define ENABLE_RATING
#define ENABLE_QUOTES
#define ENABLE_ITC_LOGO
#define ENABLE_DEFENCEFORCE_LOGO
#define ENABLE_SPACE1999_LOGO
#define ENABLE_CREDIT_PICTURES


// Sequences.s
void SequenceRating();
void SequenceQuotes();
void SequenceItcLogo();
void SequenceSpace1999Logo();
void SequenceDefenceForceLogo();
void SequenceMartinLandau();
void SequenceBarbaraBain();
void SequenceBarryMorse();
void SequenceSylviaAnderson();
void SequenceGerryAnderson();

void SequenceChema();
void SequenceTwilighte();
void SequenceDbug();

void SequenceMoonExplodes();

void SequenceEmergency();

void SequenceEndMessage();

void SequenceThisEpisode();
void Sequence13September1999();

void SetInkYellow();
void SetInkBlack();

void UnpackFont();

// Tables.s

extern unsigned char BufferUnpack[8000];

extern unsigned char CosTable[];

void TablesInit();
void CreateHalfDisc();
void GenerateSquareTables();
void MirrorTheDisc();

// Display.s
void DisplayDefenceForceFrame();
void DisplayMakeShiftedLogos();
void DisplayScrappIt();

// Bitmap.s
void FontInit();
void BlackScreen();
void DrawCar();

// Draw.s
extern unsigned char X0,X1,Y;
extern unsigned char CX,CY,RAY;

extern unsigned char FrameCounter;
extern unsigned char TimerCounter;

void DrawDisc();
void FlipToScreen();

extern unsigned char FontTableX0[];
extern unsigned char FontTableY0[];
extern unsigned char FontTableWidth[];
extern unsigned char FontTableHeight[];
extern unsigned char TableBit6Reverse[];

extern char Message_StarringBarbaraBain[];
extern char Message_StarringMartinLandau[];
extern char Message_StarringBarryMorse[];
extern char Message_SylviaAnderson[];
extern char Message_GerryAnderson[];
extern char Message_Chema[];
extern char Message_Dbug[];
extern char Message_Music[];
extern char Message_Twilighte[];

extern char Message_Exclusive[];
extern char Message_Title[];
extern char Message_Website[];
extern char Message_Quote1[];
extern char Message_Quote2[];
extern char Message_Quote3[];
extern char Message_Quote4[];


extern char FontChars[];
extern unsigned char FontCharOffset;

extern unsigned char FontIndex[];

extern unsigned char X;
extern unsigned char Y;
extern unsigned char CAR;

// Auxiliar
extern void switch_ovl(void);

unsigned char gShadingAngle=0;


// part three, filter out the part of the cycling which are hidden by graphics
void FilterTheDisc1();
void FilterTheDisc2();



void DisplayPaperSet();
int counter;		// That one as a local trashes the music


extern unsigned char BoomColorBase;
extern unsigned char GlowColor[6];
extern unsigned char BoomColorMinus16[37+16];
extern unsigned char BoomColor[37];

void DrawNuclearBoom();

void UnpackToBuffer(void *pPackedData)
{
	file_unpack(BufferUnpack,pPackedData);
}

	
unsigned char yscroll;
unsigned char* ptrscroll;

void MoonScrollsDown()
{
	gShadingAngle=64;
	
	//BlackScreen();
	
	//UnpackToBuffer(LabelPictureLogo);
	//BlitRectangle((unsigned char*)0xa000+(40*89),BufferUnpack+(40*89),40,111);
	
	FrameCounter=64;
	while (FrameCounter--)
	{
		yscroll=112;
		ptrscroll=(unsigned char*)0xa000+(40*197);
		
		RAY=20;
		CX=120;
		CY=50;
		
		DrawDisc();
		
		gShadingAngle+=3;
		
		while (yscroll)
		{
			memcpy(ptrscroll+80,ptrscroll,80);
			ptrscroll-=80;
			yscroll-=2;
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





void main()
{
	//paper(0);
	hires();
	
    switch_ovl();

	init_irq_routine();

	TablesInit();
	FontInit();
	
#ifdef ENABLE_TESTS
	{
		// Tests
		while (1)
		{
			SequenceMoonExplodes();
		}
			SequenceEmergency();
		SequenceDefenceForceLogo();
		SequenceThisEpisode();
		Sequence13September1999();
		SequenceRating();
		SequenceTwilighte();
		SequenceSylviaAnderson();
		SequenceBarbaraBain();
		SequenceQuotes();
		SequenceGerryAnderson();
		SequenceDbug();
		SequenceBarryMorse();
		SequenceChema();
		while (1);
	}
#endif	
	
#ifdef ENABLE_RATING
	//
	// Need some kind of "all audience advisory" whatnots
	//
	SequenceRating();
	//while (1);
#endif

	
#ifdef ENABLE_QUOTES	
	//
	// Start by some quotes - no music
	//
	SequenceQuotes();
#endif


#ifdef ENABLE_MUSIC
	//
	// Start the music
	//
    PlayMainTune();
#endif
	
	
#ifdef ENABLE_ITC_LOGO
 	//
	// ITC entertainment logo
	//
	SequenceItcLogo();
#endif
	
#ifdef ENABLE_CREDIT_PICTURES
	//
	// Starring Martin Landau
	//
	SequenceMartinLandau();
			
	//
	// Starring Barbara Bain
	//
	SequenceBarbaraBain();
#endif

#ifdef ENABLE_SPACE1999_LOGO
	//
	// Space:1999 title picture
	//
	SequenceSpace1999Logo();
#endif	
	
	//
	// Emergency RED ALERT
	//
	SequenceEmergency();

#ifdef ENABLE_CREDIT_PICTURES
	// ---- This Episode yellow message
	//
	// This episode
	//
	SequenceThisEpisode();
		
	//
	// designer/programmer Jose Maria "Chema" Enguita
	//
	SequenceChema();
#endif
	
#ifdef ENABLE_DEFENCEFORCE_LOGO
	//
	// Show the animated logo
	//
	SequenceDefenceForceLogo();
#endif	
	
#ifdef ENABLE_CREDIT_PICTURES
	// Original theme - Barry Gray
	// adaptation Jonathan "Twilighte" Bristow
	SequenceTwilighte();
		
	// ---- This Episode yellow message
	//
	// This episode
	//
	SequenceThisEpisode();
			
	//
	// Also starring Barry Morse
	//
	SequenceBarryMorse();
	
	//
	// Producer Sylvia Anderson
	//
	SequenceSylviaAnderson();

	//	
	// Executive producer Gerry Anderson
	//
	SequenceGerryAnderson();
	
	//
	// in fast succession:
	// - September
	// - 13th
	// - 1999
	//
	Sequence13September1999();

	//
	// Explosion on the moon
	// The moon base alpha scroll downs with the earth standing still
	//
	SequenceMoonExplodes();	
	
	//
	// intro Mickael "Dbug" Pointier
	//
	SequenceDbug();
#endif	

	StopMusic();
	
	//
	// Out Of Memory title message
	//
	SequenceEndMessage();
	
	while (1);
	
	BlackScreen();
	while (1);
	
}

