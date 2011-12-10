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
// 18-05-2011 developing attacker move (running out of memory! 31213!) hardly started
// 26-05-2011 1st attempt at computer moving piece (since Amiga days! 1990/1991?)
// 31-05-2011 fixed bug in board update position? (phantom attackers!)
// 06-06-2011 incorporated printdestinations into computerturn saving wedges of code
// 08-06-2011 fixed bug in computer targetselection (cantake wasn't resetting to 0)
// 13-06-2011 fixed bug in canbetaken (mostly fixed)
// 15-06-2011 fixed "blind spot"
// 15-06-2011 changed checkend to enable "king surrounded against board edge" facility (works)
// 15-06-2011 The AI will only be for ATTACKERS (for the moment)
// 16-06-2011 various improvements
// 17-06-2011-11-07-2011 various tomfoolery to reduce memory footprint
// 12-07-2011 New variables to check for pieces NSEW of King
// 31-08-2011 prevent attackers occupying corner squares
// 12-10-2011 using 18x18 squares (unfinished...needs LOTS of work!!!)
// 17-10-2011 using new routine to draw tiles
// 18-10-2011 tidied up graphic routines (reduced size of code/executable)
// 20-10-2011 Added expodetile function (playes animation to "kill" a piece) plus pause function (reduces executable size)
// 20-10-2011 made graphics drawing more efficient (saved 300bytes)
// 21-10-2011 added STEELDIAMOND function (create higher target values in a diamond shape around king)
// 24-10-2011 Fixed bug with crashes at south-east corner of board (counter must be SIGNED)
// 24-10-2011 Fixed a bug regarding counter - much stronger AI!
// 24-10-2011 Play again? (needs work)
// 27-10-2011 Fixing the "enemy one space away ENEMY UDATE issue" - set value=50
// 31-10-2011 Added the COMPUTER array (where the computers's pieces can get to)
// 02-11-2011 Added Select gamestyle (human vs computer or human vs human selection)
// 02-11-2011 GONZO! the -50 behaviour is interesting - still crashing though...
// 09-11-2011 LookBackInAnger routine (attackers to check behind their original position)
// 10-11-2011 Now checks to see if a piece can be taken if it stays where it is (needs some finessing)
// 14-11-2011 Improved the above routine
// 16-11-2011 compress routines more (free up some memory)
// 06-12-2011 fixed a couple of bugs (I think)
// 08-12-2011 got rid of baseplayers as unnecessary (it's just a copy of tiles)
// 08-12-2011 shrunk code still further - added calctakeweight routine
// 08-12-2011 shrunk code again (33524) - added enemyzero routine and simplified surrounded routines
// 08-12-2011 found/fixed bug in the previous surrounded routine during simplification
/* TODO LIST
*** Continue with endgame function to return a value determining victory conditions etc
*** routine to detect if all attackers have been captured
*** routine to detect stalemate (a side cannot move)
*** Improve the hightarget routine to select the BEST piece to move (rather than the 1st it finds)
*/
#include <lib.h>
//#include <math.h>
//#define CHAR_BIT 8
extern unsigned char PictureTiles[];	// standard graphics for pieces and backgrounds
extern unsigned char ExplodeTiles[];	// extra graphics to "explode" a piece (animation)
/******************* Function Declarations ************************/
void drawcursor();			// draws cursor 
void inverse();				// inverse the color in the square
void drawtiles();			// draws all tiles at board x,y boxsize z (uses draw*tile functions)
void drawboard();			// kicks off drawgrid/drawtiles
void playerturn();			// takes user input to move cursor
void drawplayers();			// draw playing pieces
void flashscreen();			// flashes screen in selected color for a second or so
void canpiecemove();		// can a selected piece move? 0=no, 1=yes
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
void pacman();				// update target positions around king (need to develop further)
void targetselect();		// choose a target square
void findpiecens();			// findpiece north-south
void findpieceew();			// findpiece east-west
void canbetaken(); 			// can I be taken after moving here? returns value (take) 0=no 1=yes
void subarrows();			// subroutine of arrows or blanks
void subarrows2();			// subroutine of arrows or blanks (updates ENEMY with direction of enemy)
void subpacman();			// subroutine of pacman
void subpacman2();			// subroutine of pacman
void subpacman3();			// sub of subpacman
void subpacman4();			// sub of subpacman2
void subpacmanx();			// grand sub of pacman
void subcanbetaken();		// sub of canbetaken
void inccantake();			// increments cantake
void incroute();			// incs route
void decroute();			// decs route
void drawtile();			// draw a tile (subroutine of drawtiles)
void drawpiece();			// draws piece
void drawarrow();			// draws "arrow"
void printmessage();		// prints message to screen
void printturnprompt();		// prints "your turn" message
void surroundcount();		// counts the number of attackers surrounding KING (or edges, or central square)
void incsurround();			// increment "surrounded" variable
void explodetile();			// explodes a piece (plays an animation)
void pause();				// wait a certain period of time (pausetime)
void tileloop();			// subdir of explodetile and drawtile
void surroundpoints();		// increment points around king depending on "surrounded" figure
void incpoints();			// increment points variable
void decpoints();			// decrement points variable
void setpoints();			// set points to default value
void zerocounter();			// set counter=0
void inccounter();			// inc counter
void deccounter();			// decrement counter
void doublepoints();		// doubles points
void LookBackInAnger();		// runs subcanbetaken if the piece "behind" an attacker is defender/king and prospective target adjacent to defender/king
void subLookBackInAnger();	// runs the various "lookbackinanger" checks
void inctarget();			// inc target[xns][xew]
void subcanbetaken2(); 		// attempt to reduce memory footprint
void surroundcheck();		// inc surrounded under various conditions
void calctakeweight();		// calculate the weight of "takeweight"
void enemyzero();			// set enemy value to zero when surrounded=3 
/****************** GLOBAL VARIABLES *******************************/
/* Populate array with tile types
Tile types:
0=blank
1=attacker square
2=defender square
3=king square
*/
extern const unsigned char tiles[11][11];	// tile description on board
extern unsigned char target[11][11];		// uninitialized variable (will calc on fly) - target values of square
/* populate array with places of players 
Players:
0=vacant
1=attacker resident
2=defender resident
3=king resident
4=corner square	// added 21/04/2011
*/
//extern char baseplayers[11][11];			// BASEPLAYERS - the starting board positions. PLAYERS is the working COPY of BASEPLAYERS 

