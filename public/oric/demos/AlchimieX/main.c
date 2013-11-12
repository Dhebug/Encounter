//
// AlchimieGarden
//
// An Oric intro for Alchimie-X coded at the Kindergarden 2013 demo party.
//
//
#include <lib.h>

#include "script.h"


extern unsigned char LabelPictureAlchemieLogo[];
extern unsigned char LabelPictureKindergardenLogo[];
extern unsigned char LabelPictureEvolution[];
extern unsigned char PictureShip[];                 // 126x56 (21 blocs)

extern unsigned char ScrollerCommand;
extern unsigned char ScrollerCommandParam1;
extern unsigned char ScrollerCommandParam2;
extern unsigned char ScrollerCommandParam3;
extern unsigned char ScrollerCommandParam4;



void System_InstallIRQ_SimpleVbl();
void ScrollerInit();


void (*BottomEffectCallBack)(void);
void (*TopEffectCallBack)(void);



// http://www-users.cs.york.ac.uk/~jowen/hashlife.html

#define GOL_WIDTH 32
#define GOL_HEIGHT 8

#define GOL_GLIDER 0
#define GOL_FPENTAMINO 1
#define GOL_BLINKER 2
#define GOL_BLOCK 3
#define GOL_SMALLSHIP 4



extern unsigned char GameOfLifeBuffer1[GOL_WIDTH*GOL_HEIGHT];
extern unsigned char GameOfLifeBuffer2[GOL_WIDTH*GOL_HEIGHT];

extern unsigned char *ptr_buffer1;
extern unsigned char *ptr_buffer2;

void GOL_DrawPattern(unsigned char x,unsigned char y,unsigned char type)
{
	unsigned char* buffer=ptr_buffer1;
	buffer+=x+y*GOL_WIDTH;
	
	switch (type)
	{
	case GOL_GLIDER:
		buffer[(GOL_WIDTH*0)+2]=1;
		buffer[(GOL_WIDTH*1)+0]=1;
		buffer[(GOL_WIDTH*1)+2]=1;
		buffer[(GOL_WIDTH*2)+1]=1;
		buffer[(GOL_WIDTH*2)+2]=1;
		break;
		
	case GOL_FPENTAMINO:
		buffer[(GOL_WIDTH*0)+1]=1;
		buffer[(GOL_WIDTH*0)+2]=1;
		buffer[(GOL_WIDTH*1)+0]=1;
		buffer[(GOL_WIDTH*1)+1]=1;
		buffer[(GOL_WIDTH*2)+1]=1;
		break;
		
	case GOL_BLINKER:
		buffer[(GOL_WIDTH*0)+0]=1;
		buffer[(GOL_WIDTH*0)+1]=1;
		buffer[(GOL_WIDTH*0)+2]=1;
		break;
		
	case GOL_BLOCK:
		buffer[(GOL_WIDTH*0)+0]=1;
		buffer[(GOL_WIDTH*0)+1]=1;
		buffer[(GOL_WIDTH*1)+0]=1;
		buffer[(GOL_WIDTH*1)+1]=1;
		break;
		
	case GOL_SMALLSHIP:
		buffer[(GOL_WIDTH*0)+1]=1;
		buffer[(GOL_WIDTH*0)+4]=1;
		buffer[(GOL_WIDTH*1)+0]=1;
		buffer[(GOL_WIDTH*2)+0]=1;
		buffer[(GOL_WIDTH*2)+4]=1;
		buffer[(GOL_WIDTH*3)+0]=1;
		buffer[(GOL_WIDTH*3)+1]=1;
		buffer[(GOL_WIDTH*3)+2]=1;
		buffer[(GOL_WIDTH*3)+3]=1;
		break;
	}
}

void GameOfLife_Init()
{
	GOL_RedefineCharacters();
	
	ptr_buffer1=GameOfLifeBuffer1;
	ptr_buffer2=GameOfLifeBuffer2;
	
	GOL_DrawPattern(5,5,GOL_BLOCK);
	GOL_DrawPattern(15,5,GOL_BLINKER);
	GOL_DrawPattern(20,10,GOL_GLIDER);
	GOL_DrawPattern(5,10,GOL_FPENTAMINO);
	GOL_DrawPattern(25,5,GOL_SMALLSHIP);
}

unsigned char GameOfLifeCounter=0;

