

#include	"lib.h"


//#define FINAL_VERSION


//#define USE_KEYBOARD



extern	void	InitTables();

void DrawCube();



#include "sin.c"
#include "cos.c"


extern void RotatePoints();




void RecomputeSin()
{
	int i;

	for (i=0;i<256;i++)
	{
		((char*)TabSin8)[i]/=4;
		((char*)TabCos8)[i]/=4;
	}
}



unsigned char	Ca,Cb,Cg;



void TableDraw();
void TableFill();
void TableInitColors();

#define FULLINK		(64+1+2+4+8+16+32)


void CharMapDraw();

extern unsigned char LabelPicture[];



// 9800 => std chars
// 9c00 => alt chars
/*
void ReconfChars(unsigned char *ptr_src)
{
	int y,x,t;
	
	unsigned char *ptr_dst;
	unsigned char *ptr_src_2;

	ptr_dst=(unsigned char*)0x9800+32*8;
	for (y=0;y<3;y++)
	{
		if (y==2)
		{
			ptr_dst=(unsigned char*)0x9c00+32*8;
		}
		for (x=1;x<40;x++)
		{
			ptr_src_2=ptr_src;
			for (t=0;t<8;t++)
			{
				*ptr_dst++=ptr_src_2[x];
				ptr_src_2+=40;
			}
		}
		ptr_src+=40*8;
	}
}
*/


void DrawInlay()
{
	CharMapDraw();

	/*
	unsigned char i,j;
	unsigned char *ptr_screen;
	unsigned char *ptr_logo;

	ptr_screen=(unsigned char*)0xbb80+40*25;
	j=32;
	*ptr_screen++=8|128;	// text std en inversion video
	for (i=0;i<39;i++)	
	{
		*ptr_screen++=j;
		j++;
	}
	*ptr_screen++=8|128;
	for (i=0;i<39;i++)	
	{
		*ptr_screen++=j;
		j++;
	}

	j=32;
	*ptr_screen++=9|128;	// alt text, inverted
	for (i=0;i<39;i++)	
	{
		*ptr_screen++=j;
		j++;
	}
	*/

	//ReconfChars(LabelPicture);
	//memcpy((unsigned char*)0xa000,LabelPicture,40*24);

	//while (get()!=' ');
}



void SetGraphicColors()
{
	unsigned char x,y;
	unsigned char *ptr_screen;
	/*	
	memset((unsigned char*)0xa000,FULLINK,8000);
	curset(0,0,0);
	fill(200,1,0);					// BLACK INK
	*/

	/*
	curset(0,0,0);
	fill(200,40,FULLINK);
	curset(0,0,0);
	fill(200,1,0);					// BLACK INK
	*/

	ptr_screen=(unsigned char*)0xa000;
	for (y=0;y<200;y++)
	{
		*ptr_screen=0;		// Black ink
		ptr_screen++;
		for (x=0;x<39;x++)
		{
			*ptr_screen=FULLINK;
			ptr_screen++;
		}
	}
}
 


int counter;

void main()
{
	char c;

#ifndef FINAL_VERSION
	hires();
#endif
	
	

	CharMapDraw();

	SetGraphicColors();


	//DrawInlay();

	RecomputeSin();

	//ComputeDivMod();
	InitTables();

	TableInitColors();

	TableFill();

	//counter=1100;
	counter=100;
	while (counter--)
	{
		RotatePoints();
		DrawCube();
		
		TableDraw();
		
#ifdef USE_KEYBOARD
		c=get();
		if (c=='Q')	Ca--;
		else
		if (c=='W')	Ca++;
		else
		if (c=='A')	Cb--;
		else
		if (c=='S')	Cb++;
#else
		Ca+=3;
		Cb+=5;
#endif
	}
}



