//
// EncounterHD - Game Splash sequence
// (c) 2020-2024 Dbug / Defence Force
//

#include <lib.h>

#include "common.h"

extern unsigned char LabelPicture0[2960];
extern unsigned char LabelPicture1[2960];
extern unsigned char LabelPicture2[2960];
extern unsigned char LabelPicture3[2960];
extern unsigned char LabelPicture4[2960];
extern unsigned char LabelPicture5[2960];

extern unsigned char *DistorterTable[6];

extern unsigned char CosTable[];         // Originally contains non signed values, from 0 to 255

extern DrawPreshiftLogos();


int angle;
int angle2;
int angle3;
int angle4;
int offset;
int sourceOffset;
int verticalSourceOffset;
int maxVerticalSourceOffset;

int y,position,stopMoving;



// Some quite ugly function which waits a certain number of frames
// while detecting key presses and returns 1 if either space or enter are pressed
int Wait(int frameCount)
{	
	int k;

	while (frameCount--)
	{
		WaitIRQ();

		k=ReadKey();
		if ((k==KEY_RETURN) || (k==' ') )
		{
			//PlaySound(KeyClickLData);
			WaitFrames(4);
			return 1;
		}
	}
	return 0;
}


void PatchCosTable()
{
	int x;

	for (x=0;x<256;x++)
	{
		CosTable[x]=(((int)CosTable[x])*3)/255;
	}
}



int ShowLogoAnimation(unsigned char height,unsigned char startPosition, unsigned int frameCount)
{
    stopMoving = 0;
    position = startPosition;

    maxVerticalSourceOffset = height*40;

    while (frameCount--)
    {
        unsigned char* ptrSrc=(unsigned char*)LabelPicture0;
        unsigned char* ptrDst=(unsigned char*)0xa000+(125-position)*40;
        unsigned char* ptrDstBottom=(unsigned char*)0xa000+(125+position/2)*40;

        angle2=angle;
        angle3=angle;
        angle4=angle;
        angle+=5;

        sourceOffset=0;

        for (y=0;y<position;y++)
        {
            if (!stopMoving)
            {
                if (y<height)
                {
                    memcpy(ptrDst+2,ptrSrc+2,40-2);
                }
                else
                {
                    memset(ptrDst+2,64,40-2);
                }
            }
            if (y&1)
            {
                offset=CosTable[angle2&255]+CosTable[angle3&255];
                verticalSourceOffset=CosTable[angle4&255]*40;

                if ((y<height) && ((sourceOffset+verticalSourceOffset)<maxVerticalSourceOffset) ) 
                {
                    memcpy(ptrDstBottom+2,DistorterTable[offset]+sourceOffset+2+verticalSourceOffset,40-2);
                }
                else
                {
                    memset(ptrDstBottom+2,64,40-2);
                }
                sourceOffset+=80;
                ptrDstBottom-=40;

                angle2+=5;
                angle3+=7;
                angle4+=11;

            }
            ptrDst+=40;
            ptrSrc+=40;
        }
        if (Wait(1))
        {
            return 1;
        }

        if (position<height+5)
        {
            position++;
        }
        else
        {
            stopMoving=1;
        }
    }
    return 0;
}


void SetupLineColors(unsigned char y,unsigned char paperTop,unsigned char inkTop,unsigned char paperBottom,unsigned char inkBottom)
{
    unsigned char* ptr=(unsigned char*)0xa000+y*40;
    if (y<125)
    {
        // Top half of the screen
        ptr[0]=paperTop;
        ptr[1]=inkTop;
    }
    else
    {
        // Bottom half of the screen (the river where things reflect)
        ptr[0]=paperBottom;
        ptr[1]=inkBottom;
    }
    memset(ptr+2,64,38);
}


int SetupColors(unsigned char paperTop,unsigned char inkTop,unsigned char paperBottom,unsigned char inkBottom)
{
    int y,spacing;
    for (spacing=16;spacing>=1;spacing>>=1)
    {
        for (y=0;y<200;y+=spacing)
        {
            SetupLineColors(y,paperTop,inkTop,paperBottom,inkBottom);
        }
        if (Wait(spacing/2))
        {
            return 1;
        }
    }
    return 0;
}



int DisplayLogosWithPreshift()
{
	// Load the first picture at the default address specified in the script
	LoadFileAt(INTRO_PICTURE_LOGOS,ImageBuffer);

	Hires(16+0,4);

    memset((char*)0xa000,64,8000);

    PatchCosTable();

    // Scroll the Servern Software up the river: Logo is 51 lines tall, from line 97 to 147
    if (SetupColors(16+0,7,16+4,6))       return 1;
    memcpy(LabelPicture0,ImageBuffer+97*40,51*40);
    DrawPreshiftLogos();
    if (ShowLogoAnimation(51,0,100))      return 1;


    // Scroll the Defence Force logo up the river: Logo is 74 lines tall, from line 5 to 78
    if (SetupColors(16+7,0,16+4,0))       return 1;
    memcpy(LabelPicture0,ImageBuffer+5*40,74*40);
    DrawPreshiftLogos();
    if (ShowLogoAnimation(74,74+5,90))   return 1;

    return 0;
}



void main()
{
	// Load the charset
	//LoadFileAt(LOADER_FONT_6x8,0x9900);              // Art Deco font
	LoadFileAt(LOADER_FONT_TYPEWRITER_6x8,0x9900);     // Typewriter font

	// Install the IRQ so we can use the keyboard
	System_InstallIRQ_SimpleVbl();

    // Display the Severn Software and Defence Force logos
	DisplayLogosWithPreshift();

    // Clear the screen
    SetupColors(16+0,7,16+0,6);

	System_RestoreIRQ_SimpleVbl();

	// Quit and return to the loader
	InitializeFileAt(LOADER_INTRO_PROGRAM,LOADER_INTRO_PROGRAM_ADDRESS);   // 0x400
}

