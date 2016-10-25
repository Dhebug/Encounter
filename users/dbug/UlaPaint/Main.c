
#include <lib.h>

// --------------------------------------
//   TuUlaTool (The Ultimate ULA Tool)
// --------------------------------------
// (c) 2003 Mickael Pointier.
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
// Note: This text was typed with a Win32
// editor. So perhaps the text will not be
// displayed correctly with other OS.




typedef enum
{
	SPECIAL_KEY_NONE		=0,
	SPECIAL_KEY_CONTROL		=1,
	SPECIAL_KEY_SHIFT_LEFT	=2,
	SPECIAL_KEY_SHIFT_RIGHT	=4,
	SPECIAL_KEY_FUNCTION	=8
}SPECIAL_KEYS;




// ============================================================================
//
//									Externals
//
// ============================================================================

//
// ===== Display.s =====
//
extern unsigned char CurrentDisplayCode;

extern unsigned char CurrentTool;

extern unsigned char HiresSizePos;		// Position of hires view
extern unsigned char HiresSizeView;		// Size of the the hires view

extern unsigned char PixelDrawMode;		// 0=erase 1=draw 2=invert 3=nothing
extern unsigned char FlagPixelMode;		// 0=byte 1=pixel 
extern unsigned char CurrentPixelX;		// Coordinate X of edited pixel/byte
extern unsigned char CurrentPixelY;		// Coordinate Y of edited pixel/byte

extern unsigned char OtherPixelX;		// Coordinate X of other edited pixel/byte
extern unsigned char OtherPixelY;		// Coordinate Y of other edited pixel/byte

extern unsigned char ToolWidth;
extern unsigned char ToolHeight;

extern unsigned char CurrentZoomPixelBit;
extern unsigned char CurrentZoomPixelX; // X Position of zoomed window pixel         
extern unsigned char CurrentZoomPixelY; // Y Position of zoomed window pixel 

extern unsigned char CurrentZoomX;		// X Position of zoomed window
extern unsigned char CurrentZoomY;		// Y Position of zoomed window
extern unsigned char CurrentLineCount;	// Number of lines in the zoomed window

extern unsigned char TableBit6[];
extern unsigned char TableMul6[];
extern unsigned char TableDiv6[];
extern unsigned char TableMod6[];


extern unsigned char MemorizedByte;
extern unsigned char *PtrCurrentByte;

extern unsigned char FlagRedrawInfos;
extern unsigned char FlagRedrawPicture;
extern unsigned char FlagRedrawZoomer;
extern unsigned char FlagRedrawInverse;

extern unsigned char FlagProtectedAttribute;

extern unsigned char FlagDisplayZoomer;

extern unsigned char KeySpecial;
extern unsigned char KeyScan;




void DoLoad();
void GenerateTables();

void DisplaySeparationLines();
void DisplayPicture();
void DisplayZoomer();
void DisplayPictureFullScreen();

void PictureInvertWindow();

void DisplayInformation();

void DisplayCursorCoordinates();




//
// ===== Font.s =====
//
extern unsigned char FuturisticFont[];
extern unsigned char TextX;
extern unsigned char TextY;

void TextPos(unsigned char x,unsigned char y);
void TextPrint(char *ptr_message);


//
// ===== Buffer.s =====
//
extern unsigned char BufferMain1[];		// Buffer for the main picture

void UndoBufferMemorize();
void UndoBufferSwap();

void BufferErase();
void PictureInvertWindow();
void PaintPixel();

void SwitchToHires();
void SwitchToText();
void ClearTextScreen();


void DrawLine();
void EraseLine();

void DrawTool();
void RestoreToolBackground();


//
// ===== Files.s =====
//
extern char			FileFlagForceAdress;
extern void			*FileAdress;
extern unsigned int FileSize;

void FileLoad();
void FileSave();





//
// ===== Handling.s =====
//

extern unsigned char KeyCar;
extern unsigned	char FlagExit;

void ZoomerExtend();
void ZoomerShrink();

void MoveLeft();
void MoveRight();
void MoveUp();
void MoveDown();

void HandleKeyboard();



// ============================================================================
//
//								File system handling
//
// ============================================================================

void LoadPicture(const char *ptr_filename)
{
	FileFlagForceAdress	=1;
	FileAdress			=BufferMain1;
	strcpy((char*)0x27f,ptr_filename);
	FileLoad();
}

