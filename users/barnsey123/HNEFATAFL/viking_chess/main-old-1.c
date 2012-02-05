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
// 16-04-2011 Changed numeric settings for board (0=blank, 1=attackers tile, 2=defenders tile, 3=kings tile)
// 16-04-2011 drawing players
// 17-04-2011 improving tile drawing (saving few bytes in each routine and having different styles)
// 19-04-2011 added flashscreen (to flash screen with desired color - e.g. GREEN for OK, RED for !OK)
// 19-04-2011 context sensitive piece selection
// 19-04-2011 canpiecemove function (can a selected piece MOVE or not?)
#include <lib.h>
/******************* Function Declarations ************************/
void drawbox(unsigned char,unsigned char,unsigned char, char);		// draws a box at x,y length z, fb/bg
void drawdiamond(unsigned char, unsigned char, char, char);		// draws diamond at x,y size z, fb/bg
void drawcursor(unsigned char,unsigned char,unsigned char,unsigned char);	// draws cursor at x,y, length z, foreground or background
void drawtile1(unsigned char,unsigned char);	// 2 concentric squares	
void drawtile2(unsigned char,unsigned char);	// 4 diamonds (one in each corner)	
void drawtile3(unsigned char,unsigned char);	// 3 concentric squares
void drawtile4(unsigned char,unsigned char);	// 5 squares (one in each corner, 1 central and inversed		
void drawtile5(unsigned char,unsigned char);	// funky x-type shape
void drawtile6(unsigned char,unsigned char);	// left arrow
void drawtile7(unsigned char,unsigned char);	// right arrow
void drawtile8(unsigned char,unsigned char);	// up arrow
void drawtile9(unsigned char,unsigned char);	// down arrow
		
void drawpiece(unsigned char,unsigned char, char);			// draws piece at x,y, type z
void drawtiles(unsigned char,unsigned char,unsigned char);		// draws all tiles at board x,y boxsize z (uses draw*tile functions)
void drawgrid(unsigned char,unsigned char,unsigned char);		// draws grid at board x,y boxsize z
void drawboard(unsigned char,unsigned char,unsigned char);		// kicks off drawgrid/drawtiles
void playerturn(unsigned char,unsigned char,unsigned char, char);	// takes user input to move cursor
void drawplayers(unsigned char, unsigned char, unsigned char);	// draw players
void flashscreen(char);								// flashes screen seelcted color for a second or so
char canpiecemove(char, char);				// can a selected piece move? 0=no, 1=yes
/****************** GLOBAL VARIABLES *******************************/
/* Populate array with tile types
Tile types:
0=blank
1=attacker square
2=defender square
3=king square
*/
const unsigned char tiles[11][11]={
		{3,0,0,1,1,1,1,1,0,0,3},
		{0,0,0,0,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0},
		{1,0,0,0,0,2,0,0,0,0,1},
		{1,0,0,0,2,2,2,0,0,0,1},
		{1,1,0,2,2,3,2,2,0,1,1},
		{1,0,0,0,2,2,2,0,0,0,1},
		{1,0,0,0,0,2,0,0,0,0,1},
		{0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,1,0,0,0,0,0},
		{3,0,0,1,1,1,1,1,0,0,3}};
/* populate array with places of players 
Players:
0=vacant
1=attacker resident
2=defender resident
3=king resident
*/
char players[11][11]={
		{0,0,0,1,1,1,1,1,0,0,0},
		{0,0,0,0,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0},
		{1,0,0,0,0,2,0,0,0,0,1},
		{1,0,0,0,2,2,2,0,0,0,1},
		{1,1,0,2,2,3,2,2,0,1,1},
		{1,0,0,0,2,2,2,0,0,0,1},
		{1,0,0,0,0,2,0,0,0,0,1},
		{0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,1,0,0,0,0,0},
		{0,0,0,1,1,1,1,1,0,0,0}};
