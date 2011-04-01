// main.c by Barnsey123
// 22-03-2011 prog to draw a grid (for viking game)
// 23-03-2011 create new drawgrid function
// 01-04-2011 create new drawtile functions and use compact code (char instead of int etc)
#include <lib.h>
void drawbox(unsigned char x, unsigned char y, unsigned char xbox)
{
curset(x,y,1);
draw(xbox,0,1);
draw(0,xbox,1);
draw(-xbox,0,1);
draw(0,-xbox,1);
}
void drawgrid(unsigned char x,unsigned char y, unsigned char boxsize, unsigned char boxcountx, unsigned char boxcounty)
{
	// draws the main grid
	/* 		***** ARGUMENTS *****
	x			=	starting x position
	y			=	starting y position
	boxsize		=	size of box
	boxcount	=	number of boxes
	*/
	unsigned char a=x;	// copy of x
	unsigned char b=y;	// copy of y
	unsigned char c=0;	// counter
	unsigned char lengthx=boxsize*boxcountx;	// linelength across
	unsigned char lengthy=boxsize*boxcounty;	// linelength down
	for (c=0;c<=boxcountx;c++) // draw vertical lines
		{
		curset(a,b,1);
		draw(0,lengthy,1);
		a+=boxsize;	// add boxsize to a
		}
	a=x;	// reset a
	for (c=0;c<=boxcounty;c++) // draw horizontal lines
		{
		curset(a,b,1);
		draw(lengthx,0,1);
		b+=boxsize;
		}
} 
void drawattacktile(unsigned char x, unsigned char y)
{
	// draws the attackers tile
	// ARGUMENTS starting x, y position for curset
	unsigned char loop=0;
	unsigned char z=13;	// line length
	for (loop=0;loop<3;loop++)
		{
		drawbox(x,y,z);
		z=z-4;
		x+=2;
		y+=2;	
		}
}
void drawdefendtile(unsigned char x, unsigned char y)
{
	// draws the attackers tile
	// ARGUMENTS starting x, y position for curset
	unsigned short int loop=0;
	unsigned short int z=13;	// line length
	for (loop=0;loop<3;loop++)
		{
		drawbox(x,y,z);
		z=z-4;
		x+=2;
		y+=2;	
		}
}
void drawkingtile(unsigned char x, unsigned char y)
{
	// draws the king tile
	// ARGUMENTS starting x, y position for curset
	drawbox(x,y,5);
	drawbox(x+8,y,5);
	drawbox(x,y+8,5);
	drawbox(x+8,y+8,5);
	drawbox(x+2,y+2,9);	
}

void drawtiles(unsigned char x, unsigned char y, unsigned char box)
{
	// draws the tiles on the board
	/* ARGUMENTS starting x,y position of grid */
	unsigned char tilex=x+2;			// starting tile x position
	unsigned char tiley=y+2;			// strating tile y position
	unsigned char row=0;			// loop through tiles array by row
	unsigned char col=0;			// loop through tiles array by column
	// populate tiles with tile type
	// 0=blank
	// 1=king square
	// 2=attacker square
	// 3=defender square
	unsigned char tiles[11][11]={
		{1,0,0,2,2,2,2,2,0,0,1},
		{0,0,0,0,0,2,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0},
		{2,0,0,0,0,3,0,0,0,0,2},
		{2,0,0,0,3,3,3,0,0,0,2},
		{2,2,0,3,3,1,3,3,0,2,2},
		{2,0,0,0,3,3,3,0,0,0,2},
		{2,0,0,0,0,3,0,0,0,0,2},
		{0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,2,0,0,0,0,0},
		{1,0,0,2,2,2,2,2,0,0,1}};
	for (row=0;row<11;row++)
		{
		for (col=0;col<11;col++)
			{
			if ( tiles[row][col] == 1 ) drawkingtile(tilex,tiley);
			if ( tiles[row][col] == 2 ) drawattacktile(tilex,tiley);
			if ( tiles[row][col] == 3 ) drawdefendtile(tilex,tiley);
			tilex+=box;			
			}
		tilex=x+2;
		tiley+=box;
		}
}
void drawboard(unsigned char gridx, unsigned char gridy)
{
	// draws the main board
	/* ARGUMENTS starting x,y co-ordinates of grid*/
	unsigned int boxsize=17;	// box size
	unsigned int boxcountx=11;	// number of boxes across
	unsigned int boxcounty=11; // number of boxes down	
	hires();
	ink(6);			// color of board
	// draw grid
	drawgrid(gridx,gridy,boxsize,boxcountx,boxcounty);
	// draw tiles
	drawtiles(gridx,gridy,boxsize);
}

main()
{
	unsigned char boardx=12;		// starting x co-ord of board
	unsigned char boardy=0;		// starting y co-ord of board
	drawboard(boardx,boardy);
	return;
}
