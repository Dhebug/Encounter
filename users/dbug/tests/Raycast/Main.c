

#include	"lib.h"

// --------------------------------------
// Walls
// --------------------------------------
// (c) 2001 Mickael Pointier.
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



char DrawCompleteColumn();




extern unsigned char CosTable[];


unsigned char TabColor[]=
{
	// 0
	64+1+2+4+8+16+32,
	64+1+2+4+8+16+32,
	64+1+2+4+8+16+32,
	64+1+2+4+8+16+32,
	64+1+2+4+8+16+32,
	64+1+2+4+8+16+32,
	64+1+2+4+8+16,
	64+1+2+4+8+16,
	64+1+2+4+8+16,
	64+1+2+4+8+16,

	// 10
	64+1+2+4+8+16,
	64+1+2+4+8+16,
	64+1+2+4+8,
	64+1+2+4+8+16,
	64+1+2+4+8+16,
	64+1+2+4+8,
	64+1+2+4+8+16,
	64+1+2+4+8,
	64+1+2+4+8,
	64+1+2+4+8,

	// 20
	64+1+2+4+8,
	64+1+2+4+8,
	64+1+2+4,
	64+1+2+4+8,
	64+1+2+4,
	64+1+2+4,
	64+1+2+4,
	64+1+2+4,
	64+1+2+4,
	64+1+2+4,

	// 30
	64+1+2+4,
	64+1+2+4,
	64+1+2+4,
	64+1+2+4,
	64+1+2+4,
	64+1+2+4,
	64+1+2+4,
	64+1+2+4,
	64+1+2+4,
	64+1+2+4,

	// 40
	64+1+2,
	64+1+2+4,
	64+1+2+4,
	64+1+2,
	64+1+2+4,
	64+1+2,
	64+1+2,
	64+1+2,
	64+1+2,
	64+1+2,

	// 50
	64+1+2,
	64+1+2,
	64+1+2,
	64+1+2,
	64+1+2,
	64+1+2,
	64+1+2,
	64+1+2,
	64+1+2,
	64+1+2,

	// 60
	64+1+2,
	64+1+2,
	64+1,
	64+1+2,
	64+1+2,
	64+1,
	64+1+2,
	64+1,
	64+1,
	64+1,

	// 70
	64+1,
	64+1,
	64+1,
	64+1,
	64+1,
	64+1,
	64+1,
	64+1,
	64+1,
	64+1,

	// 80
	64+1,
	64+1,
	64+1,
	64+1,
	64,
	64+1,
	64+1,
	64,
	64,
	64+1,

	// 90
	64,
	64,
	64,
	64,
	64,
	64,
	64,
	64,
	64,
	64,
};



unsigned char LY1;
unsigned char RY1;

unsigned char LA1;
unsigned char LA2;

unsigned char ColorDraw;



extern unsigned char Labyrinthe[];
unsigned char FlagScanned[16*16];


unsigned char	TableVerticalPos[40];
unsigned char	PosAngle;

int	PosX;
int	PosY;
int	DirX;
int	DirY;


unsigned char	Speed;



unsigned char Angle;

unsigned char XPos;
unsigned char YPos;




