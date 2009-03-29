
#include	<lib.h>

// --------------------------------------
// Proof Of Concept #1: 
// Double buffered smooth sinus Dots 
// --------------------------------------
// (c) 2004-2006 Mickael Pointier.
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
//#define ENABLE_DEBUG_INFOS




// =========================== begin externs ===============

extern unsigned int VSyncCounter1;
extern unsigned int VSyncCounter2;

void VSyncGetCounter();
void VSyncGetCounterStats();

void TablesInit();

void MainLoopStuff();

void MainShowControlKeys();

void PrepareScreen();

void KeyboardRead();
void KeyboardWait();
void KeyboardFlush();
extern char gKey;


extern unsigned char LabelPicture[];

// =========================== end externs ===============

unsigned char *TextPtr=(unsigned char*)0xbb80;
unsigned int TextWidth=40;

unsigned char TextX;
unsigned char TextY;

void TextPos(unsigned char x,unsigned char y)
{
	TextX=x;
	TextY=y;
}


void TextPrint(char *ptr_message)
{
	unsigned char car;
	unsigned char *ptr_screen;
	unsigned char memo_x;

	memo_x=TextX;
	ptr_screen=TextPtr+TextX+(TextY*TextWidth);

	while (car=*ptr_message++)
	{
		if (car==255)
		{
			TextX=memo_x;
			ptr_screen=TextPtr+TextX+(TextY*TextWidth);
			TextY++;
		}
		else
		{
			*ptr_screen++=car;
			TextX++;
		}
	}
}



void TextPrintValue(unsigned int value)
{
	unsigned int counter;
	unsigned int value2;
	unsigned char car;
	unsigned char *ptr_screen;

	TextX+=5;
	ptr_screen=TextPtr+TextX+(TextY*TextWidth);

	if (!value)
	{
		ptr_screen--;
		*ptr_screen='0';
		counter=1;
	}
	else
	{
		counter=0;
		while (value)
		{
			value2=value/10;
			car=value-(value2*10);
			value=value2;
			ptr_screen--;
			*ptr_screen=car+'0';
			counter++;
		}
	}

	while (counter<5)
	{
		counter++;
		ptr_screen--;
		*ptr_screen=' ';
	}
}


void TestVSync()
{
	unsigned char	key; 

	KeyboardFlush();
	
	TextPos(0,26);
	TextPrint("\003           Status of the VSYNC:");
	while (1)
	{
		VSyncGetCounterStats();
		if ((!VSyncCounter1) && (!VSyncCounter2))
		{
			TextPos(0,27);
			TextPrint("\001 \014== No input, Please connect Vsync ==\377");
		}
		else
		{
			TextPos(0,27);
			TextPrint("\002 Working: ");
			TextPrintValue(VSyncCounter1);
			TextPrint(" - ");
			TextPrintValue(VSyncCounter2);
			TextPrint(", press Space !");

			KeyboardRead();
			if (gKey & 16)
			{
				break;
			}
		}
	}
}

void Break();

void main()
{
	//
	// Display the POC message
	//
	IrqOff();
	text();
	paper(0);
	cls();
	*((unsigned char*)0xbb80+40-4)=0;	// Hide CAPS message
	
	TextPos(0,0);
	TextPrint("\012\003         Proof Of Concept\001#1\377");
	TextPrint("\012\003         Proof Of Concept\001#1\377");
	TextPos(0,4);
	TextPrint("\012\002  Double buffered sinus Dots \10050hz\377");
	TextPrint("\012\002  Double buffered sinus Dots \10050hz\377");
	TextPos(0,8);
	TextPrint("\004          \140 2006 - Dbug \377");
	TextPos(0,10);
	//            0         1         2         3
	//            0123456789012345678901234567890123456789
	TextPrint("\006This is not really an intro in the demo");
	TextPrint("\006scene usual definition of the term.\377");
	TextPrint("\006There is no music and only one boring\377");
	TextPrint("\006effect (sinus dots).\377");
	TextPrint("\006\377");
	TextPrint("\006This is however a milestone in the ORIC");
	TextPrint("\006demo history, because it shows for the\377");
	TextPrint("\006first time a working real double buffer\377");
	TextPrint("\006animation.\377");
	TextPrint("\006\377");
	TextPrint("\006The picture that appear next indicates\377");
	TextPrint("\006how to enable the hardware vsync. This\377");
	TextPrint("\006is just a wire to connect between two\377");
	TextPrint("\006connectors. Dumb simple, honnest.\377");
	TextPrint("\003  (Recent emulators can emulate this)\377");
	TextPrint("\006\377");
	
	TextPrint("\001   \014== Press SPACE to continue ==\377");
	
	KeyboardWait();
	//
	// Display the picture on screen
	//
	TablesInit();
	
	ink(3);
	hires();
	file_unpack((unsigned char*)0xa000,LabelPicture);
#ifdef ENABLE_VSYNC
	TestVSync();
#endif
	
	// Clean TEXT section	
	memset((void*)0xbb80,32,28*40);

	// Clean STD charset
	memset((void*)0xb400,0,8*128);
		
	// Clean HIRES section
	memset((void*)0xa000,64,0xb400-0xa000);

	// Clean TEXT section
	memset((void*)0xbb80,32,16*40);
	
	// Copy STD charset of HIRES area to ALT charset of TEXT area
	memcpy((void*)0xb800,(void*)0x9800,8*96);
	
	
		
	PrepareScreen();

	MainShowControlKeys();

	MainLoopStuff();
}










