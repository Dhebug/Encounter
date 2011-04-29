// main.c by Neil Barnes (a.k.a. Barnsey123)
// 22-03-2011 prog to draw a grid (for viking game)
// 23-03-2011 create new drawgrid function
// 01-04-2011 create new drawtile functions and use compact code (char instead of int etc)
// 02-04-2011 routine to read keyboard
// 06-04-2011 cursor drawing correct
// 11-04-2011 request help from DBUG - bug in OSDK. Have banged head against wall for far too long!
// 14-04-2011 DBUG fixed OSDK bug! :-)
// 15-04-2011 tidied code up
// 15-04-2011 tiles as a global variable, (will be used everywhere)
// 16-04-2011 Changed numeric settings for board (0=blank, 1=attackers tile, 2=defenders tile, 3=kings tile)
// 16-04-2011 drawing players
// 17-04-2011 improving tile drawing (saving few bytes in each routine and having different styles)
// 19-04-2011 added flashscreen (to flash screen with desired color - e.g. GREEN for OK, RED for !OK)
// 19-04-2011 context sensitive piece selection
// 19-04-2011 canpiecemove function (can a selected piece MOVE or not?) 
// 21-04-2011 numerous bug-fixes to do with x,y co-ords vs north-south/east-west array positions
// 21-04-2011 brilliant arrow printing function (hover over one of your pieces and press 'P')
// 25-04-2011 fixed bugs in arrow printing routine and reduced code required (TOTAL 817 lines versus 957)
// 27-04-2011 fixed some other (all?) bugs in arrow printing routines (new, neater routines)
// 29-04-2011 saved a whole bunch of code (789 lines)
// 29-04-2011 changed flashscreen so that color can be returned to previous color mode
// 29-04-2011 Using POINTERS Huzzah! (never thought that would happen!) 786 lines! 
/* IMMEDIATE TODO LIST	
// MOVE PIECES !!!	
*/
#include <lib.h>
/******************* Function Declarations ************************/
void drawbox(unsigned char,unsigned char,unsigned char, char);			// draws a box at x,y length z, fb/bg
void drawdiamond(unsigned char, unsigned char, char, char);				// draws diamond at x,y size z, fb/bg
void drawcursor(unsigned char,unsigned char,unsigned char,unsigned char);	// draws cursor at x,y, length z, foreground or background
void drawattackertile(unsigned char,unsigned char);	// 1 concentric squares	
void drawtile2(unsigned char,unsigned char);	// 4 diamonds (one in each corner)	
void drawdefendertile(unsigned char,unsigned char);	// 3 concentric squares
void drawkingtile(unsigned char,unsigned char);	// 5 squares (one in each corner, 1 central and inversed		
void drawtile5(unsigned char,unsigned char);	// funky x-type shape
void drawtile6(unsigned char,unsigned char, char);	// left arrow
void drawtile7(unsigned char,unsigned char, char);	// right arrow
void drawtile8(unsigned char,unsigned char, char);	// up arrow
void drawtile9(unsigned char,unsigned char, char);	// down arrow
void inverse(unsigned char, unsigned char, char);	// inverse the color in the square
void blanksquare(unsigned char, unsigned char);	// blank a square with background color		
void drawpiece(unsigned char,unsigned char, char);					// draws piece at x,y, type z
void drawtiles(unsigned char,unsigned char,unsigned char);			// draws all tiles at board x,y boxsize z (uses draw*tile functions)
void drawgrid(unsigned char,unsigned char,unsigned char);			// draws grid at board x,y boxsize z
void drawboard(unsigned char,unsigned char,unsigned char);			// kicks off drawgrid/drawtiles
void playerturn(unsigned char,unsigned char,unsigned char, char);	// takes user input to move cursor
void drawplayers(unsigned char, unsigned char, unsigned char);		// draw players
void flashscreen(char,char);						// flashes screen in selected color for a second or so
void fillbox(unsigned char, unsigned char, char);	// *** NEEDS ATTENTION *** fills box with color
char canpiecemove(char, char);				// can a selected piece move? 0=no, 1=yes
void printdestinations(unsigned char, unsigned char, char, char, char, char);			// print arrows on tiles where a piece can move
void printpossiblemoves(unsigned char, unsigned char, char, char, char);				// Print possible moves
void printarrowsorblanks(unsigned char, unsigned char, char, char, char, char, char);	// PRINT ARROWS/BLANK EM OUT	
void movecursor(char,unsigned char *,unsigned char *,unsigned char *,unsigned char *, char);// move cursor routine	(using pointers!!!)
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
4=corner square	// added 21/04/2011
*/
/*	*** PROPER STARTING BOARD (comment out TESTING BOARD below before uncommenting this)
char players[11][11]={
		{4,0,0,1,1,1,1,1,0,0,4},
		{0,0,0,0,0,1,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0},
		{1,0,0,0,0,2,0,0,0,0,1},
		{1,0,0,0,2,2,2,0,0,0,1},
		{1,1,0,2,2,3,2,2,0,1,1},
		{1,0,0,0,2,2,2,0,0,0,1},
		{1,0,0,0,0,2,0,0,0,0,1},
		{0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,1,0,0,0,0,0},
		{4,0,0,1,1,1,1,1,0,0,4}};
*/ 
// ***** TESTING BOARD ****
char players[11][11]={
		{4,1,0,0,1,1,1,1,0,0,4},
		{0,0,0,0,0,1,0,0,0,0,0},
		{2,0,0,0,0,0,0,0,0,0,3},
		{1,0,0,0,0,1,0,0,0,0,1},
		{1,2,0,0,0,0,0,0,0,0,1},
		{1,1,0,2,0,0,0,2,0,1,1},
		{1,0,0,0,2,3,2,0,0,0,1},
		{0,0,0,0,1,2,0,0,0,0,1},
		{1,0,0,0,0,0,0,0,1,0,2},
		{0,1,0,0,0,0,0,0,0,0,0},
		{4,0,1,0,0,0,1,1,0,0,4}};
