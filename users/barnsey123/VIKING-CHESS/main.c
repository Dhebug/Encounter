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
// 06-05-2011 saved a few bytes
// 07-05-2011 saved a few bytes (962 lines, 30311 bytes)
// 10-05-2011 fixed bug in central square Skipping (could not return to self if adjacent to square)
// 10-05-2011 fixed bug allowing defender to select corner square to move!
// 10-05-2011 Continuing glabalization (few bugs sorted)
// 11-05-2011 Finished Globalizing (23639 bytes)
// 13-05-2011 Bug Hunt (23504 bytes) - some tidying up (not 100% byte efficient I'm sure)
// 14-05-2011 Bug in printpossiblemoves resolved (arrow WILL print on corner square if piece is KING)
// 14-05-2011 checkend function to check if king escapes or is captured (not complete) (26815)
/* IMMEDIATE TODO LIST
*** Continue with endgame function to return a value determining victory conditions etc
*** Once victory conditions completed will start on AI...
*/
#include <lib.h>
/******************* Function Declarations ************************/
void drawbox();				// draws a box 
void drawdiamond();			// draws diamond 
void drawcursor();			// draws cursor 
void drawattackertile();	// 1 concentric squares	
void drawdefendertile();	// 3 concentric squares
void drawkingtile();		// 5 squares (one in each corner, 1 central and inversed		
void drawpaths();			// draw arrows/pointers
void inverse();				// inverse the color in the square
void blanksquare();			// blank a square with background color		
void drawpiece();			// draws piece
void drawtiles();			// draws all tiles at board x,y boxsize z (uses draw*tile functions)
void drawgrid();			// draws grid at board x,y boxsize z
void drawboard();			// kicks off drawgrid/drawtiles
void playerturn();			// takes user input to move cursor
void drawplayers();			// draw playing pieces
void flashscreen();			// flashes screen in selected color for a second or so
char canpiecemove();		// can a selected piece move? 0=no, 1=yes
void printdestinations();	// print arrows on tiles where a piece can move
void printpossiblemoves();	// Print possible moves
void printarrowsorblanks();	// PRINT ARROWS/BLANK EM OUT	
void movecursor2();			// move cursor routine
void movepiece(); 			// move a piece
char cantakepiece();		// returns 0=no, 1 yes
void takepiece();			// takes specified piece
void blinkcursor();			// blinks the cursor to attract attention
void checkend();			// check for end game conditions 
void computerturn();		// AI for computer
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
//	*** PROPER STARTING BOARD (comment out TESTING BOARD below before uncommenting this) 

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
		{4,0,1,1,1,1,1,1,3,0,4},
		{0,3,0,0,0,1,0,0,0,0,0},
		{2,0,0,0,0,0,0,0,0,0,2},
		{0,0,0,0,0,0,2,0,0,0,1},
		{1,2,0,0,0,0,0,0,0,0,1},
		{1,2,0,2,0,0,3,2,2,1,1},
		{1,1,0,0,2,1,2,0,1,0,1},
		{1,0,0,0,0,2,0,0,0,1,2},
		{0,1,0,0,0,0,0,0,1,0,2},
		{0,2,0,0,0,0,0,0,2,0,0},
		{4,0,3,0,0,0,1,1,3,0,4}};
