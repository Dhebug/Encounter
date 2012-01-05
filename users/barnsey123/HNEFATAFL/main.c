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
// 10-12-2011 subpacmanx(made smaller), added checkroute function
// 10-12-2011 enemyzero made more effective (and smaller) by zeroing entire enemy array
// 12-12-2011 lots of changes (seperated out "updatetarget" from "printarrowsorblanks"
// 14-12-2011 Test of replacing PACMAN with something else (see updatetarget)
// 20-12-2011 Oh Christ!
// 21-12-2011 Added nifty, don't take a defender if on same plane as king routine...
// 22-12-2011 above, wont take if LAST defender on plane (added inckingattacker etc)
// 22-12-2011 kingsouth/defsouth replaced by arrays (kingattacker, kingdefender)
// 23-12-2011 reduced code, fixed a couple of bugs
// 04-01-2012 introduced calcantake function (also beefed up the hightarget routines "findpiecens/findpieceew")
// 05-01-2012 reduced memory requirements - using unsigned char where possible  (34457)
// 05-01-2012 removed all local variables (replaced with globals) (34338)
// 05-01-2012 got rid of LookBackInAnger (plus some other changes) (33670)
/* TODO LIST
*** PROBLEM: Not blocking king under certain circumstances - related to changes in target selection...
*** Continue with endgame function to return a value determining victory conditions etc
*** routine to detect if all attackers have been captured
*** routine to detect stalemate (a side cannot move)
*** Improve the hightarget routine to select the BEST piece to move (rather than the 1st it finds)
*/
#include <lib.h>
//#include <math.h>
//#define CHAR_BIT 8
#define NORTH 0
#define SOUTH 1
#define EAST 2
#define WEST 3
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
//void findpiece();
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
//void subcanbetaken();		// sub of canbetaken
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
//void deccounter();			// decrement counter
void doublepoints();		// doubles points
//void LookBackInAnger();		// runs subcanbetaken if the piece "behind" an attacker is defender/king and prospective target adjacent to defender/king
//void subLookBackInAnger();	// runs the various "lookbackinanger" checks
void inctarget();			// inc target[xns][xew]
void subcanbetaken2(); 		// attempt to reduce memory footprint
void surroundcheck();		// inc surrounded under various conditions
void calctakeweight();		// calculate the weight of "takeweight"
void enemyzero();			// set enemy value to zero when surrounded=3 
char checkroute(); 			// sets counter to be number of pieces on a given route
void updatetarget();		// updates target array
void cantakeadjust();		// decrement cantake if taken piece is on same plane as king
void inckingattacker();		// increments count of attackers round king		
void inckingdefender();		// increments count of defenders round king
void incdefatt();			// increments count of attacker/defenders round king (calls incking...)
void cursormodezero();		// set cursor mode to 1 if 0
void cursormodevalid();		// sets modevalid to 1
void ischeckroutezero();	// is checkroute zero?
void calccantake();			// can take be made (how many)
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
unsigned char playertype,piecetype;			// player 1=attacker, 2=defender 
unsigned char ns,ew;		// default north/south position of central square 	(0-10)
unsigned char cx,cy;			// cursor x screen position (pixels across)
unsigned char fb=1;				// foreground/background 0=background, 1=foreground, 2=opposite, 3=nothing							
unsigned char inversex;		// x position of square to be inversed (to highlight a selected piece)
unsigned char inversey;		// y position of square to be inversed (to highlight a selected piece)
char mkey;					// code of key pressed (plus loops)
unsigned char cursormode;			// cursor movement mode 0=freeform 1=restricted
unsigned char ons,oew;		// original north/south board pos
unsigned char ocx,ocy;		// original xpos of piece
unsigned char orientation;	// for arrows - 0=north, 1=south 2=east 3=west
unsigned char tiletype;				// type of tile under inspection (used in arrows)
unsigned char tpns,tpew;	// north-south board location of taken piece (also used for 3) NB:no idea 20/10/2011
unsigned char flashcolor;			// color of ink to flash in
unsigned char flashback;				// color of ink to return to
unsigned char game;					// <=0 means endgame (see checkend for values), 1=GAMEON
unsigned char gamestyle;				// 0=human vs human; 1=human king vs computer; ** NO!!! 2=human vs computer king**; 3=undefined
unsigned char kingns,kingew;				// kings position North-South
unsigned char kingattacker[4];	// number of attackers in all four directions from king
unsigned char kingdefender[4];	// number of defenders in all four directsions from king
unsigned char surrounded;			// status of king "surrounded" status		//
unsigned char ctns=0;				// Computer Turn north-south board position		
unsigned char ctew=0;				// Computer Turn east-west   board position 
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
unsigned char row,col;			// used in tile drawing routines and array navigation ( a row in 11x11 grid)
//unsigned char col;			// used in tile drawing routines and array navigation ( a column in 11x11 grid)
unsigned char tiletodraw;	// used in tile drawing routines 0-11 (as at 18-10-2011)
int pausetime;				// amount of time to wait
unsigned char* ptr_draw;	// ptr to board starting position (e.g. 0xa002)
unsigned char* ptr_graph;	// pointer to byte values of loaded picture	
unsigned char points;		// points around king
char counter;				// general purpose counter (*** DO NOT set to UNSIGNED *** NB 24/10/2011)
unsigned char uncounter;	// general purpose counter (can be negative)
//unsigned char lookcol,lookrow;	// used in lookbackinanger
unsigned char origorient;			// original orientation of a piece under test (which way he is heading)
unsigned char takerow,takecol;				// can I be taken if I stop here?
unsigned char paclevel1,paclevel2;				// used in pacman/subpacmanx either ns/ew
unsigned char surns,surew;					// count of attackers surrounding king n/s used in surroundcount()
unsigned char takena,takenb,takenc,takend,takene;		// used in canbetaken routines
unsigned char ezns1,ezew1;			// used in surroundcount/enemyzero to reset enemy[][] to zero if surrounded=3
// WEIGHTS
unsigned char enemyweight=37;		// >36. weight of "enemy could get here but piece occupied by attacker"
//char defaulttakeweight=5;	// default weight assigned to a TAKE
unsigned char takeweight;			// weight assigned to a TAKE (calculated in "calctakeweight") 
unsigned char cbtweight=4;	// weight to be applied to escape position if can be taken
unsigned char pacpointsx,pacpointsy,pacpointsa,pacpointsb;		// used to calculate points in subpacmanx	
unsigned char pcheckns1,pcheckns2;		// used in taking pieces and checking for takes
unsigned char pcheckew1,pcheckew2;		// used in taking pieces and checking for takes			
unsigned char startrow,startcol;		// used in checkroute (returns no of pieces on a given path)
unsigned char destrow,destcol;		// used in checkroute (returns no of pieces on a given path)
unsigned char canmovecursor;	// controls wether screen cursor can be moved or not
unsigned char hightarget;	// contains highest value target
unsigned char targetns,targetew;		// used to calc takes
unsigned char x,y,z,a,b;						// general purpose variables
//char cannotbetaken,icanbetaken;			// used in canbetaken routine
/* below used for cursor move routine */
unsigned char multiple;	// concerning central square (how much to multiply the coords to SKIP the square
unsigned char xptrns;		// copy of NS
unsigned char xptrew;		// copy of EW
unsigned char skipns;		// skip to north/south
unsigned char skipew;		// skip to east/west 
unsigned char modeonevalid;	// is OK for mode 1? 0=no, 1=yes
/* above variables used in cursor move routine */
unsigned char gamekey=89;	// controls "play again?"
unsigned char gameinput=0;	// 0=undefined 1=play against computer, 2=human vs human
unsigned int startpos;		// USED when drawing tiles (position in tile file from which to draw)
unsigned char take;
unsigned char p1;	// piece type comparison (lower) - used for determining takes - default=attacker
unsigned char p2;	// piece type comparison (upper) - used for determining takes - default=attacker
/* playerturn variables */
unsigned char xkey;			// code of key pressed	
unsigned char canselect;	// 0=no, 1=yes (is the piece selectable?)
char cursormovetype;		// -1=no, 0=yes (n,s,e,w) 1=(north/south only), 2=(east/west only)
unsigned char turn;				// determines end of player turn 1=playerturn, 0=end of playerturn
unsigned char compass[4];	// used in cantake (if compass[NORTH]=1 then means canbetaken if i move here from NORTH
//unsigned char funca,funcb,funcc,funcd,funce,funcf;	// general purpose variables used in functions
/* end of playerturn variables */
/****************** MAIN PROGRAM ***********************************/
main()
{
//gamekey=89;	// controls "play again?"
//gameinput=0;	// 0=undefined 1=play against computer, 2=human vs human
paper(0);
ink(5);				// color of TEXT in text box at bottom
hires();
ink(6);				// boardcolor 0=black, 1=red, 2=green, 3=yellow, 4=blue, 5=magenta, 6=cyan,7=white
while (gamekey==89)
	{
	playertype=0;				// set to 0 as inited later
	drawboard();				// draw the board
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
ClearArrays();	// clear target, enemy and computer arrays
// 2. Loop through players array searching for enemy pieces - calculating where they can go
//fb=5;
//pacman1:
for (fb=4;fb<8;fb++)
	{
	for (ctns=0;ctns<11;ctns++)
		{
		for (ctew=0;ctew<11;ctew++)
			{
			ns=ctns;ew=ctew;
			if ( fb==4 )	// fb=4 means: don't print destinations, just update ENEMY
				{	
				if (( players[ctns][ctew]==2 )||(players[ctns][ctew]==3)) // if enemy found
					{
					printdestinations();	// update enemy array of possible locations
					}
				}
			if ((fb==5)||(fb==7))			// fb=5 (+COMPUTER array):fb=7 (can I be taken) 
				{
				if ( players[ctns][ctew]==1) // if attacker found
					{
					printdestinations();		
					}
				}
			if ( fb==6)	
				{
				if ( computer[ctns][ctew] ) // if computer piece can get here update target values
					{
					updatetarget();			// update target value
					}
				}
			}
		}
	}
// 3. Increment target positions around King (PACMAN)
pacman();
//if ( playertype == 1 ) {pacman();}
// other routines to go here to update the target array
// 4,5,6,7..N etc
// 
targetselect();	// Choose the highest value target 
ns=targetns;ew=targetew;	// make computer move compatible with human move selection
movepiece();	// make the move
}
/**************************************************/
/*
void findpiece()
{
if ( foundpiece == 0 )	
		{		
		if (players[funca][funcb]==1)
			{
			calccantake();
			if (( cantake==0 )&&(surrounded<3)) canbetaken(); // if cannot take can I be taken?
			if ((funcc==funcd)&&(funce!=funcd)&&(kingattacker[origorient]==1)) compass[origorient]=1;	// don't move from plane of king
			if (compass[origorient]==0)
				{
				foundpiece=1;
				funcf=funcc;
				}
			}
		if ((players[funca][funcb]==2)||(players[funca][funcb]==3)) {foundpiece=9;}
		}
}
*/
/*********************************************/
void findpiecens()	// find piece NORTH-SOUTH
{
if ( foundpiece == 0 )	
		{
		if (players[mkey][oew]==1)
			{
			calccantake();
			if (( cantake==0 )&&(surrounded<3)) canbetaken(); // if cannot take can I be taken?
			//if ((mkey==kingns)&&(targetns!=kingns)&&(kingattacker[origorient]==1)) compass[origorient]=1;	// don't move from plane of king
			if (compass[origorient]==0)
				{
				foundpiece=1;
				ons=mkey;
				}
			//else {target[targetns][targetew]=hightarget;} // if target=1 then reset it
			}
		if ((players[mkey][oew]==2)||(players[mkey][oew]==3)) {foundpiece=9;}
		}
}
/**************************************************/
void findpieceew()	// find piece EAST-WEST
{
if ( foundpiece == 0 )	
		{		
		if (players[ons][mkey]==1)
			{
			calccantake();
			if (( cantake==0 )&&(surrounded<3)) canbetaken(); // if cannot take can I be taken?
			//if ((mkey==kingew)&&(targetew!=kingew)&&(kingattacker[origorient]==1)) compass[origorient]=1;	// don't move from plane of king
			if (compass[origorient]==0)
				{
				foundpiece=1;
				oew=mkey;
				}
			//else{target[targetns][targetew]=hightarget;} // if target=1 then reset it
			}
		
		if ((players[ons][mkey]==2)||(players[ons][mkey]==3)) {foundpiece=9;}		
		}
}
/*********************************************************/
// TARGETSELECT - find the highest scoring TARGET
void targetselect()
{
//unsigned char xloop;
NEWTARGET:
hightarget=0;	// contains highest value target
foundpiece=0;		// set findpiece to "piece not found"
for (ctns=0;ctns<11;ctns++)	// find the highest value for target
	{
	for (ctew=0;ctew<11;ctew++)
		{
		if ( target[ctns][ctew] > hightarget )
			{
			hightarget=target[ctns][ctew];	// make hightarget the highest value
			targetns=ctns;
			targetew=ctew;		
			ons=ctns;	// target is accessible so make ons/oew the default piece position to move
			oew=ctew;	// the ACTUAL piece to move determined below (one of ons or oew will remain same)
			ns=ctns;
			ew=ctew;
			}
		}
	}
// having found target we need to select a piece to move
compass[NORTH]=0;compass[SOUTH]=0;compass[EAST]=0;compass[WEST]=0;	// initialize compass array
for (mkey=ons; mkey>-1; mkey--)	{origorient=NORTH;findpiecens();}	
if ( foundpiece != 1 ) { foundpiece=0;target[targetns][targetew]=hightarget; }														
for (mkey=ons; mkey<11; mkey++) {origorient=SOUTH;findpiecens();}	
if ( foundpiece != 1 ) { foundpiece=0;target[targetns][targetew]=hightarget; }
for (mkey=oew; mkey<11; mkey++)	{origorient=EAST;findpieceew();}	
if ( foundpiece != 1 ) { foundpiece=0;target[targetns][targetew]=hightarget; }
for (mkey=oew; mkey>-1; mkey--)	{origorient=WEST;findpieceew();}	
if ( foundpiece != 1 ) {target[targetns][targetew]=1;goto NEWTARGET;}	// if can still be taken select new target

cx=1+boardx+(boxsize*oew);	// piece x screen position
cy=1+boardy+(boxsize*ons);	// piece y screen position
blinkcursor();			// draw cursor in foreground color at piece to move position cx,cy
fb=0;drawcursor();		// blank cursor
cx=1+boardx+(boxsize*targetew);	// target x screen position
cy=1+boardy+(boxsize*targetns);	// target y screen position
blinkcursor();			// draw cursor in foreground color at target position cx,cy
ocx=1+boardx+(boxsize*oew);	// piece to move x screen position
ocy=1+boardy+(boxsize*ons);	// piece to move y screen position
//printf("%cNS=%d,EW=%d,ONS=%d,OEW=%d%c",19,ns,ew,ons,oew,19);
//loop=getchar();
}
/************************************************/
void subpacmanx()		// subroutine of pacman
{
z=kingattacker[orientation]+kingdefender[orientation];	// count of pieces on route to edge (attackers&defenders)
a=pacpointsx+pacpointsy; // count of pieces to two corners
b=pacpointsa+pacpointsb; // count of pieces to squares adjacent to corners
setpoints();
//x=paccount1*3;	// x=number of attackers * 3
//y=x+paccount2;	// y=(number of attackers *3)+(defenders * 1)
//if ((points-y) < 0) {points=1;}else{points-=y;}	// subtract two points for every attacker and 1 point for every defender
if ( z==0 )				// no pieces in the direction from king
	{
	doublepoints();							// double points if blank route to edge
	if (pacpointsx==0){ doublepoints();}	// double if route to one corner
	if (pacpointsy==0){ doublepoints();}	// double if route to two corners
	}
if ( z<2 )
	{
	if (pacpointsa==0){ doublepoints();}	// double if route to one square adjacent to corner
	if (pacpointsb==0){ doublepoints();}	// double if route to two squares adjacent to corners
	}
if ((paclevel2<3)||(paclevel2>7)) { incpoints(); } // if close to an edge in orientation
if ((paclevel1<2)||(paclevel2>8)) { incpoints(); } // if "left or rightside" in a "winning position"
if ((orientation == NORTH) || (orientation == WEST))	// if north or west
	{
	uncounter=paclevel2-1;
	if ( paclevel2<5 ) { incpoints();} // add weight to north or west if king in north or west side of board	
	}
else											// if south east
	{ 
	uncounter=paclevel2+1;
	if ( paclevel2>5 ) { incpoints();} // add weight to south or east if king in south or east side of board
	}
if ( kingattacker[orientation]==0 ) { incpoints();}		// inc points if no attackers on path	
surroundpoints();
// default north/south
x=uncounter;
y=paclevel1;
if ( orientation>SOUTH) // if east/west
	{
	x=paclevel1;
	y=uncounter;
	}
flag=1;
while (((players[x][y]==0)||(tiles[x][y]==3))&&((uncounter>-1)&&(uncounter<11)))
	{
	if (computer[x][y])	// if accessible by attacker	
		{ // only update target if cannot be taken OR king has clear route to corner
		if ((a==0)||(pacpointsx==0)||(pacpointsy==0)||(pacpointsa==0)||(pacpointsb==0))
			{
			target[x][y]+=points;
			flag=0;
			}
		else
			{
			if (target[x][y]>1){target[x][y]=points;flag=0;}
			}
		}
	else 
		{	
		if ((flag)&&(players[x][y]==0))	// if blank)
			{
			if (orientation<EAST) { subpacman();}else{subpacman2();} // if north/south
			}
		}
	decpoints();
	//if (z){decpoints();} // only decrement points if route to edge is blocked
	if ( (orientation==NORTH) || (orientation==WEST) ) {uncounter--;}else{uncounter++;}
	if ( orientation <EAST ) {x=uncounter;}else{y=uncounter;}
	}
}
/************************************************/
void pacman()		// PACMAN	( increment target positions around king )	
{
//int xrand=random()/1000;	// random number between 0-32
surroundcount();		// updates "surrounded"
// NORTH
orientation=NORTH;
paclevel1=kingew;
paclevel2=kingns;
startrow=0;startcol=0;destrow=0;destcol=kingew;
pacpointsx=checkroute();
startcol=kingew;destcol=10;
pacpointsy=checkroute();
startrow=1;startcol=0;destrow=1;destcol=kingew;
pacpointsa=checkroute();
startcol=kingew;destcol=10;
pacpointsb=checkroute();
subpacmanx();

//SOUTH
orientation=SOUTH;
startrow=10;startcol=0;destrow=10;destcol=kingew;
pacpointsx=checkroute();
startcol=kingew;destcol=10;
pacpointsy=checkroute();
startrow=9;startcol=0;destrow=9;destcol=kingew;
pacpointsa=checkroute();
startcol=kingew;destcol=10;
pacpointsb=checkroute();
subpacmanx();

// EAST
orientation=EAST;
paclevel1=kingns;
paclevel2=kingew;
startrow=0;startcol=10;destrow=kingns;destcol=10;
pacpointsx=checkroute();
startrow=kingns;destrow=10;
pacpointsy=checkroute();
startrow=0;startcol=9;destrow=kingns;destcol=9;
pacpointsa=checkroute();
startrow=kingns;destrow=10;
pacpointsb=checkroute();
subpacmanx();

// WEST
orientation=WEST;
startrow=0;startcol=0;destrow=kingns;destcol=0;
pacpointsx=checkroute();
startrow=kingns;destrow=10;
pacpointsy=checkroute();
startrow=0;startcol=1;destrow=kingns;destcol=1;
pacpointsa=checkroute();
startrow=kingns;destrow=10;
pacpointsb=checkroute();
subpacmanx();
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
if ( players[counter][mkey]==0 ) { flag=1;}
if ((flag==0)&&(target[counter][mkey]>1 )) { target[counter][mkey]++;}
}
void subpacman4()
{
if ( players[mkey][counter]==0 ) { flag=1;}
if ((flag==0)&&(target[mkey][counter]>1 )) { target[mkey][counter]++;}
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
			surroundcount();
			}
		if ( surrounded == 4 ) { game=-1;}	// king is surrounded on all sides by attackers or king squares
		}
}
/************************************************/
void cursormodezero()
{
if ( cursormode == 0 ) { canmovecursor=1;}
}
/***********************/
void movecursor2() // routine to move the cursor
{
/*
cursormode = [0 or 1] 0=unrestricted (move anywhere), 1= restricted (only move to possible destinations)
*/
multiple=1;	// concerning central square (how much to multiply the coords to SKIP the square
xptrns=ns;		// copy of NS
xptrew=ew;		// copy of EW
skipns=ns;		// skip to north/south
skipew=ew;		// skip to east/west 
modeonevalid=0;	// is OK for mode 1? 0=no, 1=yes
canmovecursor=0;	
piecetype=players[ons][oew];	// determines the piece type that is currently selected (used in mode 1)
if ((mkey == 8 )&&( ew))		// west
	{
	cursormodezero();
	xptrew--;		// decrement copyew
	skipew-=2;
	modeonevalid=1;
	}
if ((mkey == 9 )&&( ew<10))		// east
	{
	cursormodezero();
	xptrew++;
	skipew+=2;
	modeonevalid=1;
	}
if ((mkey == 10)&&( ns<10))		// south
	{
	cursormodezero();
	xptrns++;
	skipns+=2;
	modeonevalid=1;
	}
if ((mkey == 11)&&( ns))		// north
	{
	cursormodezero();
	xptrns--;
	skipns-=2;
	modeonevalid=1;
	}		
if (( cursormode ) && ( modeonevalid ))	// if not at edge of board
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
//zns=ns;		// another copy of ns (for computer turn)
//zew=ew;		// another copy of ew (for computer turn)
origorient=orientation; // original orientation (for computer turn)
//char cantake=0;		// can I take?	(for computer turn)
//unsigned char subloop=0;
//cantake=0;
xns=ns;	// copy of ns
xew=ew;	// copy of ew
arrow=1;
//arrowsx=cx+1;
//arrowsy=cy+1;
// orientation 0,1,2,3 = N, S, E, W
takerow=ns;takecol=ew; // will set below to be the opposite of the orientation
if ( orientation == NORTH ) { xplayers=players[xns-1][xew];takerow=xns+1;} // check north
if ( orientation == SOUTH ) { xplayers=players[xns+1][xew];takerow=xns-1;} // check south
if ( orientation == EAST ) { xplayers=players[xns][xew+1];takecol=xew-1;} // check east
if ( orientation == WEST ) { xplayers=players[xns][xew-1];takecol=xew+1;}  // check west
if ( xplayers == 0 )	// if adjacent square is OK mode
	{
	//arrow=1;
	while ( arrow == 1 ) // keep checking until cannot move
		{
		if (( orientation == NORTH ) && ( xns ))  // check north
			{
			xns--;			// decrement provisional north-south player position
			subarrows();
			}
		if (( orientation == SOUTH ) && ( xns < 10 )) // check south
			{
			xns++;			// increment provisional north-south player position
			subarrows();
			}
		if ((orientation == EAST ) && ( xew < 10 )) // check east
			{
			xew++;			// increment provisional east-west player position
			subarrows();
			}
		if ((orientation == WEST ) && ( xew )) // check west
			{
			xew--;			// decrement provisional east-west player position
			subarrows();
			}
		tiletodraw=tiles[xns][xew];				// obtain type of tile	
		if ( arrow == 1 )						// if MODE is "draw an arrow" (aka: I can move here)
			{
			row=xns;
			col=xew;
			if (fb==1) {drawarrow();}		// draw and arrow
			if (fb==4) {subarrows2();} 		// enemy can get here, update enemy array (direction specific)
			if (fb==5) {computer[xns][xew]++;} // computer can get here, increment computer array 
			if (fb==0) {drawarrow();}		// if MODE is "blank an arrow"
			}	
		// have we reached the end of the board?
		if (( orientation == NORTH ) && ( xns == 0 )) 	{ arrow=0;}	// check north
		if (( orientation == SOUTH ) && ( xns == 10 )) 	{ arrow=0;}	// check south
		if (( orientation == EAST ) && ( xew == 10 )) 	{ arrow=0;}	// check east
		if (( orientation == WEST ) && ( xew == 0 )) 	{ arrow=0;}	// check west
		}			
	}
if ((fb==7)&&(xplayers>1))	// check to see if an attacker can be caught if he stays where he is
	{
	if ((players[takerow][takecol]==0)&&(enemy[takerow][takecol])&&(enemy[takerow][takecol]<enemyweight)) 
		{
		if (target[takerow][takecol]>1){target[takerow][takecol]+=4; } // update adjacent target to provide escape route or place for someone else to occupy
		if (orientation < EAST)	// if heading north or south
			{
			if ( xew<10 ){if (target[xns][xew+1]>1){target[xns][xew+1]+=4;}}
			if ( xew  ){if (target[xns][xew-1]>1){target[xns][xew-1]+=4;}}
			}
		else					// if heading east or west
			{
			if ( xns<10 ){if (target[xns+1][xew]>1){target[xns+1][xew]+=4;}}
			if ( xns  ){if (target[xns-1][xew]>1){target[xns-1][xew]+=4;}}	
			}
		}
	}
}
/************************************************/
void printdestinations()
{
	// print appropriate arrows at all possible destinations (or blanks em out)
	// check north
	if ( ns ) { orientation=NORTH;printarrowsorblanks();}	// draws arrows/blanks em out (0=north)			
	// check south
	if ( ns < 10 ){ orientation=SOUTH;printarrowsorblanks();}	// draws arrows/blanks em out (1=south)
	// check east
	if ( ew < 10 ){ orientation=EAST;printarrowsorblanks();}	// draws arrows/blanks em out (2=east)
	// check west
	if ( ew ) { orientation=WEST;printarrowsorblanks();}	// draws arrows/blanks em out (3=west)	
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
	/*
	for (counter=0;counter<4;counter++)	// this routine uses up more memory (100bytes extra)
		{
		kingattacker[counter]=2;
		kingdefender[counter]=2;
		}
	*/
	kingattacker[NORTH]=2;		// count of attackers NORTH of king
	kingattacker[SOUTH]=2;		// count of attackers SOUTH of king
	kingattacker[EAST]=2;			// count of attackers EAST of king
	kingattacker[WEST]=2;			// count of attackers WEST of king
	kingdefender[NORTH]=2;			// count of defenders NORTH of king
	kingdefender[SOUTH]=2;			// count of defenders SOUTH of king
	kingdefender[EAST]=2;			// count of defenders EAST of king
	kingdefender[WEST]=2;			// count of defenders WEST of king
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
	/*
	unsigned char key;			// code of key pressed	
	unsigned char canselect;		// 0=no, 1=yes (is the piece selectable?)
	char cursormovetype=-1;			// -1=no, 0=yes (n,s,e,w) 1=(north/south only), 2=(east/west only)
	char turn=1;					// determines end of player turn 1=playerturn, 0=end of playerturn
	*/
	cursormovetype=-1;	// -1=no, 0=yes (n,s,e,w) 1=(north/south only), 2=(east/west only)
	turn=1;					// determines end of player turn 1=playerturn, 0=end of playerturn
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
		xkey=getchar();		// get code of pressed key
		mkey=xkey;
		if (( xkey > 7 ) && ( xkey < 12 ))  // 8-11 = cursor keys 
			{
			cursormode=0;  // freeform
			movecursor2();  
			}		
		/*******************************************************/
		/* determine if X or P is selected (to select a piece) */
		/*******************************************************/
		if (( xkey == 88) || ( xkey == 80))	// if 'X' or 'P' is selected (88=X, 80=P)
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
					if ( xkey == 80 )		// if P is pressed
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
p1=1;	// piece type comparison (lower) - used for determining takes - default=attacker
p2=1;	// piece type comparison (upper) - used for determining takes - default=attacker
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
	orientation=NORTH;
	if ( cantakepiece() ) { tpns=ns-1; takepiece(); }
	}