/****************** MAIN PROGRAM ***********************************/
main()
{
	const unsigned char boardx=20;		// starting x co-ord of board
	const unsigned char boardy=12;		// starting y co-ord of board
	const unsigned char boxsize=17;		// set boxsize
	char playertype=1;						// player 1=attacker, 2=defender
	paper(0);
	ink(5);
	drawboard(boardx,boardy,boxsize);	// draw the board	
	playerturn(boardx,boardy,boxsize,playertype);	// player input	
}
/********************* FUNCTION DEFINITIONS ************************/
// CAN A SELECTED PIECE MOVE?
char canpiecemove(char px, char py)
{
	/* returns 0 or 1 depending on wether a piece can move or not
	px = east-west position on board
	py = north-south position on board	
	*/
	int route=0;		// number of possible routes
	char piecetype=players[px][py];	// determine TYPE of selected piece (1=attacker, 2=defendr, 3=king)
	/*  for all piece types determine if adjacent square in any direction is blank or not
	it won't bother checking a particular direction if piece is at edge of board.
	*/
	if ( px > 0 )		// check west
		{
		if ( players[px-1][py] == 0 ) route++; 
		}
	if ( px < 10 )		// check east
		{
		if ( players[px+1][py] == 0 ) route++; 
		}
	if ( py > 0 )		// check north
		{
		if ( players[px][py-1] == 0 ) route++; 
		}
	if ( py < 10 )		// check south
		{
		if ( players[px][py+1] == 0 ) route++; 
		}
	/*  For non-KING pieces we need to ensure the KING CORNER SQUARES are excluded from the possible routes
	but only if a piece is adjacent to one, in which case ROUTE is decremented */
	if ( piecetype < 3 ) // if NOT a KING
		{
		if (( px == 0 )	|| ( px == 10 ))	// if FAR LEFT or FAR RIGHT of board
			{
			if ( py == 1 ) route--;     	// if directly BELOW a corner decrement ROUTE
			if ( py == 9 ) route--;			// if directly ABOVE a corner square decrement ROUTE
			}
		if (( py == 0 ) || ( py == 10 ))	// if at TOP or BOTTOM of board
			{
			if ( px == 1 ) route--;			// if directly RIGHT of a corner square dec route
			if ( px == 9 ) route--;			// if directly LEFT of a corner square dec route
			}
		}
	/* In the case that the central square is unnocupied and a piece is adjacent to that square then - for
	non-KING Pieces only - we need to check to see if the opposite square is occupied or not. 
	ROUTE will be decremented if that piece is occupied (as no piece can oocupy the central square except for
	the King but all peices can traverse it */
	if (( piecetype < 3 ) && ( players[5][5] == 0 ))	// if not a king and central sqr unoccupied
		{
		if (( px == 5 ) && ( py == 4 ))				// check south +2
			{
			if ( players[5][6] > 0 ) route--;		// south occupied, dec route
			}
		if (( px == 5 ) && ( py == 6 ))				// check north +2
			{
			if ( players[5][4] > 0 ) route--;		// north occupied, dec route
			}
		if (( px == 4 ) && ( py == 5 ))				// check east +2
			{
			if ( players[6][5] > 0 ) route--;		// east occupied, dec route
			}
		if (( px == 6 ) && ( py == 5 ))				// check west
			{
			if ( players[4][5] > 0 ) route--;		// west occupied, dec route
			}
		}
	if ( route > 0 ) route=1;
	return route;
}
// DRAW ALL THE PLAYERS ON THE BOARD
void drawplayers(unsigned char x, unsigned char y, unsigned char z)
{
	/* routine to draw the "playing pieces" 
	Arguments:
	x=starting x coord
	y=starting y coord
	z=boxsize
	*/
	unsigned char tilex=x;			// starting tile x position
	unsigned char tiley=y;			// starting tile y position
	unsigned char row=0;			// loop through tiles array by row
	unsigned char col=0;			// loop through tiles array by column	
	tilex+=2;						// starting tile x position (offset by 2 to avoid grid lines)
	tiley+=2;						// starting tile y position (offset by 2 to avoid grid lines)
	for (row=0;row<11;row++)
		{
		for (col=0;col<11;col++)
			{
			if ( players[row][col] == 1 ) drawpiece(tilex,tiley,1);		// draw attacker piece
			if ( players[row][col] == 2 ) drawpiece(tilex,tiley,2);		// draw defenders piece
			if ( players[row][col] == 3 ) drawpiece(tilex,tiley,3);		// draw king piece
			tilex+=z;	// the x position is advanced to the next square "across" - including blank squares		
			}
		tilex=x;		// reset x
		tilex+=2;		// tilex offset to avoid gridlines
		tiley+=z;		// advance tiley position to next "row"
		}
}
// DRAWBOX
void drawbox(unsigned char x, unsigned char y, unsigned char z, char f)
{
	/*	- draw a box at x,y size z
	x=xcoord for curset
	y=ycoord for curset
	z=size of line to draw
	f= foreground/background 1 or 0, inverse 2, 3=nothing
	*/
	curset(x,y,3);
	draw(z,0,f);
	draw(0,z,f);
	draw(-z,0,f);
	draw(0,-z,f);
}
// DRAW DIAMOND
void drawdiamond(unsigned char x, unsigned char y, char z, char f)
{
	/* - draw a diamond at x,y size z, foreground or background
	x= xcoord
	y= ycoord
	z= length of face
	f= foreground/background (0/1)
	*/
	curset(x,y,f);
	draw(z,z,f);
	draw(-z,z,f);
	draw(-z,-z,f);
	draw(z,-z,f);
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
// TILE1
void drawtile1(unsigned char x, unsigned char y)
{
	/* (a series of 2 concentric squares )
	x=xcoord for drawbox
	y=xcoord for drawbox
	*/
	unsigned char loop=0;		// loop counter
	unsigned char z=13;			// line length
	for (loop=0;loop<2;loop++)
		{
		drawbox(x,y,z,1);			// drawbox at x,y position
		z=z-4;					// decrease size of line
		x+=2;					// increase x position
		y+=2;					// increase y position
		}
}
// TILE2
void drawtile2(unsigned char x, unsigned char y)
{
	/* four diamonds
	x=xcoord for drawbox
	y=xcoord for drawbox
	*/
	char loop=0;		// loop counter
	char z=10;			// line length
	drawdiamond(x+3,y,3,1);
	drawdiamond(x+10,y,3,1);
	drawdiamond(x+3,y+7,3,1);
	drawdiamond(x+10,y+7,3,1);
}
// TILE3
void drawtile3(unsigned char x, unsigned char y)
{
	/* a series of 3 concentric squares
	x=xcoord for drawbox
	y=xcoord for drawbox
	*/
	unsigned char loop=0;		// loop counter
	unsigned char z=13;			// line length
	for (loop=0;loop<3;loop++)
		{
		drawbox(x,y,z,1);			// drawbox at x,y position
		z=z-4;					// decrease size of line
		x+=2;					// increase x position
		y+=2;					// increase y position	
		}
}
// TILE4
void drawtile4(unsigned char x, unsigned char y)
{
	/* ( a series of 5 sqares - one in each corner of the tile and one
	square straddling all 4 ) nice, simple pattern.  
	x=xcoord for drawbox
	y=xcoord for drawbox
	*/
	drawbox(x,y,5,1);			// box 1
	drawbox(x+8,y,5,1);		// box 2
	drawbox(x,y+8,5,1);		// box 3
	drawbox(x+8,y+8,5,1);		// box 4
	drawbox(x+2,y+2,9,2);		// box 5 (central, larger box, inverse)
}
// TILE4
void drawtile5(unsigned char x, unsigned char y)
{
	/* ( a series of 5 squares - one on outside and four inverse squares
	x=xcoord for drawbox
	y=xcoord for drawbox
	*/
	drawbox(x,y,13,1);			// box 1	
	drawbox(x+4,y,5,2);			// box 2
	drawbox(x+8,y+4,5,2);			// box 3
	drawbox(x+4,y+8,5,2);		// box 4
	drawbox(x,y+4,5,2);		// box 5 (central, larger box, inverse)
}
// TILE 6
void drawtile6(unsigned char x, unsigned char y)
{
	/* left arrow 
	x=x coord of tile
	y=y coord of tile
	*/
	drawdiamond(x+4,y+4,2,1);
	curset(x+5,y+6,1);
	draw(5,0,1);
}
// TILE 7
void drawtile7(unsigned char x, unsigned char y)
{
	/* right arrow 
	x=x coord of tile
	y=y coord of tile
	*/
	drawdiamond(x+10,y+4,2,1);
	curset(x+9,y+6,1);
	draw(-5,0,1);
}
// TILE 8
void drawtile8(unsigned char x, unsigned char y)
{
	/* up arrow 
	x=x coord of tile
	y=y coord of tile
	*/
	drawdiamond(x+7,y+3,2,1);
	curset(x+7,y+6,1);
	draw(0,5,1);
}
// TILE 9
void drawtile9(unsigned char x, unsigned char y)
{
	/* down arrow 
	x=x coord of tile
	y=y coord of tile
	*/
	drawdiamond(x+7,y+7,2,1);
	curset(x+7,y+8,1);
	draw(0,-5,1);
}
// DRAW A PIECE
void drawpiece(unsigned char x, unsigned char y, char p)
{
	/* draws the attackers piece
	x=xcoord for drawbox
	y=xcoord for drawbox
	p=piece type 1= attacker, 2= defender, 3=king
	*/
	unsigned char a=x;			// copy of x
	unsigned char b=y;			// copy of y
	// DRAW ELEMENTS COMMON TO ALL PIECES (ATTACKER only has this bit)
	char loop=0;		// loop counter
	char z=4;			// line length	
	a+=4;
	b+=2;
	for (loop=0;loop<4;loop++)
		{
		curset(a,b,0);			// blank anything there
		curset(a+1,b,1);		// set to first point of line
		draw(z,0,1);
		curset(a+z+1,b,0); // blank anything there
		z+=2;					// increase size of line
		a--;					// decrease x position
		b++;					// increase y position	
		}
	a++;
	z=10;
	curset(a,b,0);			// blank anything there
	draw(z,0,1);
	curset(a+z+1,b,0); // blank anything there
	b++;
	curset(a,b,0);			// blank anything there
	draw(z,0,1);
	curset(a+z+1,b,0); // blank anything there
	b++;
	curset(a,b,0);			// blank anything there
	draw(z,0,1);
	curset(a+z+1,b,0); // blank anything there
	for (loop=0;loop<4;loop++)
		{
		curset(a,b,0);			// blank anything there
		curset(a+1,b,1);		// set to first point of line
		draw(z,0,1);
		curset(a+z+1,b,0);		// blank anything there
		z-=2;					// decrease size of line
		a++;					// increase x position
		b++;					// increase y position	
		}
	if ( p == 2 )	// if player type is DEFENDER
		{
		a=x+6;
		b=y+3;
		drawdiamond(a,b,3,0);
		drawdiamond(a+1,b,3,0);
		drawdiamond(a,b+1,3,0);
		drawdiamond(a+1,b+1,3,0);
		}	
	if ( p == 3 )	// if player piece is KING
		{
		a=x+6;
		b=y+4;
		curset(a,b,0);
		draw(0,5,0);
		curmov(1,0,0);
		draw(0,-5,0);
		a-=2;
		b+=2;
		curset(a,b,0);		
		draw(5,0,0);
		curmov(0,1,0);
		draw(-5,0,0);
		}
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
			if ( tiles[row][col] == 1 ) drawtile3(tilex,tiley);		// draw attackers tile
			if ( tiles[row][col] == 2 ) drawtile1(tilex,tiley);		// draw defenders tile
			if ( tiles[row][col] == 3 ) drawtile4(tilex,tiley);		// draw kings tile
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
	drawplayers(x,y,z); // draw the players
}
// flashscreen
void flashscreen(char c)
{
	/* Colors are as follows:
	0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan,7=white
	*/
	unsigned int pause=1500;		// flash screen so long...
	unsigned int p=0;				// pause counter
	ink(c);	// flash color
	for (p=0;p<pause;p++){};
	ink(6);	// back to cyan
}
// Playerturn - 
void playerturn(unsigned char x, unsigned char y, unsigned char z, char p )	// filter keyboard input
{
	/*
	x=x pos of board (top left)
	y=y pos of board (top left)
	z=boxsize
	p=playertype, 1=attacker, 2=defender
	*/
	unsigned char key=0;			// code of key pressed	
	unsigned char ns=5;				// default north/south position of central square
	unsigned char ew=5;				// default east/west position of central square
	unsigned char cx=1+x+(z*ns);	// cursor x position
	unsigned char cy=1+y+(z*ew);	// cursor y position
	unsigned char cz=z-2;			// size of cursor
	drawcursor(cx,cy,cz,1);			// print dotted cursor at central square
	printf ("Arrows move cursor. X:Select,Q:Quit");
	while (key != 81)				// repeat until 'Q' pressed
		{
		key=getchar();					// get code of pressed key
		if (key == 8 )		// move cursor left
			{
			if (ew>0)
				{
				drawcursor(cx,cy,cz,0);		// print blank cursor (effect=remove dots)
				cx-=z;
				drawcursor(cx,cy,cz,1);		// print dotted cursor
				ew--;
				}
			else flashscreen(1);	// flash red
			}
		if (key == 9)		// move cursor right 	
			{
			if (ew<10)
				{
				drawcursor(cx,cy,cz,0);		// print blank cursor (effect=remove dots)
				cx+=z;
				drawcursor(cx,cy,cz,1);		// print dotted cursor 
				ew++;
				}
			else flashscreen(1);	// flash red
			}
		if (key == 10)		// move cursor down
			{
			if (ns<10)	
				{
				drawcursor(cx,cy,cz,0);		// print blank cursor (effect=remove dots)
				cy+=z;
				drawcursor(cx,cy,cz,1);		// print dotted cursor
				ns++; 
				}
			else flashscreen(1); 	// flash red
			}
		if (key == 11)		// move cursor up	
			{
			if (ns>0)
				{
				drawcursor(cx,cy,cz,0);		// print blank cursor (effect=remove dots)
				cy-=z;
				drawcursor(cx,cy,cz,1);		// print dotted cursor
				ns--;
				}
			else flashscreen(1);	// flash red	
			}
		/*******************************************************/
		/* determine if X is selected (to select a piece)	   */
		/*******************************************************/
		if (key == 88)		// if 'X' is selected to "select/de-select a piece"
			{
			if ( p == 1 )	// player is ATTACKER
				{
				if ( players[ew][ns] == 1 ) 	// if attacker piece
					{
					// printf("\n ATTACKER SQUARE");
					if (canpiecemove(ew,ns))
						{
						flashscreen(2);		// flash green
						//printdestinations(ew,ns);	// print arrows on all destinations
						}
					else flashscreen(1);	// flash red
					}
				else flashscreen(1);	// flash red
				}
			if ( p == 2 )	// player is DEFENDER
				{
				if ( players[ew][ns] == 2 )  	// if defender piece
					{
					// printf("\n DEFENDER SQUARE");
					if (canpiecemove(ew,ns))
						{
						flashscreen(2);		// flash green
						}
					else flashscreen(1);	// flash red
					}
				if ( players[ew][ns] == 3 )		// if king piece
					{
					// printf("\n KING SQUARE");
					if (canpiecemove(ew,ns))
						{
						flashscreen(3);		// flash yellow
						}
					else flashscreen(1);	// flash red
					}
				if ( players[ew][ns] < 2 ) flashscreen(1); // flash red
				}
			}
		}
}