// ARRAY ENEMY unititialized variable (will calc on fly) - can enemy reach a square?
// values:
// +1 Can be reached from NORTH
// +5 can be reached from SOUTH
// +10 can be reached from EAST
// +20 can be reached from WEST 
extern char enemy[11][11];		// where the defenders can get to
extern char computer[11][11];	// where the attackers can get to
char players[11][11];			// to be the working copy of baseplayers
const unsigned char boardx=12;	// starting x co-ord of board (for cursor drawing purposes)
const unsigned char boardy=0;	// starting y co-ord of board (for cursor drawing purposes)
const char boxsize=18;			// set boxsize (for cursor drawing purposes)
char playertype;			// player 1=attacker, 2=defender 
char piecetype;				// 1=attacker, 2=defender, 3=king
char ns;					// default north/south position of central square 	(0-10)
char ew;					// default east/west position of central square		(0-10)
unsigned char cx;			// cursor x screen position (pixels across)
unsigned char cy;			// cursor y screen position (pixels down)
char fb=1;					// foreground/background 0=background, 1=foreground, 2=opposite, 3=nothing
							// NOTE: fb now controls much more
unsigned char inversex;		// x position of square to be inversed (to highlight a selected piece)
unsigned char inversey;		// y position of square to be inversed (to highlight a selected piece)
char mkey;					// code of key pressed
char cursormode;			// cursor movement mode 0=freeform 1=restricted
char ons;					// original north/south board pos
char oew;					// original east/west board pos
unsigned char ocx;			// original xpos of piece
unsigned char ocy;			// original ypos of piece 
char orientation;			// for arrows - 0=north, 1=south 2=east 3=west
char tiletype;				// type of tile under inspection (used in arrows)
char tpns;					// north-south board location of taken piece (also used for 3) NB:no idea 20/10/2011
char tpew;					// east-west board location of taken piece
char flashcolor;			// color of ink to flash in
char flashback;				// color of ink to return to
char game;					// <=0 means endgame (see checkend for values), 1=GAMEON
char gamestyle;				// 0=human vs human; 1=human king vs computer; ** NO!!! 2=human vs computer king**; 3=undefined
char kingns;				// kings position North-South
char kingew;				// kings position East-West
char kingnorth;				// count of attackers NORTH of king
char kingsouth;				// count of attackers SOUTH of king
char kingeast;				// count of attackers EAST of king
char kingwest;				// count of attackers WEST of king
char defnorth;				// count of defenders NORTH of king
char defsouth;				// count of defenders SOUTH of king
char defeast;				// count of defenders EAST of king
char defwest;				// count of defenders WEST of king
char surrounded;			// status of king "surrounded" status		//
char ctns=0;				// Computer Turn north-south board position		
char ctew=0;				// Computer Turn east-west   board position 
char playertext[]="Attacker";
char turntext[]=" Turn:Use cursor keys.\nX:Select Piece P:Possible Moves";
char message[]="*";
char foundpiece=0;	// has a piece been found (during computer move) that can move to the hightarget square? 0=no, 1=yes&ok, 9=yes!ok
//char xloop=0;				// general purpose loop variable
char xns=0;					// copy of ns (arrows or blanks, and subarrows)
char xew=0;					// copy of ew (arrows or blanks, and subarrows)
char arrow=1;				// used in arrowsorblanks(and subarrows)
char flag=0;
char cantake;				// can I take?	(for computer turn)
char route;
unsigned char row;			// used in tile drawing routines and array navigation ( a row in 11x11 grid)
unsigned char col;			// used in tile drawing routines and array navigation ( a column in 11x11 grid)
unsigned char tiletodraw;	// used in tile drawing routines 0-11 (as at 18-10-2011)
int pausetime;				// amount of time to wait
unsigned char* ptr_draw;	// ptr to board starting position (e.g. 0xa002)
unsigned char* ptr_graph;	// pointer to byte values of loaded picture	
unsigned char points;		// points around king
char counter;				// general purpose counter (*** DO NOT set to UNSIGNED *** NB 24/10/2011)
char lookcol;				// used in lookbackinanger
char lookrow;				// used in lookbackinanger
char origorient;			// original orientation of a piece under test (which way he is heading)
char zns;					// copy of pieces north/south position (e.g row)
char zew;					// copy of pieces east/west position (e.g column)
char takerow;				// can I be taken if I stop here?
char takecol;				// can I be taken if i stop here?
char paclevel1;				// used in pacman/subpacmanx either ns/ew
char paclevel2;				// opposite of above
char paccount1;				// count of attackers relative to king in either n/s/e/w
char paccount2;				// count of defenders relative to king in either n/s/e/w
char surns;					// count of attackers surrounding king n/s used in surroundcount()
char surew;					// count of attackers surrounding king e/w used in surroundcount()
char takena;		// used in canbetaken routines
char takenb;		// used in canbetaken routines
char takenc;		// used in canbetaken routines
char takend;		// used in canbetaken routines
char takene;		// used in canbetaken routines
char takenf;		// used in canbetaken routines
char ezns1;			// used in surroundcount/enemyzero to reset enemy[][] to zero if surrounded=3
char ezns2;			// used in surroundcount/enemyzero to reset enemy[][] to zero if surrounded=3
char ezew1;			// used in surroundcount/enemyzero to reset enemy[][] to zero if surrounded=3
char ezew2;			// used in surroundcount/enemyzero to reset enemy[][] to zero if surrounded=3
// WEIGHTS
char enemyweight=37;		// >36. weight of "enemy could get here but piece occupied by attacker"
char takeweight;			// weight assigned to a TAKE 
char canbetakenweight=10;	// weight to be applied to escape postion if can be taken
//int absnum;				// absolute value of number
/****************** MAIN PROGRAM ***********************************/
main()
{
char gamekey=89;	// controls "play again?"
char gameinput=0;	// 0=undefined 1=play against computer, 2=human vs human
paper(0);
ink(5);				// color of TEXT in text box at bottom
hires();
ink(6);				// boardcolor 0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan,7=white
playertype=0;					// set to 0 as inited later
while (gamekey==89)
	{
	drawboard();					// draw the board
	printf("%c",19);			// turn off screen output (means cursor movement doesn't affect oric cursor
	while (gamestyle==3)
		{
		strcpy(message,"Select Game Type:\nEnter number of humans:");
		printmessage();
		gameinput=getchar();
		if ( gameinput == 49 ) gamestyle=1;	// 1=human vs computer (as DEFENDERS)
		if ( gameinput == 50 ) gamestyle=0;	// 0=human vs human
		if ( gamestyle == 3 ) ping();
		}
	while (game>0)
		{
		ns=5;						// default north/south position of central square
		ew=5;						// default east/west position of central square
		cx=1+boardx+(boxsize*ew);	// cursor x screen position
		cy=1+boardy+(boxsize*ns);	// cursor y screen position
		playertype++;				// playertype inited as 0 so ++ will make it 1 at start of game
		if ( playertype == 3 ) { playertype = 1; } // was defender, set to attacker player
		//if (( gamestyle == 0 )||((gamestyle==1)&&(playertype==2))||((gamestyle==2)&&(playertype==1)))
		if (( gamestyle == 0 )||((gamestyle==1)&&(playertype==2)))
			{
			playerturn();			// player input
			}
		else
			{
			computerturn();			// computer has a go...
			}				
		checkend();					// check for end of game conditions
		}	
	if ( game == 0 ) 
		{ 
		strcpy(message,"KING ESCAPED! King Wins!\nPlay Again Y/N?"); 
		printmessage();
		}
	else 
		{ 
		strcpy(message,"KING CAPTURED! Attacker Wins!\nPlay Again Y/N?");
		printmessage();
		}
	gamekey=getchar();
	if (gamekey==89)	// if "Y"
		{
		printf("%c",19);	// turn output ON
		}
	}
}
/********************* FUNCTION DEFINITIONS ************************/
void computerturn()
{
//unsigned int xrand=srandom(deek(630));	// seed random number generator
//if ( playertype == 1 ) { strcpy(playertext,"ATTACKER");}else{ strcpy(playertext,"KING");}
strcpy(message,"ORIC IS THINKING..");
printmessage();
//printf("\n\n\nORIC IS THINKING..");
// 1. initialize target, enemy and computer array to zeroes
ClearTargetAndEnemy();
// 2. Loop through players array searching for enemy pieces - calculating where they can go
fb=5;
pacman1:
for (ctns=0;ctns<11;ctns++)
	{
	for (ctew=0;ctew<11;ctew++)
		{
		ew=ctew;
		ns=ctns;
		if ( fb==5 )	// fb=5 means: don't print destinations, just update ENEMY
			{	
			if (( players[ctns][ctew]==2 )||(players[ctns][ctew]==3)) // if enemy found
				{
				printdestinations();	// update enemy array of possible locations
				}
			}
		else			// fb=6 (will update COMPUTER array) fb=3 (update TARGET array)
			{
			if ( players[ctns][ctew]==1) // if attacker found
				{
				printdestinations();		
				}
			}
		}
	}
if (fb==5) { fb=6;goto pacman1;}	// after updating enemy array, update COMPUTER array
if (fb==6) { fb=3;goto pacman1;}	// after updating both arrays, update TARGET
if (fb==3) { fb=7;goto pacman1;}	// now check to see if an attacker can be caught if he stays where he is

// 3. Increment target positions around King (PACMAN)
pacman();
//if ( playertype == 1 ) {pacman();}
// other routines to go here to update the target array
// 4,5,6,7..N etc
// 
targetselect();	// Choose the highest value target 
movepiece();	// make the move
}
/*********************************************/
void findpiecens()	// find piece NORTH-SOUTH
{
if ( foundpiece == 0 )	
		{
		//if ( playertype == 1 )
		//	{
			if (players[mkey][ew]==1){ foundpiece=1;ons=mkey;}
			if (players[mkey][ew] > 1) { foundpiece=9;}
		//	}
		/*
		if ( playertype == 2 )
			{
			if ((players[mkey][ew]==2)||(players[mkey][ew] == 3)) { foundpiece=1;ons=mkey; }
			//if (players[mkey][ew] == 1) { foundpiece=9; }
			}
		*/
		}
}
/**************************************************/
void findpieceew()	// find piece EAST-WEST
{
if ( foundpiece == 0 )	
		{
		//if ( playertype == 1 )
		//	{
			if (players[ns][mkey] == 1){ foundpiece=1;oew=mkey;}
			if (players[ns][mkey] > 1) { foundpiece=9;}
		//	}
		/*
		if ( playertype == 2 )
			{
			if ((players[ns][mkey] == 2)||(players[ns][mkey] == 3)) { foundpiece=1;oew=mkey; }
			//if (players[ns][mkey] == 1) { foundpiece=9; }
			}
		*/
		}	
}
/*********************************************************/
// TARGETSELECT - find the highest scoring TARGET
void targetselect()
{
unsigned char hightarget=0;	// contains highest value target
foundpiece=0;		// set findpiece to "piece not found"
for (ctns=0;ctns<11;ctns++)	// find the highest value for target
	{
	for (ctew=0;ctew<11;ctew++)
		{
		if ( target[ctns][ctew] > hightarget )
			{
			hightarget=target[ctns][ctew];	// make hightarget the highest value
			ns=ctns;		// make ns/ew be hightarget co-ords
			ew=ctew;		
			ons=ctns;	// target is accessible so make ons/oew the default piece position to move
			oew=ctew;	// the ACTUAL piece to move determined below (one of ons or oew will remain same)
			}
		}
	}
// having found target we need to select a piece to move
for (mkey=ns-1; mkey>-1; mkey--)	{findpiecens();}	// check NORTH
if ( foundpiece != 1 ) { foundpiece=0;}
for (mkey=ns+1; mkey<11; mkey++) 	{findpiecens();}	// Check SOUTH
if ( foundpiece != 1 ) { foundpiece=0;}
for (mkey=ew+1; mkey<11; mkey++)	{findpieceew();}	// Check EAST
if ( foundpiece != 1 ) { foundpiece=0;}
for (mkey=ew-1; mkey>-1; mkey--)	{findpieceew();}	// Check WEST
cx=1+boardx+(boxsize*oew);	// piece x screen position
cy=1+boardy+(boxsize*ons);	// piece y screen position
blinkcursor();			// draw cursor in foreground color at piece to move position cx,cy
fb=0;drawcursor();		// blank cursor
cx=1+boardx+(boxsize*ew);	// target x screen position
cy=1+boardy+(boxsize*ns);	// target y screen position
blinkcursor();			// draw cursor in foreground color at target position cx,cy
ocx=1+boardx+(boxsize*oew);	// piece to move x screen position
ocy=1+boardy+(boxsize*ons);	// piece to move y screen position
//printf("%cNS=%d,EW=%d,ONS=%d,OEW=%d%c",19,ns,ew,ons,oew,19);
//loop=getchar();
}
/************************************************/
void subpacmanx()
{
char x;
char y;
char z=paccount1+paccount2; // how many pieces (attackers and defenders in a particular direction
setpoints();
if ((paclevel1<3)||(paclevel1>7)) { incpoints(); }
if ((orientation == 0) || (orientation == 3)) // if north or west
	{
	counter=paclevel2-1;
	if ( paclevel2<5 ) { incpoints();} // add weight to north or west if king in north or west side of board	
	}
if ( (orientation == 1 )||(orientation == 2)) // if south east
	{ 
	counter=paclevel2+1;
	if ( paclevel2>5 ) { incpoints();} // add weight to south or east if king in south or east side of board
	}
if ( paccount1==0 ) { incpoints();}
if ( z==0 ) { doublepoints(); }		// if nobody on kings path, double the points added to target value
if ( z==1 ) 
	{ 
	incpoints();						// if only one piece on path, add 1
	if (paccount2) {incpoints();};  // if piece is a defender add another 1
	}
//if ( z>1 ) { decpoints(); }			// remove points if route is already populated
	
surroundpoints();
// default north/south
x=counter;
y=paclevel1;
if ( orientation>1) // if east/west
	{
	x=paclevel1;
	y=counter;
	}
if ( (orientation==0) || (orientation==3) )
	{
	while ((players[x][y] != 1 )&&(counter>-1))
		{
		if ( target[x][y] > 1 )	// possible issue if surrounded =3 and can be taken
			{ 
			target[x][y]+=points;// inc target only if accessible by attacker
			}
		if ( target[x][y]==0) // not accessible by attacker
			{
			if ( orientation==0) { subpacman();}else{subpacman2();}
			}
		decpoints();
		deccounter();
		if ( orientation == 0 ) {x=counter;}else{y=counter;}
		}
	}
if ( (orientation==1) || (orientation==2) )
	{
	while ((players[x][y] != 1 )&&(counter<11))
		{
		if (target[x][y] > 1 )
			{ 
			target[x][y]+=points;// inc target only if accessible by attacker
			}
		if ( target[x][y]==0) 
			{
			if (orientation==1) {subpacman();}else{subpacman2();}
			}
		decpoints();
		inccounter();
		if ( orientation == 1 ) {x=counter;}else{y=counter;}
		}
	}
}
/************************************************/
void pacman()		// PACMAN	( increment target positions around king )	
{
//int xrand=random()/1000;	// random number between 0-32
surroundcount();		// updates "surrounded"
// NORTH
orientation=0;
paclevel1=kingew;
paclevel2=kingns;
paccount1=kingnorth;
paccount2=defnorth;
subpacmanx();
//SOUTH
orientation=1;
paccount1=kingsouth;
paccount2=defsouth;
subpacmanx();
// EAST
orientation=2;
paclevel1=kingns;
paclevel2=kingew;
paccount1=kingeast;
paccount2=defeast;
subpacmanx();
// WEST
orientation=3;
paccount1=kingwest;
paccount2=defwest;
subpacmanx();
/*
while ((players[kingns][counter] != 1 )&&(counter>-1))
	{
	if ( target[kingns][counter] > 1 )
		{
		target[kingns][counter]+=points;// inc target only if accessible by attacker
		}
	if ( target[kingns][counter]==0) {subpacman2();}
	decpoints();
	deccounter();
	}
*/
}