if ( ns < 9 ) // check south
	{
	orientation=SOUTH;
	if ( cantakepiece() ) { tpns=ns+1; takepiece(); }
	}
tpns=ns;
if ( ew < 9 ) // check east
	{
	orientation=EAST;
	if ( cantakepiece() ) { tpew=ew+1; takepiece(); }
	}
if ( ew > 1 ) // check west
	{
	orientation=WEST;
	if ( cantakepiece() ) { tpew=ew-1; takepiece(); }
	}
// update count of attackers around king
/*
for (counter=0;counter<4;counter++)	// this routine uses 100 extra bytes than assigning manually
	{
	kingattacker[counter]=0;
	kingdefender[counter]=0;
	}
*/
kingattacker[NORTH]=0;		// count of attackers NORTH of king
kingattacker[SOUTH]=0;		// count of attackers SOUTH of king
kingattacker[EAST]=0;			// count of attackers EAST of king
kingattacker[WEST]=0;			// count of attackers WEST of king
kingdefender[NORTH]=0;			// count of defenders NORTH of king
kingdefender[SOUTH]=0;			// count of defenders SOUTH of king
kingdefender[EAST]=0;			// count of defenders EAST of king
kingdefender[WEST]=0;			// count of defenders WEST of king
orientation=NORTH;
cy=kingew;
for (counter=0;counter<kingns;inccounter()) 	
	{ 
	cx=counter;incdefatt();
	//if (players[counter][kingew]==1) {inckingattacker();}
	//if (players[counter][kingew]==2) {inckingdefender();}
	}