void GameOfLife()
{
	unsigned char* temp;
		
	GOL_ShowBuffer();
	GOL_Evolve();
	temp=ptr_buffer1;
	ptr_buffer1=ptr_buffer2;
	ptr_buffer2=temp;		
	
	GameOfLifeCounter++;
	if (GameOfLifeCounter==8)
	{
		GameOfLifeCounter=0;
		
		GOL_DrawPattern(rand()&31,rand()&7,rand()%4);
	}
}


void ClearTextWindow()
{
	memset((char*)0xbb80+40*11,32,17*40);	
	poke(0xa000+40*8,16+0);    // Black

	poke(0xa000+40*84,16+1);
	poke(0xa000+40*85,16+3);
	poke(0xa000+40*86,16+1);
	poke(0xa000+40*87,16+0);
}




void EffectDoNothing()
{

}


unsigned char ShipPosition=39;

void SpaceShipAnimation()
{
   int y;
   int sizeToShow=40-ShipPosition;
   if (sizeToShow>21)
   {
   	sizeToShow=21;
   }
   if (ShipPosition==0)
   {
   	TopEffectCallBack=EffectDoNothing;
   }
   else
   {
	   for (y=0;y<56;y++)
	   {
			memcpy((char*)0xa000+40*9+40*10+y*40+ShipPosition,PictureShip+y*21,sizeToShow);
	   }
	   ShipPosition--;   	
   }
}



extern unsigned char CosTable[256];

	unsigned char angle;
	unsigned char angle0;
	unsigned char angle1;

extern unsigned char zoom;
extern unsigned char zoomstart;
	



void ChessBoard_MakeVideoMode()	
{
	// void ChessBoard_MakeVideoMode()
	unsigned char *ptr_screen;
	unsigned int y,x;
	unsigned char c,cc,color;

	for (y=88;y<200;y++)
	{
		poke(0xa000+40*y+3,26);			// TEXT 50
	}

	for (y=11;y<25;y++)
	{
		poke(0xbb80+40*y,30);		// HIRES 50		
	}
			

	// Fill the screen with characters to redefine for the zoommer
	ptr_screen=(unsigned char*)0xbb80+11*40;
	for (y=11;y<24;y++)
	{
		c=32+10;
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
}


void ChessBoard_MainLoop()
{
	zoom=30+(CosTable[angle]>>2);
	
	zoomstart=1+(((int)zoom)*((int)CosTable[angle0]))/255;
	DrawHorizontalChecker();

	zoomstart=1+(((int)zoom)*((int)CosTable[angle1]))/255;
	DrawVerticalChecker();
	
	angle++;
	angle0+=2;
	angle1+=3;
}


void main()
{
	//
	// Clear the screen
	//
	memset((char*)0xa000,0,8000);
		
	//
	// Pseudo hires switch
	//
	ScrollerInit();

	BottomEffectCallBack=EffectDoNothing;
	TopEffectCallBack=EffectDoNothing;

	System_InstallIRQ_SimpleVbl();
		

	GameOfLife_Init();	
	ClearTextWindow();

	while (1)
	{
		if (ScrollerCommand!=SCROLLER_NOTHING)
		{
			unsigned char command=ScrollerCommand;
			ScrollerCommand=SCROLLER_NOTHING;		
			switch (command)
			{
			case SCROLLER_SHOW_LOGO:
				{
					file_unpack((char*)0xa000+40*9,LabelPictureAlchemieLogo);
				}
				break;

			case SCROLLER_SHOW_KGLOGO:
				{
					file_unpack((char*)0xa000+40*9,LabelPictureKindergardenLogo);
				}
				break;

			case SCROLLER_SHOW_EVOLUTIONLOGO:
				{
					file_unpack((char*)0xa000+40*9,LabelPictureEvolution);
				}
				break;

			case SCROLLER_START_GAMEOFLIFE:
				{
					ClearTextWindow();
					BottomEffectCallBack=GameOfLife;
				}
				break;

			case SCROLLER_SHOW_SPACESHIP:
				{
					memset((char*)0xa000+40*9,64,40*75);
					ShipPosition=39;
					TopEffectCallBack=SpaceShipAnimation;
				}
				break;

			case SCROLLER_START_CHESSBOARD:
				{
					ClearTextWindow();
					ChessBoard_MakeVideoMode();
					BottomEffectCallBack=ChessBoard_MainLoop;
				}
				break;

			case SCROLLER_END:
				break;
			}
		}

		// Stuff
		BottomEffectCallBack();
		TopEffectCallBack();
	}
}