/****************** MAIN PROGRAM ***********************************/
main()
{
	const unsigned char boardx=22;		// starting x co-ord of board
	const unsigned char boardy=12;		// starting y co-ord of board
	const unsigned char boxsize=17;		// set boxsize
	char playertype=1;					// player 1=attacker, 2=defender
	paper(0);
	ink(5);
	drawboard(boardx,boardy,boxsize);	// draw the board	
	playerturn(boardx,boardy,boxsize,playertype);	// player input	
}
/********************* FUNCTION DEFINITIONS ************************/
void movecursor(char mkey, unsigned char *ptrew, unsigned char *ptrns, unsigned char *ptrcx, unsigned char *ptrcy, char mz)
{
char canmovecursor=0;
char z=mz+2;	// copy of mz
if ((mkey == 8 )&&( (*ptrew)>0)) 	{ canmovecursor=1;}
if ((mkey == 9 )&&( (*ptrew)<10))	{ canmovecursor=1;}
if ((mkey == 10)&&( (*ptrns)<10))	{ canmovecursor=1;}
if ((mkey == 11)&&( (*ptrns)>0))	{ canmovecursor=1;}
if (canmovecursor)
	{
	drawcursor(*ptrcx,*ptrcy,mz,0);		// print blank cursor (effect=remove dots)
	if ( mkey == 8 ) {(*ptrcx)-=z;}		// left
	if ( mkey == 9 ) {(*ptrcx)+=z;}		// right
	if ( mkey == 10 ){(*ptrcy)+=z;}		// down
	if ( mkey == 11 ){(*ptrcy)-=z;}		// up
	drawcursor(*ptrcx,*ptrcy,mz,1);		// print dotted cursor
	if ( mkey == 8 ) {(*ptrew)--;}		// left
	if ( mkey == 9 ) {(*ptrew)++;}		// right
	if ( mkey == 10 ){(*ptrns)++;}		// down
	if ( mkey == 11 ){(*ptrns)--;}		// up
	}
else
	{
	flashscreen(1,6);		// flash red
	}			
}
void inverse(unsigned char ix, unsigned char iy, char iz)
{
	/* Draw an inversed colr box to highlight selected box
	ix=screen x position
	iy=screen y position
	iz=boxsize
	*/
	char loop=0;		// loop counter
	iz-=3;
	ix--;
	for (loop=0;loop<iz;loop++)
		{
		curset(ix,iy,3);
		draw(iz,0,2);		// draw inverse line
		iy++;
		}
}
void printpossiblemoves(unsigned char x, unsigned char y, char xew, char xns, char z)
{
	/*  kicks off functions that print appropriate arrows at all possible destinations and blanks
	them out afterwards
	x = xcoord
	y = ycoord
	xew = East-West position on board
	xns = North-South position on board
	z = boxsize
	*/
	char k=0;	// key entered
	printdestinations(x,y,xew,xns,z,0);	// print arrows on all destinations
	printf("\n*** Press any key to continue ***");
	k=getchar();
	printdestinations(x,y,xew,xns,z,1);	// blank out arrows on all destinations
}
// print arrows or blanks
void printarrowsorblanks(unsigned char x, unsigned char y, char xew, char xns, char z, char xblank, char orientation)
{
unsigned char a=x;	// copy of x
unsigned char b=y;	// copy of y
char pns=xns;
char pew=xew;
char arrow=1;			// test to see if OK to place an arrow (0=no, 1=yes)
char playertype=players[xns][xew];	// playertype of the prospective piece to move
char xplayers=0;					// player type at square under test
char tiletype=0;					// tile type at square under test
// orientation 0,1,2,3 = N, S, E, W
if ( orientation == 0 ) { xplayers=players[xns-1][xew]; } // check north 
if ( orientation == 1 ) { xplayers=players[xns+1][xew]; } // check south
if ( orientation == 2 ) { xplayers=players[xns][xew+1]; } // check east
if ( orientation == 3 ) { xplayers=players[xns][xew-1]; } // check west
if ( xplayers == 0 )	// if adjacent square is OK
		{
		arrow=1;
		while ( arrow == 1 ) // keep checking until cannot move
				{
				if (( orientation == 0 ) && ( pns > 0 ))  // check north
					{
					pns--;			// decrement provisional north-south player position
					if ( players[pns][pew] > 0) { arrow = 0;}	// !ok if piece occupied or corner square
					if (( playertype == 3)&&(players[pns][pew] == 4)) { arrow = 1; } // corner ok if king
					b-=z;
					}
				if (( orientation == 1 ) && ( pns < 10 )) // check south
					{
					pns++;			// increment provisional north-south player position
					if ( players[pns][pew] > 0) { arrow = 0;}	// !ok if piece occupied or corner square
					if (( playertype == 3)&&(players[pns][pew] == 4)) { arrow = 1; } // corner ok if king
					b+=z;
					}
				if ((orientation == 2 ) && ( pew < 10 )) // check east
					{
					pew++;			// increment provisional east-west player position
					if ( players[pns][pew] > 0) { arrow = 0;}	// !ok if piece occupied or corner square
					if (( playertype == 3)&&(players[pns][pew] == 4)) { arrow = 1; } // corner ok if king
					a+=z;
					}
				if ((orientation == 3 ) && ( pew > 0 )) // check west
					{
					pew--;			// decrement provisional east-west player position
					if ( players[pns][pew] > 0) { arrow = 0;} // !ok if piece occupied or corner square	
					if (( playertype == 3)&&(players[pns][pew] == 4)) { arrow = 1; } // corner ok if king
					a-=z;
					}
				tiletype=tiles[pns][pew];				// obtain type of tile	
				if (( xblank == 0 ) && ( arrow == 1 ))	// if MODE is "draw an arrow"
					{
					//if ((pns == 5)&&(pew == 5)){;}
					//else
					if ( tiletype < 3 )			// draw arrows on all squares except central/corner square
						{
						if ( orientation == 0 ) { drawtile8(a,b,tiletype) ;} // draw NORTH arrow
						if ( orientation == 1 ) { drawtile9(a,b,tiletype) ;} // draw SOUTH arrow 
						if ( orientation == 2 ) { drawtile7(a,b,tiletype) ;} // draw EAST arrow  
						if ( orientation == 3 ) { drawtile6(a,b,tiletype) ;} // draw WEST arrow  
						}	
					if ((tiletype > 2)&&(playertype == 3)) // only draw arrows on king squares if piece is a king
						{ 
						if ( orientation == 0 ) { drawtile8(a,b,tiletype) ;} // draw NORTH arrow 
						if ( orientation == 1 ) { drawtile9(a,b,tiletype) ;} // draw SOUTH arrow
						if ( orientation == 2 ) { drawtile7(a,b,tiletype) ;} // draw EAST arrow 
						if ( orientation == 3 ) { drawtile6(a,b,tiletype) ;} // draw WEST arrow
						}
					}
				if (( xblank == 1) && ( arrow == 1 )) 	// if MODE is "blank an arrow"
					{
					blanksquare(a,b); // blank it out
					if ( tiletype == 1 ) { drawattackertile(a,b); } // draw attacker tile
					if ( tiletype == 2 ) { drawdefendertile(a,b); } // draw defender tile
					if ( tiletype == 3 ) { drawkingtile(a,b); } 	// print king tile
					}	
				// have we reached the end of the board?
				if (( orientation == 0 ) && ( pns == 0 )) 	{ arrow=0;}	// check north
				if (( orientation == 1 ) && ( pns == 10 )) 	{ arrow=0;}	// check south
				if (( orientation == 2 ) && ( pew == 10 )) 	{ arrow=0;}	// check east
				if (( orientation == 3 ) && ( pew == 0 )) 	{ arrow=0;}	// check west
				}			
			}
}
// print destinations
void printdestinations(unsigned char x, unsigned char y, char xew, char xns, char z, char blankmode)
{
	/* print appropriate arrows at all possible destinations (or blanks em out)
	x = xcoord
	y = ycoord
	xew = East-West position on board
	xns = North-South position on board
	z = boxsize
	blankmode = blank out square or not 1=yes, 0=no
	*/
	unsigned char a=x;	// copy of x
	unsigned char b=y;	// copy of y
	char pew=xew;		// copy of xew
	char pns=xns;		// copy of xns
	char arrow=1;			// test to see if OK to place an arrow
	char playertype=players[xns][xew];	// playertype of the prospective piece to move
	// check north
	if ( xns > 0 ) { printarrowsorblanks(a,b,pew,pns,z,blankmode,0);}	// draws arrows/blanks em out (0=north)			
	// check south
	if ( xns < 10 ){ printarrowsorblanks(a,b,pew,pns,z,blankmode,1);}	// draws arrows/blanks em out (1=south)
	// check east
	if ( xew < 10 ){ printarrowsorblanks(a,b,pew,pns,z,blankmode,2);}	// draws arrows/blanks em out (2=east)
	// check west
	if ( xew > 0 ) { printarrowsorblanks(a,b,pew,pns,z,blankmode,3);}	// draws arrows/blanks em out (3=west)	
}
// fill box with color
void fillbox (unsigned char x, unsigned char y, char effect)
{
	curset(x+2,y,2);
	fill(14,1,effect);
}
// CAN A SELECTED PIECE MOVE?
char canpiecemove(char px, char py)
{
	/* returns 0 or 1 depending on wether a piece can move or not
	px = north-south position on board
	py = east-west position on board	
	*/
	int route=0;					// number of possible routes
	char piecetype=players[px][py];	// determine TYPE of selected piece (1=attacker, 2=defendr, 3=king)
	/*  for all piece types determine if adjacent square in any direction is blank or not
	it won't bother checking a particular direction if piece is at edge of board.
	*/
	if ( px > 0 )		// check north
		{
		if ( players[px-1][py] == 0 ) route++;
		if (( piecetype == 3 )&&(players[px-1][py] == 4 )) route++; // KING: corner square OK 
		}
	if ( px < 10 )		// check south
		{
		if ( players[px+1][py] == 0 ) route++; 
		if (( piecetype == 3 )&&(players[px+1][py] == 4 )) route++; // KING: corner square OK 
		}
	if ( py < 10 )		// check east
		{
		if ( players[px][py+1] == 0 ) route++; 
		if (( piecetype == 3 )&&(players[px][py+1] == 4 )) route++; // KING: corner square OK 
		}
	if ( py > 0 )		// check west
		{
		if ( players[px][py-1] == 0 ) route++; 
		if (( piecetype == 3 )&&(players[px][py-1] == 4 )) route++; // KING: corner square OK 
		}
	/* In the case that the central square is unnocupied and a piece is adjacent to that square then - for
	non-KING Pieces only - we need to check to see if the opposite square is occupied or not. 
	ROUTE will be decremented if that piece is occupied (as no piece can occupy the central square except for
	the King but all pieces can traverse it */
	if (( piecetype < 3 ) && ( players[5][5] == 0 ))	// if not a king and central sqr unoccupied
		{
		if (( px == 5 ) && ( py == 4 ))				// check east +2
			{
			if ( players[5][6] > 0 ) route--;		// east occupied, dec route
			}
		if (( px == 5 ) && ( py == 6 ))				// check west +2
			{
			if ( players[5][4] > 0 ) route--;		// west occupied, dec route
			}
		if (( px == 4 ) && ( py == 5 ))				// check south +2
			{
			if ( players[6][5] > 0 ) route--;		// south occupied, dec route
			}
		if (( px == 6 ) && ( py == 5 ))				// check north
			{
			if ( players[4][5] > 0 ) route--;		// north occupied, dec route
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
	unsigned char tilex=x;			// copy of x: starting tile x position
	unsigned char row=0;			// loop through tiles array by row
	unsigned char col=0;			// loop through tiles array by column	
	tilex+=2;						// starting tile x position (offset by 2 to avoid grid lines)
	y+=2;							// starting tile y position (offset by 2 to avoid grid lines)
	for (row=0;row<11;row++)
		{
		for (col=0;col<11;col++)
			{
			if ( players[row][col] == 1 ) drawpiece(tilex,y,1);		// draw attacker piece
			if ( players[row][col] == 2 ) drawpiece(tilex,y,2);		// draw defenders piece
			if ( players[row][col] == 3 ) drawpiece(tilex,y,3);		// draw king piece
			tilex+=z;	// the x position is advanced to the next square "across" - including blank squares		
			}
		tilex=x;		// reset x
		tilex+=2;		// tilex offset to avoid gridlines
		y+=z;			// advance y position to next "row"
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
// blanksquare
void blanksquare(unsigned char x, unsigned char y)
{
	/* (erase a square)
	x=xcoord  
	y=xcoord
	*/
	unsigned char loop=0;		// loop counter
	unsigned char z=9;			// line length
	for (loop=0;loop<=z;loop++)
		{
		curset(x+2,y+2,0);
		draw(z,0,0);
		y++;			// inc y position
		}
}
// drawattackertile
void drawattackertile(unsigned char x, unsigned char y)
{
	/* (a series of 1 concentric squares )
	x=xcoord for drawbox
	y=xcoord for drawbox
	*/
	//unsigned char loop=0;		// loop counter
	unsigned char z=13;			// line length
	//for (loop=0;loop<2;loop++)
	//	{
		drawbox(x,y,z,1);			// drawbox at x,y position
	//	z=z-4;					// decrease size of line
	//	x+=2;					// increase x position
	//	y+=2;					// increase y position
	//	}
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
// draw defender tile
void drawdefendertile(unsigned char x, unsigned char y)
{
	/* a series of 3 concentric squares
	x=xcoord for drawbox
	y=xcoord for drawbox
	*/
	unsigned char loop=0;		// loop counter
	unsigned char z=13;			// line length
	for (loop=0;loop<3;loop++)
		{
		drawbox(x,y,z,1);		// drawbox at x,y position
		z=z-4;					// decrease size of line
		x+=2;					// increase x position
		y+=2;					// increase y position	
		}
}
// draw king tile
void drawkingtile(unsigned char x, unsigned char y)
{
	/* ( a series of 5 squares - one in each corner of the tile and one
	square straddling all 4 ) nice, simple pattern.  
	x=xcoord for drawbox
	y=xcoord for drawbox
	*/
	drawbox(x,y,5,1);			// box 1
	drawbox(x+8,y,5,1);			// box 2
	drawbox(x,y+8,5,1);			// box 3
	drawbox(x+8,y+8,5,1);		// box 4
	drawbox(x+2,y+2,9,2);		// box 5 (central, larger box, inverse)
}
// TILE5
void drawtile5(unsigned char x, unsigned char y)
{
	/* ( a series of 5 squares - one on outside and four inverse squares
	x=xcoord for drawbox
	y=xcoord for drawbox
	*/
	drawbox(x,y,13,1);		// box 1	
	drawbox(x+4,y,5,2);		// box 2
	drawbox(x+8,y+4,5,2);	// box 3
	drawbox(x+4,y+8,5,2);	// box 4
	drawbox(x,y+4,5,2);		// box 5 (central, larger box, inverse)
}
// TILE 6
void drawtile6(unsigned char x, unsigned char y, char t)
{
	/* left arrow 
	x=x coord of tile
	y=y coord of tile
	t=tiletype
	*/
	if ( t > 0 ) { blanksquare(x,y); }	// erase tile before drawing arrow
	drawdiamond(x+4,y+4,2,1);
	curset(x+5,y+6,1);
	draw(5,0,1);
}
// TILE 7
void drawtile7(unsigned char x, unsigned char y, char t)
{
	/* right arrow 
	x=x coord of tile
	y=y coord of tile
	t=type of tile
	*/
	if ( t > 0 ) { blanksquare(x,y); }	// erase tile before drawing arrow
	drawdiamond(x+9,y+4,2,1);
	curset(x+8,y+6,1);
	draw(-5,0,1);
}
// TILE 8
void drawtile8(unsigned char x, unsigned char y, char t)
{
	/* up arrow 
	x=x coord of tile
	y=y coord of tile
	t=type of tile
	*/
	if ( t > 0 ) { blanksquare(x,y); }	// erase tile before drawing arrow
	drawdiamond(x+7,y+3,2,1);
	curset(x+7,y+6,1);
	draw(0,5,1);
}
// TILE 9
void drawtile9(unsigned char x, unsigned char y, char t)
{
	/* down arrow 
	x=x coord of tile
	y=y coord of tile
	t=type of tile
	*/
	if ( t > 0 ) { blanksquare(x,y); }	// erase tile before drawing arrow
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
	unsigned char tilex=x;	// copy of x: starting tile x position
	unsigned char row=0;	// loop through tiles array by row
	unsigned char col=0;	// loop through tiles array by column	
	tilex+=2;				// starting tile x position (offset by 2 to avoid grid lines)
	y+=2;					// starting tile y position (offset by 2 to avoid grid lines)
	for (row=0;row<11;row++)
		{
		for (col=0;col<11;col++)
			{
			if ( tiles[row][col] == 1 ) drawattackertile(tilex,y);	// draw attackers tile
			if ( tiles[row][col] == 2 ) drawdefendertile(tilex,y);	// draw defenders tile
			if ( tiles[row][col] == 3 ) 
				{
				drawkingtile(tilex,y);		// draw kings tile
				}
			tilex+=z;	// the x position is advanced to the next square "across" - including blank squares		
			}
		tilex=x;	// reset x
		tilex+=2;	// tilex offset to avoid gridlines
		y+=z;		// advance tiley position to next "row"
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
	unsigned char c=0;			// loop counter
	unsigned char length=z;		// copy of boxsize
	length*=11;					// multiply length by 11 (determines length of line to draw)
	for (c=0;c<=11;c++) // draw vertical lines
		{
		curset(a,y,1);
		draw(0,length,1);
		a+=z;	// add boxsize to a
		}
	a=x;	// reset a
	for (c=0;c<=11;c++) // draw horizontal lines
		{
		curset(a,y,1);
		draw(length,0,1);
		y+=z; // add boxsize to y
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
	ink(6);				// boardcolor 0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan,7=white
	drawgrid(x,y,z);	// draw the 11x11 gridlines
	drawtiles(x,y,z);	// draw the background tiles
	drawplayers(x,y,z); // draw the players
}
// flashscreen
void flashscreen(char c, char r)
{
	/* Colors are as follows:
	c=color
	r=return to color
	0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan,7=white
	*/
	unsigned int pause=1500;		// flash screen so long...
	unsigned int p=0;				// pause counter
	ink(c);	// flash color
	for (p=0;p<pause;p++){};
	ink(r);	// back to cyan
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
	unsigned char canselect=0;		// 0=no, 1=yes (is the piece selectable?)
	drawcursor(cx,cy,cz,1);			// print dotted cursor at central square
	printf ("\n*** ATTACKERS MOVE ***: Arrows move cursor.\n X:Select,Q:Quit,P:Possible moves");
	while (key != 81)				// repeat until 'Q' pressed
		{
		key=getchar();		// get code of pressed key
		if (( key > 7 ) && ( key < 12 )) { movecursor(key, &ew, &ns, &cx, &cy, cz);} // move cursor		
		/*******************************************************/
		/* determine if X or P is selected (to select a piece)	   */
		/*******************************************************/
		if (( key == 88) || ( key == 80))	// if 'X' or 'P' is selected (88=X, 80=P)
			{
			canselect=0;		// set piece to NOT SELECTABLE
			if (( p == 1 )&&(players[ns][ew] == 1 )) { canselect=1;} // piece is selectable
			if (( p == 2 )&&(players[ns][ew] > 1  )) { canselect=1;} // piece is selectable
			if ( canselect )
				{
				if (canpiecemove(ns,ew)) 
					{ 
					flashscreen(2,6);		// flash green
					if ( key == 80 ) { printpossiblemoves(cx+1,cy+1,ew,ns,z);}	// Print possible moves										
					}
				else 
					{ 
					flashscreen(1,6);	// flash red
					canselect=0;		// unselectable, cannot move
					}				
				}
			else { flashscreen(1,6);}	// flash red			
			if (( key == 88 )&&( canselect ))	// if piece is SELECTED and CAN move
				{
				printf("\n *** MOVE PIECE ROUTINE ***");
				inverse(cx+1,cy+1,z);
				}			
			}
		}
}