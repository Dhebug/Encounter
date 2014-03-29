//
// This program simply display a picture on the hires screen
//
//#include <demosystem.h>
#include <lib.h>

// irq.s
extern void System_InstallIRQ_SimpleVbl();
extern void System_RemoveIRQ();
extern void VSync();

// player.s
extern void Player_Initialize();
extern void Player_PlayFrame();
extern void Player_PlayNote();
extern void Player_PlayPause();
extern void Player_Silence();

extern unsigned int player_note;

extern unsigned char LabelPicture[];
extern unsigned char LabelPictureXnitzy[];
extern unsigned char LabelPictureOops[];

extern unsigned char RedRasters[];
extern unsigned char BlackRasters[];
extern unsigned char MultiRasters[];

unsigned char RasterPos=0;
unsigned char GlobalShowY;

void Rasters()
{
	if (GlobalShowY<44)
	{
		unsigned char* screen;
		int y,maxy;
		int i,j,k;

		screen=(unsigned char*)0xa000+40*44;

		i=RasterPos;
		j=RasterPos;
		k=RasterPos;

		maxy=(44-GlobalShowY)/2;
		if (maxy>18)
		{
			maxy=18;
		}

		for (y=0;y<maxy;y++)
		{
			screen[1]=RedRasters[j&15];
			screen[15]=MultiRasters[k&31];
			screen-=40;
			k++;

			screen[1]=BlackRasters[i&15];
			screen[15]=MultiRasters[k&31];
			screen-=40;
			k++;

			i++;
			j--;
		}
		RasterPos++;
	}
}

void Pause()
{
	VSync();
	/*
	int i;

	for (i=0;i<500;i++)
	{

	}
	*/
}

void PatchPicture()
{
	unsigned char* ptr;
	int y;
	ptr=LabelPicture;
	for (y=0;y<200;y++)
	{
		ptr[0]=0;
		//ptr[1]=7;
		ptr+=40;
	}
}

void ShowPicture()
{
	unsigned char* ptr;
	
	ptr=(unsigned char*)0xa000+200*40;

	GlobalShowY=200;
	while (GlobalShowY)
	{
		Pause();
		ptr-=40;

		ptr[0-40*4]=16+4;
		ptr[1-40*4]=1;

		ptr[0-40*3]=16+4;
		ptr[1-40*3]=1;

		ptr[0-40*2]=16+6;
		ptr[1-40*2]=3;

		ptr[0-40*1]=16+6;
		ptr[1-40*1]=3;

		ptr[0]=16+7;
		ptr[1]=0;

		Rasters();

		GlobalShowY--;
	}
}


unsigned char StarOffsets[]=
{
10,
22,
24,
16,
12,
19,
34,
 8,
32,
 3,
 2,
39,
28,
35,
 4,
14,
 5,
 7,
 0,
25,
23,
37,
20,
13,
 6,
36,
29,
18,
33,
11,
27,
31,
15,
17,
21,
 1,
 9,
38,
30,
26,
};

unsigned char StarColors[]=
{
	16+7,
	16+6,
	16+4,
	16+0,
};

int StarGlobalOffset;

void StarField()
{
   	int y;
	unsigned char* ptr;
	int x,xx,color;
	int xxx;
	
	memset((unsigned char*)0xa000,0,8000);
	memcpy((unsigned char*)0xa000,LabelPictureXnitzy,8000);
	
	while (StarGlobalOffset>-150)
	{
		ptr=(unsigned char*)0xa000+4;
   		for (y=0;y<20;y++)
   		{
   			x=(StarOffsets[y]+StarGlobalOffset);
   			for (xx=0;xx<4;xx++)
   			{
   				xxx=x+xx;
   				if (xxx>39)
   				{
   					xxx=0;
   				}
   				color=StarColors[xx];
				ptr[xxx]=color;
   			}
   			ptr+=40*10;
   		}

		StarGlobalOffset--;
   	}

	memcpy((unsigned char*)0xa000,LabelPictureOops,8000);
	for (y=0;y<100;y++)
	{
		VSync();
	}
}

extern void Player_SetMusic_Birthday();

void main()
{
	int y;
	/*
	if (!is_overlay_enabled())
	{
		hires();
	}
	*/
	System_InstallIRQ_SimpleVbl();

    // Show the Xnitzy && Xnutzi animation
    StarField();

	// Hide all the colors of the picture
	PatchPicture();

	// Display the black picture
	memcpy((unsigned char*)0xa000,LabelPicture,8000);

    // Change the music to HappyBirthday
	Player_SetMusic_Birthday();

	// Make the picture appear with some gradient
	ShowPicture();

	for (y=0;y<200;y++)
	{
		Rasters();
		Pause();
	}
	memset((unsigned char*)0xa000,0,8000);	

	System_RemoveIRQ();
}

