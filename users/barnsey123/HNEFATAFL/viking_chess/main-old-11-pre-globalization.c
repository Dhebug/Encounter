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
// 01-05-2011 Once a piece is selected restrict cursor movement to legal destinations 
// 02-05-2011 handle "skipping" of central square (if square beyond it is available)
// 02-05-2011 900 lines of code (including comments) versus 917 (more efficient and more features)
// 02-05-2011 907 lines including refinements
// 02-05-2011 CAN now move pieces (taking turns between attacker/defender) 935 lines
// 04-05-2011 Can now TAKE pieces (but king squares can't yet take part...) 1012 lines
// 04-05-2011 Re-design to save memory/complexity (987 lines)
// 05-05-2011 re-design to save memory/complexity (966 lines)
// 05-05-2011 add the take rule (of King being able to take attackers with the aid of the king squares)
// 06-06-2011 saved a few bytes
// 07-06-2011 saved a few bytes (962 lines, 30311 bytes)
/* IMMEDIATE TODO LIST
*** Write endgame function to return a value determining victory conditions etc
*** Apply rules when moving pieces so that taking is allowed
*/
#include <lib.h>
/******************* Function Declarations ************************/
void drawbox(unsigned char,unsigned char,unsigned char, char);	// draws a box at x,y length z, fb/bg
void drawdiamond(unsigned char, unsigned char, char, char);		// draws diamond at x,y size z, fb/bg
void drawcursor(unsigned char,unsigned char,unsigned char);	// draws cursor at x,y foreground or background
void drawattackertile(unsigned char,unsigned char);	// 1 concentric squares	
void drawtile2(unsigned char,unsigned char);	// 4 diamonds (one in each corner)	
void drawdefendertile(unsigned char,unsigned char);	// 3 concentric squares
void drawkingtile(unsigned char,unsigned char);	// 5 squares (one in each corner, 1 central and inversed		
void drawtile5(unsigned char,unsigned char);	// funky x-type shape
void drawpaths(unsigned char, unsigned char, char, char, char);	// draw pointers
void inverse(unsigned char, unsigned char);	// inverse the color in the square
void blanksquare(unsigned char, unsigned char);	// blank a square with background color		
void drawpiece(unsigned char,unsigned char, char);					// draws piece at x,y, type z
void drawtiles();			// draws all tiles at board x,y boxsize z (uses draw*tile functions)
void drawgrid();			// draws grid at board x,y boxsize z
void drawboard();			// kicks off drawgrid/drawtiles
void playerturn(char);	// takes user input to move cursor
void drawplayers();		// draw players
void flashscreen(char,char);						// flashes screen in selected color for a second or so
void fillbox(unsigned char, unsigned char, char);	// *** NEEDS ATTENTION *** fills box with color
char canpiecemove(char, char);				// can a selected piece move? 0=no, 1=yes
void printdestinations(unsigned char, unsigned char, char, char, char);			// print arrows on tiles where a piece can move
void printpossiblemoves(unsigned char, unsigned char, char, char);				// Print possible moves
void printarrowsorblanks(unsigned char, unsigned char, char, char, char, char);	// PRINT ARROWS/BLANK EM OUT	
void movecursor2(char,char *,char *,unsigned char *,unsigned char *, char, char, char);// move cursor routine	(using pointers!!!)
void movepiece(unsigned char,unsigned char,char,char,char,char,unsigned char,unsigned char); // move a piece
char cantakepiece(char, char, unsigned char);				// returns 0=no, 1 yes
void takepiece(char, char);		// takes specified piece
/****************** GLOBAL VARIABLES *******************************/
/* Populate array with tile types
Tile types:
0=blank
1=attacker square
2=defender square
3=king square
*/
const unsigned char tiles[11][11]={
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
/* populate array with places of players 
Players:
0=vacant
1=attacker resident
2=defender resident
3=king resident
4=corner square	// added 21/04/2011
*/
/*	*** PROPER STARTING BOARD (comment out TESTING BOARD below before uncommenting this) */
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
// ***** TESTING BOARD **** 
/*
char players[11][11]={
		{4,0,0,1,1,1,1,1,0,0,4},
		{0,0,0,0,0,1,0,0,0,0,0},
		{2,0,0,0,0,0,0,0,0,0,2},
		{1,0,0,0,0,0,0,0,0,0,1},
		{1,2,0,0,0,0,0,0,0,0,1},
		{1,1,0,2,0,0,3,2,0,1,1},
		{1,0,0,0,2,1,2,0,0,0,1},
		{0,0,0,0,0,0,0,0,0,0,1},
		{2,0,0,0,0,0,0,0,1,0,2},
		{0,1,0,0,0,0,0,0,0,0,0},
		{4,0,1,0,0,0,1,1,2,0,4}};
*/
const unsigned char boardx=22;		// starting x co-ord of board
const unsigned char boardy=12;		// starting y co-ord of board
const char boxsize=17;				// set boxsize
/****************** MAIN PROGRAM ***********************************/
main()
{
	char game=1;						// 0=endgame 1=gameon
	char playertype=1;					// player 1=attacker, 2=defender
	paper(0);
	ink(5);
	drawboard();	// draw the board
	while (game)
		{	
		playerturn(playertype);	// player input
		// WRITE ROUTINE TO return endgame conditions (king escapes, king captured, stalemate, quit, continue)
		playertype++;
		if ( playertype == 3 ) { playertype = 1; } // was defender, set to attacker player
		}	
	printf("%c",19);					// turn output to screen on
}
/********************* FUNCTION DEFINITIONS ************************/
// routine to move the cursor
void movecursor2(char mkey, char *ptrew, char *ptrns, unsigned char *ptrcx, unsigned char *ptrcy, char mode, char xoew, char xons)
{
/*
mkey = code of cursor key pressed 8=left/west, 9=right/east, 10=down/south, 11=up/north
ptrew= east-west square (0-10)
ptrns= north-south square (0-10)
ptrcx= cursor position (x axis)
ptrcy= cursor position (y axis)
mode = [0 or 1] 0=unrestricted (move anywhere), 1= restricted (only move to possible destinations)
xoew = original east-west board position of selected piece
xons = original north-south board position of selected piece 
*/
char canmovecursor=0;
char multiple=1;		// concerning central square (how much to multiply the coords to SKIP the square
char piecetype=players[xons][xoew];	// determines the piece type that is currently selected (used in mode 1)
char xptrns=*ptrns;		// copy of NS
char xptrew=*ptrew;		// copy of EW
char skipns=*ptrns;		// skip to north/south
char skipew=*ptrew;		// skip to east/west 
char modeonevalid=0;	// is OK for mode 1? 0=no, 1=yes	
if ((mkey == 8 )&&( (*ptrew)>0))		// west
	{
	if ( mode == 0 ) { canmovecursor=1;}
	xptrew--;		// decrement copyew
	skipew-=2;
	modeonevalid=1;
	}
if ((mkey == 9 )&&( (*ptrew)<10))		// east
	{
	if ( mode == 0 ) { canmovecursor=1;}
	xptrew++;
	skipew+=2;
	modeonevalid=1;
	}
if ((mkey == 10)&&( (*ptrns)<10))		// south
	{
	if ( mode == 0 ) { canmovecursor=1;}
	xptrns++;
	skipns+=2;
	modeonevalid=1;
	}
if ((mkey == 11)&&( (*ptrns)>0))		// north
	{
	if ( mode == 0 ) { canmovecursor=1;}
	xptrns--;
	skipns-=2;
	modeonevalid=1;
	}		
if (( mode == 1 ) && ( modeonevalid ))	// if not at edge of board
	{
	if ( players[xptrns][xptrew] == 0 ) 					 {canmovecursor=1;} // ok if square vacant
	if ( tiles[xptrns][xptrew] == 4 ) 						 {canmovecursor=0;}	// !ok if corner
	if (( piecetype == 3 )&&( tiles[xptrns][xptrew] > 2 ))   {canmovecursor=1;} // ok if KING and corner/central
	if (( (xptrns) == xons )&&( (xptrew) == xoew )) 		 {canmovecursor=1;} // ok if back to self
	// need to check that for non-king pieces wether the central square is vacant and can be skipped
	if (( piecetype < 3 )&&( tiles[xptrns][xptrew] == 3)&&(players[xptrns][xptrew] == 0 ))  // tiles=3(central), tiles=4(corner)
		{	
		if ( players[skipns][skipew] > 0 ) {canmovecursor=0;}	// cannot skip if otherside occupied
		else 
			{
			canmovecursor=1;
			multiple=2; 
			}			
		}	
	}
if (canmovecursor)
	{
	drawcursor(*ptrcx,*ptrcy,0);				// print blank cursor (effect=remove dots)
	if ( mkey == 8 ) {(*ptrcx)-=(boxsize*multiple);}	// left
	if ( mkey == 9 ) {(*ptrcx)+=(boxsize*multiple);}	// right
	if ( mkey == 10 ){(*ptrcy)+=(boxsize*multiple);}	// down
	if ( mkey == 11 ){(*ptrcy)-=(boxsize*multiple);}	// up
	drawcursor(*ptrcx,*ptrcy,1);				// print dotted cursor
	if ( mkey == 8 ) {(*ptrew)-=multiple;}		// left
	if ( mkey == 9 ) {(*ptrew)+=multiple;}		// right
	if ( mkey == 10 ){(*ptrns)+=multiple;}		// down
	if ( mkey == 11 ){(*ptrns)-=multiple;}		// up
	}
else
	{
	if ( mode == 0 ) {flashscreen(1,6);}else{flashscreen(1,2);}	// flash red: return to cyan:6 (or green:2)
	}			
}
void inverse(unsigned char ix, unsigned char iy)
{
	/* Draw an inversed colr box to highlight selected box
	ix=screen x position
	iy=screen y position
	*/
	char loop=0;		// loop counter
	char iz=boxsize-3;
	for (loop=0;loop<iz;loop++)
		{
		curset(ix,iy,3);
		draw(iz,0,2);		// draw inverse line
		iy++;
		}
}
void printpossiblemoves(unsigned char x, unsigned char y, char xew, char xns)
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
	printdestinations(x,y,xew,xns,0);	// print arrows on all destinations	
	printf("%c\n\n\n*** Press any key to continue ***%c",19,19);
	k=getchar();
	printdestinations(x,y,xew,xns,1);	// blank out arrows on all destinations
}
// print arrows or blanks
void printarrowsorblanks(unsigned char x, unsigned char y, char xew, char xns,char xblank, char orientation)
{
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
				if (( orientation == 0 ) && ( xns > 0 ))  // check north
					{
					xns--;			// decrement provisional north-south player position
					if ( players[xns][xew] > 0) { arrow = 0;}	// !ok if piece occupied or corner square
					if (( playertype == 3)&&(players[xns][xew] == 4)) { arrow = 1; } // corner ok if king
					y-=boxsize;
					}
				if (( orientation == 1 ) && ( xns < 10 )) // check south
					{
					xns++;			// increment provisional north-south player position
					if ( players[xns][xew] > 0) { arrow = 0;}	// !ok if piece occupied or corner square
					if (( playertype == 3)&&(players[xns][xew] == 4)) { arrow = 1; } // corner ok if king
					y+=boxsize;
					}
				if ((orientation == 2 ) && ( xew < 10 )) // check east
					{
					xew++;			// increment provisional east-west player position
					if ( players[xns][xew] > 0) { arrow = 0;}	// !ok if piece occupied or corner square
					if (( playertype == 3)&&(players[xns][xew] == 4)) { arrow = 1; } // corner ok if king
					x+=boxsize;
					}
				if ((orientation == 3 ) && ( xew > 0 )) // check west
					{
					xew--;			// decrement provisional east-west player position
					if ( players[xns][xew] > 0) { arrow = 0;} // !ok if piece occupied or corner square	
					if (( playertype == 3)&&(players[xns][xew] == 4)) { arrow = 1; } // corner ok if king
					x-=boxsize;
					}
				tiletype=tiles[xns][xew];				// obtain type of tile	
				if (( xblank == 0 ) && ( arrow == 1 ))	// if MODE is "draw an arrow"
					{
					if ( tiletype < 3 )			// draw arrows on all squares except central/corner square
						{
						if ( orientation < 2 ) { drawpaths(x,y,tiletype,1,1) ;} // draw NORTH/SOUTHarrow
						if ( orientation > 1 ) { drawpaths(x,y,tiletype,0,1) ;} // draw EAST/WEST arrow  
						}	
					if ((tiletype > 2)&&(playertype == 3)) // only draw arrows on king squares if piece is a king
						{ 
						if ( orientation < 2 ) { drawpaths(x,y,tiletype,1,1);}  // draw NORTH/SOUTH arrow 
						if ( orientation > 1 ) { drawpaths(x,y,tiletype,0,1) ;} // draw EAST/WEST arrow 
						}
					}
				if (( xblank == 1) && ( arrow == 1 )) 	// if MODE is "blank an arrow"
					{
					// blanksquare(a,b); // blank it out
					if ( orientation < 2 ) { drawpaths(x,y,tiletype,1,0);}	// blank arrow
					if ( orientation > 1 ) { drawpaths(x,y,tiletype,0,0);}  // blank arrow
					if ( tiletype == 1 ) { drawattackertile(x,y); } // draw attacker tile
					if ( tiletype == 2 ) { drawdefendertile(x,y); } // draw defender tile
					if ( tiletype == 3 ) { drawkingtile(x,y); } 	// print king tile
					}	
				// have we reached the end of the board?
				if (( orientation == 0 ) && ( xns == 0 )) 	{ arrow=0;}	// check north
				if (( orientation == 1 ) && ( xns == 10 )) 	{ arrow=0;}	// check south
				if (( orientation == 2 ) && ( xew == 10 )) 	{ arrow=0;}	// check east
				if (( orientation == 3 ) && ( xew == 0 )) 	{ arrow=0;}	// check west
				}			
			}
}
// print destinations
void printdestinations(unsigned char x, unsigned char y, char xew, char xns, char blankmode)
{
	/* print appropriate arrows at all possible destinations (or blanks em out)
	x = xcoord
	y = ycoord
	xew = East-West position on board
	xns = North-South position on board
	blankmode = blank out square or not 1=yes, 0=no
	*/
	char arrow=1;			// test to see if OK to place an arrow
	char playertype=players[xns][xew];	// playertype of the prospective piece to move
	// check north
	if ( xns > 0 ) { printarrowsorblanks(x,y,xew,xns,blankmode,0);}	// draws arrows/blanks em out (0=north)			
	// check south
	if ( xns < 10 ){ printarrowsorblanks(x,y,xew,xns,blankmode,1);}	// draws arrows/blanks em out (1=south)
	// check east
	if ( xew < 10 ){ printarrowsorblanks(x,y,xew,xns,blankmode,2);}	// draws arrows/blanks em out (2=east)
	// check west
	if ( xew > 0 ) { printarrowsorblanks(x,y,xew,xns,blankmode,3);}	// draws arrows/blanks em out (3=west)	
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
void drawplayers()
{
	unsigned char tilex=boardx;		// copy of boardx: starting tile x position
	unsigned char tiley=boardy;		// copy of boardy: starting tile y position
	unsigned char row=0;			// loop through tiles array by row
	unsigned char col=0;			// loop through tiles array by column	
	tilex+=2;						// starting tile x position (offset by 2 to avoid grid lines)
	tiley+=2;						// starting tile y position (offset by 2 to avoid grid lines)
	for (row=0;row<11;row++)
		{
		for (col=0;col<11;col++)
			{
			if (( players[row][col] >0 )&&(players[row][col] < 4)){drawpiece(tilex,tiley,players[row][col]);}
			tilex+=boxsize;	// the x position is advanced to the next square "across" - including blank squares		
			}
		tilex=boardx;	// reset x
		tilex+=2;		// tilex offset to avoid gridlines
		tiley+=boxsize;	// advance y position to next "row"
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
void drawcursor(unsigned char x, unsigned char y, unsigned char f)
{
	/*	- draw the cursor at x,y size z, foreground/background color (1 or 0)
	x=xcoord for curset
	y=ycoord for curset
	f=foreground/background 1=visible, 0=blank (to overwrite old cursor position)
	*/
	char z=boxsize-2;
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
void drawpaths(unsigned char x, unsigned char y, char t, char compass, char f)
{
	/* 
	x=x coord of tile
	y=y coord of tile
	t=tiletype
	compass= 0=horizontal or 1=vertical
	f=foreground/background 1=visible, 0=blank 
	*/
	if ( t > 0 ) { blanksquare(x,y); }	// erase tile before drawing arrow
	drawdiamond(x+7,y+4,3,f);
	if ( compass == 0 ) { draw(0,5,f);}
	else
		{
		curset(x+5,y+7,f);
		draw(4,0,f);
		}
}
// DRAW A PIECE
void drawpiece(unsigned char x, unsigned char y, char p)
{
	/* draws the attackers piece
	x=xcoord for drawbox
	y=xcoord for drawbox
	p=piece type 1= attacker, 2= defender, 3=king
	*/
	unsigned char a=x+4;			// copy of x
	unsigned char b=y+2;			// copy of y
	// DRAW ELEMENTS COMMON TO ALL PIECES (DEFENDER only has this bit)
	char loop=0;		// loop counter
	char z=4;			// line length	
	//a+=4;
	//b+=2;
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
	if ( p == 1 )	// if player type is ATTACKER
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
void drawtiles()
{
	unsigned char tilex=boardx;	// copy of boardx: starting tile x position
	unsigned char tiley=boardy; // copy of boardy: starting tile y position
	unsigned char row=0;		// loop through tiles array by row
	unsigned char col=0;		// loop through tiles array by column	
	tilex+=2;					// starting tile x position (offset by 2 to avoid grid lines)
	tiley+=2;					// starting tile y position (offset by 2 to avoid grid lines)
	for (row=0;row<11;row++)
		{
		for (col=0;col<11;col++)
			{
			if ( tiles[row][col] == 1 ) drawattackertile(tilex,tiley);	// draw attackers tile
			if ( tiles[row][col] == 2 ) drawdefendertile(tilex,tiley);	// draw defenders tile
			if ( tiles[row][col] >2 ) 	// corner or central square
				{
				drawkingtile(tilex,tiley);		// draw kings tile
				}
			tilex+=boxsize;	// the x position is advanced to the next square "across" - including blank squares		
			}
		tilex=boardx;	// reset x
		tilex+=2;	// tilex offset to avoid gridlines
		tiley+=boxsize;		// advance tiley position to next "row"
		}
}
// DRAWGRID
void drawgrid()
{
	unsigned char a=boardx;			// copy of boardx (board offset x position)
	unsigned char b=boardy;			// copy of boardy (board offset y position)
	unsigned char c=0;				// loop counter
	unsigned char length=boxsize;	// copy of boxsize
	length*=11;						// multiply length by 11 (determines length of line to draw)
	for (c=0;c<=11;c++) 	// draw vertical lines
		{
		curset(a,b,1);
		draw(0,length,1);
		a+=boxsize;			// add boxsize to a
		}
	a=boardx;				// reset a
	for (c=0;c<=11;c++) 	// draw horizontal lines
		{
		curset(a,b,1);
		draw(length,0,1);
		b+=boxsize; 		// add boxsize to y
		}
} 
// DRAW THE BOARD
void drawboard()
{
	hires();
	ink(6);			// boardcolor 0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan,7=white
	drawgrid();		// draw the 11x11 gridlines
	drawtiles();	// draw the background tiles
	drawplayers(); 	// draw the players
	printf("%c",19);// turn output to screen off
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
void playerturn(char p )	// filter keyboard input
{
	/*
	p=playertype, 1=attacker, 2=defender
	*/
	unsigned char key=0;			// code of key pressed	
	unsigned char xkey=0;			// code of key pressed after piece selected
	char ns=5;						// default north/south position of central square
	char ew=5;						// default east/west position of central square
	unsigned char cx=1+boardx+(boxsize*ns);	// cursor x screen position
	unsigned char cy=1+boardy+(boxsize*ew);	// cursor y screen position
	unsigned char ocx=cx;			// original x screen position
	unsigned char ocy=cy;			// original y screen position
	char ons=5;						// original ns board position
	char oew=5;						// original ew board position
	//unsigned char cz=boxsize-2;		// size of cursor
	unsigned char canselect=0;		// 0=no, 1=yes (is the piece selectable?)
	char cursormovetype=-1;			// -1=no, 0=yes (n,s,e,w) 1=(north/south only), 2=(east/west only)
	char turn=1;					// determines end of player turn 1=playerturn, 0=end of playerturn
	char playertext[]="ATTACKERS";
	drawcursor(cx,cy,1);			// print dotted cursor at central square
	if ( p ==2 ) { strcpy(playertext,"DEFENDERS");}
	printf ("%c\n\n\n* %s Turn: Arrows move cursor.\n X:Select P:Possibles%c",19,playertext,19);
	while (turn)				// repeat until move is made
		{
		key=getchar();		// get code of pressed key
		if (( key > 7 ) && ( key < 12 )) { movecursor2(key, &ew, &ns, &cx, &cy, 0,9,9);} // freeform 		
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
					if ( key == 80 )		// if P is pressed
						{ 
						printpossiblemoves(cx+1,cy+1,ew,ns);	// Print possible moves
						printf ("%c\n\n\n* %s Turn: Arrows move cursor.\n X:Select P:Possibles%c",19,playertext,19);
						}
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

				ink(2); // green to indicate piece is selected
				printf("%c\n\n\n%s Turn X=Selects/Deselects. R=Reset%c",19,playertext,19);
				inverse(cx,cy+1);	// highlight selected square (inverse color)
				xkey=0;					// ensure xkey at known value
				// set Original cursor and board position of selected square
				ocx=cx;
				ocy=cy;
				ons=ns;
				oew=ew;
				while (( xkey != 88 ) && ( xkey != 82)) // move cursor until X or R selected
					{
					xkey=getchar();
					if (( ons == ns )&&( cursormovetype<0)) { cursormovetype=1; }// cursor allowed north-south
					if (( oew == ew )&&( cursormovetype<0)) { cursormovetype=2; }// cursor allowed east-west
					if (( ons == ns )&&	(oew == ew )) { cursormovetype=0;} 	 	 // cursor can move 	
					if (( cursormovetype == 2) && (( xkey == 8)	||(xkey == 9)))	{cursormovetype=-1;}//!move 
					if (( cursormovetype == 1) && (( xkey == 10)||(xkey == 11))){cursormovetype=-1;}//!move
					if (( cursormovetype == 0) && (( xkey == 8)	||(xkey == 9)))	{cursormovetype=1;}	//move
					if (( cursormovetype == 0) && (( xkey == 10)||(xkey == 11))){cursormovetype=2;}	//move
					if ( cursormovetype > 0 ) 
						{
						movecursor2(xkey, &ew, &ns, &cx, &cy, 1, oew, ons);// move cursor (restricted)
						}
					else { flashscreen(1,2);}	// flashscreen red
					}
				if ( xkey == 82 ) // R has been selected, Reset cursor to original positions
					{
					drawcursor(cx,cy,0);		// blank out cursor at current position
					cx=ocx;						// reset coords and board values to original positions
					cy=ocy;
					ns=ons;
					ew=oew;
					inverse(cx,cy+1);		// inverse square
					drawcursor(cx,cy,1);		// draw cursor at original selected position
					}
				if ( xkey == 88 )				// if X selected
					{
					inverse(ocx,ocy+1);			// inverse original position
					if (( ons == ns )&&( oew == ew))// X is in original position so return to cursor movement 
						{
						xkey=0;		// piece de-selected
						} 
					else{ 
						movepiece(cx,cy,ns,ew,ons,oew,ocx,ocy);	// move selected piece				
						turn=0;		// player has ended turn
						}
					}
				}
			ink(6);	// back to cyan			
			}		// key = X or P
		}	// While player turn		
}
void movepiece(unsigned char mcx,unsigned char mcy,char mns,char mew,char mons,char moew,unsigned char mocx, unsigned char mocy)
{ // Moves selected piece to new location - updating board arrays and re-drawing tiles where necessary
char piecetype=players[mons][moew];	// obtain type of piece
char p1=1;	// piece type comparison (lower) - used for determining takes - default=attacker
char p2=1;	// piece type comparison (upper) - used for determining takes - default=attacker
// move piece
drawcursor(mcx,mcy,0);				// draw blank cursor at new selected position
drawpiece(mcx+1,mcy+1,players[mons][moew]);	// draw piece at new location
players[mns][mew]=players[mons][moew];		// update square with player info
blanksquare(mocx+1,mocy+1);				// blank out square
players[mons][moew]=0;					// blank original location
if (tiles[mons][moew] > 0)				// draw tile at old positions
	{
	if (tiles[mons][moew] == 1) { drawattackertile(mocx+1,mocy+1);}
	if (tiles[mons][moew] == 2) { drawdefendertile(mocx+1,mocy+1);}
	if (tiles[mons][moew] == 3) { drawkingtile(mocx+1,mocy+1);}
	}
// having moved piece we now need to check for, and implement any TAKES
if (piecetype > 1 )	// if defender
	{
	p1=2;
	p2=3;
	}
if ( mns > 1 ) // check north
	{
	if ( cantakepiece(mns,mew,1) ) { takepiece(mns-1, mew); }
	}
if ( mns < 9 ) // check south
	{
	if ( cantakepiece(mns,mew,2) ) { takepiece(mns+1, mew); }
	}
if ( mew < 9 ) // check east
	{
	if ( cantakepiece(mns,mew,3) ) { takepiece(mns, mew+1); }
	}
if ( mew > 1 ) // check west
	{
	if ( cantakepiece(mns,mew,4) ) { takepiece(mns, mew-1); }
	}	
}
char cantakepiece(char tns, char tew, unsigned char takemode)
{
/* Will return a value (take) who's values will be:
0= no takes
IF the takemode = 1-4 (1=north, 2=south, 3=east, 4=west (it will return the following) 
1 if can take north
1 if can take south
1 if can take east
1 if can take west
*/
char take=0;
char taketotal=0;
char piecetype=players[tns][tew];	// obtain type of piece
char p1=1;	// piece type comparison (lower) - used for determining takes - default=attacker
char p2=1;	// piece type comparison (upper) - used for determining takes - default=attacker
char pcheckns1=tns-1;	// defaults to north
char pcheckns2=tns-2;
char pcheckew1=tew;
char pcheckew2=tew;
if (piecetype > 1 )	// if defender
	{
	p1=2;
	p2=3;
	}
if ( takemode == 2)	// if south
{
	pcheckns1=tns+1;
	pcheckns2=tns+2;
}
if ( takemode > 2)	// if east or west
{
	pcheckns1=tns;
	pcheckns2=tns;
	pcheckew1=tew+1;
	pcheckew2=tew+2;
	if ( takemode == 4) // if west
		{
		pcheckew1=tew-1;
		pcheckew2=tew-2;
		}
}
// if a take is possible increment the take counter
if (( players[pcheckns1][pcheckew1] != 0 )&&(players[pcheckns1][pcheckew1] != p1)&&(players[pcheckns1][pcheckew1] != p2)&&(players[pcheckns1][pcheckew1] != 3))
	{	
	if ((( players[pcheckns2][pcheckew2] == p1 )||(players[pcheckns2][pcheckew2] == p2 ))&&(players[pcheckns1][pcheckew1] < 3))
		{
		take++;
		} 
	}
if ( piecetype == 3 ) // if king and next to attacker and opposite square is a king square
	{
	if ((players[pcheckns1][pcheckew1] == 1 )&&(tiles[pcheckns2][pcheckew2] > 2)) { take++;}
	}
return take;
} 
// TAKE A PIECE
void takepiece(char tns, char tew)
{
char tpx=boardx+(boxsize*tew+2);
char tpy=boardy+(boxsize*tns+2);
blanksquare(tpx,tpy);		// blank out square
players[tns][tew]=0;		// zero players
if (tiles[tns][tew] > 0)	// draw tile at deleted position
	{
	if (tiles[tns][tew] == 1) { drawattackertile(tpx,tpy);}
	if (tiles[tns][tew] == 2) { drawdefendertile(tpx,tpy);}
	if (tiles[tns][tew] == 3) { drawkingtile(tpx,tpy);}
	}
}