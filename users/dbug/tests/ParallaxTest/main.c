//
// Super Mario Bros Parallax Test
//
#include <lib.h>



extern unsigned char Trees[];
extern unsigned char Blocks[];


unsigned char Frame=0;


void InverseBlock(unsigned char x,unsigned char y,unsigned char width,unsigned char height)
{
	unsigned char* screen;
	screen=(unsigned char*)0xbb80;
	screen+=x;
	screen+=y*40;
	while (height--)
	{
		for (x=0;x<width;x++)
		{
			screen[x]^=128;
		}
		screen+=40;
	}
}


void InitializeScreen()
{
	text();
	cls();
	
	// Erase the screen
	memset((unsigned char*)0xbb80,32,40*28);

	// Put some color
	paper(4);
	ink(2);
	
	// Draw the trees
	memcpy((unsigned char*)0xbb80+11*40+2,"ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABC",38);
	memcpy((unsigned char*)0xbb80+12*40+2,"DEFDEFDEFDEFDEFDEFDEFDEFDEFDEFDEFDEFDEFDEFDEFDEF",38);
	memcpy((unsigned char*)0xbb80+13*40+2,"GHIGHIGHIGHIGHIGHIGHIGHIGHIGHIGHIGHIGHIGHIGHIGHI",38);
	memcpy((unsigned char*)0xbb80+14*40+2,"JKLJKLJKLJKLJKLJKLJKLJKLJKLJKLJKLJKLJKLJKLJKLJKL",38);
	
	
	// Draw blocks
	memcpy((unsigned char*)0xbb80+11*40+4,"abcde",5);
	memcpy((unsigned char*)0xbb80+12*40+4,"fghij",5);
	memcpy((unsigned char*)0xbb80+13*40+4,"klmno",5);
	memcpy((unsigned char*)0xbb80+14*40+4,"pqrst",5);
	InverseBlock(4,11,5,4);

	
	memcpy((unsigned char*)0xbb80+ 7*40+24,"abcde",5);
	memcpy((unsigned char*)0xbb80+ 8*40+24,"fghij",5);
	memcpy((unsigned char*)0xbb80+ 9*40+24,"klmno",5);
	memcpy((unsigned char*)0xbb80+10*40+24,"pqrst",5);
	InverseBlock(24,7,5,4);
	
	memcpy((unsigned char*)0xbb80+11*40+24,"abcde",5);
	memcpy((unsigned char*)0xbb80+12*40+24,"fghij",5);
	memcpy((unsigned char*)0xbb80+13*40+24,"klmno",5);
	memcpy((unsigned char*)0xbb80+14*40+24,"pqrst",5);
	InverseBlock(24,11,5,4);
	
	memset((unsigned char*)0xbb80+40*15,16,40);
}



void Animate()
{
	{
		// Redef the trees
		int y;
		unsigned char* trees;
		unsigned char* redef=(unsigned char*)0xb400;
		
		trees=Trees;	
		trees+=12*8*(Frame%6);
		
		for (y=0;y<8;y++)
		{
			redef[8*'A'+y]=trees[8*3*0+0+y*3];
			redef[8*'B'+y]=trees[8*3*0+1+y*3];
			redef[8*'C'+y]=trees[8*3*0+2+y*3];
			
			redef[8*'D'+y]=trees[8*3*1+0+y*3];
			redef[8*'E'+y]=trees[8*3*1+1+y*3];
			redef[8*'F'+y]=trees[8*3*1+2+y*3];
			
			redef[8*'G'+y]=trees[8*3*2+0+y*3];
			redef[8*'H'+y]=trees[8*3*2+1+y*3];
			redef[8*'I'+y]=trees[8*3*2+2+y*3];
	
			redef[8*'J'+y]=trees[8*3*3+0+y*3];
			redef[8*'K'+y]=trees[8*3*3+1+y*3];
			redef[8*'L'+y]=trees[8*3*3+2+y*3];				
		}
	}		


	{
		// Redef the boxes
		int y;
		unsigned char* box;
		unsigned char* redef=(unsigned char*)0xb400;
		
		box=Blocks;	
		
		for (y=0;y<8;y++)
		{
			redef[8*'a'+y]=box[8*5*0+0+y*5];
			redef[8*'b'+y]=box[8*5*0+1+y*5];
			redef[8*'c'+y]=box[8*5*0+2+y*5];
			redef[8*'d'+y]=box[8*5*0+3+y*5];
			redef[8*'e'+y]=box[8*5*0+4+y*5];
			
			redef[8*'f'+y]=box[8*5*1+0+y*5];
			redef[8*'g'+y]=box[8*5*1+1+y*5];
			redef[8*'h'+y]=box[8*5*1+2+y*5];
			redef[8*'i'+y]=box[8*5*1+3+y*5];
			redef[8*'j'+y]=box[8*5*1+4+y*5];
			
			redef[8*'k'+y]=box[8*5*2+0+y*5];
			redef[8*'l'+y]=box[8*5*2+1+y*5];
			redef[8*'m'+y]=box[8*5*2+2+y*5];
			redef[8*'n'+y]=box[8*5*2+3+y*5];
			redef[8*'o'+y]=box[8*5*2+4+y*5];
	
			redef[8*'p'+y]=box[8*5*3+0+y*5];
			redef[8*'q'+y]=box[8*5*3+1+y*5];
			redef[8*'r'+y]=box[8*5*3+2+y*5];				
			redef[8*'s'+y]=box[8*5*3+3+y*5];				
			redef[8*'t'+y]=box[8*5*3+4+y*5];				
		}
	}		
		
}



void ScrollLeft()
{
	int y;
	unsigned char* screen;
	
	screen=(unsigned char*)0xbb80;
	
	for (y=0;y<15;y++)
	{
		unsigned char temp;
		
		temp=screen[2];
		memcpy(screen+2,screen+3,37);
		screen[39]=temp;
		
		screen+=40;
		
	}
	Frame++;
}
		

void ScrollRight()
{
	char temp[40];
	int y;
	unsigned char* screen;
	
	screen=(unsigned char*)0xbb80;
	
	for (y=0;y<15;y++)
	{
		memcpy(temp,screen,40);
		memcpy(screen+3,temp+2,37);
		screen[2]=temp[39];
		
		screen+=40;
		
	}
	Frame--;
}



void main()
{		
	unsigned char car,car2;
	
	poke(0x26a,NOKEYCLICK|SCREEN);
	
	
	car=8;
	InitializeScreen();
	while (1)
	{
		Animate();
		
		car2=key();
		if (car2)
		{
			car=car2;
		}
		
		if (car==8)
		{
			ScrollLeft();
		}
		else
		if (car==9)
		{
			ScrollRight();
		}
	}
}




#if 0

Clouds
Mountains 
Forest is 3x4 characters
Ground

Blocks are 5x4 characters



#endif