void Raycast()
{
	unsigned char	i;
	unsigned char	angle;
	unsigned char	y_value;

	int				xx,yy;
	int				ix,iy;

	unsigned int	distance;

	unsigned int	d_step;

	//
	// Clean the buffer ;)
	//
	i=0;
	do
	{
		FlagScanned[i]=0;
		i++;
	}
	while (i);


	FlagScanned[(PosX>>8) + ((PosY>>8)<<4)]=1;

	//
	// Start angle
	//
	angle=PosAngle+20;
	for (i=0;i<40;i++)
	{	  
		//
		// Vertical scan
		// 
		xx=PosX;
		yy=PosY;

		//
		// Launch a ray scanning...
		//
		ix=((int)(CosTable[(angle)&255]>>1)   -64);
		iy=((int)(CosTable[(angle+64)&255]>>1)-64);
		distance=0;


		// http://www.permadi.com/tutorial/raycast/rayc8.html
		//
		// Before drawing the wall, there is one problem that must be taken care of. 
		// This problem is known as the "fishbowl effect." 
		// Fishbowl effect happens because ray-casting implementation mixes polar coordinate and Cartesian coordinate together. 
		// Therefore, using the above formula on wall slices that are not directly in front of the viewer will 
		// gives a longer distance. This is not what we want because it will cause a viewing distortion such as 
		// illustrated below.		
		// Thus to remove the viewing distortion, the resulting distance obtained from equations in Figure 17 
		// must be multiplied by cos(BETA); where BETA is the angle of the ray that is being cast relative to 
		// the viewing angle. On the figure above, the viewing angle (ALPHA) is 90 degrees because the player 
		// is facing straight upward. Because we have 60 degrees field of view, BETA is 30 degrees for the leftmost 
		// ray and it is -30 degrees for the rightmost ray.
		//d_step=CosTable[(256+(i<<1)-40)&255]>>5;
		//d_step=CosTable[(256+(i<<2)-80)&255]>>6;
		//if (i<5)	d_step=2<<8;			
		//else		d_step=3<<8;	//CosTable[(256+(i<<2)-80)&255]>>5;
		
		//d_step=((unsigned int)CosTable[(256+(i<<2)-80)&255])<<1;	// Fishball
		d_step=((unsigned int)CosTable[(256+i-20)&255])<<1;	// Fishball nearly gone
		
		//printf("%d ",d_step);

		//
		// Do the raycast
		//
		while (!Labyrinthe[(xx>>8) + ((yy>>8)<<4)])
		{
			//printf("%d %d-",xx>>8,yy>>8);
			
			FlagScanned[(xx>>8) + ((yy>>8)<<4)]=1;
			xx+=ix;
			yy+=iy;
			distance+=d_step;	// 4	//(128>>2);
		}
		
		//distance>>=4;
		//distance=(64*255)/distance;
		
		distance>>=4;
		
		distance=(64<<8)/distance;
		
		//printf("%d ",distance);


		//
		// Compute the distance
		//
		if (distance>100)
		{
			y_value=100;
		}
		else
		{
			y_value=distance;
		}
		
		// Fake perspective test
		y_value=100-y_value;
		

		//
		// Store value, and increment angle
		// 1F 1E 1E 1E 1D 3A 3A 3A 38 38 54 54 54 51 51 51 51 51 ...
		
		// Projected Slice Height = 64 / Distance to the Slice * 277
		
		//   0=Full size block (200 high)
		// 100=Nothing drawn (0 high, horizontal single pixel)
		TableVerticalPos[i]=y_value;
		angle--;
	}

}







//
//
//
/*
void RaycastOld()
{
	unsigned char	i;
	unsigned char	angle;
	unsigned char	y_value;

	int				xx,yy;
	int				ix,iy;

	int				distance;


	//
	// Start angle
	//
	angle=PosAngle-20;
	for (i=0;i<40;i++)
	{
		//
		// Launch a ray scanning...
		//
		xx=PosX;
		yy=PosY;
		ix=((int)CosTable[(angle)&255]-127);
		iy=((int)CosTable[(angle+64)&255]-127);
		ix=ix>>2;
		iy=iy>>2;



		//
		// Do the raycast
		//
		while (!Labyrinthe[(xx>>8) + ((yy>>8)<<4)])
		{
			xx+=ix;
			yy+=iy;

		}

		//
		// Compute the distance
		//
		xx-=PosX;
		yy-=PosY;

		if (xx<0)	xx=-xx;
		if (yy<0)	yy=-yy;

		distance=(xx+yy)/2;		// Kind of average :)

		distance>>=3;

		if (distance>100)
		{
			y_value=100;
		}
		else
		{
			y_value=distance;
		}


		//printf("a:%d y:%d d:%d\n",angle,y_value,distance);


		//
		// Store value, and increment
		//
		TableVerticalPos[i]=y_value;
		angle++;
	}

}
*/












void DisplayWall()
{
	int x,y;
	unsigned int py1;
	int iy1;

	unsigned char *ptr_dst;

	unsigned char *ptr_dst_up;

	unsigned char counter;

	unsigned char yy;

	ptr_dst=(unsigned char*)0xa000+(36*40);

	py1=(LY1<<8);

	//iy1=1<<8;


	iy1=((RY1<<8)-(LY1<<8))/40;



	for (x=2;x<40;x++)
	//for (x=2;x<24;x++)
	{
		yy=(py1>>8);

			yy=TableVerticalPos[x];


		XPos=x;
		YPos=yy;


		//ColorDraw=TabColor[100-yy];
		ColorDraw=TabColor[yy];

		//YPos=CosTable[((x<<1)+Angle)&255]>>2;

		DrawCompleteColumn();

		/*
		ptr_dst_up	=ptr_dst+x+yy*40;

		counter=(64-yy)*2;
		while (counter--)
		{		
			*ptr_dst_up		=ColorDraw;
			ptr_dst_up+=40;
		}
		*/

		py1+=iy1;
	}

	Angle+=3;
}