void SavePicture(const char *ptr_filename)
{
	strcpy((char*)0x27f,ptr_filename);
	strcpy((char*)0x293,ptr_filename);

	FileAdress			=BufferMain1;
	FileSize			=8000;

	FileSave();
}


// ============================================================================
//
//									Main code
//
// ============================================================================


void ValidateDisplayValues_X();
void ValidateDisplayValues_Y();


void ValidateDisplayValues()
{
	int new_pos;

	ValidateDisplayValues_X();

	ValidateDisplayValues_Y();

	
	new_pos=CurrentZoomY+(CurrentLineCount>>1)-(HiresSizeView>>1);
	if (new_pos<0)
	{
		new_pos=0;
	}
	else
	if (new_pos>=(200-HiresSizeView))
	{
		new_pos=(200-HiresSizeView);
	}

	if (HiresSizePos!=new_pos)
	{
		HiresSizePos=new_pos;
		FlagRedrawPicture=1;
	}



	if (CurrentPixelX>OtherPixelX)
	{
		ToolWidth=CurrentPixelX-OtherPixelX;
	}
	else
	{
		ToolWidth=OtherPixelX-CurrentPixelX;
	}

	if (CurrentPixelY>OtherPixelY)
	{
		ToolHeight=CurrentPixelY-OtherPixelY;
	}
	else
	{
		ToolHeight=OtherPixelY-CurrentPixelY;
	}

	ToolWidth++;
	ToolHeight++;
}





void EditMode()
{
	SwitchToHires();

	FlagRedrawPicture=1;
	FlagRedrawZoomer=1;
	FlagRedrawInverse=1;
	FlagRedrawInfos=1;

	FlagExit=0;


	// Initial sanity checks
	ValidateDisplayValues();

	// Key wait
	while (!FlagExit)
	{
		DisplayInformation();
		DisplayCursorCoordinates();

		if (FlagRedrawPicture)
		{
			// - test
			RestoreToolBackground();
			DrawTool();
			// -
			
			if (FlagDisplayZoomer)
			{				
				if (FlagRedrawInverse)	
				{
					PictureInvertWindow();
				}				
				DisplayPicture();		// BufferMain1 => $a000
				if (FlagRedrawInverse)	
				{					
					PictureInvertWindow();
					FlagRedrawInverse=0;					
				}
				else
				{
					FlagRedrawPicture=0;
				}
			}
			else
			{
				DisplayPictureFullScreen();
				FlagRedrawPicture=0;
			}
			

			/*
			{
				int x0,y0,x1,y1;
				x0=CurrentPixelX;
				y0=CurrentPixelY;
				x1=OtherPixelX;
				y1=OtherPixelY;

				x1-=CurrentPixelX;
				y1-=CurrentPixelY;

				*((unsigned char*)0x21f)=1;	// HIRES
				*((unsigned char*)0x213)=255;	// PATTERN

				DrawLine();
				curset(x0,y0,1);
				draw(x1,y1,1);
			}
			*/

			//DrawLine();
				
		}

		//curset(120,100,1);

		if ((FlagRedrawZoomer) && (FlagDisplayZoomer))
		{
			// Draw two separation lines...
			DisplaySeparationLines();

			DisplayZoomer();
			FlagRedrawZoomer=0;
		}


		


		while (KeyCar=key())
		{
			/*
			if (KeyCar)
			{
				KeyScan=(*((unsigned char*)0x208));
			}
			else
			{
				KeyScan=0;
			}


			// Read shift things
			switch (*((unsigned char*)0x209))
			{
			case 162:
				KeySpecial=SPECIAL_KEY_CONTROL;
				break;
			case 164:
				KeySpecial=SPECIAL_KEY_SHIFT_LEFT;
				break;
			case 167:
				KeySpecial=SPECIAL_KEY_SHIFT_RIGHT;
				break;
			case 165:
				KeySpecial=SPECIAL_KEY_FUNCTION;
				break;
			default:
				KeySpecial=SPECIAL_KEY_NONE;
				break;
			}
			*/


			//
			// Handling of keyboard
			//
			HandleKeyboard();

		}
	}
}



void Keyboard_Filter()
{
	while (key())
	{
		get();
	}
}

