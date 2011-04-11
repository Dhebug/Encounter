// main.c by Barnsey123
// 22-03-2011 prog to draw a grid (for viking game)
// 23-03-2011 create new drawgrid function
// 01-04-2011 create new drawtile functions and use compact code (char instead of int etc)
// 02-04-2011 routine to read keyboard
// 06-04-2011 cursor drawing correct

#include <lib.h>
// DRAWBOX - draw a box at x,y length xbox
void drawbox(int x, int y, int z)
{
	/*
	x=xcoord for curset
	y=ycoord for curset
	z=size of line to draw
	*/
	curset(x,y,1);
	draw(z,0,1);
	draw(0,z,1);
	draw(-z,0,1);
	draw(0,-z,1);
}
// DRAW CURSOR
void drawcursor(int x, int y, int z)
{
	pattern(170);
	curset(x,y,1);
	draw(z,0,1);
	draw(0,z,1);
	draw(-z,0,1);
	draw(0,-z,1);
	pattern(255);
}
// blank cursor
void drawblankcursor(int x, int y, int z)
{
	pattern(170);
	curset(x,y,0);
	draw(z,0,0);
	draw(0,z,0);
	draw(-z,0,0);
	draw(0,-z,0);
	pattern(255);	
}
// DRAW DEFENDERS TILE
void drawdefendtile(int x, int y)
{
	// draws the defenders tile (a series of 2 concentric squares )
	// ARGUMENTS starting x, y position for curset
	int a=x;					// copy of x
	int b=y;					// copy of y
	unsigned char loop=0;		// loop counter
	int z=13;			// line length
	for (loop=0;loop<2;loop++)
		{
		drawbox(a,b,z);			// drawbox at x,y position
		z=z-4;					// decrease size of line
		a+=2;					// increase x position
		b+=2;					// increase y position
		}
}
// DRAW ATTACKERS TILE
void drawattacktile(int x, int y)
{
	// draws the attackers tile ( a series of 3 concentric squares )
	// ARGUMENTS starting x, y position for curset
	int a=x;					// copy of x
	int b=y;					// copy of y
	unsigned char loop=0;		// loop counter
	int z=13;			// line length
	for (loop=0;loop<3;loop++)
		{
		drawbox(a,b,z);			// drawbox at x,y position
		z=z-4;					// decrease size of line
		a+=2;					// increase x position
		b+=2;					// increase y position	
		}
}
// DRAW KINGS TILE
void drawkingtile(int x, int y)
{
	/* draws the king tile ( a series of 5 sqares - one in each corner of the tile and one
	square straddling all 4 ) nice, simple pattern.  
	ARGUMENTS starting x, y position for curset
	*/
	drawbox(x,y,5);			// box 1
	drawbox(x+8,y,5);		// box 2
	drawbox(x,y+8,5);		// box 3
	drawbox(x+8,y+8,5);		// box 4
	drawbox(x+2,y+2,9);		// box 5 (central, larger box)
}
// DRAW ALL THE TILES ON THE BOARD
void drawtiles(const int x, const int y, const int z)
{
	/* routine to draw the "background tiles" 
	Tile types:
	0=blank
	1=king square
	2=attacker square
	3=defender square
	*/
	int tilex=x;			// starting tile x position
	int tiley=y;			// starting tile y position
	unsigned char row=0;			// loop through tiles array by row
	unsigned char col=0;			// loop through tiles array by column
	// Populate array with tile types
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
	tilex+=2;							// starting tile x position (offset by 2 to avoid grid lines)
	tiley+=2;							// starting tile y position (offset by 2 to avoid grid lines)
	for (row=0;row<11;row++)
		{
		for (col=0;col<11;col++)
			{
			if ( tiles[row][col] == 1 ) drawkingtile(tilex,tiley);		// draw king tile
			if ( tiles[row][col] == 2 ) drawattacktile(tilex,tiley);	// draw attackers tile
			if ( tiles[row][col] == 3 ) drawdefendtile(tilex,tiley);	// draw defenders tile
			tilex+=z;	// the x position is advanced to the next square "across" - including blank squares		
			}
		tilex=x;		// reset x
		tilex+=2;		// tilex offset to avoid gridlines
		tiley+=z;		// advance tiley position to next "row"
		}
}
// DRAW THE MAIN 11x11 GRID
void drawgrid(const int x, const int y, const int z)
{
	int a=x;			// copy of boardx (board offset x position)
	int b=y;			// copy of boardy (board offset y position)
	unsigned char c=0;			// loop counter
	int length=z;		// copy of boxsize
	length*=11;					// multiply length by 11 (determines length of line to draw)
	for (c=0;c<=11;c++) // draw vertical lines
		{
		curset(a,b,1);
		draw(0,length,1);
		a+=z;	// add boxsize to a
		}
	a=x;	// reset a
	for (c=0;c<=11;c++) // draw horizontal lines
		{
		curset(a,b,1);
		draw(length,0,1);
		b+=z; // add boxsize to b
		}
} 
// DRAW THE BOARD
void drawboard(const int x, const int y, const int z)
{
	hires();
	ink(6);				// color of board
	drawgrid(x,y,z);	// draw the 11x11 gridlines
	drawtiles(x,y,z);	// draw the background tiles
}
// READKEYB
void readkeyb()	// filter keyboard input
{
	int key=0;
	int cx=98;
	int cy=86;
	unsigned char ns=5, ew=5;	// north-south=5, east-west=5
	//coordx=5*17;
	//coordy=coordx;
	//coordx=coordx+xboardx;
	//coordy=coordy+xboardy;	
	//printf("\n coordx=%d:",coordx);
	//printf("\n coordy=%d:",coordy);
	drawcursor(cx,cy,15);			// print dotted cursor at central square
	while (key != 81)		// repeat until 'Q' pressed
		{
		key=getchar();				// get code of pressed key
		if ((key == 8 )&&(ew>0))	// cursor left
			{
			drawblankcursor(cx,cy,15);				// print blank cursor (effect=remove dots)
			cx=cx-17;
			drawcursor(cx,cy,15);			// print dotted cursor
			ew--;	
			}
		if ((key == 9)&&(ew<10))	// cursor right 	
			{
			drawblankcursor(cx,cy,15);				// print blank cursor (effect=remove dots)
			cx=cx+17;
			drawcursor(cx,cy,15);			// print dotted cursor 
			ew++;
			}
		if ((key == 10)&&(ns<10))	// cursor down
			{
			drawblankcursor(cx,cy,15);				// print blank cursor (effect=remove dots)
			cy=cy+17;
			drawcursor(cx,cy,15);			// print dotted cursor
			ns++; 
			}
		if ((key == 11)&&(ns>0))	// cursor up	
			{
			drawblankcursor(cx,cy,15);				// print blank cursor (effect=remove dots)
			cy=cy-17;
			drawcursor(cx,cy,15);			// print dotted cursor
			ns--;
			}
		// printf("\nKEY=%d",key);		// debugging - prints code of key pressed
		}
	printf ("\n*** Q pressed ***");		// print message when Q is pressed
}
main()
{
	const int boardx=12;		// starting x co-ord of board
	const int boardy=0;			// starting y co-ord of board
	const int boxsize=17;		// set boxsize
	drawboard(boardx,boardy,boxsize);	// draw the board		
	readkeyb();							// player input
	
}