/*

i*6=

i*2 + i*4


*/



//
// Display TWO maps.
// The first one is simply the map with walls
// The second one show the recasting informations
//
void DrawMap()
{
	unsigned char x,y;
	unsigned char *ptr_dst;
	unsigned char *ptr_src;
	unsigned char *ptr_scan;
	unsigned char color;

	ptr_src=Labyrinthe;
	ptr_scan=FlagScanned;
	ptr_dst=(unsigned char*)0xa000+24;
	for (y=0;y<16;y++)
	{
		for (x=0;x<16;x++)
		{
			color=64;

			if (*ptr_src)
			{
				color=64+1+2+4+8+16+32;
			}
			else
			{
				color=64;
			}
			if (*ptr_scan)
			{
				color|=128;
				//printf("%d/%d ",x,y);
			}

			ptr_dst[x]=color;
			ptr_dst[x+40]=color;
			ptr_dst[x+80]=color;
			ptr_dst[x+120]=color;
			ptr_src++;
			ptr_scan++;
		}
		ptr_dst+=40*4;
	}

	curset(144+((PosX*6)>>8),(PosY>>6),2);
}





void main()
{
	int counter;
	int	y;
	int	i;

	unsigned char truc;


	// Inits
	Speed=2;
	PosAngle=0;
	PosX=(8<<8)+128;
	PosY=(7<<8)+128;
		DirX=((int)(CosTable[(PosAngle)&255])   -127);
		DirY=((int)(CosTable[(PosAngle+64)&255])-127);

	/*
	Raycast();
	while(1);
	*/


	/*
	printf("%d \n",CosTable[0]);
	printf("%d \n",CosTable[64]);
	printf("%d \n",CosTable[128]);
	printf("%d \n",CosTable[192]);

	printf("\n");

	printf("%d \n",(int)CosTable[0]-127);
	printf("%d \n",(int)CosTable[64]-127);
	printf("%d \n",(int)CosTable[128]-127);
	printf("%d \n",(int)CosTable[192]-127);

	while(1);
	*/

	//paper(0);
	//ink(0);
	hires();

	ink(3);


	truc=1;




	while (1)
	{
		//printf("(%d.%d,%d.%d) %d (%d,%d) \n",PosX>>8,PosX&255,PosY>>8,PosY&255,PosAngle,DirX,DirY);
		
		//
		// Fill the vertical pos table
		//
		for (i=0;i<40;i++)
		{
			TableVerticalPos[i]=i*2;
		}


		//
		// Fill the table
		//
		Raycast();


		//
		// Display the table
		//
		ColorDraw=64+truc;
		DisplayWall();

		DrawMap();

		/*
		// Get a value between 0 and 64
		// 100-64 => 36
		LY1=CosTable[LA1]>>2;
		RY1=CosTable[LA2]>>2;

		LA1+=1;
		LA2+=2;

		//ColorDraw=64+1+2+4+8+16+32;
		ColorDraw=64+truc;
		DisplayWall();

		truc=truc<<1;
		if (truc==64)
		{
			truc=1;
		}
		*/


		//
		// Handle player movement.
		// Update angle and coordinates
		//
		switch (get())	// key
		{
		case 8:	// gauche => tourne gauche
			PosAngle+=16;
			DirX=((int)(CosTable[(PosAngle)&255])   -127);
			DirY=((int)(CosTable[(PosAngle+64)&255])-127);

			//DirX=DirX>>1;
			//DirY=DirY>>1;
			break;

		case 9:	// droite => tourne droite
			PosAngle-=16;
			DirX=((int)(CosTable[(PosAngle)&255])   -127);
			DirY=((int)(CosTable[(PosAngle+64)&255])-127);

			//DirX=DirX>>1;
			//DirY=DirY>>1;
			break;

		case 10: // bas => recule
			PosX-=DirX;
			PosY-=DirY;
			break;

		case 11: // haut => avance
			PosX+=DirX;
			PosY+=DirY;
			break;
		}

		/*
		ColorDraw=64;
		DisplayWall();
		*/
	}
}