orientation=SOUTH;
for (counter=kingns+1;counter<11;inccounter()) 
	{ 
	cx=counter; incdefatt();
	//if (players[counter][kingew]==1) {inckingattacker();}
	//if (players[counter][kingew]==2) {inckingdefender();}
	}
orientation=EAST;
cx=kingns;
for (counter=kingew+1;counter<11;inccounter())	
	{ 
	cy=counter; incdefatt();
	//if (players[kingns][counter]==1) {inckingattacker();}
	//if (players[kingns][counter]==2) {inckingdefender();}
	}
orientation=WEST;
for (counter=0;counter<kingew;inccounter()) 	
	{ 
	cy=counter; incdefatt();
	//if (players[kingns][counter]==1) {inckingattacker();}
	//if (players[kingns][counter]==2) {inckingdefender();}
	}
}

/*******************/
void incdefatt()
{
if (players[cx][cy]==1) {inckingattacker();}
if (players[cx][cy]==2) {inckingdefender();}
}
void inckingdefender()
{
kingdefender[orientation]++;
}
void inckingattacker()
{
kingattacker[orientation]++;
}
/************************************************/
/*void subcanbetaken()
{
target[targetns][targetew]=1;
//if ((ns==kingns)||(ew==kingew)) { target[ns][ew]=3;}  // means acceptable risk
}
*/
/************************************************/
void canbetaken() // can I be taken after moving here? 
{
//cannotbetaken=0;
//icanbetaken=0;
if ((targetns>0)&&(targetns<10))
	{
	takena=targetns-1;takenb=targetew;takenc=targetns+1;takend=targetew;takene=1;
	subcanbetaken2();
	takena=targetns+1;takenb=targetew;takenc=targetns-1;takend=targetew;takene=5;
	subcanbetaken2();
	}
	
if ((targetew>0)&&(targetew<10))
	{	
	takena=targetns;takenb=targetew+1;takenc=targetns;takend=targetew-1;takene=10;
	subcanbetaken2();
	takena=targetns;takenb=targetew-1;takenc=targetns;takend=targetew+1;takene=20;
	subcanbetaken2();	
	}
//if (cannotbetaken==0) {target[targetns][targetew]=1;}		
}
/************************************************/
// Will return a value (take) who's values will be: 0= no, 1=yes
char cantakepiece()
{
//char take=0;
//char p1=1;	// piece type comparison (lower) - used for determining takes - default=attacker
//char p2=4;	// piece type comparison (upper) - used for determining takes - default=attacker
take=0;
p1=1;
p2=4;
pcheckns1=ns-1;	// defaults to north
pcheckns2=ns-2;
pcheckew1=ew;
pcheckew2=ew;
piecetype=players[ns][ew];	// obtain type of piece
//if ( fb==3) { piecetype=players[ctns][ctew];} // if computer turn set piecetype to piece being checked
if ( fb==3 ) { piecetype=1;}	// default = ATTACKER
if (piecetype > 1 )	// if defender
	{
	p1=2;
	p2=3;
	}
if ( orientation == SOUTH)	// if south
	{
	pcheckns1=ns+1;
	pcheckns2=ns+2;
	}
if ( orientation > SOUTH)	// if east or west
	{
	pcheckns1=ns;
	pcheckns2=ns;
	pcheckew1=ew+1;
	pcheckew2=ew+2;
	if ( orientation == WEST) // if west
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
	if ((fb==4)&&(players[xns][xew]==1)) {enemy[xns][xew]+=enemyweight;}	// means enemy could get here if attacker moved elsewhere
	}
if (( players[ns][ew] == 3)&&(tiles[xns][xew] == 4)) { arrow = 1; } // corner ok if king	
}
/*****************************/
void subarrows2()
{
if ( orientation==NORTH ) { enemy[xns][xew]+=5; }	// means enemy can get here from SOUTH
if ( orientation==SOUTH ) { enemy[xns][xew]+=1; }	// means enemy can get here from NORTH
if ( orientation==EAST ) { enemy[xns][xew]+=20; }	// means enemy can get here from WEST
if ( orientation==WEST ) { enemy[xns][xew]+=10; }	// means enemy can get here from EAST
}
/*****************************/
void inccantake()
{
//unsigned char take;
//cantake+=cantakepiece();
z=cantakepiece();
if (z)
	{
	cantake+=z;
	cantakeadjust();	// decrement take count if taken piece on same plane as king and taker isn't	
	}
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
//unsigned char b;
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
//printf("%c\n\n3/1=%d 7/1=%d%c",19,target[3][1],target[7][1],19);
//printf("%cSURROUNDED=%d%c",19,surrounded,19);
}
/**************************************/
void surroundcount()
{
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
if (surrounded==3)	// unset any "enemy and target values" 
	{
	ezew1=kingew;
	if ( kingns > 0 )
		{
		ezns1=kingns-1;
		enemyzero();
		}
	if ( kingns < 10 )
		{
		ezns1=kingns+1;
		enemyzero();
		}
	ezns1=kingns;
	if ( kingew > 0 )
		{
		ezew1=kingew-1;
		enemyzero();
		}
	if ( kingew < 10 )
		{
		ezew1=kingew+1;
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
if (points==0) points=1;	// suggested by JamesD
//if ((points-1)==0) {points=1;}else{points--;}
}
/****************************/
void setpoints()
{
points=10;
}
/****************************/
void doublepoints()
{
points+=10;	// not really double anymore (10/12/2011)
}
/****************************/


/******************************/
void surroundpoints()
{
//printf("%c* %d *%c",19,(points+(points*surrounded)),19);
points+=10*surrounded;	// multiply the points around king depending on the "surrounded" figure
}
/****************************/
void inccounter()
{
counter++;
}
/****************************/
/*
void deccounter()
{
counter--;
}
*/
/****************************/
void zerocounter()
{
counter=0;;
}
/****************************/
/*
void LookBackInAnger()		// returns the value of the piece "behind" an attacker
{
flag=0;			// status of foundpiece 0=no, 1=yes
if ( origorient == 0 ) 
	{
	for ( lookrow=mkey-1;lookrow>-1;lookrow--)
		{
		subLookBackInAnger();
		}
	}
if ( origorient == 1 ) 
	{
	for ( lookrow=mkey+1;lookrow<11;lookrow++)
		{
		subLookBackInAnger();
		}
	}
if ( origorient == 2 ) 
	{
	for ( lookcol=mkey+1;lookcol<11;lookcol++)
		{
		subLookBackInAnger();
		}
	}
if ( origorient == 3 ) 
	{
	for ( lookcol=mkey-1;lookcol>-1;lookcol--)
		{
		subLookBackInAnger();
		}
	}
}
*/
/****************************/
/*
void subLookBackInAnger()	// subroutine of LookBackInAnger
{
if (players[lookrow][lookcol]==1) { flag=1;}
if ( (flag==0)&&((players[lookrow][lookcol]==2)||(players[lookrow][lookcol]==3))) { target[ons][oew]=1;}
}
*/
/****************************/
void subcanbetaken2()
{
if (players[takena][takenb]>1)
		{
		//if (( enemy[ns2][ew2]-xvalue > 0 )||(enemy[ns2][ew2]-50 > 50)) // 14-11-2011 
		if ((enemy[takenc][takend]-takene)&&((enemy[takenc][takend]<enemyweight)||(enemy[takenc][takend]-enemyweight))) // 23-12-2011 
			{
			compass[origorient]=1;	// e.g. compass[NORTH]=1 means canbetaken here if moving from NORTH
			}
		//else
		//	{
		//	cannotbetaken++;
		//	}
		}
}
/****************************/
void inctarget()
{
target[targetns][targetew]+=2;
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
//unsigned char x;
takeweight=5;		// default
// don't worry about TAKES if the king has unbroken line of sight to edge of board
for (x=0;x<4;x++)
	{
	if ((kingattacker[x]==0)&&(kingdefender[x]==0)){takeweight=0;}
	}
//if (((kingnorth==0)&&(defnorth==0))||((kingsouth==0)&&(defsouth==0))||((kingeast==0)&&(defeast==0))||((kingwest==0)  && (defwest==0))) {takeweight=0;}
}
/******************************/
void enemyzero()    // calling routine = surroundcount() 
{
if (( players[ezns1][ezew1] == 0 )&&(target[ezns1][ezew1]))	// if adjacent square n/s/e/w is blank and accessible
		{
		ClearArrays();				// set all arrays to zero (target, enemy, computer)
		target[ezns1][ezew1]=100;	// set big target value to final space by king
		}
}
/******************************/
char checkroute()	// returns number of pieces on a given route
{
//char start=cx;
//char dest=kingns;
//unsigned char x;
z=0;
if (orientation<EAST) 			// if checking ROWS (crossing the T) (used for NORTH SOUTH checks)
	{
	for (x=startcol;x<=destcol;x++)	// check row
		{
		if ((players[startrow][x])&&(players[startrow][x]<3)) {z++;}
		}
	}
else						// EAST WEST checks (crossing the T)
	{
	for (x=startrow;x<=destrow;x++) // check accross
		{
		if ((players[x][startcol])&&(players[x][startcol]<3)) {z++;}
		}
	}
return z;
}
/*************************/
void cantakeadjust()		// decrements cantake if taken piece is on same plane as king 
{							// and attacking piece isn't AND only one defender on plane
flag=0;
if ((playertype==1)&&(gamestyle==1))	// if computer playing as attacker and his turn
	{
	if (pcheckns1==kingns)
		{
		flag=1;
		if (ctew<kingew){orientation=WEST;}else{orientation=EAST;}
		//if ((kingattacker[orientation]+kingdefender[orientation])<4){cantake--;}
		}
	if (pcheckew1==kingew)
		{
		flag=1;
		if (ctns<kingns){orientation=NORTH;}else{orientation=SOUTH;}
		//if ((kingattacker[orientation]+kingdefender[orientation])<4){cantake--;}
		}
	if (flag)		
		{
		if ((kingattacker[orientation]+kingdefender[orientation])<4){cantake--;}
		}

	}
}
/*************************/
void updatetarget()
{
//unsigned char x;
//unsigned char y;
targetns=ctns;targetew=ctew;
//char orient=1;	// 0=north, 1=south, 2=east, 3=west
//char orientA;
//char orientB;
//char z;
target[targetns][targetew]=2;	// set target to 2
target[5][5]=0;		// set "illegal" squares to zero
target[0][10]=0;
target[0][0]=0;
target[10][0]=0;
target[10][10]=0;
if (target[targetns][targetew])	// only if target is valid (i.e. not a king square)
	{
	if (enemy[targetns][targetew]){inctarget();}	// increase target if blocking an enemy	
	calccantake();			// calculates how many takes can be made in this position (cantake)
	calctakeweight();		// calculate weight that should be applied to takes	
	y=cantake*takeweight;	// value to be added to target			
	target[targetns][targetew]+=y; // add cantake (will be zero if cannot take)
	/*
	if ((ctew==1)||(ctew==9))
		{
		orientation=1;	// check south for number of pieces
		startcol=ctew;startrow=0;destcol=ctew;destrow=10;
		ischeckroutezero();	// if so inctarget
		}
	if ((ctns==1)||(ctns==9))
		{
		orientation=2;	// check east for number of pieces
		startcol=0;startrow=ctns;destcol=10;destrow=ctns;
		ischeckroutezero();	// if so inctarget
		}
	*/
	//if (cantake==0)	{canbetaken();}		// sets target to 1 if cannot take but can be taken
	}
}
/******************/
void ischeckroutezero()
{
//char a=checkroute();
if ((checkroute())==0) {inctarget();}	// if nobody on column, inctarget
}
/********************/
void calccantake()			// calculate how many takes can be made
{
//unsigned char x;
cantake=0;	
inccantake();	// inc cantake if can take in direction of travel
for (x=0;x<4;x++)
	{
	if ( x<2 ) // heading north/south
		{
		orientation=EAST; inccantake();
		orientation=WEST; inccantake();	
		}
	if ( x>1 ) // heading east/west
		{
		orientation=NORTH; inccantake();
		orientation=SOUTH; inccantake();
		}
	}
}