void HelpMode_Concept()
{
	char KeyCar;

	// Switch to TEXT mode...
	ClearTextScreen();

	TextPos(0,0);
	TextPrint("\003=======================================\n");
	TextPrint("     Concept and general informations\n");
	TextPrint("\003=======================================\n");
	TextPrint(" The only way to create pictures on the\n");
	TextPrint(" Oric today is to use programs like\001Hide\n");
	TextPrint("\001Lorigraph\007, or \001MasterPaint\007.\n\n");

	TextPrint(" These programs are either too\004old\007to be\n");
	TextPrint(" really usable today, or too\004complicated\n");
	TextPrint(" to use by someone that don't know the\n");
	TextPrint("\003Oric\007peculiarities by heart...\n\n");

	TextPrint(" Drawing on a\001PC\007painting program and  \n");
	TextPrint(" then using\001PcHires\007or\001PictConv\007also \n");
	TextPrint(" requires that the artists mastered all\n");
	TextPrint("\003Oric\007constraints.\n\n");

	TextPrint(" The objective is to design\004UlaPaint\007in\n");
	TextPrint(" a way that makes it usable by anyone, \n");
	TextPrint(" and to provide the best features found \n");
	TextPrint(" in the other paint programs...\n");

	TextPrint("\n\n\002[ESCAPE]\007Previous page\n");

	Keyboard_Filter();
	while (1)
	{
		KeyCar=get();
		switch (KeyCar)
		{
		case 27:
			// Back to editing
			return;
		}
	}
}


void HelpMode_Keyboard()
{
	char KeyCar;

	// Switch to TEXT mode...
	ClearTextScreen();

	TextPos(0,0);
	TextPrint("\003=======================================\n");
	TextPrint("           keyboard shortcuts\n");
	TextPrint("\003=======================================\n");

	TextPrint(" Please look into 'documentation.txt'.\n\n");

	TextPrint(" That page will be updated when\n");
	TextPrint(" keyboard layout will be fixed.\n");

	/*
	TextPrint(" The following keys can be used:\n\n");

	TextPrint("\002      ARROWS\007Move view (slow)\n");
	TextPrint("\002LSHIFT+ARROW\007Move view (Fast)\n");
	TextPrint("\002RSHIFT+ARROW\007Move view to borders\n");
	TextPrint("\002CTRL+UP/DOWN\007Change zoomer size\n\n");
	TextPrint("\002      LSHIFT\007Show zoomed area\n");
	TextPrint("\002       SPACE\007Switch zoom display mode\n\n");
	TextPrint("\002      1 to 6\007Load a test picture\n\n");
	TextPrint("\002      S to J\007Change one of the 6 pixels\n");
	TextPrint("\002       ENTER\007Change current pixel\n\n");
	TextPrint("\002           I\007Video invert current byte\n\n");
	TextPrint("\002     C and V\007Copy and Paste byte\n\n");
	TextPrint("\002      ESCAPE\007Back to help page\n");
	*/

	TextPrint("\n\n\002[ESCAPE]\007Previous page\n");

	Keyboard_Filter();
	while (1)
	{
		KeyCar=get();
		switch (KeyCar)
		{
		case 27:
			// Back to editing
			return;
		}
	}
}