*/
// TIGER
const unsigned char boardx=22;	// starting x co-ord of board
const unsigned char boardy=12;	// starting y co-ord of board
const char boxsize=17;		// set boxsize
char playertype=0;			// player 1=attacker, 2=defender (default to attacker)
char piecetype;				// 1=attacker, 2=defender, 3=king
char ns;					// default north/south position of central square
char ew;					// default east/west position of central square
unsigned char cx;			// cursor x screen position (pixels across)
unsigned char cy;			// cursor y screen position (pixels down)
char fb=1;					// foreground/background 0=background, 1=foreground, 2=opposite, 3=nothing
unsigned char inversex;		// x position of square to be inversed
unsigned char inversey;		// y position of square to be inversed
char mkey;					// code of key pressed
char cursormode;			// cursor movement mode 0=freeform 1=restricted
char ons;					// original north/south board pos
char oew;					// original east/west board pos
unsigned char ocx;			// original xpos of piece
unsigned char ocy;			// original ypos of piece 
char orientation;			// for arrows - 0=north, 1=south 2=east 3=west
unsigned char arrowsx;		// xpos for arrows
unsigned char arrowsy;		// ypos for arrows
char tiletype;				// type of tile under inspection (used in arrows)
unsigned char tilex;		// xpos of tile to draw
unsigned char tiley;		// ypos of tile to draw
unsigned char blankx;		// xpos to blank
unsigned char blanky;		// ypos to blank
unsigned char size;			// size of line to draw or something
char tpns;					// north-south board location of taken piece
char tpew;					// east-west board location of taken piece
char flashcolor;			// color ink to flashing in
char flashback;				// color of ink to return to
char game=1;				// <=0 means endgame (see checkend for values), 1=GAMEON
char gamestyle=0;			// 0=human vs human; 1=human king vs computer; 2=human vs computer king
/****************** MAIN PROGRAM ***********************************/
main()
{
paper(0);
ink(5);
drawboard();					// draw the board
while (game>0)
	{
	ns=5;						// default north/south position of central square
	ew=5;						// default east/west position of central square
	cx=1+boardx+(boxsize*ns);	// cursor x screen position
	cy=1+boardy+(boxsize*ew);	// cursor y screen position
	playertype++;				// playertype inited as 0 so ++ will make it 1 at start of game
	if ( playertype == 3 ) { playertype = 1; } // was defender, set to attacker player
	if (( gamestyle == 0 )||((gamestyle==1)&&(playertype==2))||((gamestyle==2)&&(playertype==1)))
		{
		playerturn();			// player input
		}
	else
		{
		computerturn();			// computer has a go...
		}				
	checkend();					// check for end of game conditions
	}	
printf("%c",19);					// turn output to screen
if ( game == 0 ) { printf("\n\n*** KING HAS ESCAPED! Defenders Win ***");ping();}
else { printf("\n\n*** KING IS CAPTURED! Attackers Win ***");explode();}
getchar();
}
/********************* FUNCTION DEFINITIONS ************************/
void computerturn()
{
printf("%c\n\nComputa Turn innit?%c",19,19);
}
// check for endgame conditions
void checkend()
{
	/* Victory Conditions 
	game=0 King escapes. 										// DONE
	game=-1 King Surrounded in open play or by central square 	// DONE
	game=-2 King surrounded by attackers and corner squares		// TBD
	game=-3 King surrounded by attackers and edge of board		// TBD
	game=-4 defenders cannot move (stalemate)					// TBD
	game=-5 attackers cannot move (stalemate)					// TBD
	game=-6 all attackers eliminated 							// TBD
	game=-7 all defenders eliminated							// TBD
	*/
	char surrounded=0;		// count of number of attackers around king
	char kingns=-1;			// king north-south position
	char kingew=-1;			// king east-west position
	// ns and ew contains new board co-ords of last piece moved
	if (( players[ns][ew] == 3 ) && ( tiles[ns][ew] == 4 )) { game=0; }		// king has escaped
	// check to see if king is surrounded by attackers (first find king)
	if ( players[ns][ew] == 1 )	// if attacker was last to move
		{
		kingns=ns;	// set default
		kingew=ew;	// set default
		// check north for king and opposite piece
		if ((ns>0 )&&(players[ns-1][ew]==3 )) {kingns=ns-1;}
		// check south
		if ((ns<10 )&&(players[ns+1][ew]==3 )) {kingns=ns+1;}
		// check east
		if ((ew<10 )&&(players[ns][ew+1]==3 )) {kingew=ew+1;}
		// check west
		if ((ew>0 )&&(players[ns][ew-1]==3 )) {kingew=ew-1;}
		// has king been found?
		if (( kingns != ns ) || (kingew != ew)) // king found!
			{
			// printf("%c*** KING FOUND AT:%d,%d%c",19,kingns, kingew,19);
			// check north from king position
			if (kingns > 0 )
				{
				if ((players[kingns-1][kingew]==1)||(tiles[kingns-1][kingew]==3)){surrounded++;}
				if (tiles[kingns-1][kingew]==4){surrounded+=2;} // corner square counts as two
				}
			// check south from king position
			if (kingns < 10 )
				{
				if((players[kingns+1][kingew]==1)||(tiles[kingns+1][kingew]==3)){surrounded++;}
				if (tiles[kingns+1][kingew]==4){surrounded+=2;} // corner square counts as two
				}
			// check east from king position
			if (kingew < 10 )
				{
				if((players[kingns][kingew+1]==1)||(tiles[kingns][kingew+1]==3)){surrounded++;}
				if (tiles[kingns][kingew+1]==4){surrounded+=2;} // corner square counts as two
				}
			// check west from king position
			if (kingew > 0 )
				{
				if((players[kingns][kingew-1]==1)||(tiles[kingns][kingew-1]==3)){surrounded++;}
				if (tiles[kingns][kingew-1]==4){surrounded+=2;} // corner square counts as two
				}
			}
		// printf("%cSURROUNDED=%d%c",19,surrounded,19);
		if ( surrounded == 4 ) { game=-1;}	// king is surrounded on all sides by attackers or king squares
		//getchar();
		}
}
// routine to move the cursor
void movecursor2()
{
/*
mode = [0 or 1] 0=unrestricted (move anywhere), 1= restricted (only move to possible destinations)
*/
char canmovecursor=0;
char multiple=1;		// concerning central square (how much to multiply the coords to SKIP the square
char xptrns=ns;		// copy of NS
char xptrew=ew;		// copy of EW
char skipns=ns;		// skip to north/south
char skipew=ew;		// skip to east/west 
char modeonevalid=0;	// is OK for mode 1? 0=no, 1=yes	
piecetype=players[ons][oew];	// determines the piece type that is currently selected (used in mode 1)
if ((mkey == 8 )&&( ew>0))		// west
	{
	if ( cursormode == 0 ) { canmovecursor=1;}
	xptrew--;		// decrement copyew
	skipew-=2;
	modeonevalid=1;
	}
if ((mkey == 9 )&&( ew<10))		// east
	{
	if ( cursormode == 0 ) { canmovecursor=1;}
	xptrew++;
	skipew+=2;
	modeonevalid=1;
	}
if ((mkey == 10)&&( ns<10))		// south
	{
	if ( cursormode == 0 ) { canmovecursor=1;}
	xptrns++;
	skipns+=2;
	modeonevalid=1;
	}
if ((mkey == 11)&&( ns>0))		// north
	{
	if ( cursormode == 0 ) { canmovecursor=1;}
	xptrns--;
	skipns-=2;
	modeonevalid=1;
	}		
if (( cursormode == 1 ) && ( modeonevalid ))	// if not at edge of board
	{
	if ( players[xptrns][xptrew] == 0 ) 					{canmovecursor=1;} // ok if square vacant
	if ( tiles[xptrns][xptrew] == 4 ) 						{canmovecursor=0;}	// !ok if corner
	if (( piecetype == 3 )&&( tiles[xptrns][xptrew] > 2 ))  {canmovecursor=1;} // ok if KING and corner/central
	if (( xptrns == ons )&&( xptrew == oew )) 		 		{canmovecursor=1;} // ok if back to self
	// need to check that for non-king pieces wether the central square is vacant and can be skipped
	if (( piecetype < 3 )&&( tiles[xptrns][xptrew] == 3)&&(players[xptrns][xptrew] == 0 ))  // tiles=3(central), tiles=4(corner)
		{	
		if ( players[skipns][skipew] > 0 ) {canmovecursor=0;}	// cannot skip if otherside occupied
		if ((( skipns == ons )&&( skipew == oew ))||(	players[skipns][skipew]==0))			// ok to skip to self
			{
			canmovecursor=1;
			multiple=2; 
			}			
		}	
	}
if (canmovecursor)
	{
	fb=0;
	drawcursor();				// print blank cursor (effect=remove dots)
	if ( mkey == 8 ) {cx-=(boxsize*multiple);}	// left
	if ( mkey == 9 ) {cx+=(boxsize*multiple);}	// right
	if ( mkey == 10 ){cy+=(boxsize*multiple);}	// down
	if ( mkey == 11 ){cy-=(boxsize*multiple);}	// up
	fb=1;
	drawcursor();				// print dotted cursor
	if ( mkey == 8 ) {ew-=multiple;}		// left
	if ( mkey == 9 ) {ew+=multiple;}		// right
	if ( mkey == 10 ){ns+=multiple;}		// down
	if ( mkey == 11 ){ns-=multiple;}		// up
	}
else
	{
	flashcolor=1;
	if ( cursormode == 0 ) {flashback=6;flashscreen();}	// flash red: return to cyan:6
	if ( cursormode == 1 ) {flashback=2;flashscreen();}	// flash red: return to green:2)
	}			
}
void inverse()
{
	/* Draw an inversed colr box to highlight selected box
	ix=screen x position
	iy=screen y position
	*/
	char loop=0;		// loop counter
	char iz=boxsize-3;
	for (loop=0;loop<iz;loop++)
		{
		curset(inversex,inversey,3);
		draw(iz,0,2);		// draw inverse line
		inversey++;
		}
}
void printpossiblemoves()
{
	/*  kicks off functions that print appropriate arrows at all possible destinations and blanks
	them out afterwards*/
	char k=0;	// key entered
	fb=1;
	printdestinations();	// print arrows on all destinations	
	printf("%c\n\n\n*** Press any key to continue ***%c",19,19);
	k=getchar();
	fb=0;
	printdestinations();	// blank out arrows on all destinations
}
// print arrows or blanks
void printarrowsorblanks()
{
char arrow=1;			// test to see if OK to place an arrow (0=no, 1=yes)
char xplayers=players[ns-1][ew];	// player type at square under test (default to North)
char xns=ns;	// copy of ns
char xew=ew;	// copy of ew
arrowsx=cx+1;
arrowsy=cy+1;
// orientation 0,1,2,3 = N, S, E, W
if ( orientation == 1 ) { xplayers=players[xns+1][xew]; } // check south
if ( orientation == 2 ) { xplayers=players[xns][xew+1]; } // check east
if ( orientation == 3 ) { xplayers=players[xns][xew-1]; } // check west
if ( xplayers == 0 )	// if adjacent square is OK
	{
	//arrow=1;
	while ( arrow == 1 ) // keep checking until cannot move
		{
		if (( orientation == 0 ) && ( xns > 0 ))  // check north
			{
			xns--;			// decrement provisional north-south player position
			if ( players[xns][xew] > 0) { arrow = 0;}	// !ok if piece occupied or corner square
			if (( players[ns][ew] == 3)&&(tiles[xns][xew] == 4)) { arrow = 1; } // corner ok if king
			arrowsy-=boxsize;
			}
		if (( orientation == 1 ) && ( xns < 10 )) // check south
			{
			xns++;			// increment provisional north-south player position
			if ( players[xns][xew] > 0) { arrow = 0;}	// !ok if piece occupied or corner square
			if (( players[ns][ew] == 3)&&(tiles[xns][xew] == 4)) { arrow = 1; } // corner ok if king
			arrowsy+=boxsize;
			}
		if ((orientation == 2 ) && ( xew < 10 )) // check east
			{
			xew++;			// increment provisional east-west player position
			if ( players[xns][xew] > 0) { arrow = 0;}	// !ok if piece occupied or corner square
			if (( players[ns][ew] == 3)&&(tiles[xns][xew] == 4)) { arrow = 1; } // corner ok if king
			arrowsx+=boxsize;
			}
		if ((orientation == 3 ) && ( xew > 0 )) // check west
			{
			xew--;			// decrement provisional east-west player position
			if ( players[xns][xew] > 0) { arrow = 0;} // !ok if piece occupied or corner square	
			if (( players[ns][ew] == 3)&&(tiles[xns][xew] == 4)) { arrow = 1; } // corner ok if king
			arrowsx-=boxsize;
			}
		tiletype=tiles[xns][xew];				// obtain type of tile	
		if ( arrow == 1 )	// if MODE is "draw an arrow"
			{
			drawpaths();
			if ( fb == 0) 	// if MODE is "blank an arrow"
				{
				if (tiletype > 0)
					{
					fb=1;
					tilex=arrowsx;
					tiley=arrowsy;
					if ( tiletype == 1 ) { drawattackertile(); } // draw attacker tile
					if ( tiletype == 2 ) { drawdefendertile(); } // draw defender tile
					if (( tiletype > 2 )&&(piecetype == 3)) { drawkingtile(); } 	 // print king tile
					fb=0;
					}
				}
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
void printdestinations()
{
	// print appropriate arrows at all possible destinations (or blanks em out)
	// check north
	if ( ns > 0 ) { orientation=0;printarrowsorblanks();}	// draws arrows/blanks em out (0=north)			
	// check south
	if ( ns < 10 ){ orientation=1;printarrowsorblanks();}	// draws arrows/blanks em out (1=south)
	// check east
	if ( ew < 10 ){ orientation=2;printarrowsorblanks();}	// draws arrows/blanks em out (2=east)
	// check west
	if ( ew > 0 ) { orientation=3;printarrowsorblanks();}	// draws arrows/blanks em out (3=west)	
}
/*fill box with color
void fillbox (unsigned char x, unsigned char y, char effect)
{
	curset(x+2,y,2);
	fill(14,1,effect);
}*/
// CAN A SELECTED PIECE MOVE?
char canpiecemove()
{
	// returns 0 or 1 depending on wether a piece can move or not
	int route=0;				// number of possible routes
	piecetype=players[ns][ew];	// determine TYPE of selected piece (1=attacker, 2=defendr, 3=king)
	/*  for all piece types determine if adjacent square in any direction is blank or not
	it won't bother checking a particular direction if piece is at edge of board.
	*/
	if ( ns > 0 )		// check north
		{
		if ( players[ns-1][ew] == 0 ) route++;
		if (( piecetype == 3 )&&(players[ns-1][ew] == 4 )) route++; // KING: corner square OK 
		}
	if ( ns < 10 )		// check south
		{
		if ( players[ns+1][ew] == 0 ) route++; 
		if (( piecetype == 3 )&&(players[ns+1][ew] == 4 )) route++; // KING: corner square OK 
		}
	if ( ew < 10 )		// check east
		{
		if ( players[ns][ew+1] == 0 ) route++; 
		if (( piecetype == 3 )&&(players[ns][ew+1] == 4 )) route++; // KING: corner square OK 
		}
	if ( ew > 0 )		// check west
		{
		if ( players[ns][ew-1] == 0 ) route++; 
		if (( piecetype == 3 )&&(players[ns][ew-1] == 4 )) route++; // KING: corner square OK 
		}
	/* In the case that the central square is unnocupied and a piece is adjacent to that square then - for
	non-KING Pieces only - we need to check to see if the opposite square is occupied or not. 
	ROUTE will be decremented if that piece is occupied (as no piece can occupy the central square except for
	the King but all pieces can traverse it */
	if (( piecetype < 3 ) && ( players[5][5] == 0 ))	// if not a king and central sqr unoccupied
		{
		if (( ns == 5 ) && ( ew == 4 ))				// check east +2
			{
			if ( players[5][6] > 0 ) route--;		// east occupied, dec route
			}
		if (( ns == 5 ) && ( ew == 6 ))				// check west +2
			{
			if ( players[5][4] > 0 ) route--;		// west occupied, dec route
			}
		if (( ns == 4 ) && ( ew == 5 ))				// check south +2
			{
			if ( players[6][5] > 0 ) route--;		// south occupied, dec route
			}
		if (( ns == 6 ) && ( ew == 5 ))				// check north
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
	unsigned char row=0;		// loop through tiles array by row
	unsigned char col=0;		// loop through tiles array by column	
	tilex=boardx+2;				// starting tile x position (offset by 2 to avoid grid lines)
	tiley=boardy+2;				// starting tile y position (offset by 2 to avoid grid lines)
	for (row=0;row<11;row++)
		{
		for (col=0;col<11;col++)
			{
			piecetype=players[row][col];
			if (( piecetype > 0 )&&(piecetype < 4)){drawpiece();}
			tilex+=boxsize;	// the x position is advanced to the next square "across" - including blank squares		
			}
		tilex=boardx+2;	// reset tilex offset to avoid gridlines
		tiley+=boxsize;	// advance y position to next "row"
		}
}
// DRAWBOX
void drawbox()
{
	// draws a box
	curset(tilex,tiley,3);
	draw(size,0,fb);
	draw(0,size,fb);
	draw(-size,0,fb);
	draw(0,-size,fb);
}
// DRAW DIAMOND
void drawdiamond()
{
	// - draw a diamond at x,y size z, foreground or background
	curset(tilex,tiley,fb);
	draw(size,size,fb);
	draw(-size,size,fb);
	draw(-size,-size,fb);
	draw(size,-size,fb);
}
// DRAWCURSOR
void drawcursor()
{
	//	- draw the cursor at cx,cy size z, foreground/background color (1 or 0)
	char z=boxsize-2;
	pattern(170);
	curset(cx,cy,fb);
	draw(z,0,fb);
	draw(0,z,fb);
	draw(-z,0,fb);
	draw(0,-z,fb);
	pattern(255);
}
// blanksquare
void blanksquare()
{
	// (erase a square)
	unsigned char loop=0;		// loop counter
	unsigned char z=9;			// line length
	for (loop=0;loop<=z;loop++)
		{
		curset(blankx+2,blanky+2,0);
		draw(z,0,0);
		blanky++;			// inc y position
		}
}
// drawattackertile
void drawattackertile()
{
	size=13;			// line length
	drawbox();		// drawbox at x,y position
}
/* TILE2
void drawtile2(unsigned char x, unsigned char y)
{
	char loop=0;		// loop counter
	char z=10;			// line length
	drawdiamond(x+3,y,3,1);
	drawdiamond(x+10,y,3,1);
	drawdiamond(x+3,y+7,3,1);
	drawdiamond(x+10,y+7,3,1);
}*/
// draw defender tile
void drawdefendertile()
{
	// a series of 3 concentric squares
	unsigned char loop=0;		// loop counter
	unsigned char x=tilex;
	unsigned char y=tiley;
	size=13;
	for (loop=0;loop<3;loop++)
		{
		drawbox();		// drawbox at x,y position
		size-=4;		// decrease size of line
		tilex+=2;		// increase x position
		tiley+=2;		// increase y position	
		}
	tilex=x;
	tiley=y;
}
// draw king tile
void drawkingtile()
{
	/* ( a series of 5 squares - one in each corner of the tile and one
	square straddling all 4 ) nice, simple pattern.  
	x=xcoord for drawbox
	y=xcoord for drawbox
	*/
	unsigned char x=tilex;
	unsigned char y=tiley;
	size=5;
	drawbox();			// box 1
	tilex+=8;
	drawbox();			// box 2
	tilex=x;
	tiley+=8;
	drawbox();			// box 3
	tilex+=8;
	drawbox();		// box 4
	tilex=x+2;
	tiley=y+2;
	fb=2;
	size=9;
	drawbox();		// box 5 (central, larger box, inverse)
	tilex=x;		// reset tilex
	tiley=y;		// reset tiley
	fb=1;			// reset fb
}
/* TILE5
void drawtile5(unsigned char x, unsigned char y)
{
	// ( a series of 5 squares - one on outside and four inverse squares
	
	drawbox(x,y,13,1);		// box 1	
	drawbox(x+4,y,5,2);		// box 2
	drawbox(x+8,y+4,5,2);	// box 3
	drawbox(x+4,y+8,5,2);	// box 4
	drawbox(x,y+4,5,2);		// box 5 (central, larger box, inverse)
}*/
void drawpaths()	// DRAW ARROWS ON ALL POSSIBLE TILES
{
	blankx=arrowsx;
	blanky=arrowsy;
	if (( tiletype < 3)||(( tiletype > 2 ) && ( piecetype == 3))) { blanksquare(); }
	tilex=arrowsx+7;
	tiley=arrowsy+4;
	if (( tiletype < 3)||(( tiletype > 2 ) && ( piecetype == 3)))
		{
		size=3;	// sizeof diamond line
		drawdiamond();
		if ( orientation > 1) { draw(0,5,fb);}
		else
			{
			curset(arrowsx+5,arrowsy+7,fb);
			draw(4,0,fb);
			}
		}
}
// DRAW A PIECE
void drawpiece()
{
	unsigned char a=tilex+4;			// copy of tilex
	unsigned char b=tiley+2;			// copy of tiley
	unsigned char c=tilex;
	unsigned char d=tiley;
	// DRAW ELEMENTS COMMON TO ALL PIECES (DEFENDER only has this bit)
	char loop=0;		// loop counter
	char z=4;			// line length	
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
	if ( piecetype == 1 )	// if player type is ATTACKER
		{
		tilex=a+1;
		tiley=b-9;
		fb=0;
		size=3; // size of diamond face
		drawdiamond();
		tilex++;
		drawdiamond();
		tilex--;
		tiley++;
		drawdiamond();
		tilex++;
		drawdiamond();
		}	
	if ( piecetype == 3 )	// if player piece is KING
		{
		a=tilex+6;
		b=tiley+4;
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
	tilex=c;	// reset tilex
	tiley=d;	// reset tiley
}
// DRAW ALL THE TILES ON THE BOARD
void drawtiles()
{
	unsigned char row=0;		// loop through tiles array by row
	unsigned char col=0;		// loop through tiles array by column	
	tilex=boardx+2;	// copy of boardx: starting tile x position (offset by 2 to avoid grid lines)
	tiley=boardy+2; // copy of boardy: starting tile y position (offset by 2 to avoid grid lines)
	for (row=0;row<11;row++)
		{
		for (col=0;col<11;col++)
			{
			if ( tiles[row][col] == 1 ) drawattackertile();	// draw attackers tile
			if ( tiles[row][col] == 2 ) drawdefendertile();	// draw defenders tile
			if ( tiles[row][col] >2 ) 	// corner or central square
				{
				drawkingtile();		// draw kings tile
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
// blinks the cursor a number of times to attract attention
void blinkcursor()
{
char curloop=0;
unsigned int subloop=0;
for (curloop=0;curloop<5;curloop++)	// flash the cursor to draw attention to it
	{
	fb=0; drawcursor();					// draw cursor in background color at cx,cy
	for (subloop=0;subloop<250;subloop++){;} // wait a bit
	fb=1; drawcursor();					// draw cursor in foreground color at cx,cy
	for (subloop=0;subloop<2000;subloop++){;} // wait a bit
	}
}
// flashscreen
void flashscreen()
{
	/* Colors are as follows:
	0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan,7=white
	*/
	unsigned int pause=1500;		// flash screen so long...
	unsigned int p=0;				// pause counter
	ink(flashcolor);	// flash in color
	for (p=0;p<pause;p++){};
	ink(flashback);	// back to original
}
// Playerturn - 
void playerturn()	// filter keyboard input
{
	unsigned char key=0;			// code of key pressed	
	unsigned char canselect=0;		// 0=no, 1=yes (is the piece selectable?)
	char cursormovetype=-1;			// -1=no, 0=yes (n,s,e,w) 1=(north/south only), 2=(east/west only)
	char turn=1;					// determines end of player turn 1=playerturn, 0=end of playerturn
	char playertext[]="ATTACKERS";
	ons=ns;			// original ns board position
	oew=ew;			// original ew board position
	ocx=cx;			// original x screen position
	ocy=cy;			// original y screen position
	flashback=6;
	if ( playertype == 2 ) { strcpy(playertext,"DEFENDERS");}
	printf ("%c\n\n\n* %s Turn: Arrows move cursor.\n X:Select P:Possibles%c",19,playertext,19);
	blinkcursor();
	while (turn)				// repeat until move is made
		{
		key=getchar();		// get code of pressed key
		mkey=key;
		if (( key > 7 ) && ( key < 12 ))  // 8-11 = cursor keys 
			{
			cursormode=0;  // freeform
			movecursor2();  
			}		
		/*******************************************************/
		/* determine if X or P is selected (to select a piece) */
		/*******************************************************/
		if (( key == 88) || ( key == 80))	// if 'X' or 'P' is selected (88=X, 80=P)
			{
			canselect=0;		// set piece to NOT SELECTABLE
			if (( playertype == 1 )&&(players[ns][ew] == 1 )) { canselect=1;} // piece is selectable
			if (( playertype == 2 )&&((players[ns][ew] == 2 )||(players[ns][ew] == 3 ))) { canselect=1;} // piece is selectable
			if ( canselect )
				{
				if (canpiecemove()) 
					{ 
					//piecetype=players[ns][ew];
					flashcolor=2;flashscreen();	// flash green
					if ( key == 80 )		// if P is pressed
						{ 
						printpossiblemoves();	// Print possible moves
						printf ("%c\n\n\n* %s Turn: Arrows move cursor.\n X:Select P:Possibles%c",19,playertext,19);
						}
					}
				else 
					{ 
					flashcolor=1;flashscreen();	// flash red
					canselect=0;		// unselectable, cannot move
					}				
				}
			else { flashcolor=1;flashscreen();}	// flash red			
			if (( mkey == 88 )&&( canselect ))	// if piece is SELECTED and CAN move
				{
				ink(2); 				// green to indicate piece is selected
				flashback=2;
				printf("%c\n\n\n%s Turn X=Selects/Deselects. R=Reset%c",19,playertext,19);
				inversex=cx;
				inversey=cy+1;
				inverse();				// highlight selected square (inverse color)
				mkey=0;					// ensure mkey at known value
				// set Original cursor and board position of selected square
				ocx=cx; ocy=cy; ons=ns; oew=ew;
				while (( mkey != 88 ) && ( mkey != 82)) // move cursor until X or R selected
					{
					if (( ons == ns )&&( cursormovetype<0)) { cursormovetype=1; }// cursor allowed north-south
					if (( oew == ew )&&( cursormovetype<0)) { cursormovetype=2; }// cursor allowed east-west
					if (( ons == ns )&&	(oew == ew )) { cursormovetype=0;} 	 	 // cursor can move 	
					if (( cursormovetype == 2) && (( mkey == 8)	||(mkey == 9)))	{cursormovetype=-1;}//!move 
					if (( cursormovetype == 1) && (( mkey == 10)||(mkey == 11))){cursormovetype=-1;}//!move
					if (( cursormovetype == 0) && (( mkey == 8)	||(mkey == 9)))	{cursormovetype=1;}	//move
					if (( cursormovetype == 0) && (( mkey == 10)||(mkey == 11))){cursormovetype=2;}	//move
					if ( cursormovetype > 0 ) 
						{
						cursormode=1;	// restricted
						movecursor2();
						}
					if ( cursormovetype < 0) { flashcolor=1;flashscreen();}	// flashscreen red
					mkey=getchar();
					}
				if ( mkey == 82 ) // R has been selected, Reset cursor to original positions
					{
					fb=0;
					drawcursor();		// blank out cursor at current position
					cx=ocx;						// reset coords and board values to original positions
					cy=ocy;
					ns=ons;
					ew=oew;
					inversex=cx;
					inversey=cy+1;
					inverse();		// inverse square
					fb=1;
					drawcursor();		// draw cursor at original selected position
					}
				if ( mkey == 88 )				// if X selected
					{
					inversex=ocx;
					inversey=ocy+1;
					inverse();			// inverse original position
					if (( ons == ns )&&( oew == ew))// X is in original position so return to cursor movement 
						{
						mkey=0;		// piece de-selected
						} 
					else{ 
						movepiece();	// move selected piece				
						turn=0;		// player has ended turn
						}
					}
				}
			ink(6);	// back to cyan	
			flashback=6;		
			}		// key = X or P
		}	// While player turn		
}
// Moves selected piece to new location - updating board arrays and re-drawing tiles where necessary
void movepiece()
{ 
char p1=1;	// piece type comparison (lower) - used for determining takes - default=attacker
char p2=1;	// piece type comparison (upper) - used for determining takes - default=attacker
piecetype=players[ons][oew];	// obtain type of piece
// move piece
fb=0;
drawcursor();				// blank out cursor at new selected position
tilex=cx+1;
tiley=cy+1;
drawpiece();				// draw piece at new location
players[ns][ew]=piecetype;	// update square with player info
blankx=ocx+1;
blanky=ocy+1;
blanksquare();				// blank out square
players[ons][oew]=0;		// blank original location
if (tiles[ons][oew] > 0)	// draw tile at old positions
	{
	fb=1;
	tilex=ocx+1;
	tiley=ocy+1;
	if (tiles[ons][oew] == 1) 	{ drawattackertile();}
	if (tiles[ons][oew] == 2) 	{ drawdefendertile();}
	if (tiles[ons][oew] >2) 	{ drawkingtile();}
	}
// having moved piece we now need to check for, and implement any TAKES
if (piecetype > 1 )	// if defender
	{
	p1=2;
	p2=3;
	}
if ( ns > 1 ) // check north
	{
	orientation=1;
	if ( cantakepiece() ) { tpns=ns-1; tpew=ew; takepiece(); }
	}
if ( ns < 9 ) // check south
	{
	orientation=2;
	if ( cantakepiece() ) { tpns=ns+1; tpew=ew; takepiece(); }
	}
if ( ew < 9 ) // check east
	{
	orientation=3;
	if ( cantakepiece() ) { tpns=ns; tpew=ew+1; takepiece(); }
	}
if ( ew > 1 ) // check west
	{
	orientation=4;
	if ( cantakepiece() ) { tpns=ns; tpew=ew-1; takepiece(); }
	}	
}
// Will return a value (take) who's values will be: 0= no, 1=yes
char cantakepiece()
{
char take=0;
char taketotal=0;
char p1=1;	// piece type comparison (lower) - used for determining takes - default=attacker
char p2=1;	// piece type comparison (upper) - used for determining takes - default=attacker
char pcheckns1=ns-1;	// defaults to north
char pcheckns2=ns-2;
char pcheckew1=ew;
char pcheckew2=ew;
piecetype=players[ns][ew];	// obtain type of piece
if (piecetype > 1 )	// if defender
	{
	p1=2;
	p2=3;
	}
if ( orientation == 2)	// if south
	{
	pcheckns1=ns+1;
	pcheckns2=ns+2;
	}
if ( orientation > 2)	// if east or west
	{
	pcheckns1=ns;
	pcheckns2=ns;
	pcheckew1=ew+1;
	pcheckew2=ew+2;
	if ( orientation == 4) // if west
		{
		pcheckew1=ew-1;
		pcheckew2=ew-2;
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
void takepiece()
{
unsigned char tpx=boardx+(boxsize*tpew+2);
unsigned char tpy=boardy+(boxsize*tpns+2);
blankx=tpx;
blanky=tpy;
blanksquare();				// blank out square
players[tpns][tpew]=0;		// zero players
if (tiles[tpns][tpew] > 0)	// draw tile at deleted position
	{
	fb=1;
	tilex=tpx;
	tiley=tpy;
	if (tiles[tpns][tpew] == 1) { drawattackertile();}
	if (tiles[tpns][tpew] == 2) { drawdefendertile();}
	if (tiles[tpns][tpew] >2 ) { drawkingtile();}
	}
}