/************************************************/
void subpacman()		// increase target positions that LEAD to a king target
{
	flag=0;
	for (mkey=kingew-1;mkey>-1;mkey--){subpacman3();}
	flag=0;
	for (mkey=kingew+1;mkey<11;mkey++){subpacman3();}
}
/************************************************/
void subpacman2()
{
	flag=0;
	for (mkey=kingns-1;mkey>-1;mkey--){subpacman4();}
	flag=0;
	for (mkey=kingns+1;mkey<11;mkey++){subpacman4();}	
}
/*****************************/
void subpacman3()
{
if ( players[counter][mkey] ) { flag=1;}
if ((flag==0)&&(target[counter][mkey]>1 )) { target[counter][mkey]++; }
}
void subpacman4()
{
if ( players[mkey][counter] ) { flag=1;}
if ((flag==0)&&(target[mkey][counter]>1 )) { target[mkey][counter]++; }
}
/************************************************/
void checkend()	// check for endgame conditions
{
	/* Victory Conditions 
	game=0 King escapes. 										// DONE
	game=-1 King Surrounded in open play or by central square 	// DONE
	game=-2 King surrounded by attackers and corner squares		// DONE
	game=-3 King surrounded by attackers and edge of board		// DONE
	game=-4 defenders cannot move (stalemate)					// TBD
	game=-5 attackers cannot move (stalemate)					// TBD
	game=-6 all attackers eliminated 							// TBD
	*/
	//char kingfound=0;	// 0=king not found 1=king found 
	// ns and ew contains new board co-ords of last piece moved
	if (( players[ns][ew] == 3 ) && ( tiles[ns][ew] == 4 )) { game=0; }		// king has escaped
	// check to see if king is surrounded by attackers (first find king)
	if ( players[ns][ew] == 1 )	// if attacker was last to move
		{
		if (((ns>0 )&&(players[ns-1][ew]==3 ))||((ns<10 )&&(players[ns+1][ew]==3 ))||((ew<10 )&&(players[ns][ew+1]==3 ))||((ew>0 )&&(players[ns][ew-1]==3 ))) 
			{
			//printf("%cCHECKEND SURROUNDCOUNT-START%c",19,19);
			surroundcount();
			//printf("%cCHECKEND SURROUNDCOUNT-END%c",19,19);
			}
//		if (( kingns==0)||(kingns==10)||(kingew==0)||(kingew==10)) { surrounded++;}
		if ( surrounded == 4 ) { game=-1;}	// king is surrounded on all sides by attackers or king squares
		}
}
/************************************************/
void movecursor2() // routine to move the cursor
{
/*
cursormode = [0 or 1] 0=unrestricted (move anywhere), 1= restricted (only move to possible destinations)
*/
char canmovecursor=0;
char multiple=1;	// concerning central square (how much to multiply the coords to SKIP the square
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
/************************************************/
void inverse()
{
	/* Draw an inversed colr box to highlight selected box
	ix=screen x position
	iy=screen y position
	*/
	char iz=boxsize-3;
	for (counter=0;counter<iz;inccounter())
		{
		curset(inversex,inversey,3);
		draw(iz,0,2);		// draw inverse line
		inversey++;
		}
}
/************************************************/
void printpossiblemoves()
{
	/*  kicks off functions that print appropriate arrows at all possible destinations and blanks
	them out afterwards*/
	char k;	// key entered
	fb=1;
	printdestinations();	// print arrows on all destinations	
	strcpy(message,"* press any key to proceed *");
	printmessage();
	k=getchar();
	fb=0;
	printdestinations();	// blank out arrows on all destinations
}
/************************************************/
void printarrowsorblanks()	// used in printdestinations
{
char xplayers;		// player type at square under test 
zns=ns;		// another copy of ns (for computer turn)
zew=ew;		// another copy of ew (for computer turn)
origorient=orientation; // original orientation (for computer turn)
//char cantake=0;		// can I take?	(for computer turn)
//unsigned char subloop=0;
cantake=0;
xns=ns;
xew=ew;
arrow=1;
//arrowsx=cx+1;
//arrowsy=cy+1;
// orientation 0,1,2,3 = N, S, E, W
takerow=ns;takecol=ew; // will set below to be the opposite of the orientation
if ( orientation == 0 ) { xplayers=players[xns-1][xew];takerow=xns+1;} // check north
if ( orientation == 1 ) { xplayers=players[xns+1][xew];takerow=xns-1;} // check south
if ( orientation == 2 ) { xplayers=players[xns][xew+1];takecol=xew-1;} // check east
if ( orientation == 3 ) { xplayers=players[xns][xew-1];takecol=xew+1;}  // check west
if ( xplayers == 0 )	// if adjacent square is OK
	{
	//arrow=1;
	while ( arrow == 1 ) // keep checking until cannot move
		{
		if (( orientation == 0 ) && ( xns ))  // check north
			{
			xns--;			// decrement provisional north-south player position
			subarrows();
			}
		if (( orientation == 1 ) && ( xns < 10 )) // check south
			{
			xns++;			// increment provisional north-south player position
			subarrows();
			}
		if ((orientation == 2 ) && ( xew < 10 )) // check east
			{
			xew++;			// increment provisional east-west player position
			subarrows();
			}
		if ((orientation == 3 ) && ( xew )) // check west
			{
			xew--;			// decrement provisional east-west player position
			subarrows();
			}
		tiletodraw=tiles[xns][xew];				// obtain type of tile	
		if ( arrow == 1 )						// if MODE is "draw an arrow" (aka: I can move here)
			{
			row=xns;
			col=xew;
			if (fb==1) {drawarrow();}
			if (fb==5)	// computer turn - the enemy can reach this square
				{ 
				subarrows2(); // update enemy array
				}
			if (fb==3)	// computer turn - I can reach this square, is it desirable?	
				{
				target[xns][xew]=2;		
				target[5][5]=0;		// set "illegal" squares to zero
				target[0][10]=0;
				target[0][0]=0;
				target[10][0]=0;
				target[10][10]=0;
				/*
				if ((xns>0) && (players[xns-1][xew]==2 )){inctarget();} 
				if ((xns<10)&& (players[xns+1][xew]==2 )){inctarget();}
				if ((xew>0) && (players[xns][xew-1]==2 )){inctarget();} 
				if ((xew<10)&& (players[xns][xew+1]==2 )){inctarget();} 
				*/
				// check to see if computer can take a piece
				ns=xns;
				ew=xew;	
				inccantake();
				if ( orientation<2 ) // heading north/south
					{
					orientation=2; inccantake();
					orientation=3; inccantake();	
					}
				if ( orientation>1) // heading east/west
					{
					orientation=0; inccantake();
					orientation=1; inccantake();
					}
				orientation=origorient; //reset orientation				
				target[xns][xew]+=(cantake*takeweight); // add cantake (will be zero if cannot take)
				if (cantake==0)	{canbetaken();}		// sets target to 1 if cannot take but can be taken
				/*
				if (((xns==kingns)||(xew==kingew))&&( surrounded == 3 )) 
					{
					target[xns][xew]=100;
					}
				*/
				cantake=0;	// reset cantake
				ns=zns;		// reset ns
				ew=zew; 	// reset ew
				}
			if ( fb == 0) 	// if MODE is "blank an arrow"
				{
				row=xns;
				col=xew;
				drawarrow();
				}
			}	
		// have we reached the end of the board?
		if (( orientation == 0 ) && ( xns == 0 )) 	{ arrow=0;}	// check north
		if (( orientation == 1 ) && ( xns == 10 )) 	{ arrow=0;}	// check south
		if (( orientation == 2 ) && ( xew == 10 )) 	{ arrow=0;}	// check east
		if (( orientation == 3 ) && ( xew == 0 )) 	{ arrow=0;}	// check west
		}			
	}
else	// xplayers !=0
	{
	if ((fb==7)&&(xplayers!=1))	// check to see if an attacker can be caught if he stays where he is
		{
		if ((players[takerow][takecol]==0)&&(target[takerow][takecol]>0)&&(enemy[takerow][takecol])&&(enemy[takerow][takecol]<enemyweight)) 
			{
			target[takerow][takecol]+=canbetakenweight;
			//if (xplayers==3) { target[takerow][takecol]+=5;}	// add 5 if adjacent piece is a KING (not sure if this makes any difference!)
			}
		}
	}
}
/************************************************/
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
/************************************************/
void canpiecemove() // CAN A SELECTED PIECE MOVE?
{
	// returns 0 or 1 depending on wether a piece can move or not
	// int route=0;				// number of possible routes
	route=0;
	piecetype=players[ns][ew];	// determine TYPE of selected piece (1=attacker, 2=defendr, 3=king)
	/*  for all piece types determine if adjacent square in any direction is blank or not
	it won't bother checking a particular direction if piece is at edge of board.
	*/
	if ( ns )		// check north
		{
		if ( players[ns-1][ew] == 0 ) incroute();
		if (( piecetype == 3 )&&(players[ns-1][ew] == 4 )) incroute(); // KING: corner square OK 
		}
	if ( ns < 10 )		// check south
		{
		if ( players[ns+1][ew] == 0 ) incroute(); 
		if (( piecetype == 3 )&&(players[ns+1][ew] == 4 )) incroute(); // KING: corner square OK 
		}
	if ( ew < 10 )		// check east
		{
		if ( players[ns][ew+1] == 0 ) incroute(); 
		if (( piecetype == 3 )&&(players[ns][ew+1] == 4 )) incroute(); // KING: corner square OK 
		}
	if ( ew )		// check west
		{
		if ( players[ns][ew-1] == 0 ) incroute(); 
		if (( piecetype == 3 )&&(players[ns][ew-1] == 4 )) incroute(); // KING: corner square OK 
		}
	/* In the case that the central square is unnocupied and a piece is adjacent to that square then - for
	non-KING Pieces only - we need to check to see if the opposite square is occupied or not. 
	ROUTE will be decremented if that piece is occupied (as no piece can occupy the central square except for
	the King but all pieces can traverse it */
	if (( piecetype < 3 ) && ( players[5][5] == 0 ))	// if not a king and central sqr unoccupied
		{
		if ( ns == 5 ) 				
			{
			if ( ew == 4 ) {if ( players[5][6] > 0 ) decroute();}	// check east +2	// east occupied, dec route
			if ( ew == 6 ) {if ( players[5][4] > 0 ) decroute();}	// check west +2	// west occupied, dec route
			}
		if ( ew == 5 )
			{
			if ( ns == 4 ) { if ( players[6][5] > 0 ) decroute();}	// check south +2	// south occupied, dec route
			if ( ns == 6 ) { if ( players[4][5] > 0 ) decroute();}	// check north +2	// north occupied, dec route
			}
		}
	if ( route > 0 ) route=1;
	//return route;
}
/************************************************/
void drawplayers() // DRAW ALL THE PIECES ON THE BOARD
{
	for (row=0;row<11;row++)
		{
		for (col=0;col<11;col++)
			{
			if (( players[row][col] > 0 )&&(players[row][col] < 4)){drawpiece();}			
			}
		}
}
/************************************************/
void drawtiles() // DRAW ALL THE TILES ON THE BOARD
{
	for (row=0;row<11;row++)
		{
		for (col=0;col<11;col++)
			{
			players[row][col]=tiles[row][col];	// populate players array
			tiletodraw=tiles[row][col];
			if ( tiletodraw==4 ) { tiletodraw=3;}
			drawtile();	
			}
		}
}
/************************************************/
void drawboard()	// DRAW THE BOARD
{
	game=1;				// game=1 means PLAY GAME
	gamestyle=3;		// 0=play against human, 1=play as DEFENDERS, 2=play as ATTACKERS, 3=nobody  
	kingns=5;kingew=5;	// DEFAULT kings board position
	kingnorth=2;		// count of attackers NORTH of king
	kingsouth=2;		// count of attackers SOUTH of king
	kingeast=2;			// count of attackers EAST of king
	kingwest=2;			// count of attackers WEST of king
	defnorth=2;			// count of defenders NORTH of king
	defsouth=2;			// count of defenders SOUTH of king
	defeast=2;			// count of defenders EAST of king
	defwest=2;			// count of defenders WEST of king
	surrounded=0;		// reset surrounded back to zero
	drawtiles();	// draw the background tiles
	//drawborder();
	curset(12,198,1);
	draw(198,0,1);
	draw(0,-198,1);
	drawplayers(); 	// draw the players
	//printf("%c",19);// turn output to screen off
}
/************************************************/
void blinkcursor() // blinks the cursor a number of times to attract attention
{
//char curloop;
//unsigned int subloop;
for (counter=0;counter<5;inccounter())	// flash the cursor to draw attention to it
	{
	fb=0; drawcursor();					// draw cursor in background color at cx,cy
	pausetime=250;pause();
	fb=1; drawcursor();					// draw cursor in foreground color at cx,cy
	pausetime=2000;pause();
	}
}
/************************************************/
void flashscreen() // flashes the screen in the selected ink color
{
	/* Colors are as follows:
	0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan,7=white
	*/
	ink(flashcolor);	// flash in color
	pausetime=1500;pause();
	ink(flashback);	// back to original
}
/************************************************/
void playerturn()	// The human players turn : filter keyboard input
{
	unsigned char key;			// code of key pressed	
	unsigned char canselect;		// 0=no, 1=yes (is the piece selectable?)
	char cursormovetype=-1;			// -1=no, 0=yes (n,s,e,w) 1=(north/south only), 2=(east/west only)
	char turn=1;					// determines end of player turn 1=playerturn, 0=end of playerturn
	ons=ns;			// original ns board position
	oew=ew;			// original ew board position
	ocx=cx;			// original x screen position
	ocy=cy;			// original y screen position
	flashback=6;
	if ( playertype == 2 )
		{ 
		strcpy(playertext,"King");
		}
	else
		{
		strcpy(playertext,"Attacker");
		}
	blinkcursor();
	printturnprompt();			// display instructions
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
				canpiecemove();
				if (route) 
					{ 
					//piecetype=players[ns][ew];
					flashcolor=2;flashscreen();	// flash green
					if ( key == 80 )		// if P is pressed
						{ 
						printpossiblemoves();	// Print possible moves
						printturnprompt();
						//strcpy(message,playertext);
						//strcat(message,turntext);
						//printmessage();
						//printf ("\n\n\n* %s Turn:Use cursor keys.\nX:Select P:Possible",playertext);
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
				//printmessage();
				//strcpy(message,playertext);
				strcpy(message,"Place cursor on destination\nX=Select Destination R=Reset/De-Select");
				printmessage();
				//printf("\n\n\n%s Turn X=Select R=Reset",playertext);
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
			printturnprompt();		
			}		// key = X or P
		}	// While player turn		
}
/********************************************************/
// Moves selected piece to new location - updating board arrays and re-drawing tiles where necessary
void movepiece()
{ 
char p1=1;	// piece type comparison (lower) - used for determining takes - default=attacker
char p2=1;	// piece type comparison (upper) - used for determining takes - default=attacker
piecetype=players[ons][oew];	// obtain type of piece
// move piece
fb=0;
drawcursor();				// blank out cursor at new selected position
row=ons;
col=oew;
tiletodraw=tiles[row][col];
drawtile();					// draw tile at original location (blank out square)
players[ons][oew]=0;		// set original location to zero (unnocupied)
players[ns][ew]=piecetype;	// update square with player info
row=ns;
col=ew;
drawpiece();				// draw piece at new location - 18-10-2011
if ( piecetype == 3 )	{ kingns=ns;kingew=ew;}	// update king position (used by AI)
// having moved piece we now need to check for, and implement any TAKES
if (piecetype > 1 )	// if defender
	{
	p1=2;
	p2=3;
	}
tpew=ew;
if ( ns > 1 ) // check north
	{
	orientation=0;
	if ( cantakepiece() ) { tpns=ns-1; takepiece(); }
	}
if ( ns < 9 ) // check south
	{
	orientation=1;
	if ( cantakepiece() ) { tpns=ns+1; takepiece(); }
	}
tpns=ns;
if ( ew < 9 ) // check east
	{
	orientation=2;
	if ( cantakepiece() ) { tpew=ew+1; takepiece(); }
	}
if ( ew > 1 ) // check west
	{
	orientation=3;
	if ( cantakepiece() ) { tpew=ew-1; takepiece(); }
	}
// update count of attackers around king
kingnorth=0;
kingsouth=0;
kingeast=0;
kingwest=0;
defnorth=0;
defsouth=0;
defeast=0;
defwest=0;
for (counter=0;counter<kingns;inccounter()) 	
	{ 
	if (players[counter][kingew]==1) {kingnorth++;}
	if (players[counter][kingew]==2) {defnorth++;}
	}
for (counter=kingns+1;counter<11;inccounter()) 
	{ 
	if (players[counter][kingew]==1) {kingsouth++;}
	if (players[counter][kingew]==2) {defsouth++;}

	}
for (counter=0;counter<kingew;inccounter()) 	
	{ 
	if (players[kingns][counter]==1) {kingwest++;}
	if (players[kingns][counter]==2) {defwest++;}
	}
for (counter=kingew+1;counter<11;inccounter())	
	{ 
	if (players[kingns][counter]==1) {kingeast++;}
	if (players[kingns][counter]==2) {defeast++;}
	}
}
/************************************************/
void subcanbetaken()
{
target[ns][ew]=1;
//if ((ns==kingns)||(ew==kingew)) { target[ns][ew]=3;}  // means acceptable risk
}
/************************************************/
void canbetaken() // can I be taken after moving here? 
{
if ((ns>0)&&(ns<10))
	{
	takena=ns-1;takenb=ew;takenc=ns+1;takend=ew;takene=1;takenf=0;
	subcanbetaken2();
	takena=ns+1;takenb=ew;takenc=ns-1;takend=ew;takene=5;takenf=1;
	subcanbetaken2();
	}
	
if ((ew>0)&&(ew<10))
	{	
	takena=ns;takenb=ew+1;takenc=ns;takend=ew-1;takene=10;takenf=2;
	subcanbetaken2();
	takena=ns;takenb=ew-1;takenc=ns;takend=ew+1;takene=20;takenf=3;
	subcanbetaken2();	
	}		
}
/************************************************/
// Will return a value (take) who's values will be: 0= no, 1=yes
char cantakepiece()
{
char take=0;
char taketotal=0;
char p1=1;	// piece type comparison (lower) - used for determining takes - default=attacker
char p2=4;	// piece type comparison (upper) - used for determining takes - default=attacker
char pcheckns1=ns-1;	// defaults to north
char pcheckns2=ns-2;
char pcheckew1=ew;
char pcheckew2=ew;
piecetype=players[ns][ew];	// obtain type of piece
//if ( fb==3) { piecetype=players[ctns][ctew];} // if computer turn set piecetype to piece being checked
if ( fb==3 ) { piecetype=1;}	// default = ATTACKER
if (piecetype > 1 )	// if defender
	{
	p1=2;
	p2=3;
	}
if ( orientation == 1)	// if south
	{
	pcheckns1=ns+1;
	pcheckns2=ns+2;
	}
if ( orientation > 1)	// if east or west
	{
	pcheckns1=ns;
	pcheckns2=ns;
	pcheckew1=ew+1;
	pcheckew2=ew+2;
	if ( orientation == 3) // if west
		{
		pcheckew1=ew-1;
		pcheckew2=ew-2;
		}
	}
// if a take is possible increment the take counter - if values fall within bounds...
if ((pcheckns2>-1)&&(pcheckns2<11)&&(pcheckew2>-1)&&(pcheckew2<11))
	{
	if (( players[pcheckns1][pcheckew1] > 0 )&&(players[pcheckns1][pcheckew1] != p1)&&(players[pcheckns1][pcheckew1] != p2)&&(players[pcheckns1][pcheckew1] != 3))
		{	
		if ((( players[pcheckns2][pcheckew2] == p1 )||(players[pcheckns2][pcheckew2] == p2 )||(players[pcheckns2][pcheckew2] == 4)&&(pcheckns2!=5)&&(pcheckew2!=5))) // the 5 is to EXCLUDE central square
			{
			take++;
			} 
		if ( computer[pcheckns2][pcheckew2] ) {inctarget();} // 31-10-2011 - can possibly take on next turn
		}
	}
if ( piecetype == 3 ) // if king and next to attacker and opposite square is a king square
	{
	if ((players[pcheckns1][pcheckew1] == 1 )&&(tiles[pcheckns2][pcheckew2] > 2)) { take++;}
	}
return take;
}
/************************************************/ 
void takepiece() // performs taking/removing a piece
{
players[tpns][tpew]=0;			// zero players
row=tpns;
col=tpew;
ink(6);
explodetile();					// plays animation to "kill" a tile
tiletodraw=tiles[row][col];		// decide tile to draw
drawtile();						// draw tile at location
}
/*****************************/
void subarrows()
{
if (players[xns][xew]) 
	{ 
	arrow = 0;	// !ok if piece occupied or corner square
	if ((fb==5)&&(players[xns][xew]==1)) {enemy[xns][xew]+=enemyweight;}	// means enemy could get here if attacker moved elsewhere
	}
if (( players[ns][ew] == 3)&&(tiles[xns][xew] == 4)) { arrow = 1; } // corner ok if king	
}
/*****************************/
void subarrows2()
{
if ( fb==5 )
	{
	if ( orientation==0 ) { enemy[xns][xew]+=5; }	// means enemy can get here from SOUTH
	if ( orientation==1 ) { enemy[xns][xew]+=1; }	// means enemy can get here from NORTH
	if ( orientation==2 ) { enemy[xns][xew]+=20; }	// means enemy can get here from WEST
	if ( orientation==3 ) { enemy[xns][xew]+=10; }	// means enemy can get here from EAST
	}
if ( fb==6 )
	{
	computer[xns][xew]++; // don't need to know the orientation
	if ( enemy[xns][xew] >0 ) { inctarget();};	// ADD WEIGHT TO EMPTY SQUARE IF IT CAN BLOCK AN ENEMY)
	/*
	if ( orientation==0 ) { computer[xns][xew]+=5; }	// means computer can get here from SOUTH
	if ( orientation==1 ) { computer[xns][xew]+=1; }	// means computer can get here from NORTH
	if ( orientation==2 ) { computer[xns][xew]+=20; }	// means computer can get here from WEST
	if ( orientation==3 ) { computer[xns][xew]+=10; }	// means computer can get here from EAST
	*/
	}
}
/*****************************/
void inccantake()
{
cantake+=cantakepiece();
}
/*****************************/
void incroute()
{
route++;
}
/*****************************/
void decroute()
{
route--;
}
/*********************************/
void drawtile()	// draws a board tile, player piece or "arrow"
{
unsigned int startpos;				// position in tile file from which to draw
ptr_graph=PictureTiles;				// pointer to Picture Tiles graphics
//ptr_draw=(unsigned char*)0xa002;	// pointer to start of board
//ptr_draw+=(col*3)+(row*720);		// 720=18*40 starting screen coordinate
startpos=(tiletodraw*54);			// 54=3*18 calc how many lines "down" in the graphic file to print from
ptr_graph+=startpos;				// set start position in graphic file
tileloop();
}
/*********************************/
void explodetile()	// Explodes a tile
{
unsigned char b;
ptr_graph=ExplodeTiles;					// pointer to byte values of loaded picture	
for (b=0;b<8;b++)
	{
	tileloop();
	pausetime=900;
	if (b==5) {pausetime=3000;} // pause longer on skull&crossbones
	pause();	// add a pause
	}	
}
/**************************************/
void tileloop()
{
//unsigned char a;
ptr_draw=(unsigned char*)0xa002;	// pointer to start of board
ptr_draw+=(col*3)+(row*720);		// 720=18*40 starting screen coordinate
for (counter=0;counter<18;inccounter())					// nn = tile height in pixels (e.g. 18)
	{
	ptr_draw[0]=ptr_graph[0];
	ptr_draw[1]=ptr_graph[1];
	ptr_draw[2]=ptr_graph[2];
	ptr_draw+=40;	// number of 6pixel "units" to advance (+40=next line down, same position across)
	ptr_graph+=3;	// + unit of measurement	(how many 6pixel chunks "across" in graphic file)
	}
}
/**************************************/
void drawpiece()
{
	tiletodraw=players[row][col];
	if ( tiletodraw>0) { tiletodraw+=3;}
	if ( tiles[row][col]>0 ) { tiletodraw+=3; }
	drawtile();
}
/**************************************/
void drawarrow()
{
	if ( fb==1 )
		{
		tiletodraw=10;
		if ( tiles[row][col] > 0 ) tiletodraw++;		// add another 1 for arrow with background
		}
	else
		{
		tiletodraw=tiles[row][col];						// draw original tile (includes blank)
		}
	drawtile();
}
/**************************************/
void printmessage()
{
//char c;
//PrintChr();	// turn output ON
/*
for (c=0;message[c]!='\0';c++)
		{
		putchar(c);
		}
*/
//printf("%c\n\n\n%s%c",19,message,19);
printf("%c\n\n\n%s%c",19,message,19);

//PrintChr();	// TURN OUTPUT off
}
/**************************************/
void printturnprompt()
{
strcpy(message,playertext);
strcat(message,turntext);
printmessage();
//printf("%c\n\n3/7=%d 6/7=%d%c",19,target[3][7],target[6][7],19);
//printf("%cSURROUNDED=%d%c",19,surrounded,19);
}
/**************************************/
void surroundcount()
{
char xflag=1;
zerocounter();
setpoints();
surrounded=0;
if (( kingns==0)||(kingns==10)||(kingew==0)||(kingew==10))	{incsurround();} // added 18/10/2011
surew=kingew;
if ( kingns > 0 )	{ surns=kingns-1;surroundcheck(); }
if ( kingns < 10 )	{ surns=kingns+1;surroundcheck(); }
surns=kingns;
if ( kingew > 0 )	{ surew=kingew-1;surroundcheck(); }
if ( kingew < 10 )	{ surew=kingew+1;surroundcheck(); }
if (surrounded==3)	// unset any "enemy values" that may prevent a "kill"
	{
	if ( kingns > 1 )
		{
		ezns1=kingns-1;ezew1=kingew;ezns2=kingns-2;ezew2=kingew;
		enemyzero();
		}
	if ( kingns < 9 )
		{
		ezns1=kingns+1;ezew1=kingew;ezns2=kingns+2;ezew2=kingew;
		enemyzero();
		}
	if ( kingew > 1 )
		{
		ezns1=kingns;ezew1=kingew-1;ezns2=kingns;ezew2=kingew-2;
		enemyzero();
		}
	if ( kingew < 9 )
		{
		ezns1=kingns;ezew1=kingew+1;ezns2=kingns;ezew2=kingew+2;
		enemyzero();
		}
	}
}
/****************************/
void incsurround()
{
	surrounded++;
}
/****************************/
void pause()
{
int p;
for (p=0; p<pausetime;p++){};
}
/****************************/
void incpoints()
{
points++;
}
/****************************/
void decpoints()
{
points--;
}
/****************************/
void setpoints()
{
points=10;
}
/****************************/
void doublepoints()
{
points*=2;
}
/****************************/


/******************************/
void surroundpoints()
{
//printf("%c* %d *%c",19,(points+(points*surrounded)),19);
points+=points*surrounded;	// multiply the points around king depending on the "surrounded" figure
}
/****************************/
void inccounter()
{
counter++;
}
/****************************/
void deccounter()
{
counter--;
}
/****************************/
void zerocounter()
{
counter=0;;
}
/****************************/
void LookBackInAnger()		// returns the value of the piece "behind" an attacker
{
lookrow=zns;	// copy of original attacker piece position (north-south e.g. row)
lookcol=zew;	// copy of original attacker piece position (east-west e.g column)
flag=0;			// status of foundpiece 0=no, 1=yes
if ( origorient == 0 ) 
	{
	for ( lookrow=zns-1;lookrow>-1;lookrow--)
		{
		subLookBackInAnger();
		}
	}
if ( origorient == 1 ) 
	{
	for ( lookrow=zns+1;lookrow<11;lookrow++)
		{
		subLookBackInAnger();
		}
	}
if ( origorient == 2 ) 
	{
	for ( lookcol=zew+1;lookcol<11;lookcol++)
		{
		subLookBackInAnger();
		}
	}
if ( origorient == 3 ) 
	{
	for ( lookcol=zew-1;lookcol>-1;lookcol--)
		{
		subLookBackInAnger();
		}
	}
}
/****************************/
void subLookBackInAnger()	// subroutine of LookBackInAnger
{
if (players[lookrow][lookcol]==1) { flag=1;}
if ( (flag==0)&&((players[lookrow][lookcol]==2)||(players[lookrow][lookcol]==3))) { subcanbetaken();}
}
/****************************/
void subcanbetaken2()
{
if (players[takena][takenb]>1)
		{
		//if (( enemy[ns2][ew2]-xvalue > 0 )||(enemy[ns2][ew2]-50 > 50)) // 14-11-2011 
		if (( (enemy[takenc][takend]-takene > 0 )&&(enemy[takenc][takend]<enemyweight))||(enemy[takenc][takend]-enemyweight > 0)) // 06-12-2011 
			{
			subcanbetaken();
			}
		if ( origorient == takenf ) // check opposite to direction of travel for defenders
			{
			LookBackInAnger();
			}
		}
}
/****************************/
void inctarget()
{
target[xns][xew]+=2;
}
/****************************/
void surroundcheck()
{
if (players[surns][surew]==1)		{incsurround();} 	// is attacker n,s,e,w
if (tiles[surns][surew]>2)			{incsurround();}	// is king square n,s,e,w
}
/****************************/
void calctakeweight()			// calculate the weight that should be applied to TAKES
{
takeweight=10;		// default
// don't worry about TAKES if the king has unbroken line of sight to edge of board

if (((kingnorth==0) && (defnorth==0))||((kingsouth==0) && (defsouth==0))||((kingeast==0)  && (defeast==0))||((kingwest==0)  && (defwest==0))) {takeweight=0;}
}
/******************************/
void enemyzero()    // calling routine = surroundcount() 
{
if ( players[ezns1][ezew1] == 0 )	// if adjacent square n/s/e/w is blank...
		{
		enemy[ezns2][ezew2]=0;		// set value to zero but only is surrounded=3
		}
}
/* This function will return absoulte value of n*/
/*
unsigned int getabs(int absnum) 
{   
	int const mask = absnum >> (sizeof(int) * CHAR_BIT - 1);
	int val;
	val=((absnum ^ mask) - mask); 
	printf ("%c%d%c:",19,val,19);
	return val;
}
*/