void HelpMode_BufferOperation()
{
	char KeyCar;
	char flag_refresh;
			  
	flag_refresh=1;

	while (1)
	{
		if (flag_refresh)
		{
			ClearTextScreen();

			TextPos(0,0);
			TextPrint("\003=======================================\n");
			TextPrint("           Buffer operations\n");
			TextPrint("\003=======================================\n");

			TextPrint(" The following keys can be used:\n\n");

			TextPrint("\002 [0]\007Erase buffer\n\n");
			TextPrint("\002 [1]\007Load 'Yessa'\n");
			TextPrint("\002 [2]\007Load 'Damsel'\n");
			TextPrint("\002 [3]\007Load 'Krillys'\n");
			TextPrint("\002 [4]\007Load 'Diamond1'\n");
			TextPrint("\002 [5]\007Load 'Diamond2'\n");
			TextPrint("\002 [6]\007Load 'Diamond3'\n\n");

			TextPrint("\002 [8]\007Load 'TEST.TAP'\n");
			TextPrint("\002 [9]\007Save 'TEST.TAP'\n\n");

			TextPrint("\n\n\002[ESCAPE]\007Previous page\n");

			flag_refresh=0;
		}

		Keyboard_Filter();
		KeyCar=get();
		switch (KeyCar)
		{
		case '0':
			UndoBufferMemorize();
			BufferErase();
			FlagRedrawZoomer=1;
			FlagRedrawPicture=1;
			FlagRedrawInverse=1;
			break;

		case '1':
			UndoBufferMemorize();
			LoadPicture("yessa");
			FlagRedrawZoomer=1;
			FlagRedrawPicture=1;
			FlagRedrawInverse=1;
			flag_refresh=1;
			break;

		case '2':
			UndoBufferMemorize();
			LoadPicture("damsel");
			FlagRedrawZoomer=1;
			FlagRedrawPicture=1;
			FlagRedrawInverse=1;
			flag_refresh=1;
			break;

		case '3':
			UndoBufferMemorize();
			LoadPicture("krillys");
			FlagRedrawZoomer=1;
			FlagRedrawPicture=1;
			FlagRedrawInverse=1;
			flag_refresh=1;
			break;

		case '4':
			UndoBufferMemorize();
			LoadPicture("diamond_1");
			FlagRedrawZoomer=1;
			FlagRedrawPicture=1;
			FlagRedrawInverse=1;
			flag_refresh=1;
			break;

		case '5':
			UndoBufferMemorize();
			LoadPicture("diamond_2");
			FlagRedrawZoomer=1;
			FlagRedrawPicture=1;
			FlagRedrawInverse=1;
			flag_refresh=1;
			break;

		case '6':
			UndoBufferMemorize();
			LoadPicture("diamond_3");
			FlagRedrawZoomer=1;
			FlagRedrawPicture=1;
			FlagRedrawInverse=1;
			flag_refresh=1;
			break;

		case '8':
			UndoBufferMemorize();
			LoadPicture("test.tap");
			FlagRedrawZoomer=1;
			FlagRedrawPicture=1;
			FlagRedrawInverse=1;
			flag_refresh=1;
			break;

		case '9':
			SavePicture("test.tap");
			FlagRedrawZoomer=1;
			FlagRedrawPicture=1;
			FlagRedrawInverse=1;
			flag_refresh=1;
			break;

		case 27:
			// Back to editing
			return;
		}
	}
}




char HelpMode()
{
	char KeyCar;
	char flag_refresh;

	SwitchToText();

	flag_refresh=1;

	while (1)
	{
		if (flag_refresh)
		{
			ClearTextScreen();

			TextPos(0,0);
			TextPrint("\003=======================================\n");
			TextPrint("        UlaPaint (beta) \001v0.010\n");
			TextPrint("             \004(c) 2003 Dbug\n");
			TextPrint("\003=======================================\n");
			TextPrint("\001UlaPaint\007is a painting program. This\n");
			TextPrint(" version is only a beta for evaluation\n");
			TextPrint(" and debugging. You can't do anything\n");
			TextPrint(" interesting with it.\n");
			TextPrint(" Wait for the first official release !!!\n");
			TextPrint("\003=======================================\n");

			TextPrint("\n\n");
			TextPrint("\002     [1]\007Concept and informations\n");
			TextPrint("\002     [2]\007Keyboard shortcuts\n");
			TextPrint("\002     [3]\007Buffer operations\n");
			TextPrint("\002     [Q]\007Quit program\n");
			TextPrint("\002[ESCAPE]\007back to editing\n");

			flag_refresh=0;
		}

		KeyCar=get();
		switch (KeyCar)
		{
		case 27:
			// Back to editing
			return 1;

		case '1':
			HelpMode_Concept();
			flag_refresh=1;
			break;

		case '2':
			HelpMode_Keyboard();
			flag_refresh=1;
			break;

		case '3':
			HelpMode_BufferOperation();
			flag_refresh=1;
			break;

		case 'q':
		case 'Q':
			// Quit
			return 0;
		}
	}
}


void main()
{	
	// Remove key click, cursor blinking
	*((unsigned char*)0x26a)=NOKEYCLICK|SCREEN;

	// Fill the picture buffer with neutral values
	BufferErase();
	UndoBufferMemorize();

	// Configurate things
	GenerateTables();

	// Start working
	while (1)
	{
		if (!HelpMode())
		{
			// Quit
			break;
		}

		EditMode();
	}

	// Quit
	//paper(7);
	//ink(0);
	//text();
	ClearTextScreen();
	*((unsigned char*)0x26a)=CURSOR|SCREEN;
	//printf("Type 'CALL#600' to relaunch program\n");
}


