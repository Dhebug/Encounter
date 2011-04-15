// main.c by Barnsey123
// 22-03-2011 prog to draw a grid (for viking game)
// 23-03-2011 create new drawgrid function
// 01-04-2011 create new drawtile functions and use compact code (char instead of int etc)
// 02-04-2011 routine to read keyboard
// 06-04-2011 cursor drawing correct
// 11-04-2011 request help from DBUG - bug in OSDK
// 14-04-2011 DBUG fixed OSDK bug!
// 15-04-2011 tidied code up
// 15-04-2011 tiles as a global variable as will be used everywhere...

#include <lib.h>
/******************* Function Declarations ************************/
void drawbox(unsigned char,unsigned char,unsigned char);		// draws a box at x,y length z
void drawcursor(unsigned char,unsigned char,unsigned char,unsigned char);	// draws cursor at x,y, length z, foreground or background
void drawdefendtile(unsigned char,unsigned char);		// draws defenders background tile at x,y
void drawattacktile(unsigned char,unsigned char);		// draws attackers background tile at x,y
void drawkingtile(unsigned char,unsigned char);			// draws kings backround tile at x,y
void drawtiles(unsigned char,unsigned char,unsigned char);		// draws all tiles at board x,y boxsize z (uses draw*tile functions)
void drawgrid(unsigned char,unsigned char,unsigned char);		// draws grid at board x,y boxsize z
void drawboard(unsigned char,unsigned char,unsigned char);		// kicks off drawgrid/drawtiles
void playerturn(unsigned char,unsigned char,unsigned char);		// takes user input to move cursor
/****************** GLOBAL VARIABLES *******************************/
/* Populate array with tile types
Tile types:
0=blank
1=king square
2=attacker square
3=defender square
*/
const unsigned char tiles[11][11]={
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
/****************** MAIN PROGRAM ***********************************/
main()
{
	const unsigned char boardx=12;		// starting x co-ord of board
	const unsigned char boardy=0;		// starting y co-ord of board
	const unsigned char boxsize=17;		// set boxsize
	drawboard(boardx,boardy,boxsize);	// draw the board	
	playerturn(boardx,boardy,boxsize);	// player input	
}
/********************* FUNCTION DEFINITIONS ************************/
// DRAWBOX
void drawbox(unsigned char x, unsigned char y, unsigned char z)
{
	/*	- draw a box at x,y size z
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
// DRAWCURSOR
void drawcursor(unsigned char x, unsigned char y, unsigned char z, unsigned char f)
{
	/*	- draw the cursor at x,y size z, foreground/background color (1 or 0)
	x=xcoord for curset
	y=ycoord for curset
	z=size of line to draw
	f=foreground/background 1=visible, 0=blank (to overwrite old cursor position)
	*/
	pattern(170);
	curset(x,y,f);
	draw(z,0,f);
	draw(0,z,f);
	draw(-z,0,f);
	draw(0,-z,f);
	pattern(255);
}
// DRAW DEFENDERS TILE
void drawdefendtile(unsigned char x, unsigned char y)
{
	/* draws the defenders tile (a series of 2 concentric squares )
	x=xcoord for drawbox
	y=xcoord for drawbox
	*/
	unsigned char a=x;			// copy of x
	unsigned char b=y;			// copy of y
	unsigned char loop=0;		// loop counter
	unsigned char z=13;			// line length
	for (loop=0;loop<2;loop++)
		{
		drawbox(a,b,z);			// drawbox at x,y position
		z=z-4;					// decrease size of line
		a+=2;					// increase x position
		b+=2;					// increase y position
		}
}
// DRAW ATTACKERS TILE
void drawattacktile(unsigned char x, unsigned char y)
{
	/* draws the attackers tile ( a series of 3 concentric squares )
	x=xcoord for drawbox
	y=xcoord for drawbox
	*/
	unsigned char a=x;			// copy of x
	unsigned char b=y;			// copy of y
	unsigned char loop=0;		// loop counter
	unsigned char z=13;			// line length
	for (loop=0;loop<3;loop++)
		{
		drawbox(a,b,z);			// drawbox at x,y position
		z=z-4;					// decrease size of line
		a+=2;					// increase x position
		b+=2;					// increase y position	
		}
}
// DRAW KINGS TILE
void drawkingtile(unsigned char x, unsigned char y)
{
	/* draws the king tile ( a series of 5 sqares - one in each corner of the tile and one
	square straddling all 4 ) nice, simple pattern.  
	x=xcoord for drawbox
	y=xcoord for drawbox
	*/
	drawbox(x,y,5);			// box 1
	drawbox(x+8,y,5);		// box 2
	drawbox(x,y+8,5);		// box 3
	drawbox(x+8,y+8,5);		// box 4
	drawbox(x+2,y+2,9);		// box 5 (central, larger box)
}
// DRAW ALL THE TILES ON THE BOARD
void drawtiles(unsigned char x, unsigned char y, unsigned char z)
{
	/* routine to draw the "background tiles" 
	Arguments:
	x=starting x coord
	y=starting y coord
	z=boxsize
	*/
	unsigned char tilex=x;			// starting tile x position
	unsigned char tiley=y;			// starting tile y position
	unsigned char row=0;			// loop through tiles array by row
	unsigned char col=0;			// loop through tiles array by column
	
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
// DRAWGRID
void drawgrid(unsigned char x, unsigned char y, unsigned char z)
{
	/* drawgrid - draws main 11x11 grid
	x=starting x position
	y=starting y position
	z=boxsize
	*/
	unsigned char a=x;			// copy of boardx (board offset x position)
	unsigned char b=y;			// copy of boardy (board offset y position)
	unsigned char c=0;			// loop counter
	unsigned char length=z;		// copy of boxsize
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
void drawboard(unsigned char x, unsigned char y, unsigned char z)
{
	/* drawboard
	x=starting x coord
	y=starting y coord
	z=boxsize
	*/
	hires();
	ink(6);				// color of board
	drawgrid(x,y,z);	// draw the 11x11 gridlines
	drawtiles(x,y,z);	// draw the background tiles
}
// Playerturn - 
void playerturn(unsigned char x, unsigned char y, unsigned char z)	// filter keyboard input
{
	/*
	x=x pos of board (top left)
	y=y pos of board (top left)
	z=boxsize
	*/
	unsigned char key=0;			// code of key pressed
	unsigned char ns=5;				// default north/south position of central square
	unsigned char ew=5;				// default east/west position of central square
	unsigned char cx=1+x+(z*ns);	// cursor x position
	unsigned char cy=1+y+(z*ew);	// cursor y position
	unsigned char cz=z-2;			// size of cursor
	drawcursor(cx,cy,cz,1);			// print dotted cursor at central square
	while (key != 81)				// repeat until 'Q' pressed
		{
		key=getchar();					// get code of pressed key
		if ((key == 8 )&&(ew>0))		// move cursor left
			{
			drawcursor(cx,cy,cz,0);		// print blank cursor (effect=remove dots)
			cx-=z;
			drawcursor(cx,cy,cz,1);		// print dotted cursor
			ew--;	
			}
		if ((key == 9)&&(ew<10))		// move cursor right 	
			{
			drawcursor(cx,cy,cz,0);		// print blank cursor (effect=remove dots)
			cx+=z;
			drawcursor(cx,cy,cz,1);		// print dotted cursor 
			ew++;
			}
		if ((key == 10)&&(ns<10))		// move cursor down
			{
			drawcursor(cx,cy,cz,0);		// print blank cursor (effect=remove dots)
			cy+=z;
			drawcursor(cx,cy,cz,1);		// print dotted cursor
			ns++; 
			}
		if ((key == 11)&&(ns>0))		// move cursor up	
			{
			drawcursor(cx,cy,cz,0);		// print blank cursor (effect=remove dots)
			cy-=z;
			drawcursor(cx,cy,cz,1);		// print dotted cursor
			ns--;
			}
		}
}